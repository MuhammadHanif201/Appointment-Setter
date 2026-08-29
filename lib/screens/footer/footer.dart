import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A titled column of footer links.
class _LinkGroup {
  final String title;
  final List<String> links;

  const _LinkGroup(this.title, this.links);
}

/// A social destination: the glyph shown and the network it points at.
///
/// The label is not decoration — the Material set carries no brand marks, so
/// the name is what tells a visitor which network an abstract glyph is for. It
/// is exposed to both the pointer (tooltip) and the screen reader (semantics).
class _SocialLink {
  final IconData icon;
  final String label;

  const _SocialLink(this.icon, this.label);
}

const List<_LinkGroup> _primaryGroups = [
  _LinkGroup('Links', [
    'Book demo',
    'Blog',
    'Login',
    'Help',
    'Affiliate Program',
    'Manage Subscription',
  ]),
  _LinkGroup('Solutions', [
    'WhatsApp Appointment Setter',
    'WhatsApp Reminder Software',
    'Calendly Booking API',
    'WhatsApp API',
    'AI Sales Agent',
  ]),
  _LinkGroup('Free Tools', [
    'Free Sales Tools',
    'Appointment Setting Script Generator',
    'WhatsApp Appointment Setting Script Generator',
    'WhatsApp Link Generator',
    'WhatsApp Button Generator',
  ]),
];

const List<_LinkGroup> _legalGroups = [
  _LinkGroup('Legal', [
    'Privacy Policy',
    'Terms and Conditions',
  ]),
  _LinkGroup('Industries', ['Solar']),
];

/// The dark band that closes the page.
///
/// It is [AppColors.surfaceDark] — the page inverts for its last section, so
/// the footer reads as the end of the document rather than one more white
/// block. Everything on it follows the dark-surface rules from the theme: copy
/// is [AppColors.textOnDark] / [AppColors.textOnDarkMuted], lines are
/// [AppColors.borderOnDark] and hover washes are [AppColors.surfaceOnDarkAlt].
/// Links are muted and lift to full white on hover; the only gold in the whole
/// block is the Subscribe button.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = context.blockGap;

    return SectionContainer(
      color: AppColors.surfaceDark,
      // Ink has to be painted on a Material; the section is a plain Container,
      // so give the whole footer a transparent one.
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FooterTop(),
            SizedBox(height: gap),
            _LinkColumnsGrid(
              groups: _legalGroups,
              columns: context.responsive(mobile: 1, tablet: 2, desktop: 3),
            ),
            SizedBox(height: gap),
            const _FooterBottomBar(),
          ],
        ),
      ),
    );
  }
}

/// Link columns beside the newsletter block on desktop, stacked below it
/// everywhere else.
class _FooterTop extends StatelessWidget {
  const _FooterTop();

  @override
  Widget build(BuildContext context) {
    final gap = context.blockGap;

    if (context.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: _LinkColumnsGrid(groups: _primaryGroups, columns: 3),
          ),
          SizedBox(width: gap),
          const SizedBox(width: 320, child: _SubscribeColumn()),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LinkColumnsGrid(
          groups: _primaryGroups,
          columns: context.isTablet ? 2 : 1,
        ),
        SizedBox(height: gap),
        const _SubscribeColumn(),
      ],
    );
  }
}

/// Lays [groups] out in [columns] equal-width columns that reflow instead of
/// overflowing.
class _LinkColumnsGrid extends StatelessWidget {
  final List<_LinkGroup> groups;
  final int columns;

  const _LinkColumnsGrid({required this.groups, required this.columns});

  @override
  Widget build(BuildContext context) {
    final gap = context.blockGap;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = columns <= 1
            ? constraints.maxWidth
            : (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final group in groups)
              SizedBox(width: width, child: _FooterLinkColumn(group: group)),
          ],
        );
      },
    );
  }
}

class _FooterLinkColumn extends StatelessWidget {
  final _LinkGroup group;

  const _FooterLinkColumn({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Matches the horizontal inset the links carry for their hover target,
        // so the heading and the list share one left edge.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            group.title,
            style: AppText.title(context, color: AppColors.textOnDark),
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        for (final link in group.links) _FooterLink(label: link),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;

  const _FooterLink({required this.label});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // Rest is muted copy; hover lifts it to full white. Gold is reserved for
    // the Subscribe button, so a hovered link brightens rather than tints.
    final color =
        _hovered ? AppColors.textOnDark : AppColors.textOnDarkMuted;

    return InkWell(
      onTap: () {},
      onHover: (value) => setState(() => _hovered = value),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      // On the dark band a hover is a faint white wash, not a grey one — a
      // solid grey would read as a smudge here.
      hoverColor: AppColors.surfaceOnDarkAlt,
      mouseCursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppSpacing.sm,
        ),
        child: AnimatedDefaultTextStyle(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          style: AppText.bodySmall(context, color: color).copyWith(
            // The underline is the hover affordance — showing it on every link
            // makes the footer look like a wall of hyperlinks.
            decoration:
                _hovered ? TextDecoration.underline : TextDecoration.none,
            decorationColor: color,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _SubscribeColumn extends StatelessWidget {
  const _SubscribeColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // The wordmark is white on transparent, so it sits straight on the
            // dark band — this is the surface it was drawn for.
            Image.asset(
              'assets/images/setter_ai.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            // The Meta badge ships with an opaque white background, so it is
            // framed as a deliberate white plate rather than left as a raw
            // rectangle punched out of the dark band.
            const _LogoPlate(
              child: Image(
                image: AssetImage('assets/images/meta.png'),
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const _EmailSubscribeField(),
        const SizedBox(height: AppSpacing.lg),
        // The Product Hunt badge draws its own white card, so it needs no
        // plate of its own.
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset(
            'assets/images/featured.svg',
            width: 250,
            height: 54,
          ),
        ),
      ],
    );
  }
}

/// A small white card for a partner mark that was drawn for a light surface.
class _LogoPlate extends StatelessWidget {
  final Widget child;

  const _LogoPlate({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: child,
    );
  }
}

/// The one gold moment in the whole footer.
///
/// The global `inputDecorationTheme` was written for a white page — off-white
/// fill, grey hairline — and both vanish on the dark band, so the field carries
/// the dark-surface equivalents: a faint white fill, a low-alpha white
/// hairline, and the same gold focus ring every other input in the app has.
/// Height, radius and padding are still inherited from the theme so the field
/// matches the rest of the product.
class _EmailSubscribeField extends StatelessWidget {
  const _EmailSubscribeField();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          keyboardType: TextInputType.emailAddress,
          style: AppText.body(context, color: AppColors.textOnDark),
          // A caret is a thin stroke; on a dark fill the light gold is the
          // one that stays visible.
          cursorColor: AppColors.primaryLight,
          decoration: InputDecoration(
            hintText: 'Enter your Email',
            hintStyle: AppText.body(context, color: AppColors.textOnDarkMuted),
            fillColor: AppColors.surfaceOnDarkAlt,
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(color: AppColors.borderOnDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        // Stacked rather than tucked inside the field: on the 320 wide desktop
        // column an inline button leaves no room to read what you typed.
        ActionButton(
          text: "Subscribe",
          onPressed: () {},
        ),
      ],
    );
  }
}

class _FooterBottomBar extends StatelessWidget {
  const _FooterBottomBar();

  /// The theme's divider is a grey hairline for white pages; on the dark band
  /// the line is the low-alpha white the theme reserves for dark surfaces.
  Widget _divider() => const Divider(color: AppColors.borderOnDark);

  @override
  Widget build(BuildContext context) {
    final legal = AppText.bodySmall(context, color: AppColors.textOnDarkMuted);

    if (context.isMobile) {
      return Column(
        children: [
          _divider(),
          SizedBox(height: context.blockGap),
          Text("Setter AI LLC", style: legal),
          const SizedBox(height: AppSpacing.md),
          const _SocialIcons(),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Setter AI LLC", style: legal),
              const SizedBox(width: AppSpacing.lg),
              const _SocialIcons(),
            ],
          ),
        ),
        Expanded(child: _divider()),
      ],
    );
  }
}

class _SocialIcons extends StatelessWidget {
  const _SocialIcons();

  static const List<_SocialLink> _links = [
    _SocialLink(Icons.play_circle_outline_rounded, 'YouTube'),
    _SocialLink(Icons.share_outlined, 'Facebook'),
    _SocialLink(Icons.chat_bubble_outline_rounded, 'Twitter'),
    _SocialLink(Icons.photo_camera_outlined, 'Instagram'),
    _SocialLink(Icons.work_outline_rounded, 'LinkedIn'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      alignment: WrapAlignment.center,
      children: [
        for (final link in _links) _SocialIcon(link: link),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final _SocialLink link;

  const _SocialIcon({required this.link});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.link.label,
      // The global tooltip is a dark chip — invisible on a dark band — so on
      // the footer it inverts to a white chip with dark text.
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      textStyle: AppText.caption(context, color: AppColors.textPrimary),
      child: Semantics(
        label: widget.link.label,
        button: true,
        child: InkWell(
          onTap: () {},
          onHover: (value) => setState(() => _hovered = value),
          customBorder: const CircleBorder(),
          hoverColor: AppColors.surfaceOnDarkAlt,
          mouseCursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: TweenAnimationBuilder<Color?>(
              duration: AppDurations.fast,
              curve: AppCurves.standard,
              tween: ColorTween(
                begin: AppColors.textOnDarkMuted,
                end: _hovered
                    ? AppColors.textOnDark
                    : AppColors.textOnDarkMuted,
              ),
              builder: (context, color, _) => ExcludeSemantics(
                child: Icon(
                  widget.link.icon,
                  color: color,
                  size: context.responsive<double>(
                    mobile: 20,
                    tablet: 22,
                    desktop: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
