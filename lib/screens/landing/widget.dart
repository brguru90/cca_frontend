import 'dart:convert';

import 'package:cca_vijayapura/screens/landing/body.dart';
import 'package:cca_vijayapura/screens/landing/header.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/sharedState/state.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool isLoading = true;
  void checkExistingSession() {
    setState(() {
      isLoading = true;
    });
    exeFetch(
      uri: "/api/login_status/",
    ).then((value) {
      final respBody = jsonDecode(value["body"]);
      userData.state = respBody?["data"];
      Navigator.pushNamedAndRemoveUntil(
          context, "/home", (Route<dynamic> route) => false);
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkExistingSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: const [
                SizedBox(height: 20),
                LandingHeader(),
                SizedBox(height: 20),
                LandingBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
