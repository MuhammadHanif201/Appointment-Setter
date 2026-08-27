import 'dart:math' as math;

import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';

class FacebookLeadAdsSection extends StatelessWidget {
  const FacebookLeadAdsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      // Sits between two white bands (the channel grid above, the testimonials
      // below), so it takes the warm off-white step and the page reads as
      // separate sections instead of one continuous sheet.
      color: AppColors.surfaceAlt,
      maxWidth: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TitleText(
            text:
                "Use Case: How to Automate Facebook\nLead Ads - Full Tutorial",
          ),
          const SizedBox(height: AppSpacing.md),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text:
                  "First message in 10 seconds after form submission.\nThen human-like setting conversion and booking into your calendar.\nThis is how we achieve up to ",
              style: AppText.bodyLarge(context),
              children: [
                // The result is the point of the paragraph, so it lifts to the
                // primary text colour and a heavier weight — the gold in this
                // section belongs to the call to action.
                TextSpan(
                  text: "52% lead-to-booking rates.",
                  style:
                      AppText.bodyLarge(context, color: AppColors.textPrimary)
                          .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: context.blockGap),
          LayoutBuilder(
            builder: (context, constraints) {
              // The player already frames itself (16:9, rounded, clipped), so
              // it only needs a readable maximum width here.
              final videoWidth = math.min(constraints.maxWidth, 768.0);
              return SizedBox(
                width: videoWidth,
                child: const YouTubePlayerWidget(videoId: 'ybcZQxpTrCs'),
              );
            },
          ),
          SizedBox(height: context.blockGap),
          ActionButton(
            text: "Get me a demo",
            icon: Icons.arrow_forward_rounded,
            size: ActionButtonSize.large,
            expand: context.isMobile,
            onPressed: () {
              // Add your demo action here
            },
          ),
        ],
      ),
    );
  }
}
