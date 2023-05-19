import 'package:flutter/material.dart';

class VideosSlider extends StatefulWidget {
  const VideosSlider({Key? key}) : super(key: key);

  @override
  State<VideosSlider> createState() => _VideosSliderState();
}

class _VideosSliderState extends State<VideosSlider> {
  final items = [1, 2, 3, 4, 5, 6, 7, 8];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...items.asMap().entries.map((item) {
          return Padding(
            padding: EdgeInsets.only(top: item.key == 0 ? 0 : 20),
            child: SizedBox(
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/images/course.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Introduction to PCI",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFF6750A3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "By Shreekanth",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFFF0099),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "1 Hour 10 Mins",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF595959),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 10),
      ],
    );
  }
}
