import 'package:flutter/material.dart';

class ProvidedServices extends StatelessWidget {
  const ProvidedServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset("assets/icons/caDialy.png",
                      fit: BoxFit.cover),
                ),
                const SizedBox(height: 5),
                const Text(
                  "CA Dialy",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/course_playlist'),
              child: Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset("assets/icons/courses.png",
                        fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Courses",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/study_materials'),
              child: Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset("assets/icons/download.png",
                        fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Downloads",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child:
                      Image.asset("assets/icons/test.png", fit: BoxFit.cover),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Practice test",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child:
                      Image.asset("assets/icons/videos.png", fit: BoxFit.cover),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Videos",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset("assets/icons/gk.png", fit: BoxFit.cover),
                ),
                const SizedBox(height: 5),
                const Text(
                  "G K",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
