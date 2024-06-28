import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

// 동영상 위젯 생성
class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    super.key,
    required this.video,
    required this.onNewVideoPressed,
  });
  @override
  State<StatefulWidget> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  final Duration skipTime = const Duration(seconds: 3);
  bool showControlIcons = false;

  @override
  void initState() {
    super.initState();
    initializeVideoController();
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.path != widget.video.path) {
      initializeVideoController();
    }
  }

  // dispose 안하면 앱 실행 될 때마다 찌꺼기가 남아있음.
  @override
  void dispose() {
    videoPlayerController?.removeListener(videoContollerListener);
    super.dispose();
  }

  // 컨트롤러 초기화
  initializeVideoController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );
    await videoController.initialize();

    videoController.addListener(videoContollerListener);
    setState(() {
      this.videoPlayerController = videoController;
    });
  }

  void videoContollerListener() {
    setState(() {});
  }

  void onReversePressed() {
    final currentPosition = videoPlayerController!.value.position;
    Duration position = const Duration(); // 0초로 실행위치 초기화

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - skipTime;
    }

    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed() {
    final Duration maxPosition = videoPlayerController!.value.duration;
    final Duration currentPosition = videoPlayerController!.value.position;

    Duration position = maxPosition;

    if ((maxPosition - skipTime).inSeconds > currentPosition.inSeconds) {
      position = currentPosition + skipTime;
    }
    videoPlayerController!.seekTo(position);
  }

  void onPlayPressed() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControlIcons = !showControlIcons;
        });
      },
      child: AspectRatio(
        aspectRatio: videoPlayerController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(videoPlayerController!),
            if (showControlIcons)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Slider(
                min: 0,
                value:
                    videoPlayerController!.value.position.inSeconds.toDouble(),
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
                onPressed: widget.onNewVideoPressed,
                iconData: Icons.photo_camera_back,
              ),
            ),
            if (showControlIcons)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    CustomIconButton(
                      onPressed: onPlayPressed,
                      iconData: videoPlayerController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow_outlined,
                    ),
                    CustomIconButton(
                      onPressed: onForwardPressed,
                      iconData: Icons.rotate_right,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
