import 'dart:convert';

import 'package:cca_vijayapura/screens/coursePlaylist/widget.dart';
import 'package:cca_vijayapura/services/http_request.dart';
import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:cca_vijayapura/sharedComponents/toastMessages/toastMessage.dart';
import 'package:flutter/material.dart';

class VideoLists {
  final String id, title, description, createdBy;
  final String linkToVideoPreviewImage, linkToVideoStream;
  final bool paid;

  VideoLists({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.linkToVideoPreviewImage,
    required this.linkToVideoStream,
    required this.paid,
  });
}

class VideosSlider extends StatefulWidget {
  const VideosSlider({Key? key}) : super(key: key);

  @override
  State<VideosSlider> createState() => _VideosSliderState();
}

class _VideosSliderState extends State<VideosSlider> {
  List<VideoLists> videoList = [];

  void fetchPlaylist() {
    final args = (ModalRoute.of(context)!.settings.arguments as Map);
    final playlist = args["playlist"] as Playlist;

    exeFetch(
      uri: "/api/user/get_videos/",
      method: "post",
      body: jsonEncode({
        "video_ids": playlist.videos.map((video) => video.id).toList(),
      }),
    ).then((body) {
      final data = jsonDecode(body["body"])["data"] as List;
      shared_logger.d(data);
      setState(() {
        videoList = data.map((video) {
          return VideoLists(
            id: video["_id"],
            title: video["title"],
            description: video["description"],
            createdBy: video["created_by_user"],
            linkToVideoPreviewImage: video["link_to_video_preview_image"] ?? "",
            linkToVideoStream: video["link_to_video_stream"] ?? "",
            paid: args["paid"],
          );
        }).toList();
      });
      shared_logger.d(videoList);
    }).catchError((e, s) {
      shared_logger.e(e);
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

  String FullURI =
      """${const String.fromEnvironment("SERVER_PROTOCOL")}://${const String.fromEnvironment("SERVER_HOST")}:${const String.fromEnvironment("SERVER_PORT")}""";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...videoList.asMap().entries.map((item) {
          final video = item.value;
          final imagePreviewUrl = "$FullURI${video.linkToVideoPreviewImage}";
          return Padding(
            padding: EdgeInsets.only(top: item.key == 0 ? 0 : 20),
            child: GestureDetector(
              onTap: () {
                if (!video.paid) {
                  ToastMessage.warning("Playlist is not purchased");
                  return;
                }
                if (video.linkToVideoStream.trim() == "") {
                  ToastMessage.warning("Video link not available yet");
                  return;
                }
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/watch_video',
                  (Route<dynamic> route) => false,
                  arguments: {
                    "video_data": video,
                    "backToRooute": "/playlist_videos",
                    "backRouteArgs": ModalRoute.of(context)!.settings.arguments,
                  },
                );
              },
              child: SizedBox(
                height: 110,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/loading.png",
                              image: imagePreviewUrl,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.low,
                              height: 400,
                              imageCacheHeight: 400,
                              placeholderCacheHeight: 400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title.toString(),
                            style: const TextStyle(
                              fontSize: 22.0,
                              color: Color(0xFF6750A3),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            video.createdBy.toString(),
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFFFF0099),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
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
            ),
          );
        }).toList(),
        const SizedBox(height: 10),
      ],
    );
  }
}
