import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

// 동영상 위젯 생성
class CustomVideoPlayer extends StatefulWidget {
  final XFile video;

  const CustomVideoPlayer({
    super.key,
    required this.video,
  });
  @override
  State<StatefulWidget> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    initializeVideoController();
  }

  // dispose 안하면 앱 실행 될 때마다 찌꺼기가 남아있음.
  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  // 컨트롤러 초기화
  initializeVideoController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );
    await videoController.initialize();

    setState(() {
      this.videoPlayerController = videoController;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return AspectRatio(
      aspectRatio: videoPlayerController!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(videoPlayerController!),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Slider(
              min: 0,
              value: videoPlayerController!.value.position.inSeconds.toDouble(),
              max: videoPlayerController!.value.duration.inSeconds.toDouble(),
              onChanged: (double val) {
                videoPlayerController!.seekTo(
                  Duration(seconds: val.toInt()),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: CustomIconButton(
              onPressed: () {},
              iconData: Icons.photo_camera_back,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomIconButton(
                    onPressed: () {},
                    iconData: Icons.rotate_left,
                  ),
                  CustomIconButton(
                    onPressed: () {},
                    iconData: videoPlayerController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow_outlined,
                  ),
                  CustomIconButton(
                    onPressed: () {},
                    iconData: Icons.rotate_right,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
