import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static void FlutterToastTemplate({
    required String msg,
    Color? fg_color = Colors.white,
    Color? bg_color = Colors.deepOrange,
  }) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bg_color,
        textColor: fg_color,
        fontSize: 16.0);
  }

  static void error(String msg) {
    FlutterToastTemplate(msg: msg, bg_color: Colors.red);
  }

  static void info(String msg) {
    FlutterToastTemplate(msg: msg, bg_color: Colors.blueAccent[700]);
  }

  static void success(String msg) {
    FlutterToastTemplate(msg: msg, bg_color: Colors.green[700]);
  }

  static void warning(String msg) {
    FlutterToastTemplate(msg: msg, bg_color: Colors.amber[500]);
  }

  static show(String? msg, String? type) {
    msg ??= "Empty message";
    switch (type) {
      case "success":
        ToastMessage.success(msg);
        break;
      case "error":
        ToastMessage.error(msg);
        break;
      case "warning":
        ToastMessage.warning(msg);
        break;
      default:
        ToastMessage.info(msg);
    }
    return null;
  }
}
