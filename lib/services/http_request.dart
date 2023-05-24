import 'dart:convert';
import 'dart:io';

import 'package:cca_vijayapura/services/debug_server.dart';
import 'package:cca_vijayapura/services/secure_store.dart';
import 'package:cca_vijayapura/services/temp_store.dart';

// Future<Map<dynamic, dynamic>> exeFetch(
//     {required String uri,
//     method = "get",
//     body = const {},
//     header = const {
//       "Content-Type": "application/json",
//     }}) async {
//   if (uri.startsWith("/")) {
//     uri = uri.substring(1);
//   }
//   uri =
//       """${dotenv.env["SERVER_PROTOCOL"]}://${dotenv.env["SERVER_HOST"]}:${dotenv.env["SERVER_PORT"]}/$uri""";
//   var url = Uri.parse(uri);

//   print("exeFetch: " + uri);
//   print("body: " + body);
//   late http.Response response;

//   try {
//     switch (method) {
//       case "post":
//         response = await http.post(url, body: body, headers: header);
//         break;
//       case "put":
//         response = await http.put(url, body: body, headers: header);
//         break;
//       case "delete":
//         response = await http.delete(url, body: body, headers: header);
//         break;
//       default:
//         response = await http.get(url, headers: header);
//     }

//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//     print(response.headers);
//     // var _cookie=Cookie.fromSetCookieValue(response.headers["set-cookie"].toString());
//     // print(_cookie);
//     // print(_cookie.name);

//     return jsonDecode(response.body);
//   } catch (e) {
//     print(e);
//     return {};
//   }
// }

Future<Map<dynamic, dynamic>> exeFetch({
  required String uri,
  method = "get",
  body,
  Map<String, dynamic> header = const {
    "Content-Type": "application/json",
  },
  Function(int? statusCode)? navigateToIfNotAllowed,
  getRequest,
}) async {
  navigateToIfNotAllowed ??= (a) {};
  Future<Map<dynamic, dynamic>> future;

  bool forwardToLocal = uri.startsWith("/forward");

  if (uri.startsWith("/")) {
    uri = uri.substring(1);
  }
  var client = HttpClient();
  // var client = MyHttpInterceptor();
  late HttpClientRequest request;

  Uri FullURI = Uri.parse(
      """${const String.fromEnvironment("SERVER_PROTOCOL")}://${const String.fromEnvironment("SERVER_HOST")}:${const String.fromEnvironment("SERVER_PORT")}/$uri""");
  if (forwardToLocal) {
    FullURI =
        Uri.parse("""http://$DEBUG_SERVER_HOST:$DEBUG_SERVER_PORT/$uri""");
  }
  try {
    switch (method) {
      case "post":
        request = await client.postUrl(FullURI);
        break;
      case "put":
        request = await client.putUrl(FullURI);
        break;
      case "delete":
        request = await client.deleteUrl(FullURI);
        break;
      default:
        request = await client.getUrl(FullURI);
    }
    // ------------ constructing request --------------------

    header.forEach((key, value) {
      request.headers.add(key, value);
    });

    String ua = request.headers.value("user-agent") ?? "";
    ua = "$ua,${jsonEncode(temp_store["deviceInfo"])}";
    request.headers.set("user-agent", ua);

    String cookies =
        temp_store["cookies"] ?? await storage.read(key: "cookies") ?? "";
    if (cookies != "") {
      temp_store["cookies"] = cookies;
      List cookiesObj = jsonDecode(cookies);
      for (var cookie in cookiesObj) {
        request.cookies.add(Cookie.fromSetCookieValue(cookie));
      }
    }

    if (temp_store["csrf_token"] != null) {
      request.headers.add("csrf_token", temp_store["csrf_token"]);
    }

    if (body != null) {
      request.write(body);
    }

    if (getRequest != null) {
      getRequest(request);
    }

    // print("request.headers ${request.headers}");
    HttpClientResponse response = await request.close();

    // ------------ reading response --------------------

    if (response.headers.value("csrf_token") != null &&
        response.headers.value("csrf_token") != "") {
      temp_store["csrf_token"] =
          response.headers.value("csrf_token").toString();
    }

    if (response.cookies.isNotEmpty) {
      String cookies0 = jsonEncode(
          response.cookies.map((cookie) => cookie.toString()).toList());
      await storage.write(key: "cookies", value: cookies0);
      temp_store["cookies"] = cookies0;
    }

    final stringData = await response.transform(utf8.decoder).join();
    // print('uri=$uri => Response status: ${response.statusCode}\nResponse body2: $stringData');

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      future = Future<Map>.value({"body": stringData});
    } else if (response.statusCode == 401) {
      // // this also works
      // throw Exception(Map.from({
      //   "body":stringData,
      //   "navigate":navigateToIfNotAllowed()
      // }));
      future = Future.error(Map.from({
        "status_code": response.statusCode,
        "body": stringData,
        "navigate": navigateToIfNotAllowed(response.statusCode)
      }));
    } else {
      future = Future.error(Map.from({
        "status_code": response.statusCode,
        "body": stringData,
        "navigate": navigateToIfNotAllowed(response.statusCode)
      }));
    }
  } on HttpException catch (e) {
    print("HttpException = $e");
    if (e.message.contains("Request has been aborted")) {
      future = Future<Map>.value({"body": null});
    } else {
      future = Future.error(
          Map.from({"body": "{}", "navigate": navigateToIfNotAllowed(-2)}));
    }
  } catch (e, stacktrace) {
    print("Exception:");
    print(e);
    print("stacktrace:");
    print(stacktrace);
    future = Future.error(
        Map.from({"body": " {}", "navigate": navigateToIfNotAllowed(-1)}));
  } finally {
    client.close();
  }
  return future;
}
