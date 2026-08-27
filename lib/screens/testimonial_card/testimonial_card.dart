import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/user_testimonial_card.dart';
import 'package:flutter/material.dart';

/// A single, featured customer quote.
///
/// The band is the warm off-white so the white card genuinely lifts off it, and
/// the ring around the portrait is the one gold moment this section is allowed.
class TestimonialCard extends StatelessWidget {
  const TestimonialCard({super.key});

  @override
  Widget build(BuildContext context) {
    final avatarSize = context.responsive(mobile: 56.0, desktop: 64.0);

    return SectionContainer(
      color: AppColors.surfaceAlt,
      maxWidth: 768,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.card,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(
            mobile: AppSpacing.s20,
            tablet: AppSpacing.xl,
            desktop: AppSpacing.s40,
          ),
          vertical: context.responsive(
            mobile: AppSpacing.lg,
            tablet: AppSpacing.xl,
            desktop: AppSpacing.s40,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Punctuation, not an accent — the mark stays in the line colour.
            Icon(
              Icons.format_quote_rounded,
              size: context.sp(38),
              color: AppColors.borderStrong,
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              '"I LOVE it, it\'s working perfectly!\nOur business generates 30,000 leads per month, which we previously had to reach out manually. Thanks to Setter AI, we now wake up every day to find new meetings seamlessly booked into my calendar. I would gladly pay \$1,000 per day for Setter AI as we scale our operations."',
              style: AppText.bodyLarge(context, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            TestimonialAvatar(
              imagePath: "assets/images/carlos.jpg",
              size: avatarSize,
              ringColor: AppColors.primaryInk,
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              "Carlos de Ory",
              style: AppText.title(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Eco Beach City (Real Estate)",
              style: AppText.caption(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
