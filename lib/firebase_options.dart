// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCIzRDrjxj1HpCBaaTHJ5C7IAvUdh3trQw',
    appId: '1:564585822015:web:c1767c7e5cd513df60858a',
    messagingSenderId: '564585822015',
    projectId: 'cca-vijayapura',
    authDomain: 'cca-vijayapura.firebaseapp.com',
    storageBucket: 'cca-vijayapura.appspot.com',
    measurementId: 'G-CDME9DFQHY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZhzn6vXV0E8aquJBNoEWepPOVWijOzzY',
    appId: '1:564585822015:android:e418a9fcaee725a660858a',
    messagingSenderId: '564585822015',
    projectId: 'cca-vijayapura',
    storageBucket: 'cca-vijayapura.appspot.com',
  );
}
