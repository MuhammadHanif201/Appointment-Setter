import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:flutter/material.dart';

/// A single customer quote. Takes the width its parent gives it, so it can sit
/// in a column, a [Wrap] or a stretched [Row] without overflowing.
///
/// The quote block sits at the top and the attribution is pushed to the bottom,
/// so a row of these line up even when the quotes are wildly different lengths.
class UserTestimonialCard extends StatelessWidget {
  final String quote;
  final String userName;
  final String userTitle;
  final String imagePath;

  const UserTestimonialCard({
    super.key,
    required this.quote,
    required this.userName,
    required this.userTitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      padding: EdgeInsets.all(context.cardPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Deliberately not gold — the mark is punctuation, not an accent.
              Icon(
                Icons.format_quote_rounded,
                size: context.sp(30),
                color: AppColors.borderStrong,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                quote,
                style: AppText.bodyLarge(context, color: AppColors.textPrimary),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full width hairline: a bare Divider would collapse inside a
                // start-aligned Column.
                const SizedBox(
                  height: 1,
                  width: double.infinity,
                  child: ColoredBox(color: AppColors.border),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    TestimonialAvatar(imagePath: imagePath, size: 44),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: AppText.title(context),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            userTitle,
                            style: AppText.caption(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A round customer photo. On a light page a photograph only needs a circular
/// clip and a hairline to sit down properly; [ringColor] draws an extra ring
/// outside that, which is reserved for the one featured portrait.
class TestimonialAvatar extends StatelessWidget {
  final String imagePath;
  final double size;

  /// When set, a thin ring is drawn around the portrait.
  final Color? ringColor;

  const TestimonialAvatar({
    super.key,
    required this.imagePath,
    this.size = 44,
    this.ringColor,
  });

  @override
  Widget build(BuildContext context) {
    final portrait = Container(
      height: size,
      width: size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceMuted,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.borderStrong),
        ),
      ),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );

    if (ringColor == null) return portrait;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor!, width: 1.5),
      ),
      child: portrait,
    );
  }
}
