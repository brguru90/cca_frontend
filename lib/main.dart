import 'package:cca_vijayapura/screens/StudyMaterials/widget.dart';
import 'package:cca_vijayapura/screens/coursePlaylist/widget.dart';
import 'package:cca_vijayapura/screens/home/widget.dart';
import 'package:cca_vijayapura/screens/landing/widget.dart';
import 'package:cca_vijayapura/screens/login/screen.dart';
import 'package:cca_vijayapura/screens/playlistVideos/widget.dart';
import 'package:cca_vijayapura/screens/signUp/signUpMobile.dart';
import 'package:cca_vijayapura/screens/signUpOld/screen.dart';
import 'package:cca_vijayapura/screens/userProfile/screen.dart';
import 'package:cca_vijayapura/screens/watchVideo/widget.dart';
import 'package:cca_vijayapura/services/auth.dart';
import 'package:cca_vijayapura/services/debug_server.dart';
import 'package:cca_vijayapura/services/secure_store.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';

Future initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  initSecureStore();
  temp_store_reset();
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

void mapRoutes() {
  return runApp(WrapApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const LandingScreen(),
      "/signUpMobile": (context) => const SignUpMobile(),
      "/watch_video": (context) => const WatchVideo(),
      "/login": (context) => const LoginScreen(),
      "/home": (context) => const HomeScreen(),
      "/old_sign_up": (context) => const SignUP(),
      "/user_profile": (context) => const UserProfile(),
      "/course_playlist": (context) => const CoursePlaylist(),
      "/playlist_videos": (context) => const PlaylistVideos(),
      "/study_materials": (context) => const StudyMaterials(),
    },
  )));
}

void main() async {
  await initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => mapRoutes());
  mapRoutes();
}
