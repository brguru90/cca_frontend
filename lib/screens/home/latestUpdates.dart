import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LatestUpdates extends StatefulWidget {
  const LatestUpdates({Key? key}) : super(key: key);

  @override
  State<LatestUpdates> createState() => _LatestUpdatesState();
}

class _LatestUpdatesState extends State<LatestUpdates> {
  final items = [1, 2, 3, 4, 5];
  int currentSlide = 0;
  bool autoPlay = true;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: autoPlay,
            height: 200.0,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            onPageChanged: (i, _) => setState(() => currentSlide = i),
          ),
          items: items.asMap().entries.map((item) {
            final i = item.key;
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6750A3),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text(
                    'text $i',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.asMap().entries.map((item) {
            final i = item.key;
            return GestureDetector(
              onTap: () {
                _controller.stopAutoPlay();
                setState(() {
                  _controller.jumpToPage(i);
                  autoPlay = false;
                });
              },
              child: Container(
                width: i == currentSlide ? 12 : 9,
                height: i == currentSlide ? 12 : 9,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF6750A3),
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
