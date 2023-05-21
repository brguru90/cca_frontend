import 'dart:convert';

import 'package:cca_vijayapura/screens/coursePlaylist/playlistSlider/widget.dart';
import 'package:cca_vijayapura/screens/home/bottomNavBar.dart';
import 'package:cca_vijayapura/screens/home/header.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:flutter/material.dart';

class PlaylistVideo {
  final String id;
  final String title;
  final String linkToVideoPreviewImage;

  PlaylistVideo({
    required this.id,
    required this.title,
    required this.linkToVideoPreviewImage,
  });
}

class Playlist {
  final String id;
  final String title;
  final List<PlaylistVideo> videos;

  Playlist({
    required this.id,
    required this.title,
    required this.videos,
  });
}

class CoursePlaylist extends StatefulWidget {
  const CoursePlaylist({Key? key}) : super(key: key);

  @override
  State<CoursePlaylist> createState() => _CoursePlaylistState();
}

class _CoursePlaylistState extends State<CoursePlaylist> {
  ScrollController scrollController = ScrollController();
  double scrollCount = 0;

  List<Playlist> playlists = [];

  void fetchPlaylist() {
    exeFetch(
      uri: "/api/user/get_playlists/",
    ).then((body) {
      final data = jsonDecode(body["body"])["data"] as List;
      shared_logger.d(data);
      setState(() {
        playlists = data.map((playlist) {
          return Playlist(
            id: playlist["_id"],
            title: playlist["title"],
            videos: (playlist["videos_ids"] as List).map((video) {
              return PlaylistVideo(
                id: video["video_id"],
                title: video["title"],
                linkToVideoPreviewImage: video["link_to_video_preview_image"],
              );
            }).toList(),
          );
        }).toList();
      });
      shared_logger.d(playlists);
    }).catchError((e, s) {
      shared_logger.e(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPlaylist();
  }

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
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: HomeHeader(),
              ),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              // children: const [
                              //   PlaylistSlider(),
                              //   PlaylistSlider(),
                              //   PlaylistSlider(),
                              //   PlaylistSlider(),
                              //   SizedBox(height: 10),
                              // ],
                              children: playlists
                                  .map((playlist) =>
                                      PlaylistSlider(playlist: playlist))
                                  .toList(),
                            ),
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
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}
