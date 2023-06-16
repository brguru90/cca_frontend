import 'package:cca_vijayapura/sharedState/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: SvgPicture.asset(
            "assets/icons/logo.svg",
            // colorFilter: const ColorFilter.mode(
            //   Color(0xFF6750A3),
            //   BlendMode.srcIn,
            // ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/account"),
          child: Row(
            children: [
              Text(
                userData.state!.userName,
                style: const TextStyle(
                  color: Color(0xFF6750A3),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  "assets/icons/userAcc.svg",
                  // colorFilter: const ColorFilter.mode(
                  //   Color(0xFF6750A3),
                  //   BlendMode.srcIn,
                  // ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
