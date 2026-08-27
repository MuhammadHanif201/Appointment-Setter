import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';

/// A placeholder frame for a video. It borrows the real player's letterbox
/// ([VideoFrame]) so a stand-in and a live player never look like two different
/// components, and caps itself at [width] / [height] while still shrinking to
/// whatever room the parent gives it.
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
    final badgeSize =
        context.responsive(mobile: 44.0, tablet: 52.0, desktop: 56.0);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width, maxHeight: height),
      child: VideoFrame(
        child: Padding(
          padding: EdgeInsets.all(context.cardPad),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pale gold disc, gold *ink* glyph — the fill is the badge, the
              // icon still has to be read.
              Container(
                width: badgeSize,
                height: badgeSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.primaryInk,
                  size: badgeSize * 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              Flexible(
                child: Text(
                  'YouTube Player for videoId: $videoId',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  // Copy on the one dark surface in the theme.
                  style: AppText.bodySmall(
                    context,
                    color: AppColors.textOnDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
