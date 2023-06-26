import 'package:cca_vijayapura/screens/playlistVideos/videosSlider/widget.dart';
import 'package:cca_vijayapura/sharedComponents/NestedWillPopScope/widget.dart';
import 'package:cca_vijayapura/sharedComponents/videoPlayer/widget.dart';
import 'package:flutter/material.dart';

class WatchVideo extends StatefulWidget {
  const WatchVideo({Key? key}) : super(key: key);

  @override
  State<WatchVideo> createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {
  VideoLists? videoData;

  Map routeArguments = {};

  void fetchPlaylist() {
    final video = routeArguments["video_data"] as VideoLists;
    setState(() {
      videoData = video;
    });
  }

  bool onBack() {
    if (routeArguments["backToRooute"] != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routeArguments["backToRooute"],
        (Route<dynamic> route) => false,
        arguments: routeArguments["backRouteArgs"],
      );
      return false;
    }
    //  else {
    //   if (ModalRoute.of(context)?.willHandlePopInternally ?? false) {
    //     Navigator.of(context).pop();
    //   }
    // }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        routeArguments = ModalRoute.of(context)!.settings.arguments as Map;
      });
      fetchPlaylist();
    });
  }

  Uri FullURI = Uri.parse(
      """${const String.fromEnvironment("SERVER_PROTOCOL")}://${const String.fromEnvironment("SERVER_HOST")}:${const String.fromEnvironment("SERVER_PORT")}""");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedWillPopScope(
          onWillPop: (data) async {
            return Future.value(onBack());
          },
          child: Container(
            child: videoData != null && videoData!.paid
                ? CustomVideoPlayer(
                    videoUrl: "$FullURI${videoData!.linkToVideoStream}",
                    fullscreen: true,
                    onBack: onBack,
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
