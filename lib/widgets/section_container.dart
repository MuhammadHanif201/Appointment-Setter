import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:flutter/material.dart';

/// A full bleed page section: the background stretches edge to edge while the
/// content is centered and capped at a readable width.
///
/// Side padding comes from `context.hPad` (never more than 20) and the vertical
/// rhythm from `context.vPad`, so every section on the page lines up.
///
/// The default [color] is [AppColors.background] on purpose — a section is a
/// band of the page, not a card. Reach for [AppColors.surface] /
/// [AppColors.surfaceAlt] only when a band should genuinely lift off the page,
/// otherwise the whole scroll reads as a stack of floating panels.
class SectionContainer extends StatelessWidget {
  final Widget child;

  /// Widest the inner content may get. Defaults to `context.maxContentWidth`.
  final double? maxWidth;

  /// Overrides the default responsive padding. Prefer [verticalPadding] when
  /// you only need to tweak the rhythm.
  final EdgeInsetsGeometry? padding;

  /// Custom vertical padding, keeping the standard horizontal gutter.
  final double? verticalPadding;

  final EdgeInsetsGeometry? margin;
  final Color color;
  final Gradient? gradient;
  final double? height;

  /// Where the width-capped content band sits inside the full bleed band.
  /// [CrossAxisAlignment.center] (the default) centers it; `start` / `end` pin
  /// it to the leading / trailing gutter.
  final CrossAxisAlignment crossAxisAlignment;

  const SectionContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.verticalPadding,
    this.margin,
    this.color = AppColors.background,
    this.gradient,
    this.height,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// The content band is already vertically laid out by [child]; the only axis
  /// this container decides is the horizontal one.
  Alignment get _contentAlignment => switch (crossAxisAlignment) {
        CrossAxisAlignment.start => Alignment.centerLeft,
        CrossAxisAlignment.end => Alignment.centerRight,
        _ => Alignment.center,
      };

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: context.hPad,
          vertical: verticalPadding ?? context.vPad,
        );

    return Container(
      width: double.infinity,
      height: height,
      margin: margin,
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
      ),
      child: Align(
        alignment: _contentAlignment,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: maxWidth ?? context.maxContentWidth),
          child: child,
        ),
      ),
    );
  }
}
