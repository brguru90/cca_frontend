import 'package:cca_vijayapura/screens/playlistVideos/videosSlider/widget.dart';
import 'package:cca_vijayapura/sharedComponents/videoPlayer/widget.dart';
import 'package:flutter/material.dart';

class WatchVideo extends StatefulWidget {
  const WatchVideo({Key? key}) : super(key: key);

  @override
  State<WatchVideo> createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {
  VideoLists? videoData;

  void fetchPlaylist() {
    final video = ModalRoute.of(context)!.settings.arguments as VideoLists;
    setState(() {
      videoData = video;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPlaylist();
    });
  }

  Uri FullURI = Uri.parse(
      """${const String.fromEnvironment("SERVER_PROTOCOL")}://${const String.fromEnvironment("SERVER_HOST")}:${const String.fromEnvironment("SERVER_PORT")}""");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: videoData != null && videoData!.paid
              ? CustomVideoPlayer(
                  videoUrl: "$FullURI${videoData!.linkToVideoStream}",
                  fullscreen: true,
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
