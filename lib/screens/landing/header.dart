import 'package:flutter/material.dart';
import 'package:cca_vijayapura/sharedComponents/orgBanner/widget.dart';

class LandingHeader extends StatelessWidget {
  const LandingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome to",
                style: TextStyle(
                  color: Color(0xFF6750A3),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("assets/icons/GraduationCap.png"),
              ),
              const OrganizationBanner(),
            ],
          ),
        ),
      ],
    );
  }
}
