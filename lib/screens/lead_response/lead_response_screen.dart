import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:flutter/material.dart';

/// The short statement section that follows the hero.
///
/// It carries exactly one accent moment — the gold half of the headline — so
/// the rest of the block stays in the neutral text ramp.
class LeadResponseSection extends StatelessWidget {
  const LeadResponseSection({super.key});

  /// Measures. A centred headline stops reading well much past ~900, and the
  /// paragraph under it wants to be narrower still.
  static const double _headingWidth = 900;
  static const double _bodyWidth = 760;

  @override
  Widget build(BuildContext context) {
    // The copy hard-breaks after "Fix", so the first line has to fit "Hiring
    // More SDRs Won’t Fix" in one go. At the h1 step it does that on desktop
    // but soft-wraps below it, which strands "Fix" alone on a line of its own —
    // so narrower screens drop a step rather than orphan a word.
    final headingStyle = context.responsive(
      mobile: AppText.h2(context),
      desktop: AppText.h1(context),
    );
    final bodyStyle = AppText.bodyLarge(context);

    // Inline emphasis without spending gold: brighter ink, one weight step up.
    final emphasisStyle =
        AppText.bodyLarge(context, color: AppColors.textPrimary)
            .copyWith(fontWeight: FontWeight.w600);

    return SectionContainer(
      // The sections either side are white, so this statement band takes the
      // warm off-white step: the three separate without a divider line.
      color: AppColors.surfaceAlt,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _headingWidth),
            child: Text.rich(
              TextSpan(
                text: "Hiring More SDRs Won’t Fix\n a ",
                style: headingStyle,
                children: [
                  // The one gold moment in this band. `primaryInk`, never
                  // `primary` — gold only reaches 2.4:1 on a light surface.
                  TextSpan(
                    text: "Broken Lead Response.",
                    style: headingStyle.copyWith(color: AppColors.primaryInk),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: context.responsive(
              mobile: AppSpacing.s12,
              tablet: AppSpacing.md,
              desktop: AppSpacing.s20,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _bodyWidth),
            child: Text.rich(
              TextSpan(
                text: "Automate first contact in under ",
                style: bodyStyle,
                children: [
                  TextSpan(
                    text: " 10 seconds",
                    style: emphasisStyle,
                  ),
                  TextSpan(
                    text:
                        " - and convert up to 52%\n of your leads into meetings - without expanding your sales team.",
                    style: bodyStyle,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
