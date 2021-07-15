import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String mediaUrl;

  CustomVideoPlayer(this.mediaUrl);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Container();
  }
}

// floatingActionButton: FloatingActionButton(
// onPressed: () {
// // Wrap the play or pause in a call to `setState`. This ensures the
// // correct icon is shown.
// setState(() {
// // If the video is playing, pause it.
// if (_controller.value.isPlaying) {
// _controller.pause();
// } else {
// // If the video is paused, play it.
// _controller.play();
// }
// });
// },
// // Display the correct icon depending on the state of the player.
// child: Icon(
// _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
// ),
// ),