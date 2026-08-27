import 'package:appointment_setter/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// The letterbox every video on the page sits in.
///
/// [AppColors.surfaceDark] is the one dark surface this theme keeps, because a
/// video reads best against a well rather than against white. On a white page
/// that well needs an edge and a little lift, so the frame carries a hairline
/// rim plus [AppShadows.card] — without them a dark rectangle looks pasted onto
/// the sheet. Anything drawn inside it is copy on a dark surface, so it uses
/// [AppColors.textOnDark] / [AppColors.textOnDarkMuted].
class VideoFrame extends StatelessWidget {
  /// Filled into a 16:9 box: the player itself, or a placeholder standing in
  /// for one.
  final Widget child;

  const VideoFrame({super.key, required this.child});

  static const double _hairline = 1;

  static const BorderRadius _radius =
      BorderRadius.all(Radius.circular(AppRadius.lg));

  /// The rim is painted by the decoration and `Container` insets the child by
  /// the border on its own, so the inner clip is one hairline tighter — that is
  /// what keeps an opaque player from painting over the edge.
  static const BorderRadius _innerRadius =
      BorderRadius.all(Radius.circular(AppRadius.lg - _hairline));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: _radius,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.border, width: _hairline),
        ),
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: _innerRadius,
        child: AspectRatio(aspectRatio: 16 / 9, child: child),
      ),
    );
  }
}

/// A YouTube player that always keeps a 16:9 frame and fills whatever width it
/// is given, so callers never have to hardcode a pixel size.
class YouTubePlayerWidget extends StatefulWidget {
  final String videoId;
  const YouTubePlayerWidget({super.key, required this.videoId});

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoFrame(
      child: YoutubePlayer(
        controller: _controller,
        aspectRatio: 16 / 9,
      ),
    );
  }
}
