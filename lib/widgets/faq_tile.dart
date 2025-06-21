import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';

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
    return SizedBox(
      height: height,
      width: width,
      child: YouTubePlayerWidget(videoId: videoId),
    );
  }
}
