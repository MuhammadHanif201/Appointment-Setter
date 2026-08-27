import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';

/// Video on one side, a single claim on the other. Two columns only once there
/// is real room for them — on tablets the pair stacks so neither half gets
/// squeezed into an unreadable strip.
///
/// The band is white: the dark 16:9 well is the contrast in this section, and
/// the statement band that follows it is the warm one.
class SetterAIVideoSection extends StatelessWidget {
  const SetterAIVideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stacked = !context.isDesktop;

    const video = YouTubePlayerWidget(videoId: 'ybcZQxpTrCs');

    return SectionContainer(
      color: AppColors.background,
      child: stacked
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Capped so the frame does not sprawl across a wide tablet.
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: video,
                ),
                SizedBox(height: context.blockGap),
                const _Heading(textAlign: TextAlign.center),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(flex: 6, child: video),
                SizedBox(width: context.blockGap),
                const Expanded(
                  flex: 5,
                  child: _Heading(textAlign: TextAlign.left),
                ),
              ],
            ),
    );
  }
}

class _Heading extends StatelessWidget {
  final TextAlign textAlign;

  const _Heading({required this.textAlign});

  @override
  Widget build(BuildContext context) {
    final style = context.responsive(
      mobile: AppText.h2(context),
      tablet: AppText.h1(context),
    );

    return Text.rich(
      TextSpan(
        text: "Setter AI requires ",
        children: [
          // The one gold moment in this section.
          TextSpan(
            text: "zero change\n",
            style: style.copyWith(color: AppColors.primaryInk),
          ),
          const TextSpan(text: "to your business."),
        ],
      ),
      textAlign: textAlign,
      style: style,
    );
  }
}
