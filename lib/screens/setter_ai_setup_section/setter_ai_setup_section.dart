import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:flutter/material.dart';

/// A full-bleed statement section: five short promises stacked on top of each
/// other. The only accent it spends is the gold ink on "10 seconds" — that
/// number is the claim the whole section is built around.
///
/// It sits on the warm band between two white sections, and takes a little more
/// vertical room than a standard section, so the page reads it as a pause
/// rather than as one more block of copy.
class SetterAISetupSection extends StatelessWidget {
  const SetterAISetupSection({super.key});

  @override
  Widget build(BuildContext context) {
    // The headline carries hard line breaks, so it steps down a size on phones
    // to stay readable instead of wrapping every line twice. The extra line
    // height gives each statement room to read as its own line.
    final headline = context
        .responsive(
          mobile: AppText.h2(context),
          tablet: AppText.h1(context),
        )
        .copyWith(height: 1.32);

    return SectionContainer(
      color: AppColors.surfaceAlt,
      verticalPadding: context.vPad + AppSpacing.lg,
      maxWidth: 900,
      child: Text.rich(
        TextSpan(
          text: "We setup you up.\nYour response time drops to ",
          children: [
            TextSpan(
              text: "10 seconds",
              style: headline.copyWith(color: AppColors.primaryInk),
            ),
            const TextSpan(
              text: ".\nYour booking rate skyrockets."
                  "\nYour team talks only to real buyers."
                  "\nYour business grows without more hires.",
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: headline,
      ),
    );
  }
}
