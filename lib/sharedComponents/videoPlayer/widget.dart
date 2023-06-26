import 'package:flutter/material.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool fullscreen;
  final void Function()? onBack;
  const CustomVideoPlayer(
      {Key? key, required this.videoUrl, this.fullscreen = false, this.onBack})
      : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool fullscreen = false;
  bool isLoaded = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (event) {
        // if (_myWidgetState.currentState?.mounted != null) {
        //   _myWidgetState.
        // }
      },
      child: YoYoPlayer(
        defaultQualityToBeHeigh: true,
        onLoad: (loaded) => {
          setState(() {
            isLoaded = loaded;
          })
        },
        onBack: widget.onBack,
        aspectRatio: 16 / 9,
        displayFullScreenAfterInit: widget.fullscreen,
        url: widget.videoUrl,
        videoStyle: const VideoStyle(
          qualityOptionsPadding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          qualityStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          forwardAndBackwardBtSize: 30.0,
          playButtonIconSize: 40.0,
          playIcon: Icon(
            Icons.play_arrow,
            size: 40.0,
            color: Colors.white,
          ),
          pauseIcon: Icon(
            Icons.pause,
            size: 40.0,
            color: Colors.white,
          ),
          videoQualityPadding: EdgeInsets.all(5.0),
          progressIndicatorPadding: EdgeInsets.only(top: 20),
        ),
        videoLoadingStyle: const VideoLoadingStyle(
          loading: Center(
            child: Text(
              "Loading...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
        allowCacheFile: false,
        onCacheFileCompleted: (files) {
          print('Cached file length ::: ${files?.length}');

          if (files != null && files.isNotEmpty) {
            for (var file in files) {
              print('File path ::: ${file.path}');
            }
          }
        },
        onCacheFileFailed: (error) {
          print('Cache file error ::: $error');
        },
        onFullScreen: (value) {
          if (widget.fullscreen && !value) {
            if (widget.onBack != null) {
              widget.onBack!();
            }
          }
        },
      ),
    );
  }
}
