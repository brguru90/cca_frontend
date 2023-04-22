import 'package:flutter/material.dart';
import 'package:cca_vijayapura/screens/landing/body.dart';
import 'package:cca_vijayapura/screens/landing/header.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
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
