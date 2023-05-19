import 'package:cca_vijayapura/screens/coursePlaylist/playlistSlider/widget.dart';
import 'package:cca_vijayapura/screens/home/header.dart';
import 'package:flutter/material.dart';

class CoursePlaylist extends StatefulWidget {
  const CoursePlaylist({Key? key}) : super(key: key);

  @override
  State<CoursePlaylist> createState() => _CoursePlaylistState();
}

class _CoursePlaylistState extends State<CoursePlaylist> {
  ScrollController scrollController = ScrollController();
  double scrollCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const HomeHeader(),
      //   backgroundColor: Colors.white,
      //   automaticallyImplyLeading: false,
      // ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const HomeHeader(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/training.png",
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  ),
                  const Text(
                    "Courses",
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Color(0xFF6750A3),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0, // shadow blur
                          color: Color.fromARGB(
                              255, 145, 142, 142), // shadow color
                          offset:
                              Offset(2.0, 3.0), // how much shadow will be shown
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: NotificationListener(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification &&
                              scrollNotification.metrics.axis ==
                                  Axis.vertical) {
                            // print(scrollNotification.metrics.pixels);
                            setState(() {
                              scrollCount = scrollNotification.metrics.pixels;
                            });
                            // print(scrollNotification.metrics.axis);
                          }
                          return true;
                        },
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: const [
                              PlaylistSlider(),
                              PlaylistSlider(),
                              PlaylistSlider(),
                              PlaylistSlider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    scrollCount >= 2
                        ? Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            height: 50,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                    0.0,
                                    0.5,
                                    1,
                                  ],
                                  colors: [
                                    Color.fromARGB(255, 255, 255, 255),
                                    Color.fromARGB(135, 255, 255, 255),
                                    Color.fromARGB(0, 255, 255, 255),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const Positioned(
                            height: 0,
                            width: 0,
                            child: SizedBox(),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
