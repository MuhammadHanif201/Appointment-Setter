import 'dart:math' as math;

import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:flutter/material.dart';

/// One booking channel tile.
class _Channel {
  final IconData icon;
  final String title;
  final String description;
  final String actionText;

  const _Channel({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionText,
  });
}

const List<_Channel> _channels = [
  _Channel(
    icon: Icons.chat_bubble_outline_rounded,
    title: 'WhatsApp',
    description:
        'Use WhatsApp to turn leads into meetings – on autopilot. Connect WhatsApp Business in just 5 clicks.',
    actionText: 'Learn more',
  ),
  _Channel(
    icon: Icons.sms_outlined,
    title: 'Text',
    description:
        'Automate lead response via SMS. Turn texts into booked appointments effortlessly using conversational booking.',
    actionText: 'Learn more',
  ),
  _Channel(
    icon: Icons.language_rounded,
    title: 'Website Embed',
    description:
        'Add a lead generation chatbot on your website. Respond to every lead in seconds and book more meetings.',
    actionText: 'Learn more',
  ),
  _Channel(
    icon: Icons.forum_outlined,
    title: 'Facebook Messenger',
    description:
        'Automate conversations on Facebook Messenger. Run click-to-messenger ads and book more meetings.',
    actionText: 'Learn more',
  ),
  _Channel(
    icon: Icons.photo_camera_outlined,
    title: 'Instagram',
    description:
        'Automate lead generation on Instagram: turn comments, replies, and DMs into booked appointments instantly!',
    actionText: 'Learn more',
  ),
  _Channel(
    icon: Icons.work_outline_rounded,
    title: 'LinkedIn',
    description:
        'Automate lead generation on LinkedIn: Turn comments, messages, and connections into booked meetings with AI.',
    actionText: 'Learn more',
  ),
];

class BookingChannelsSection extends StatelessWidget {
  const BookingChannelsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      // A white band between the two off-white ones either side of it, so the
      // sections separate on tone without a divider. The cards are white too —
      // they read as cards through their hairline, not through a fill step.
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TitleText(text: 'Book More Meetings with Conversational AI.'),
          SizedBox(height: context.blockGap),
          _ChannelGrid(
            columns: context.responsive(mobile: 1, tablet: 2, desktop: 3),
          ),
        ],
      ),
    );
  }
}

/// A fixed-column grid of cards. Rows are laid out with [IntrinsicHeight] so
/// every card in a row ends at the same baseline no matter how long its copy
/// is, which a `Wrap` cannot do.
class _ChannelGrid extends StatelessWidget {
  final int columns;

  const _ChannelGrid({required this.columns});

  static const double _gap = AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    final rows = <List<_Channel>>[
      for (var i = 0; i < _channels.length; i += columns)
        _channels.sublist(i, math.min(i + columns, _channels.length)),
    ];

    return Column(
      children: [
        for (var row = 0; row < rows.length; row++) ...[
          if (row > 0) const SizedBox(height: _gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var column = 0; column < columns; column++) ...[
                  if (column > 0) const SizedBox(width: _gap),
                  Expanded(
                    child: column < rows[row].length
                        ? _ChannelCard(channel: rows[row][column])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ChannelCard extends StatefulWidget {
  final _Channel channel;

  const _ChannelCard({required this.channel});

  @override
  State<_ChannelCard> createState() => _ChannelCardState();
}

class _ChannelCardState extends State<_ChannelCard> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final badgeSize = context.responsive<double>(
      mobile: 44,
      tablet: 48,
      desktop: 48,
    );
    final iconSize = context.responsive<double>(
      mobile: 22,
      tablet: 24,
      desktop: 24,
    );

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedContainer(
        duration: AppDurations.medium,
        curve: AppCurves.standard,
        padding: EdgeInsets.all(context.cardPad),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceAlt : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: _hovered ? AppColors.borderStrong : AppColors.border,
          ),
          boxShadow: _hovered ? AppShadows.soft : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The badge is neutral on purpose. Six of these repeat down the
            // grid, so a gold one would spend the section's whole accent
            // budget on decoration and leave nothing to mark the hovered card.
            // It inverts against the card instead: an off-white chip on the
            // white card, a white chip once the card washes to off-white.
            AnimatedContainer(
              duration: AppDurations.medium,
              curve: AppCurves.standard,
              width: badgeSize,
              height: badgeSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _hovered ? AppColors.surface : AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: _hovered ? AppColors.borderStrong : AppColors.border,
                ),
              ),
              child: Icon(
                widget.channel.icon,
                color:
                    _hovered ? AppColors.textPrimary : AppColors.textSecondary,
                size: iconSize,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(widget.channel.title, style: AppText.title(context)),
            const SizedBox(height: AppSpacing.sm),
            Text(widget.channel.description, style: AppText.body(context)),
            const SizedBox(height: AppSpacing.md),
            // Pins the action to the bottom so a short card and a long card in
            // the same row line up.
            const Spacer(),
            _LearnMoreLink(
              label: widget.channel.actionText,
              highlighted: _hovered,
            ),
          ],
        ),
      ),
    );
  }
}

class _LearnMoreLink extends StatefulWidget {
  final String label;

  /// True while the parent card is hovered, so the whole tile lights the
  /// action up rather than only the eight pixels under the cursor.
  final bool highlighted;

  const _LearnMoreLink({required this.label, required this.highlighted});

  @override
  State<_LearnMoreLink> createState() => _LearnMoreLinkState();
}

class _LearnMoreLinkState extends State<_LearnMoreLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || widget.highlighted;
    // The only gold in the section, and only ever on one card at a time. It is
    // text and a small icon, so it takes the readable ink step — the fill gold
    // reaches 2.4:1 on white and would not survive at this size.
    final color = active ? AppColors.primaryInk : AppColors.textPrimary;

    return Align(
      alignment: Alignment.centerLeft,
      // Pulls the ink target back over the card padding so the label keeps the
      // same left edge as the title and the copy above it.
      child: Transform.translate(
        offset: const Offset(-AppSpacing.sm, 0),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            onTap: () {},
            onHover: (value) => setState(() => _hovered = value),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xs,
                horizontal: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: AnimatedDefaultTextStyle(
                      duration: AppDurations.fast,
                      curve: AppCurves.standard,
                      style: AppText.label(context, color: color)
                          .copyWith(fontWeight: FontWeight.w600),
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AnimatedSlide(
                    duration: AppDurations.fast,
                    curve: AppCurves.standard,
                    offset: active ? const Offset(0.3, 0) : Offset.zero,
                    child: TweenAnimationBuilder<Color?>(
                      duration: AppDurations.fast,
                      curve: AppCurves.standard,
                      tween: ColorTween(
                        begin: AppColors.textSecondary,
                        end: color,
                      ),
                      builder: (context, animatedColor, _) => Icon(
                        Icons.arrow_forward_rounded,
                        color: animatedColor,
                        size: context.sp(18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
