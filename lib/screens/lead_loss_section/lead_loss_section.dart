import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';

/// The demo video section: kicker, headline, supporting copy, the embedded
/// player and the primary call to action.
///
/// The gold in this band belongs to the call to action, so the headline
/// emphasis is carried two-tone by the text ramp instead of the accent.
class LeadLossSection extends StatelessWidget {
  const LeadLossSection({super.key});

  /// Widest the embedded player is allowed to get; it shrinks with the column
  /// on anything narrower.
  static const double _maxVideoWidth = 768;

  /// Readable measures for the centred copy above the player.
  static const double _headingWidth = 900;
  static const double _bodyWidth = 760;

  @override
  Widget build(BuildContext context) {
    // Two-tone headline: the sentence sits on the secondary ink and the phrase
    // that matters steps up to the primary ink.
    final headingStyle = AppText.h1(context, color: AppColors.textSecondary);
    final headingEmphasis = AppText.h1(context);

    final bodyStyle = AppText.bodyLarge(context);

    // Inline emphasis without spending gold: brighter ink, one weight step up.
    final emphasisStyle =
        AppText.bodyLarge(context, color: AppColors.textPrimary)
            .copyWith(fontWeight: FontWeight.w600);

    return SectionContainer(
      // White band: the section above it is the warm off-white step, so the two
      // separate on tone alone.
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kicker. Sits at the muted end of the ramp so it introduces the
          // headline instead of competing with it.
          TitleText(
            text: "Stop losing hot leads.",
            style: AppText.title(context, color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.s12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _headingWidth),
            child: Text.rich(
              TextSpan(
                text: "Follow-up every lead ",
                style: headingStyle,
                children: [
                  TextSpan(
                    text: "in 10 seconds.",
                    style: headingEmphasis,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _bodyWidth),
            child: Text.rich(
              TextSpan(
                text:
                    "First message in 10 seconds after form submission.\nThen human-like setting conversion and booking into your calendar.\nThis is how we achieve up to ",
                style: bodyStyle,
                children: [
                  TextSpan(
                    text: "52% lead-to-booking rates.",
                    style: emphasisStyle,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: context.blockGap),
          // The player draws its own `surfaceDark` letterbox — the one dark
          // surface this theme keeps — so all this section decides is how wide
          // it is allowed to get.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxVideoWidth),
            child: const YouTubePlayerWidget(
              videoId: 'ybcZQxpTrCs',
            ),
          ),
          SizedBox(
            height: context.responsive(
              mobile: AppSpacing.s20,
              tablet: AppSpacing.lg,
              desktop: AppSpacing.xl,
            ),
          ),
          // The single gold moment in this band. Without a handler an
          // ActionButton renders disabled — flat grey fill, muted label, no ink
          // and no cursor — so the placeholder is what keeps the section's
          // primary call to action reading as a call to action at all.
          ActionButton(
            text: "Get me a demo",
            icon: Icons.arrow_forward,
            size: ActionButtonSize.large,
            onPressed: () {},
            expand: context.isMobile,
          ),
        ],
      ),
    );
  }
}
