import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:flutter/material.dart';

/// The mobile navigation panel. Mirrors the desktop nav: the same links, the
/// same "Solutions" menu and the same primary call to action.
///
/// It reads as a premium light nav sheet — a white surface, rows that answer to
/// hover and press, one gold marker on the open row, and the single gold action
/// pinned under a hairline at the bottom edge. The panel's rounding, border and
/// shadow are drawn by the shell that hosts it in `HomeScreen`.
class CustomEndDrawer extends StatefulWidget {
  const CustomEndDrawer({super.key});

  @override
  State<CustomEndDrawer> createState() => _CustomEndDrawerState();
}

class _CustomEndDrawerState extends State<CustomEndDrawer> {
  bool isDropdownOpen = false;

  /// Close the panel and land the user back on the home page.
  ///
  /// The drawer is owned by the Scaffold rather than the Navigator, so it is
  /// dismissed through `closeEndDrawer` — popping the navigator here would tear
  /// down the page underneath instead. The `popUntil` then unwinds anything
  /// that was pushed on top of home; it is a no-op when home is already the
  /// route on screen, which is the case today, and stays correct once this app
  /// grows a second route.
  void _closeAndGoHome() {
    Scaffold.of(context).closeEndDrawer();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// The nested "Solutions" panel. Sits on the muted warm panel one step in
  /// from the drawer surface, so it reads as contained by the row that opened
  /// it rather than as a second sheet.
  Widget _solutionsDropdownContainer() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _DrawerSubItem(
            title: 'Whatsapp AI Appointment Center',
            subtitle: 'Reach 3 Billion Users.',
          ),
          _DrawerSubItem(
            title: 'Facebook Appointment Integration',
            subtitle: 'Connect to Facebook Pages.',
          ),
          _DrawerSubItem(
            title: 'Google Business Booking',
            subtitle: 'Appear on Google Search.',
          ),
          _DrawerSubItem(
            title: 'Website Booking Widget',
            subtitle: 'Integrate on your own site.',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      // The host clips and outlines the panel, so the drawer itself stays
      // square — two competing radii would show as a notch at the corners.
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        // The shell already offsets the panel below the status bar.
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.hPad,
                  AppSpacing.s12,
                  context.hPad,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DrawerNavRow(
                      label: 'Solutions',
                      active: isDropdownOpen,
                      trailing: AnimatedRotation(
                        turns: isDropdownOpen ? 0.5 : 0,
                        duration: AppDurations.medium,
                        curve: AppCurves.standard,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: context.sp(20),
                          // Gold has to be readable, so the open chevron takes
                          // the ink step of the accent, never the fill step.
                          color: isDropdownOpen
                              ? AppColors.primaryInk
                              : AppColors.textSecondary,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isDropdownOpen = !isDropdownOpen; // toggle on tap
                        });
                      },
                    ),

                    // Show dropdown only when open
                    AnimatedSize(
                      duration: AppDurations.medium,
                      curve: AppCurves.standard,
                      alignment: Alignment.topCenter,
                      child: isDropdownOpen
                          ? _solutionsDropdownContainer()
                          : const SizedBox(width: double.infinity),
                    ),

                    const SizedBox(height: AppSpacing.xs),
                    _DrawerNavRow(
                      label: 'Enterprise',
                      onTap: _closeAndGoHome,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _DrawerNavRow(label: 'Login', onTap: _closeAndGoHome),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.hPad,
                AppSpacing.md,
                context.hPad,
                AppSpacing.md,
              ),
              child: ActionButton(
                text: "Get Started",
                icon: Icons.arrow_forward,
                expand: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A top level row of the drawer. The rail on its left is the panel's only
/// accent: nothing at rest, a gold marker on the open row.
class _DrawerNavRow extends StatefulWidget {
  final String label;
  final bool active;
  final Widget? trailing;
  final VoidCallback onTap;

  const _DrawerNavRow({
    required this.label,
    required this.onTap,
    this.active = false,
    this.trailing,
  });

  @override
  State<_DrawerNavRow> createState() => _DrawerNavRowState();
}

class _DrawerNavRowState extends State<_DrawerNavRow> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    final Color background = widget.active
        ? AppColors.primarySoft
        : (_hovered ? AppColors.surfaceAlt : Colors.transparent);

    // The animated fill sits *under* the Material so the ink from a press
    // still reads on the selected row.
    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppCurves.standard,
      decoration: BoxDecoration(color: background, borderRadius: radius),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: radius,
          hoverColor: Colors.transparent,
          splashColor: AppColors.primary.withValues(alpha: 0.10),
          highlightColor: AppColors.primary.withValues(alpha: 0.06),
          onHover: _setHovered,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s12,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: AppDurations.medium,
                  curve: AppCurves.standard,
                  width: 3,
                  height: widget.active ? AppSpacing.s20 : AppSpacing.s12,
                  decoration: BoxDecoration(
                    // Resting rows keep the indent but spend no gold; the open
                    // row gets the marker, in the readable ink step.
                    color: widget.active
                        ? AppColors.primaryInk
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: AppText.label(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A row inside the "Solutions" panel: a title one step down from the nav rows
/// above it, over a muted supporting line.
class _DrawerSubItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _DrawerSubItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.sm);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: () {},
        borderRadius: radius,
        hoverColor: AppColors.surfaceAlt,
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.surfaceAlt,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.s12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppText.bodySmall(context, color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle, style: AppText.caption(context)),
            ],
          ),
        ),
      ),
    );
  }
}
