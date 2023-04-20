import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/screens/landing/widget.dart';
import 'package:flutter_crud_auth/screens/login/screen.dart';
import 'package:flutter_crud_auth/screens/signUp/screen.dart';
import 'package:flutter_crud_auth/screens/userProfile/screen.dart';
import 'package:flutter_crud_auth/services/secure_store.dart';
import 'package:flutter_crud_auth/services/temp_store.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> loadENV() {
  const RELEASE_MODE = String.fromEnvironment("RELEASE_MODE");
  if (RELEASE_MODE == "true") {
    return dotenv.load(fileName: "assets/env/.env_prod");
  } else {
    return dotenv.load(fileName: "assets/env/.env");
  }
}

Widget WrapApp(Widget child) {
  if (kIsWeb) {
    return SizedBox(
      width: 600,
      height: 900,
      child: child,
    );
  }
  return child;
}

void main() async {
  await loadENV();
  initSecureStore();
  temp_store_reset();
  Map<String, String> envValues = dotenv.env;
  runApp(WrapApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const LandingScreen(),
      "/login": (context) => LoginScreen(env_values: envValues),
      "/sign_up": (context) => SignUP(env_values: envValues),
      "/user_profile": (context) => UserProfile(env_values: envValues),
    },
  )));
}
