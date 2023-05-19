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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset("assets/icons/home.png", fit: BoxFit.cover),
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset("assets/icons/library.png", fit: BoxFit.cover),
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset("assets/icons/ebook.png", fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
