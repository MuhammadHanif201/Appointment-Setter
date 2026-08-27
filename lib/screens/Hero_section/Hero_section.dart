// The file name is kept as-is because other screens import it by this path.
// ignore_for_file: file_names

import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Ceilings for the measured blocks — the lead paragraph, the logo strip, the
/// case study line and the player. They are caps, never fixed widths: every one
/// of these shrinks freely below its ceiling, so nothing here can overflow a
/// narrow phone.
const double _kCopyMaxWidth = 640;
const double _kLogoWallMaxWidth = 812;
const double _kCaseStudyMaxWidth = 760;
const double _kVideoMaxWidth = 900;

/// The top of the marketing page: eyebrow, headline, calls to action, the
/// customer logo wall and the case study video.
///
/// It is laid out as two bands rather than one. The pitch sits on the white
/// page; the case study drops onto the warm [AppColors.surfaceAlt] underneath
/// it, so the two separate by surface instead of by a divider rule.
class HeroSectionWidget extends StatelessWidget {
  const HeroSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPitchBand(context),
        _buildCaseStudyBand(context),
      ],
    );
  }

  /// The white band: the promise, the two actions and the proof beneath them.
  Widget _buildPitchBand(BuildContext context) {
    return SectionContainer(
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // The hero copy fades and rises once on mount; everything below it is
          // static so scrolling never re-triggers motion.
          _HeroEntrance(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEyebrow(context),
                const Gap(AppSpacing.lg),
                _buildHeadline(context),
                const Gap(AppSpacing.md),
                _buildSubhead(context),
                Gap(context.blockGap),
                _buildCallsToAction(context),
              ],
            ),
          ),
          Gap(context.blockGap),
          _buildSocialProof(context),
          const Gap(AppSpacing.lg),
          _buildLogoWall(context),
        ],
      ),
    );
  }

  /// The warm band: one claim and the video that backs it up.
  Widget _buildCaseStudyBand(BuildContext context) {
    return SectionContainer(
      color: AppColors.surfaceAlt,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCaseStudyHeadline(context),
          Gap(context.blockGap),
          _buildVideo(context),
        ],
      ),
    );
  }

  /// A small all caps eyebrow in a neutral pill.
  ///
  /// `overline` defaults to [AppColors.primaryInk], but this is the least
  /// important line in the band and it was the first gold the eye landed on —
  /// ahead of the headline emphasis and the call to action, which is where the
  /// band's gold belongs. So it is overridden down to the neutral ink.
  Widget _buildEyebrow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'Reliable AI Sales Agents for Enterprise',
        textAlign: TextAlign.center,
        style: AppText.overline(context, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildHeadline(BuildContext context) {
    final base = AppText.display(context);

    return Text.rich(
      TextSpan(
        text: "Scale Your Business\n",
        style: base,
        children: [
          // The single gold span on the page, in the ink weight of gold so it
          // is a headline rather than a smudge.
          TextSpan(
            text: "Without Hiring.",
            style: base.copyWith(color: AppColors.primaryInk),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubhead(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _kCopyMaxWidth),
      child: Text(
        "Follow up leads in 10 seconds - with 15-52% lead-to-booking rate.",
        textAlign: TextAlign.center,
        style: AppText.bodyLarge(context),
      ),
    );
  }

  Widget _buildCallsToAction(BuildContext context) {
    final isMobile = context.isMobile;

    final primary = ActionButton(
      text: "Get Started",
      icon: Icons.arrow_forward,
      size: ActionButtonSize.large,
      onPressed: () {},
      expand: isMobile,
    );

    final secondary = ActionButton(
      text: "Book a demo",
      variant: ActionButtonVariant.outlined,
      size: ActionButtonSize.large,
      onPressed: () {},
      expand: isMobile,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          primary,
          const Gap(AppSpacing.s12),
          secondary,
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.s12,
      children: [primary, secondary],
    );
  }

  /// Supporting line above the logo wall: quiet body copy with one emphasised
  /// phrase — no accent colour, the logos are the proof.
  Widget _buildSocialProof(BuildContext context) {
    final base = AppText.bodyLarge(context);

    return Text.rich(
      TextSpan(
        text: "Industry leading teams replace",
        style: base,
        children: [
          TextSpan(
            text: " slow SDRs ",
            style: base.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: "with Setter AI", style: base),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  /// The customer logo strip. The raster was drawn for a white page, so it is
  /// dropped straight onto it — the plate that used to sit behind it only
  /// existed to rescue it from the old navy background, and on white it read as
  /// an empty box around the logos.
  Widget _buildLogoWall(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _kLogoWallMaxWidth),
      child: Image.asset(
        "assets/images/company_logo.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildCaseStudyHeadline(BuildContext context) {
    // One step down from `h3` in weight so the claim inside it can carry the
    // emphasis without the whole block turning bold.
    final base = AppText.h3(context, color: AppColors.textSecondary).copyWith(
      fontWeight: FontWeight.w500,
      height: 1.5,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _kCaseStudyMaxWidth),
      child: Text.rich(
        TextSpan(
          text: "Case Study:",
          style: base.copyWith(color: AppColors.textMuted),
          children: [
            TextSpan(
              text: " 352 high-ticket appointments per month.\n",
              style: base.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: "Without lifting a finger.", style: base),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// The player already carries its own 16:9 frame, radius and hairline, so
  /// this only has to cap how wide it may get.
  Widget _buildVideo(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _kVideoMaxWidth),
      child: const YouTubePlayerWidget(videoId: 'ybcZQxpTrCs'),
    );
  }
}

/// A one shot fade and rise for the hero copy. Runs on first build only.
class _HeroEntrance extends StatelessWidget {
  final Widget child;

  const _HeroEntrance({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: AppDurations.slow,
      curve: AppCurves.standard,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * AppSpacing.s12),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
