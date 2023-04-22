import 'package:cca_vijayapura/screens/landing/body.dart';
import 'package:cca_vijayapura/screens/landing/header.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

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
