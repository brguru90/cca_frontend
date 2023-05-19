import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlaylistSlider extends StatefulWidget {
  const PlaylistSlider({Key? key}) : super(key: key);

  @override
  State<PlaylistSlider> createState() => _PlaylistSliderState();
}

class _PlaylistSliderState extends State<PlaylistSlider> {
  final items = [1, 2, 3, 4, 5];
  int currentSlide = 0;
  bool autoPlay = false;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "PC/PCI",
                style: TextStyle(
                    fontSize: 24.0,
                    color: Color(0xFF6750A3),
                    fontWeight: FontWeight.w800),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/playlist_videos'),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/right_arrow.svg",
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF0099),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "full course",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFFFF0099),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: autoPlay,
            height: 180.0,
            disableCenter: true,
            enableInfiniteScroll: false,
            viewportFraction: 0.7,
            padEnds: false,
            // enlargeCenterPage: true,
            onPageChanged: (i, _) => setState(() => currentSlide = i),
          ),
          items: items.asMap().entries.map((item) {
            final i = item.key;
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: i == 0 ? 0 : 15),
                          width: MediaQuery.of(context).size.width,
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 15.0, vertical: 10),
                          // decoration: BoxDecoration(
                          //   color: const Color(0xFF6750A3),
                          //   borderRadius: BorderRadius.circular(18.0),
                          // ),
                          child: Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                "assets/images/course.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          "Introduction to course",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }).toList(),
        )
      ],
    );
  }
}
