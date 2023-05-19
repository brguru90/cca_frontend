import 'package:cca_vijayapura/sharedComponents/videoPlayer/widget.dart';
import 'package:flutter/material.dart';

class WatchVideo extends StatelessWidget {
  const WatchVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: const CustomVideoPlayer(
              videoUrl:
                  "http://127.0.0.1:8000/cdn/video/multi_bitrate/tutorial_name/playlist.m3u8"),
        ),
      ),
    );
  }
}
