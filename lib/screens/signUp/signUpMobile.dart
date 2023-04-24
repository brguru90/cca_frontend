import 'dart:async';
import 'dart:convert';

import 'package:cca_vijayapura/services/auth.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/social_authentication.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:cca_vijayapura/sharedComponents/orgBanner/widget.dart';
import 'package:cca_vijayapura/sharedComponents/toastMessages/toastMessage.dart';
import 'package:cca_vijayapura/sharedState/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpMobile extends StatefulWidget {
  const SignUpMobile({Key? key}) : super(key: key);

  @override
  State<SignUpMobile> createState() => _SignUpMobileState();
}

enum OtpStatus {
  none,
  sent,
  invalidOTP,
  invalidMobileNumber,
  timeout,
  verified
}

class _SignUpMobileState extends State<SignUpMobile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobileNumberController =
          TextEditingController(text: "+91"),
      otpController = TextEditingController(text: ""),
      nameController = TextEditingController(text: ""),
      passwordController = TextEditingController(text: ""),
      confirmPasswordController = TextEditingController(text: "");

  User? userDetail;
  bool validMobileNumber = false, signUp = false;
  OtpStatus otpStatus = OtpStatus.invalidOTP;
  String verificationId = "";
  String finalVerifiedMobileNumber = "";
  bool loading = false;

  void onLogin() => Navigator.pushNamed(context, "/home");

  void signUpOrLoginWithCredential() async {
    setState(() {
      loading = true;
    });
    if (signUp) {
      if (passwordController.text != confirmPasswordController.text) {
        ToastMessage.error("Password mismatch");
        return;
      }
      try {
        await getTokenVerified(
          mobile: finalVerifiedMobileNumber,
          name: nameController.text,
          password: passwordController.text,
        );
        onLogin();
      } catch (e) {
        shared_logger.e(e);
        ToastMessage.error("Error in sign up");
      } finally {
        setState(() {
          loading = false;
        });
      }
    } else {
      await exeFetch(
        uri: "/api/login_mobile/",
        method: "post",
        body: jsonEncode({
          "mobile": mobileNumberController.text,
          "password": otpController.text,
        }),
      ).then((value) {
        setState(() {
          loading = false;
        });
        final respBody = jsonDecode(value["body"]);
        userData.state = respBody?["data"];
        ToastMessage.success("Signed in");
        onLogin();
      }).catchError((e) {
        setState(() {
          loading = false;
        });
        final respBody = jsonDecode(e?["body"]);
        if (respBody?["data"]?["errors"] != null) {
          shared_logger.e(respBody?["data"]?["errors"]);
        }
        ToastMessage.show(respBody?["msg"], respBody?["status"]);
      });
    }
  }

  Future signWithMobile(credential) async {
    try {
      var ft = await auth.signInWithCredential(credential);
      setState(() {
        verificationId = "";
        otpStatus = OtpStatus.verified;
      });
      _formKey.currentState!.validate();
      otpController.text = "";
      ToastMessage.error("Mobile number verified successfully");
      signUpOrLoginWithCredential();
      return ft;
    } catch (e) {
      print(e);
      setState(() {
        otpStatus = OtpStatus.invalidOTP;
        finalVerifiedMobileNumber = "";
      });
      _formKey.currentState!.validate();
      ToastMessage.error("Please enter correct OTP");
    }
  }

  void verifyMobileNumber() {
    MobileAuth.verify(
        phoneNumber: mobileNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY! (automatically get the OTP)
          await signWithMobile(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ToastMessage.error(e.toString());
          if (e.code == 'invalid-phone-number') {
            otpStatus = OtpStatus.invalidMobileNumber;
            _formKey.currentState!.validate();
            return;
          }
          print(e);
          setState(() {
            otpStatus = OtpStatus.invalidOTP;
          });
          _formKey.currentState!.validate();
        },
        codeAutoRetrievalTimeout: () {
          setState(() {
            otpStatus = OtpStatus.timeout;
          });
          _formKey.currentState!.validate();
          ToastMessage.error("Time out for auto retrieval of OTP");
        },
        codeSent: (String sentVerificationId, int? resendToken) {
          setState(() {
            otpStatus = OtpStatus.sent;
            verificationId = sentVerificationId;
            finalVerifiedMobileNumber = mobileNumberController.text;
          });
          _formKey.currentState!.validate();
          print("code sent");
          ToastMessage.error("code sent");
        });
  }

  void verifyOTP() async {
    if (verificationId == "") {
      ToastMessage.error("Please click 'Get OTP'");
      return;
    }
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpController.text);

    // Sign the user in (or link) with the credential
    await signWithMobile(credential);
  }

  final mobileNumberRegex = RegExp(r'^(\+\d{1,3}[- ]?)?\d{10}$');

  Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;

    /// if [500] is the default color, there are at LEAST five
    /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
    /// divisor of 5 would mean [50] is a lightness of 1.0 or
    /// a color of #ffffff. A value of six would be near white
    /// but not quite.
    const lowDivisor = 6;

    /// if [500] is the default color, there are at LEAST four
    /// steps above [500]. A divisor of 4 would mean [900] is
    /// a lightness of 0.0 or color of #000000
    const highDivisor = 5;

    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;

    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Login / Signup"),
          ],
        ),
        foregroundColor: const Color(0xFF6750A3),
        // automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const OrganizationBanner(),
                const SizedBox(height: 40),
                TextFormField(
                  controller: mobileNumberController,
                  cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                  maxLength: 15,
                  validator: (value) => (value != "" &&
                          value != null &&
                          !mobileNumberRegex.hasMatch(value))
                      ? "Invalid mobile number"
                      : null,
                  onChanged: (value) {
                    setState(() {
                      otpStatus = OtpStatus.none;
                      validMobileNumber = mobileNumberRegex.hasMatch(value);
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/callText.svg",
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF6750A4),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    labelText: 'Mobile number',
                    border: const OutlineInputBorder(),
                    labelStyle: const TextStyle(
                      color: Color(0xFF6750A4),
                    ),
                    helperText: 'Example: +919482399078',
                    suffixIcon: mobileNumberController.text != ""
                        ? validMobileNumber
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF6750A4),
                                size: 28,
                              )
                            : Container(
                                width: 16,
                                height: 16,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: const Icon(
                                  Icons.clear_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                        : null,
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(149, 102, 80, 164)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6750A4)),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                ...(() {
                  if (validMobileNumber) {
                    return [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: (() {
                          if (signUp) {
                            return ElevatedButton(
                              onPressed: () {
                                otpStatus = OtpStatus.none;
                                finalVerifiedMobileNumber = "";
                                verifyMobileNumber();
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                                overlayColor: MaterialStateProperty.all(
                                    const Color.fromARGB(27, 104, 80, 163)),
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                  Color.fromARGB(255, 255, 255, 255),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: const BorderSide(
                                      color: Color(0xFF6750A3),
                                    ),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Send OTP",
                                    style: TextStyle(
                                      color: Color(0xFF6750A3),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(
                                    "assets/icons/send.svg",
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF6750A3),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  signUp = true;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Don't have account yet?",
                                    style: TextStyle(
                                      color: Color(0xFFFF0099),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Color(0xFF6750A3),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        })(),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: otpController,
                        cursorColor:
                            Theme.of(context).textSelectionTheme.cursorColor,
                        maxLength: 15,
                        decoration: InputDecoration(
                          labelText: signUp ? 'OTP' : "PASSWORD",
                          labelStyle: const TextStyle(
                            color: Color(0xFF6750A4),
                          ),
                          helperText:
                              'Warning: Entering more than 3 wrong otp will block sign in for next 5 minutes',
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(149, 102, 80, 164)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6750A4)),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...(() {
                        if (otpStatus == OtpStatus.sent ||
                            otpStatus == OtpStatus.verified) {
                          return [
                            TextFormField(
                              controller: nameController,
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              maxLength: 15,
                              decoration: const InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(
                                  color: Color(0xFF6750A4),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(149, 102, 80, 164)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF6750A4)),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              maxLength: 15,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  color: Color(0xFF6750A4),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(149, 102, 80, 164)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF6750A4)),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: confirmPasswordController,
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              maxLength: 15,
                              validator: (value) => (value != "" &&
                                      value != null &&
                                      value != passwordController.text)
                                  ? "Password didn't matched"
                                  : null,
                              decoration: const InputDecoration(
                                labelText: "Confirm Password",
                                labelStyle: TextStyle(
                                  color: Color(0xFF6750A4),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(149, 102, 80, 164)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF6750A4)),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ];
                        }
                        return [];
                      })(),
                      (() {
                        if (!signUp || otpStatus != OtpStatus.none) {
                          return ElevatedButton(
                            onPressed: () {
                              if (!signUp || otpStatus == OtpStatus.verified) {
                                signUpOrLoginWithCredential();
                                return;
                              }
                              if (otpStatus != OtpStatus.none) {
                                verifyOTP();
                              }
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                              ),
                              backgroundColor:
                                  const MaterialStatePropertyAll<Color>(
                                      Color(0xFF6750A3)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: const BorderSide(
                                      color: Color.fromARGB(0, 255, 255, 255)),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  signUp ? "Sign Up" : "Login",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      })(),
                    ];
                  }
                  return [];
                })(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
