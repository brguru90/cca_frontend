import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

late FirebaseAuth auth;

void initFirebaseSetup() async {
  auth = FirebaseAuth.instance;
}

Future authSignOut() async {
  final providerData = FirebaseAuth.instance.currentUser!.providerData;
  for (int i = 0; i < providerData.length; i++) {
    if (providerData[0].providerId.contains("google")) {
      try {
        await googleAuth.signOut();
      } catch (e) {
        print(e);
      }
    }
  }
  return await FirebaseAuth.instance.signOut();
}

Stream<User?> bindToLoginStateChange() {
  return auth.authStateChanges();
}

class GoogleAuth {
  late GoogleSignIn googleSignIn;
  GoogleSignInAccount? googleUser;

  GoogleAuth() {
    googleSignIn = GoogleSignIn();
  }

  Future<UserCredential> signIn() async {
    // Trigger the authentication flow
    try {
      googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return Future.error("error");
      }
    } catch (e) {
      return Future.error("error");
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future signOut() async {
    Completer c = Completer();
    try {
      await googleSignIn.disconnect();
      // await authSignOut();
      c.complete("done");
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }
}

GoogleAuth googleAuth = GoogleAuth();

class FBAuth {
  late LoginResult loginResult;
  Future<UserCredential> signIn() async {
    // Trigger the sign-in flow
    loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  void signout() {
    authSignOut();
  }
}

FBAuth fbAuth = FBAuth();

class MobileAuth {
  static void verify({
    required String phoneNumber,
    required Function(PhoneAuthCredential credential) verificationCompleted,
    required Function(FirebaseAuthException e) verificationFailed,
    required Function codeAutoRetrievalTimeout,
    Function(String verificationId, int? resendToken)? codeSent,
  }) async {
    codeSent ??= (String verificationId, int? resendToken) {};
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}

class EmailAuth {
  // better to implements own email verification
  // https://firebase.flutter.dev/docs/auth/usage/
  // https://medium.com/firebase-developers/dive-into-firebase-auth-on-flutter-email-and-link-sign-in-e51603eb08f8
  static Future<void> verify({required String user_email}) async {
    return await FirebaseAuth.instance.sendSignInLinkToEmail(
      email: user_email,
      actionCodeSettings: ActionCodeSettings(
        url: 'https://flutterauth.page.link/',
        androidInstallApp: true,
        androidMinimumVersion: "1",
        androidPackageName: "com.example.travel_planner",
        handleCodeInApp: true,
        iOSBundleId: "com.example.travel_planner",
      ),
    );
  }
}
