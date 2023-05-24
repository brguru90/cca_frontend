import 'dart:convert';
import 'dart:io';

import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:cca_vijayapura/services/utils.dart';

String getPrettyJSONString(jsonObject) {
  var encoder = const JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}

Map fixData(Map obj) {
  Map temp = Map.from(obj)
    ..removeWhere((key, value) {
      return key is String && !key.startsWith("shared_state__");
    });
  temp.forEach((key, value) {
    try {
      temp[key] = "\n${getPrettyJSONString(value?.toMap() ?? {})}\n";
    } catch (e) {}
  });
  return temp;
}

Map<String, String> queryToJson(String query) {
  if (query.startsWith("?")) {
    query = query.substring(1);
  }
  List<String> queriesList = query.split("&");
  Map<String, String> queryMapped = {};
  for (var q in queriesList) {
    List<String> qList = q.split("=");
    queryMapped[qList[0]] = qList[1];
  }
  return queryMapped;
}

void logSharedState(HttpRequest req) {
  shared_logger.d("~~| logSharedState |~~");
  try {
    req.response
      ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
      ..write((fixData(temp_store)).toString())
      ..close();
  } catch (e) {
    shared_logger.e(e);
  }
}

forwardGetVideo(HttpRequest req) {
  shared_logger.d("~~| forwardGetVideo |~~");
  try {
    final query = queryToJson(req.uri.query);
    if (query.containsKey("url")) {
      String forwardToUrl = query["url"]!;
      forwardToUrl = utf8.decode(base64.decode(forwardToUrl));
      exeFetch(
        uri: forwardToUrl,
        method: "post",
        body: jsonEncode({
          "app_id": const String.fromEnvironment("APP_ID"),
        }),
      ).then((body) {
        final data = jsonDecode(body["body"])["data"];
        shared_logger.d(data);
        final decryptedValue = DecryptAES(
            const String.fromEnvironment("APP_SECRET"),
            data["block_size"],
            data["key"]);
        shared_logger.d(decryptedValue);
        req.response
          ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
          ..write(decryptedValue)
          ..close();
      }).catchError((e, s) {
        shared_logger.e(e);
      });
    } else {
      req.response
        ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
        ..write("didn't got url key")
        ..close();
    }
  } catch (e) {
    shared_logger.e(e);
    req.response
      ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
      ..write("error")
      ..close();
  }
}

routeRequest(HttpRequest req) {
  if (req.uri.path.startsWith("/forward")) {
    forwardGetVideo(req);
  } else {
    logSharedState(req);
  }
}

String DEBUG_SERVER_HOST = "127.0.0.1";
int DEBUG_SERVER_PORT = 8898;

startServer() async {
  var server =
      await HttpServer.bind(InternetAddress.loopbackIPv4, DEBUG_SERVER_PORT);
  print(
      "Server running on IP : ${server.address.address} On Port : ${server.port}");
  DEBUG_SERVER_HOST = server.address.address;
  DEBUG_SERVER_PORT = server.port;
  await for (var request in server) {
    shared_logger.d("~~||~~");
    shared_logger.d(request.uri.path);
    shared_logger.d(request.uri);
    routeRequest(request);
  }
}
