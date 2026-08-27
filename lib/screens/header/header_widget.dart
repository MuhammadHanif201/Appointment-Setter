import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:flutter/material.dart';

/// Width of the "Solutions" mega menu panel.
const double _kDropdownWidth = 320;

/// The logo asset is 3:1, so height always follows from the width.
const double _kLogoRatio = 3;

class HeaderNavBar extends StatefulWidget {
  const HeaderNavBar({super.key});

  @override
  State<HeaderNavBar> createState() => _HeaderNavBarState();
}

class _HeaderNavBarState extends State<HeaderNavBar> {
  final GlobalKey _solutionsKey = GlobalKey();
  OverlayEntry? _dropdownOverlay;

  bool isHoveringDropdown = false;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _hideDropdown();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
    super.dispose();
  }

  void _showDropdown() {
    if (_dropdownOverlay != null) return;

    final RenderBox? renderBox =
        _solutionsKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Keep the panel on screen no matter where the anchor sits.
    final double maxLeft = (context.screenWidth - _kDropdownWidth - AppSpacing.md)
        .clamp(AppSpacing.md, double.infinity);
    final double left = (offset.dx + size.width / 2 - _kDropdownWidth / 2)
        .clamp(AppSpacing.md, maxLeft);

    _dropdownOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: left,
          top: offset.dy + size.height + AppSpacing.sm,
          child: MouseRegion(
            onEnter: (_) => isHoveringDropdown = true,
            onExit: (_) {
              isHoveringDropdown = false;
              _hideDropdown();
            },
            // A short fade + lift so the panel arrives instead of snapping in.
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: AppDurations.fast,
              curve: AppCurves.standard,
              builder: (context, t, child) => Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, (1 - t) * -AppSpacing.sm),
                  child: child,
                ),
              ),
              // A white panel lifted off the page by a hairline and a soft
              // shadow — depth on a light UI never comes from a heavier fill.
              child: Container(
                width: _kDropdownWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.card,
                ),
                child: Material(
                  color: AppColors.surface,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DropdownItem(
                          title: 'Whatsapp AI Appointment Center',
                          subtitle: 'Reach 3 Billion Users.',
                        ),
                        _DropdownItem(
                          title: 'Facebook Appointment Integration',
                          subtitle: 'Connect to Facebook Pages.',
                        ),
                        _DropdownItem(
                          title: 'Google Business Booking',
                          subtitle: 'Appear on Google Search.',
                        ),
                        _DropdownItem(
                          title: 'Website Booking Widget',
                          subtitle: 'Integrate on your own site.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_dropdownOverlay!);
    _focusNode.requestFocus();
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  /// Shared chrome for every breakpoint: a white bar closed by a single
  /// hairline, the standard 16/20 gutter and the content capped at 1200. The
  /// top inset is honoured so the wordmark never runs into the status bar.
  Widget _navShell({required Widget child}) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: SectionContainer(
          color: Colors.transparent,
          verticalPadding: AppSpacing.s12,
          child: child,
        ),
      ),
    );
  }

  /// The wordmark is dark ink drawn for a white page, so it sits directly on
  /// the bar with nothing behind it. The asset itself is untouched.
  Widget _buildLogo(double width) {
    return Image.asset(
      'assets/images/logo_image.png',
      width: width,
      height: width / _kLogoRatio,
      fit: BoxFit.contain,
    );
  }

  Widget _buildDesktopNavBar() {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _focusNode.requestFocus(),
        child: _navShell(
          child: Row(
            children: [
              _buildLogo(160),
              const Spacer(),
              _NavLink(
                key: _solutionsKey,
                label: 'Solutions',
                trailingIcon: Icons.keyboard_arrow_down,
                rotateTrailingOnHover: true,
                onEnter: _showDropdown,
                onExit: () {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (!mounted) return;
                    if (!isHoveringDropdown) _hideDropdown();
                  });
                },
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.xs),
              _NavLink(label: 'Enterprise', onTap: () {}),
              const SizedBox(width: AppSpacing.xs),
              _NavLink(label: 'Login', onTap: () {}),
              const SizedBox(width: AppSpacing.md),
              ActionButton(
                text: "Get Started",
                icon: Icons.arrow_forward,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletNavBar() {
    return _navShell(
      child: Row(
        children: [
          _buildLogo(136),
          const Spacer(),
          _NavLink(
            label: 'Solutions',
            trailingIcon: Icons.keyboard_arrow_down,
            onTap: () {},
          ),
          const SizedBox(width: AppSpacing.xs),
          _NavLink(label: 'Enterprise', onTap: () {}),
          const SizedBox(width: AppSpacing.xs),
          _NavLink(label: 'Login', onTap: () {}),
          const SizedBox(width: AppSpacing.sm),
          ActionButton(
            text: "Get Started",
            icon: Icons.arrow_forward,
            size: ActionButtonSize.small,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavBar(BuildContext context) {
    return _navShell(
      child: Row(
        children: [
          _buildLogo(112),
          const Spacer(),
          _IconAction(
            icon: Icons.menu,
            tooltip: 'Menu',
            onTap: () => Scaffold.of(context).openEndDrawer(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          return _buildDesktopNavBar();
        } else if (constraints.maxWidth >= AppBreakpoints.mobile) {
          return _buildTabletNavBar();
        } else {
          return _buildMobileNavBar(context);
        }
      },
    );
  }
}

/// One row of the "Solutions" panel: a title, a muted line under it and a warm
/// off-white wash on hover so the pointer always has a target.
class _DropdownItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _DropdownItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      hoverColor: AppColors.surfaceAlt,
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.surfaceMuted,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.s12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.label(context)),
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle, style: AppText.caption(context)),
          ],
        ),
      ),
    );
  }
}

/// A nav bar link: muted at rest, lifting to full contrast with a soft fill on
/// hover. Gold stays reserved for the one primary action next to it.
class _NavLink extends StatefulWidget {
  final String label;
  final IconData? trailingIcon;

  /// Flip the chevron while the panel it opens is showing.
  final bool rotateTrailingOnHover;
  final VoidCallback? onTap;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;

  const _NavLink({
    super.key,
    required this.label,
    this.trailingIcon,
    this.rotateTrailingOnHover = false,
    this.onTap,
    this.onEnter,
    this.onExit,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final color = _hovered ? AppColors.textPrimary : AppColors.textSecondary;
    final radius = BorderRadius.circular(AppRadius.sm);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: radius,
        hoverColor: AppColors.surfaceAlt,
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.surfaceMuted,
        onHover: (hovered) {
          _setHovered(hovered);
          if (hovered) {
            widget.onEnter?.call();
          } else {
            widget.onExit?.call();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: AppDurations.fast,
                curve: AppCurves.standard,
                style: AppText.label(context, color: color),
                child: Text(widget.label),
              ),
              if (widget.trailingIcon != null) ...[
                const SizedBox(width: AppSpacing.xs),
                AnimatedRotation(
                  turns: widget.rotateTrailingOnHover && _hovered ? 0.5 : 0,
                  duration: AppDurations.medium,
                  curve: AppCurves.standard,
                  child: Icon(
                    widget.trailingIcon,
                    size: context.sp(18),
                    color: color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A square, themed icon button — used for the drawer trigger on mobile.
class _IconAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.surfaceAlt,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          hoverColor: AppColors.surfaceMuted,
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          child: Ink(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 22),
          ),
        ),
      ),
    );
  }
}
