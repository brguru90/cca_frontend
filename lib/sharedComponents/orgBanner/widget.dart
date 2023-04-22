import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrganizationBanner extends StatelessWidget {
  const OrganizationBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 150, minHeight: 150),
            child: SvgPicture.asset(
              "assets/icons/logo.svg",
              // colorFilter: const ColorFilter.mode(
              //   Color(0xFF6750A3),
              //   BlendMode.srcIn,
              // ),
            ),
          ),
        ),
        const Flexible(
          child: Text(
            "Chanakya Career Academy Vijayapura",
            style: TextStyle(
              color: Color(0xFF6750A3),
              fontSize: 24,
              fontWeight: FontWeight.w800,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Color.fromARGB(153, 0, 0, 0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
