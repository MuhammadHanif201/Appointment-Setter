import 'package:flutter/material.dart';
// import your actual YouTube player package here

class VideoPlayerContainer extends StatelessWidget {
  final String videoId;
  final double height;
  final double width;

  const VideoPlayerContainer({
    super.key,
    required this.videoId,
    this.height = 432.2,
    this.width = 768,
  });

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual YouTube player widget
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: Text(
          'YouTube Player for videoId: $videoId',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
