import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cca_vijayapura/sharedComponents/toastMessages/toastMessage.dart';
import 'package:encrypt/encrypt.dart';
import 'package:google_api_availability/google_api_availability.dart';

class CustomEvent {
  late StreamController controller;
  Timer? _timer;
  CustomEvent() {
    controller = StreamController.broadcast();
  }
  void sendEvent(data) => controller.add(data);
  Stream get getStream => controller.stream;
  set timer(Timer t) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = t;
  }
}

class Debounce {
  Duration delay;
  Timer? _timer;
  Debounce({this.delay = const Duration(milliseconds: 200)});

  set callback(Function() cb) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(delay, cb);
  }
}

isGooglePlayServicesAvailable() async {
  if (Platform.isAndroid) {
    GooglePlayServicesAvailability? playStoreAvailability;
    try {
      playStoreAvailability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability(true);
    } catch (e) {
      playStoreAvailability = GooglePlayServicesAvailability.unknown;
    }
    // if (playStoreAvailability ==
    //     GooglePlayServicesAvailability.serviceVersionUpdateRequired) {
    //   ToastMessage.error("Google service outdated");
    // } else {}
    if (playStoreAvailability != GooglePlayServicesAvailability.success) {
      ToastMessage.error("Unknown error occurred in checking google service");
    }
    return playStoreAvailability;
  }
  return null;
}

String DecryptAES(String encKey, int blockSize, String encodedText) {
  final encBytes = base64.decode(encodedText);
  final initVect = base64.encode(encBytes.sublist(0, blockSize));
  final actualEncodedText = base64.encode(encBytes.sublist(blockSize));

  final key = Key.fromUtf8(encKey);
  final iv = IV.fromBase64(initVect);

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final decrypted =
      encrypter.decrypt(Encrypted.fromBase64(actualEncodedText), iv: iv);

  return decrypted;
}
