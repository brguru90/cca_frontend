import 'package:cca_vijayapura/sharedState/state.dart';
import 'package:flutter/material.dart';

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
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child:
                        Image.asset("assets/icons/home.png", fit: BoxFit.cover),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/study_materials'),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset("assets/icons/library.png",
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child:
                      Image.asset("assets/icons/ebook.png", fit: BoxFit.cover),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
