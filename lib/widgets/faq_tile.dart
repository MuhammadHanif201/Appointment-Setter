import 'dart:math' as math;

import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';

/// Frames a YouTube player. [height] and [width] are the preferred size — the
/// frame shrinks to whatever room the parent has and keeps its 16:9 ratio, so
/// it never overflows on a phone.
///
/// The frame itself (dark well, hairline rim, card shadow, radius) is
/// [VideoFrame], applied by [YouTubePlayerWidget]; this only decides how much
/// room the player gets.
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : context.screenWidth - context.hPad * 2;

        // Width is the only thing set here: the player keeps 16:9 itself, so
        // the height cap is expressed as the width it allows.
        final resolvedWidth = math.min<double>(
          math.min<double>(width, height * 16 / 9),
          math.max<double>(available, 0),
        );

        return SizedBox(
          width: resolvedWidth,
          child: YouTubePlayerWidget(videoId: videoId),
        );
      },
    );
  }
}
