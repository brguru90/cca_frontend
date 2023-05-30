import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/secure_store.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  void logout(context) async {
    exeFetch(
      uri: "/api/user/logout/",
    ).then((value) async {
      temp_store["cookies"] = null;
      await storage.delete(key: "cookies");
      Navigator.pushReplacementNamed(context, "/");
    }).catchError((e) => print(e));
  }

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
          onTap: () => logout(context),
          child: Row(
            children: [
              const Text(
                "Sathya",
                style: TextStyle(
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
