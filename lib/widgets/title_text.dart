import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:flutter/material.dart';

/// Section heading. A thin wrapper over the type scale — it defaults to the
/// `h1` step, which already scales itself per breakpoint, so a caller should
/// never hand it a hardcoded `fontSize`.
///
/// Pass [style] to step the heading down (`AppText.h2(context)`,
/// `AppText.display(context)`, ...) rather than reaching for `TextStyle`.
class TitleText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  /// Headings stay [AppColors.textPrimary] unless there is a real reason:
  /// gold belongs on actions and key stats, not on every headline.
  final Color? color;

  /// Optional override when a heading needs a different step of the scale.
  final TextStyle? style;

  const TitleText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.color,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final base = style ?? AppText.h1(context, color: color);

    return Text(
      // Hard breaks in the copy are authored for the widest layout; below
      // desktop they orphan words, so they wrap naturally instead.
      context.softBreaks(text),
      textAlign: textAlign,
      // [color] stays honoured even when a caller also supplies a [style].
      style: color == null ? base : base.copyWith(color: color),
    );
  }
}

/// The supporting paragraph that sits under a [TitleText]. Reads as secondary
/// copy by default, which is what keeps the heading dominant.
class SectionSubtitle extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color? color;

  /// Optional override for the rare subtitle that needs a different step
  /// (`AppText.body(context)` on a dense panel, for instance).
  final TextStyle? style;

  const SectionSubtitle({
    super.key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.color,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final base = style ?? AppText.bodyLarge(context, color: color);

    return Text(
      context.softBreaks(text),
      textAlign: textAlign,
      style: color == null ? base : base.copyWith(color: color),
    );
  }
}
