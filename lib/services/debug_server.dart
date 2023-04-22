import 'dart:convert';
import 'dart:io';

import 'package:cca_vijayapura/services/temp_store.dart';

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
      temp[key] = "\n" + getPrettyJSONString(value?.toMap() ?? {}) + "\n";
    } catch (e) {}
  });
  return temp;
}

startServer() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8898);
  print("Server running on IP : " +
      server.address.toString() +
      " On Port : " +
      server.port.toString());
  await for (var request in server) {
    try {
      request.response
        ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
        ..write((fixData(temp_store)).toString())
        ..close();
    } catch (e) {
      shared_logger.e(e);
    }
  }
}
