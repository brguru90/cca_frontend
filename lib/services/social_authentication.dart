import 'dart:async';
import 'dart:convert';

import 'package:cca_vijayapura/services/auth.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/sharedState/state.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future socialAuth({String provider = "google"}) {
  Completer c = Completer();
  switch (provider) {
    case "google":
      googleAuth.signIn().then((UserCredential value) {
        print("user detail");
        print(value.user);
        c.complete(value);
      }).catchError((onError) => c.completeError(onError));
      break;
    case "facebook":
      fbAuth.signIn().then((UserCredential value) {
        print("user detail");
        print(value.user);
        c.complete(value);
      }).catchError((onError) => c.completeError(onError));
      break;
    default:
      c.completeError("Invalid provider");
  }
  return c.future;
}

Future getTokenVerified({String? name, String? mobile, String? password}) {
  Completer c = Completer();
  auth.currentUser!.getIdToken(true).then((idToken) {
    exeFetch(
      uri: "/api/verify_social_auth/",
      method: "post",
      body: jsonEncode({
        "idToken": idToken,
        "mobile": mobile,
        "name": name,
        "password": password,
      }),
    ).then((value) {
      final respBody = jsonDecode(value["body"]);
      userData.state = respBody?["data"];
      c.complete(respBody);
    }).catchError((e) => c.completeError(e));
  });
  return c.future;
}
