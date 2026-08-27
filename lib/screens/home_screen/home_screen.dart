import 'dart:math' as math;

import 'package:appointment_setter/screens/ai_agent_screen/ai_agent_screen.dart';
import 'package:appointment_setter/screens/booking_channels_widget/booking_channels_widget.dart';
import 'package:appointment_setter/screens/custom_drawer/custom_drawer.dart';
import 'package:appointment_setter/screens/facebook_leadAds/facebook_leadAds_widget.dart';
import 'package:appointment_setter/screens/faq_section/faq_section.dart';
import 'package:appointment_setter/screens/footer/footer.dart';
import 'package:appointment_setter/screens/header/header_widget.dart';
import 'package:appointment_setter/screens/integration_section/integration_section.dart';
import 'package:appointment_setter/screens/lead_conversion_section/lead_conversion_section.dart';
import 'package:appointment_setter/screens/lead_loss_section/lead_loss_section.dart';
import 'package:appointment_setter/screens/lead_response/lead_response_screen.dart';
import 'package:appointment_setter/screens/outbound_whatsApp_demo/outbound_whatsApp_demo.dart';
import 'package:appointment_setter/screens/sales_meeting_calculator/sales_meeting_calculator.dart';
import 'package:appointment_setter/screens/setter_ai_setup_section/setter_ai_setup_section.dart';
import 'package:appointment_setter/screens/setter_ai_video_section/setter_ai_video_section.dart';
import 'package:appointment_setter/screens/setter_steps_widget/setter_steps_widget.dart';
import 'package:appointment_setter/screens/testimonial_card/testimonial_card.dart';
import 'package:appointment_setter/screens/user_testimonials/user_testimonials_widget.dart';
import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:flutter/material.dart';

/// The end drawer hangs off the bottom of the header rather than the top of the
/// window, so it needs the header's height as an offset.
const double _kDrawerTopOffset = kToolbarHeight + AppSpacing.md;

/// How tall the end drawer panel is allowed to get before it scrolls.
const double _kDrawerMaxHeight = 340;

/// The panel is anchored to the header above it, so only its bottom edge is
/// rounded.
const BorderRadius _kDrawerRadius = BorderRadius.vertical(
  bottom: Radius.circular(AppRadius.xl),
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// The shell around [CustomEndDrawer]: a white sheet dropped below the header,
  /// held by a hairline and a soft shadow rather than a heavy elevation.
  Widget _buildEndDrawer(BuildContext context) {
    // Never let the panel eat the whole viewport on a short screen — it scrolls
    // internally instead.
    final double maxHeight = math.min(_kDrawerMaxHeight, context.hp(60));

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: context.screenPadding.top + _kDrawerTopOffset,
        ),
        // The shadow has to live outside the clip, or the clip crops it away.
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: _kDrawerRadius,
            boxShadow: AppShadows.card,
          ),
          child: ClipRRect(
            borderRadius: _kDrawerRadius,
            child: Container(
              constraints: BoxConstraints(maxHeight: maxHeight),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: _kDrawerRadius,
                border: Border.all(color: AppColors.border),
              ),
              child: const CustomEndDrawer(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawerScrimColor: AppColors.scrim,
      endDrawer: _buildEndDrawer(context),
      body: const Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                HeaderNavBar(),
                AiAgentSection(),
                LeadResponseSection(),
                SalesMeetingCalculatorSection(),
                IntegrationSection(),
                TestimonialCard(),
                LeadConversionSection(),
                SetterAIVideoSection(),
                SetterAISetupSection(),
                LeadLossSection(),
                OutboundWhatsAppDemo(),
                SetterStepsSection(),
                BookingChannelsSection(),
                FacebookLeadAdsSection(),
                UserTestimonialsSection(),
                FAQSectionWidget(),
                FooterSection(),
              ],
            ),
          ),
          Positioned(
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: _ChatWithAgentButton(),
          ),
        ],
      ),
    );
  }
}

/// The floating chat CTA. It is the page's primary action, so it carries the
/// gold fill and the near-black label.
///
/// The label rides along on every screen size. Collapsing to a bare bubble on
/// small phones left the most common devices with an unlabelled generic glyph
/// whose only explanation was a hover tooltip that a touch user never sees; on
/// a narrow screen the pill tightens its padding and the label ellipsises
/// instead of disappearing.
class _ChatWithAgentButton extends StatefulWidget {
  const _ChatWithAgentButton();

  @override
  State<_ChatWithAgentButton> createState() => _ChatWithAgentButtonState();
}

class _ChatWithAgentButtonState extends State<_ChatWithAgentButton> {
  static const String _label = "Chat with Megan (AI)";

  /// Drives the one-off entrance, so the CTA settles in after the first paint
  /// instead of snapping into place with the page.
  bool _entered = false;
  bool _hovered = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _entered = true);
    });
  }

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  /// The width the pill may not exceed: the viewport less the gutter it is
  /// pinned into on both sides, so a long label ellipsises rather than pushing
  /// the button off screen.
  double _maxWidth(BuildContext context) => math.max(
        0,
        context.screenWidth -
            AppSpacing.lg * 2 -
            context.screenPadding.horizontal,
      );

  @override
  Widget build(BuildContext context) {
    final bool compact = context.isSmallMobile;
    final radius = BorderRadius.circular(AppRadius.pill);

    // On a light page a gold fill *deepens* as it is touched — lifting it
    // towards primaryLight was a dark-page habit that made the button fade into
    // the page at the exact moment the pointer was on it.
    final Color fill = _pressed
        ? AppColors.primaryDark
        : _hovered
            ? Color.alphaBlend(
                AppColors.onPrimary.withValues(alpha: 0.06),
                AppColors.primary,
              )
            : AppColors.primary;

    final Widget button = AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppCurves.standard,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        // Depth on a white page is a quiet neutral shadow — never a glow, and
        // never a coloured one.
        boxShadow: _hovered ? AppShadows.card : AppShadows.soft,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: () {
            // Chat action
          },
          onHover: _setHovered,
          onHighlightChanged: _setPressed,
          splashColor: AppColors.onPrimary.withValues(alpha: 0.14),
          highlightColor: AppColors.onPrimary.withValues(alpha: 0.08),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? AppSpacing.s12 : AppSpacing.s20,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: AppColors.onPrimary,
                  size: context.sp(20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    _label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.button(context, color: AppColors.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: context.screenPadding.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: _maxWidth(context)),
        child: AnimatedSlide(
          offset: _entered ? Offset.zero : const Offset(0, 0.4),
          duration: AppDurations.slow,
          curve: AppCurves.emphasized,
          child: AnimatedOpacity(
            opacity: _entered ? 1 : 0,
            duration: AppDurations.slow,
            curve: AppCurves.standard,
            child: AnimatedScale(
              scale: _pressed ? 0.96 : 1,
              duration: AppDurations.fast,
              curve: AppCurves.standard,
              child: button,
            ),
          ),
        ),
      ),
    );
  }
}
