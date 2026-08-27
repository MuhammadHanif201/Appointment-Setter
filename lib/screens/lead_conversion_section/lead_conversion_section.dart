import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:flutter/material.dart';

/// Headline + CTA on the left, the oversized "10s" stat on the right.
///
/// The stat is the one gold moment in this section, so the headline emphasis is
/// carried by the text ramp and the button steps down to the outlined variant —
/// nothing else competes for the accent.
class LeadConversionSection extends StatelessWidget {
  const LeadConversionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return SectionContainer(
      // White band. The featured quote above it is the warm one, so the two
      // separate without a rule between them; the stat card below carries a
      // hairline and a soft shadow, which is what lifts it off a white page.
      color: AppColors.background,
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top section (heading + button)
                const _ConversionHeadline(textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.lg),
                ActionButton(
                  text: "Get Started",
                  icon: Icons.arrow_forward_outlined,
                  variant: ActionButtonVariant.outlined,
                  size: ActionButtonSize.large,
                  expand: true,
                  // Without a handler `ActionButton` renders disabled: pale
                  // hairline, muted label, no cursor or ink. The CTA has to
                  // read as live.
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.xl),
                const _ConversionStat(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left section: Heading + Button
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ConversionHeadline(textAlign: TextAlign.start),
                      const SizedBox(height: AppSpacing.lg),
                      ActionButton(
                        text: "Get Started",
                        icon: Icons.arrow_forward_outlined,
                        variant: ActionButtonVariant.outlined,
                        size: ActionButtonSize.large,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.blockGap),
                // Right section: Big number + description
                const Expanded(
                  flex: 6,
                  child: _ConversionStat(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
    );
  }
}

/// The "Setter AI is the *fastest* way ..." headline. The manual line breaks in
/// the copy are preserved, but the text also soft wraps so it never overflows a
/// narrow column.
///
/// Emphasis is two-tone rather than gold: the sentence sits on the secondary
/// ink and the key word steps up to the primary ink.
class _ConversionHeadline extends StatelessWidget {
  final TextAlign textAlign;

  const _ConversionHeadline({required this.textAlign});

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppText.h1(context, color: AppColors.textSecondary);
    final emphasisStyle = AppText.h1(context);

    return Text.rich(
      TextSpan(
        text: "Setter AI is the\n",
        style: baseStyle,
        children: [
          TextSpan(
            text: "fastest",
            style: emphasisStyle,
          ),
          TextSpan(
            text: " way to turn leads\n into sales calls for\n businesses.",
            style: baseStyle,
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

/// The oversized "10s" stat and its caption, framed as a raised card so the
/// number reads as the anchor of the section.
///
/// White card, hairline border and a soft shadow — on a light page depth comes
/// from those three, not from heavy elevation.
class _ConversionStat extends StatelessWidget {
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign textAlign;

  /// Keeps the caption on a readable measure inside a wide card.
  static const double _captionWidth = 460;

  const _ConversionStat({
    required this.crossAxisAlignment,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final isCentred = textAlign == TextAlign.center;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          // `AppText.stat` already resolves to `primaryInk`, which reads at
          // 4.9:1 on white — the gold that has to be legible is never `primary`.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: isCentred ? Alignment.center : Alignment.centerLeft,
            child: Text(
              "10s",
              style: AppText.stat(context),
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _captionWidth),
            child: Text(
              "Setter AI follow-up with your leads in just 10 seconds.",
              textAlign: textAlign,
              style: AppText.body(context),
            ),
          ),
        ],
      ),
    );
  }
}
