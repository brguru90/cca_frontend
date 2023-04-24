import 'package:cca_vijayapura/screens/home/widget.dart';
import 'package:cca_vijayapura/screens/landing/widget.dart';
import 'package:cca_vijayapura/screens/login/screen.dart';
import 'package:cca_vijayapura/screens/signUp/signUpMobile.dart';
import 'package:cca_vijayapura/screens/signUpOld/screen.dart';
import 'package:cca_vijayapura/screens/userProfile/screen.dart';
import 'package:cca_vijayapura/services/auth.dart';
import 'package:cca_vijayapura/services/debug_server.dart';
import 'package:cca_vijayapura/services/secure_store.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';

Future<void> loadENV() {
  const RELEASE_MODE = String.fromEnvironment("RELEASE_MODE");
  if (RELEASE_MODE == "true" || RELEASE_MODE == true) {
    return dotenv.load(fileName: "assets/env/.env_prod");
  } else {
    return dotenv.load(fileName: "assets/env/.env");
  }
}

Future initialize() async {
  await loadENV();
  initSecureStore();
  temp_store_reset();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initFirebaseSetup();
  if (kDebugMode) {
    Future(() {
      try {
        startServer();
      } catch (e) {
        shared_logger.e(e);
      }
    });
  }
  return Future<Map>.value({});
}

void acquirePermissions() async {
  await [Permission.locationWhenInUse, Permission.locationAlways].request();
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
  await initialize();
  Map<String, String> envValues = dotenv.env;
  runApp(WrapApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const LandingScreen(),
      "/signUpMobile": (context) => const SignUpMobile(),
      "/login": (context) => LoginScreen(env_values: envValues),
      "/home": (context) => const HomeScreen(),
      "/old_sign_up": (context) => SignUP(env_values: envValues),
      "/user_profile": (context) => UserProfile(env_values: envValues),
    },
  )));
}
