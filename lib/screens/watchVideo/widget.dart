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
    // exeFetch(uri: "/forward/test");
    // exeFetch(
    //   uri: "/api/user/get_stream_key/",
    //   method: "post",
    //   body: jsonEncode({
    //     "video_id": video.id,
    //     "app_id": const String.fromEnvironment("APP_ID"),
    //   }),
    // ).then((body) {
    //   final data = jsonDecode(body["body"])["data"];
    //   shared_logger.d(data);
    //   shared_logger.d(DecryptAES(const String.fromEnvironment("APP_SECRET"),
    //       data["block_size"], data["key"]));
    //   // setState(() {
    //   //   streamLink
    //   // });
    // }).catchError((e, s) {
    //   shared_logger.e(e);
    // });
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
          child: videoData != null
              ? CustomVideoPlayer(
                  videoUrl: "$FullURI${videoData!.linkToVideoStream}")
              : const SizedBox(),
        ),
      ),
    );
  }
}
