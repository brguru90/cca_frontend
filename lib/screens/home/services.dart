import 'package:flutter/material.dart';

class ProvidedServices extends StatelessWidget {
  const ProvidedServices({Key? key}) : super(key: key);

  Widget commingSoonLabel() {
    return Positioned.fill(
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FractionalTranslation(
            translation: const Offset(0, 1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: const Text(
                "Comming soon",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
                      "Study material",
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
              Stack(
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
                  commingSoonLabel(),
                ],
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset("assets/icons/test.png",
                            fit: BoxFit.cover),
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
                  commingSoonLabel(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset("assets/icons/videos.png",
                            fit: BoxFit.cover),
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
                  commingSoonLabel(),
                ],
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset("assets/icons/gk.png",
                            fit: BoxFit.cover),
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
                  commingSoonLabel(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
