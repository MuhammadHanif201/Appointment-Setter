import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/setter_calculator_ai_widget.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:flutter/material.dart';

class SalesMeetingCalculatorSection extends StatelessWidget {
  const SalesMeetingCalculatorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyStyle = AppText.bodyLarge(context);

    return SectionContainer(
      // The warm band in the run of sections either side of it. It does two
      // jobs: it breaks up a stretch of pure white so the page does not read as
      // one sheet, and it gives the white calculator card something to lift off.
      color: AppColors.surfaceAlt,
      maxWidth: 1000,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TitleText(
            text: "How Many Sales Meetings Are You\n Leaving on the Table?",
            style: AppText.h2(context),
          ),
          const SizedBox(height: AppSpacing.md),
          // Capped narrower than the section so the lead paragraph keeps a
          // readable measure on a wide desktop.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text.rich(
              TextSpan(
                text: "Use the calculator below to see what ",
                style: bodyStyle,
                children: [
                  // The one emphasised phrase steps up to the primary text
                  // colour rather than the accent — gold is reserved for the
                  // readouts in the card and the call to action below it.
                  TextSpan(
                    text: "slow lead follow-up ",
                    style: bodyStyle.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        "is costing you - and how fast\n you could grow with Setter AI.",
                    style: bodyStyle,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: context.blockGap),
          const SetterAICalculatorWidget(),
          SizedBox(height: context.blockGap),
          ActionButton(
            text: "GO live for 7 days",
            icon: Icons.arrow_forward,
            size: ActionButtonSize.large,
            // Full bleed on a phone, intrinsic width from a tablet up.
            expand: context.isMobile,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
