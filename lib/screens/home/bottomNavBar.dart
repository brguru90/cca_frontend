import 'package:cca_vijayapura/sharedState/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (() {
              if ((cartData.state?.playlists != null &&
                      cartData.state!.playlists.isNotEmpty) ||
                  (cartData.state?.playlistSubscriptionPackages != null &&
                      cartData
                          .state!.playlistSubscriptionPackages.isNotEmpty)) {
                return Container(
                  child: Row(
                    children: const [
                      Text(
                        "Items in Cart",
                        style: TextStyle(color: Colors.red, fontSize: 24),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            })(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (Route<dynamic> route) => false),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child:
                        Image.asset("assets/icons/home.png", fit: BoxFit.cover),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context,
                      '/study_materials', (Route<dynamic> route) => false),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset("assets/icons/library.png",
                        fit: BoxFit.cover),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, "/account", (Route<dynamic> route) => false),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset(
                      "assets/icons/userAcc.svg",
                      colorFilter: const ColorFilter.mode(
                        Color.fromARGB(255, 241, 106, 82),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
