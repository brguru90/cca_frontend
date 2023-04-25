import 'package:cca_vijayapura/sharedComponents/orgBanner/widget.dart';
import 'package:flutter/material.dart';

class SocialAccountSignup extends StatefulWidget {
  const SocialAccountSignup({Key? key}) : super(key: key);

  @override
  State<SocialAccountSignup> createState() => _SocialAccountSignupState();
}

class _SocialAccountSignupState extends State<SocialAccountSignup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Signup/Login"),
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
          child: Column(
            children: const [
              SizedBox(height: 40),
              OrganizationBanner(),
            ],
          ),
        ),
      ),
    );
  }
}