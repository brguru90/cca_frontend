import 'dart:async';
import 'dart:convert';

import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/social_authentication.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:cca_vijayapura/sharedComponents/toastMessages/toastMessage.dart';
import 'package:cca_vijayapura/sharedState/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingBody extends StatefulWidget {
  const LandingBody({Key? key}) : super(key: key);

  @override
  State<LandingBody> createState() => _LandingBodyState();
}

class _LandingBodyState extends State<LandingBody> {
  bool loading = false;

  Future<Map> onSignUp(
    String username,
    String email,
    String password,
  ) async {
    print("signup");
    Map errors = {};
    if (password.trim() == "") {
      errors["password"] = "Password should not be empty";
    }

    if (errors.isEmpty) {
      Completer<Map> c = Completer();
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        loading = true;
      });
      var response = await exeFetch(
        uri: "/api/sign_up/",
        method: "post",
        body: jsonEncode({
          "email": email,
          "username": username,
          "password": password,
        }),
      ).then((value) {
        setState(() {
          loading = false;
        });
        final respBody = jsonDecode(value["body"]);
        userData.state = respBody?["data"];
        ToastMessage.success("signedup");
        c.complete({"errors": errors, "body": respBody});
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (Route<dynamic> route) => false);
      }).catchError((e) {
        setState(() {
          loading = false;
        });
        final respBody = jsonDecode(e?["body"]);
        // c.completeError(e);
        if (respBody?["data"]?["errors"] != null) {
          errors.addAll(respBody?["data"]?["errors"]);
        } else {
          ToastMessage.show(respBody?["msg"], respBody?["status"]);
        }
        print(errors);
        c.complete({"errors": errors, "body": respBody});
      });
      return c.future;
    } else {
      ToastMessage.error(const JsonEncoder().convert(errors));
      return {"errors": errors};
    }
  }

  void socialLogin(String provider) {
    setState(() {
      loading = true;
    });
    socialAuth(provider: provider).then((value) async {
      await getTokenVerified();
      setState(() {
        loading = false;
      });
      Navigator.pushNamedAndRemoveUntil(
          context, "/home", (Route<dynamic> route) => false);
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      shared_logger.e(e);
      ToastMessage.error(const JsonEncoder().convert(e));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, "/signUpMobile"),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                    ),
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                      Color(0xFF6750A3),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                            color: Color.fromARGB(0, 255, 255, 255)),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/callText.svg",
                        colorFilter: const ColorFilter.mode(
                          Color.fromARGB(255, 255, 255, 255),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Sign up with your phone number",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      FractionallySizedBox(
                        widthFactor: 0.4,
                        child: Row(
                          children: const [
                            Flexible(
                              child: Divider(
                                color: Color(0XFFBBB2D3),
                                thickness: 1.2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Color(0xFF6750A3),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Flexible(
                              child: Divider(
                                color: Color(0XFFBBB2D3),
                                thickness: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => socialLogin("google"),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                    ),
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                        Color(0xFF6750A3)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                            color: Color.fromARGB(0, 255, 255, 255)),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Image.asset("assets/icons/google.png",
                            fit: BoxFit.cover),
                      ),
                      // const SizedBox(width: 20),
                      const Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.7,
                          child: Text(
                            "Login with Google",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => socialLogin("facebook"),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                    ),
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                        Color(0xFF6750A3)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                            color: Color.fromARGB(0, 255, 255, 255)),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Image.asset("assets/icons/fb.png",
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 20),
                      const Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.7,
                          child: Text(
                            "Login with Facebook",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
