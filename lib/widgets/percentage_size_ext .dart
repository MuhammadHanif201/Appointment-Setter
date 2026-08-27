import 'package:flutter/widgets.dart';

/// Breakpoints used across the app.
class AppBreakpoints {
  const AppBreakpoints._();

  /// Below this width the layout collapses to a single column.
  static const double mobile = 600;

  /// Below this width we use the tablet layout, above it the desktop layout.
  static const double desktop = 1024;

  /// Very narrow phones need slightly tighter type and spacing.
  static const double smallMobile = 380;
}

/// An extension on `context` to support sizes based on percentage plus the
/// responsive helpers (breakpoints, section padding, font scaling) that every
/// screen in this app builds on.
///
/// usage: `SizedBox(width: context.percentWidth * 10)` to size a widget to 10%
/// of screen width.
extension ContextSizeExtensions on BuildContext {
  /// To get a [MediaQuery] directly.
  MediaQueryData get mq => MediaQuery.of(this);

  /// Get MediaQuery Screen Size
  Size get screenSize => mq.size;

  /// Get MediaQuery Screen Density
  double get screenDensity => mq.devicePixelRatio;

  /// Get MediaQuery Screen Padding
  EdgeInsets get screenPadding => mq.padding;

  /// Get MediaQuery Screen Width
  double get screenWidth => mq.size.width;

  /// Get MediaQuery Screen Height
  double get screenHeight => mq.size.height;

  /// Get MediaQuery device pixel ratio
  double get devicePixelRatio => mq.devicePixelRatio;

  /// Get MediaQuery Screen Width in percentage
  double get percentWidth => screenWidth / 100;

  /// Get MediaQuery Screen height in percentage
  double get percentHeight => screenHeight / 100;

  /// Width as a fraction of the screen, e.g. `context.wp(50)` == half the width.
  double wp(double percent) => percentWidth * percent;

  /// Height as a fraction of the screen, e.g. `context.hp(25)`.
  double hp(double percent) => percentHeight * percent;

  // ---------------------------------------------------------------------------
  // Breakpoints
  // ---------------------------------------------------------------------------

  /// Phones — single column layouts.
  bool get isMobile => screenWidth < AppBreakpoints.mobile;

  /// Small phones (iPhone SE and friends).
  bool get isSmallMobile => screenWidth < AppBreakpoints.smallMobile;

  /// Tablets — two column layouts, desktop typography scaled down.
  bool get isTablet =>
      screenWidth >= AppBreakpoints.mobile &&
      screenWidth < AppBreakpoints.desktop;

  /// Desktop / web — full multi column layouts.
  bool get isDesktop => screenWidth >= AppBreakpoints.desktop;

  /// Anything that is not a phone.
  bool get isTabletOrLarger => screenWidth >= AppBreakpoints.mobile;

  /// Pick a value per breakpoint. [tablet] falls back to [mobile] and
  /// [desktop] falls back to [tablet], so you only pass what actually changes.
  ///
  /// ```dart
  /// final columns = context.responsive(mobile: 1, tablet: 2, desktop: 3);
  /// ```
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------

  /// Horizontal gutter for a section. Capped at 20 on every breakpoint — the
  /// page is kept readable by [maxContentWidth], not by fat side padding.
  double get hPad => responsive(mobile: 16, tablet: 20, desktop: 20);

  /// Vertical rhythm between sections.
  double get vPad => responsive(mobile: 32, tablet: 40, desktop: 56);

  /// Standard padding for a full width section.
  EdgeInsets get sectionPadding =>
      EdgeInsets.symmetric(horizontal: hPad, vertical: vPad);

  /// Horizontal-only section padding, for sections that manage their own
  /// vertical rhythm.
  EdgeInsets get sectionHPadding => EdgeInsets.symmetric(horizontal: hPad);

  /// Padding used inside cards / tiles.
  double get cardPad => responsive(mobile: 16, tablet: 20, desktop: 24);

  /// Gap between the stacked blocks inside a section.
  double get blockGap => responsive(mobile: 24, tablet: 32, desktop: 40);

  /// The widest the readable content is allowed to get. Content is centered
  /// inside this, which is what keeps large screens from looking stretched.
  double get maxContentWidth => 1200;

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  /// Soften the hard line breaks a copywriter put in a headline.
  ///
  /// Copy like "How Many Sales Meetings Are You\nLeaving on the Table?" is
  /// authored against the widest layout. Narrower than that, the line before
  /// the break soft-wraps on its own and the break then strands the last word
  /// alone on a line ("...Are\nYou\nLeaving..."). Below desktop the breaks
  /// therefore collapse to ordinary spaces and the text simply wraps to fit —
  /// the words are untouched, only where they fall changes.
  String softBreaks(String text) => isDesktop
      ? text
      : text.replaceAll(RegExp(r'\s*\n\s*'), ' ');

  /// Scale a desktop font size down for smaller screens.
  ///
  /// Display type shrinks hard while body copy barely moves — a headline can
  /// lose a third of its size and still read, a 16px paragraph cannot. Sizes
  /// are blended between those two factors between 18px and 40px.
  ///
  /// ```dart
  /// Text('Hi', style: TextStyle(fontSize: context.sp(44)))
  /// ```
  double sp(double size) {
    if (isDesktop) return size;

    final headingFactor = isTablet ? 0.86 : (isSmallMobile ? 0.62 : 0.68);
    final bodyFactor = isTablet ? 0.96 : (isSmallMobile ? 0.90 : 0.94);

    final t = ((size - 18) / (40 - 18)).clamp(0.0, 1.0);
    final factor = bodyFactor + (headingFactor - bodyFactor) * t;

    return (size * factor).clamp(12.0, size);
  }
}
