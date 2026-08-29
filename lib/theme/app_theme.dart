import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Every colour in the product. Nothing should hardcode a hex outside of here.
///
/// The palette is a white, neutral-grey system with gold as a restrained
/// accent. White and light greys carry the surfaces and every card or outlined
/// control is separated from the page by a grey hairline; gold appears only on
/// the primary action, the active state, and the single number that matters on
/// a screen — never on decoration or body copy.
class AppColors {
  const AppColors._();

  // --- Brand -----------------------------------------------------------------

  /// Luxury gold. Fills for primary actions, active states, key indicators.
  ///
  /// Gold is a *fill* colour, not a text or stroke colour. Against white it
  /// only reaches 2.4:1, which fails even the 3:1 bar for large text and icons,
  /// so anything that has to be *read* uses [primaryInk] (4.9:1) instead. Use
  /// this one for button fills, active indicators and progress — shapes whose
  /// meaning does not depend on legibility.
  static const Color primary = Color(0xFFC9A227);

  /// Gold dark enough to read as text or an icon on a white page (4.9:1).
  static const Color primaryInk = Color(0xFF8A6D14);

  /// Hover / pressed state of a gold fill — on a light page gold darkens.
  static const Color primaryDark = Color(0xFFA8871D);

  /// Light gold for tints, hairlines and washes.
  static const Color primaryLight = Color(0xFFE3C86A);

  /// Pale gold wash — selected chips, icon badges, highlighted rows.
  static const Color primarySoft = Color(0xFFFBF4DE);

  /// Text/icons that sit ON a gold fill. Near-black, never white (7.6:1).
  static const Color onPrimary = Color(0xFF1A1508);

  /// Gold sweep for the rare hero flourish. Use sparingly.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE3C86A), Color(0xFFC9A227)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Surfaces --------------------------------------------------------------

  /// Page background.
  static const Color background = Color(0xFFFFFFFF);

  /// Default card / section surface.
  static const Color surface = Color(0xFFFFFFFF);

  /// Raised surface: input fills, hovered rows, alternating section bands.
  /// A neutral grey — the page reads white and calm, and gold stays an accent
  /// rather than tinting whole areas.
  static const Color surfaceAlt = Color(0xFFF7F8FA);

  /// Muted panel one step further in — nested content, quiet inner panels.
  static const Color surfaceMuted = Color(0xFFF1F2F5);

  /// The genuinely dark surfaces: video letterboxes, the call screen and the
  /// footer band that closes the page.
  /// Anything drawn on it must use [textOnDark] / [textOnDarkMuted].
  static const Color surfaceDark = Color(0xFF0E1422);

  /// Scrim behind modals and drawers.
  static const Color scrim = Color(0x660E1422);

  // --- Text ------------------------------------------------------------------

  static const Color textPrimary = Color(0xFF16181D);
  static const Color textSecondary = Color(0xFF4C525E);

  /// Tertiary copy: helper text, metadata, disabled labels.
  static const Color textMuted = Color(0xFF868C99);

  /// For copy placed on [surfaceDark] — the call screen, video frames and the
  /// footer.
  static const Color textOnDark = Color(0xFFF8F7F2);
  static const Color textOnDarkMuted = Color(0xFFB4BAC6);

  /// Hairline on a dark surface. A solid grey would read as a smudge there, so
  /// lines on [surfaceDark] are a low-alpha white instead.
  static const Color borderOnDark = Color(0x1FFFFFFF);

  /// A lift on a dark surface — input fills and hover washes on [surfaceDark].
  static const Color surfaceOnDarkAlt = Color(0x14FFFFFF);

  // --- Lines & states --------------------------------------------------------

  /// The hairline that makes a white card or an outlined button visible on a
  /// white page. Every card and every outlined control gets one — without it
  /// they disappear into the background.
  static const Color border = Color(0xFFE1E4E9);

  /// A step darker, for outlined buttons and anything that needs to read as a
  /// deliberate edge rather than a whisper.
  static const Color borderStrong = Color(0xFFC9CED6);

  static const Color success = Color(0xFF1B9E6B);
  static const Color warning = Color(0xFFC4881C);
  static const Color danger = Color(0xFFD14343);

  /// Kept for the one genuine WhatsApp brand moment. Not a UI accent.
  static const Color whatsapp = Color(0xFF25D366);

  /// Legacy accent names from the previous palette, remapped onto gold so any
  /// straggling reference stays on-brand.
  static const Color accentBlue = primaryLight;
  static const Color accentCyan = primary;
}

/// Corner radii. Restrained — cards are softened, not pill-shaped.
class AppRadius {
  const AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 100;
}

/// Spacing steps on a 4/8 grid. Responsive spacing lives on `context`
/// (see `percentage_size_ext .dart`).
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double s12 = 12;
  static const double md = 16;
  static const double s20 = 20;
  static const double lg = 24;
  static const double xl = 32;
  static const double s40 = 40;
  static const double xxl = 48;
}

/// Elevation. On a light UI a soft neutral shadow plus a hairline border reads
/// as depth; anything heavier looks like a 2014 material card, so these stay
/// deliberately quiet.
class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1416181D),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0D16181D),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  /// For a gold element that needs to feel lit.
  static const List<BoxShadow> gold = [
    BoxShadow(
      color: Color(0x47C9A227),
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
  ];
}

/// Motion. Micro-interactions stay in the 150–300ms band.
class AppDurations {
  const AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 300);
}

/// Easing that matches [AppDurations].
class AppCurves {
  const AppCurves._();

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuart;
}

/// The app's type scale, on the bundled Inter family (no runtime font fetch).
///
/// Sizes are declared at their desktop value and scaled down per breakpoint by
/// `context.sp`, so one call adapts everywhere. Weights stay in the 400–700
/// band; heavier type is not available and is not wanted.
class AppText {
  const AppText._();

  /// The bundled family. Declared in pubspec.yaml under `fonts:`.
  static const String fontFamily = 'Inter';

  static TextStyle _inter(
    BuildContext context, {
    required double size,
    required FontWeight weight,
    double height = 1.4,
    Color color = AppColors.textPrimary,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: context.sp(size),
      fontWeight: weight,
      height: height,
      color: color,
      letterSpacing: letterSpacing,
      decoration: TextDecoration.none,
    );
  }

  /// Hero headline — one per page.
  static TextStyle display(BuildContext context, {Color? color}) => _inter(
        context,
        size: 56,
        weight: FontWeight.w700,
        height: 1.08,
        letterSpacing: -1.2,
        color: color ?? AppColors.textPrimary,
      );

  /// Section headline.
  static TextStyle h1(BuildContext context, {Color? color}) => _inter(
        context,
        size: 44,
        weight: FontWeight.w700,
        height: 1.14,
        letterSpacing: -0.8,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle h2(BuildContext context, {Color? color}) => _inter(
        context,
        size: 32,
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle h3(BuildContext context, {Color? color}) => _inter(
        context,
        size: 24,
        weight: FontWeight.w600,
        height: 1.28,
        letterSpacing: -0.3,
        color: color ?? AppColors.textPrimary,
      );

  /// Card / list item title.
  static TextStyle title(BuildContext context, {Color? color}) => _inter(
        context,
        size: 20,
        weight: FontWeight.w600,
        height: 1.32,
        letterSpacing: -0.15,
        color: color ?? AppColors.textPrimary,
      );

  /// Lead paragraph under a headline.
  static TextStyle bodyLarge(BuildContext context, {Color? color}) => _inter(
        context,
        size: 18,
        weight: FontWeight.w400,
        height: 1.6,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle body(BuildContext context, {Color? color}) => _inter(
        context,
        size: 16,
        weight: FontWeight.w400,
        height: 1.6,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle bodySmall(BuildContext context, {Color? color}) => _inter(
        context,
        size: 14,
        weight: FontWeight.w400,
        height: 1.55,
        color: color ?? AppColors.textSecondary,
      );

  /// Metadata, helper text, roles.
  static TextStyle caption(BuildContext context, {Color? color}) => _inter(
        context,
        size: 13,
        weight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.1,
        color: color ?? AppColors.textMuted,
      );

  /// Nav links, field labels, chips.
  static TextStyle label(BuildContext context, {Color? color}) => _inter(
        context,
        size: 16,
        weight: FontWeight.w500,
        height: 1.5,
        color: color ?? AppColors.textPrimary,
      );

  /// All button labels.
  static TextStyle button(BuildContext context, {Color? color}) => _inter(
        context,
        size: 16,
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.1,
        color: color ?? AppColors.onPrimary,
      );

  /// A small all-caps eyebrow above a headline.
  static TextStyle overline(BuildContext context, {Color? color}) => _inter(
        context,
        size: 13,
        weight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 1.4,
        color: color ?? AppColors.primaryInk,
      );

  /// Oversized stat numbers ("10s", "97%"). Gold by default — this is one of
  /// the few places the accent earns its place.
  static TextStyle stat(BuildContext context, {Color? color}) => _inter(
        context,
        size: 120,
        weight: FontWeight.w700,
        height: 1,
        letterSpacing: -3,
        color: color ?? AppColors.primaryInk,
      );
}

/// The [ThemeData] handed to `GetMaterialApp`. Light by construction — the app
/// ships one theme, and it is this one.
ThemeData buildAppTheme() {
  const colorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primarySoft,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.primaryLight,
    onSecondary: AppColors.onPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceMuted,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.borderStrong,
    error: AppColors.danger,
    onError: AppColors.background,
  );

  const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
  );

  TextStyle font(double size, FontWeight weight, Color color, [double h = 1.4]) {
    return TextStyle(
      fontFamily: AppText.fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: h,
      color: color,
    );
  }

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    fontFamily: AppText.fontFamily,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.surface,
    splashFactory: InkSparkle.splashFactory,

    // Fixed-size text theme — responsive sizing goes through AppText/context.sp.
    textTheme: TextTheme(
      displayLarge: font(56, FontWeight.w700, AppColors.textPrimary, 1.08),
      displayMedium: font(44, FontWeight.w700, AppColors.textPrimary, 1.14),
      headlineLarge: font(32, FontWeight.w600, AppColors.textPrimary, 1.2),
      headlineMedium: font(24, FontWeight.w600, AppColors.textPrimary, 1.28),
      titleLarge: font(20, FontWeight.w600, AppColors.textPrimary, 1.32),
      titleMedium: font(16, FontWeight.w500, AppColors.textPrimary, 1.5),
      bodyLarge: font(18, FontWeight.w400, AppColors.textSecondary, 1.6),
      bodyMedium: font(16, FontWeight.w400, AppColors.textSecondary, 1.6),
      bodySmall: font(14, FontWeight.w400, AppColors.textSecondary, 1.55),
      labelLarge: font(16, FontWeight.w600, AppColors.textPrimary, 1.2),
      labelMedium: font(13, FontWeight.w500, AppColors.textMuted, 1.45),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        fontFamily: AppText.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.surfaceMuted,
        disabledForegroundColor: AppColors.textMuted,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.s12,
        ),
        shape: shape,
        textStyle: font(16, FontWeight.w600, AppColors.onPrimary, 1.2),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        disabledForegroundColor: AppColors.textMuted,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.s12,
        ),
        side: const BorderSide(color: AppColors.borderStrong),
        shape: shape,
        textStyle: font(16, FontWeight.w600, AppColors.textPrimary, 1.2),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryInk,
        disabledForegroundColor: AppColors.textMuted,
        textStyle: font(16, FontWeight.w600, AppColors.primaryInk, 1.2),
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 22),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        highlightColor: AppColors.primary.withValues(alpha: 0.12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      hintStyle: font(16, FontWeight.w400, AppColors.textMuted, 1.5),
      labelStyle: font(14, FontWeight.w500, AppColors.textSecondary, 1.4),
      floatingLabelStyle: font(14, FontWeight.w500, AppColors.primaryInk, 1.4),
      errorStyle: font(13, FontWeight.w500, AppColors.danger, 1.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceAlt,
      selectedColor: AppColors.primarySoft,
      disabledColor: AppColors.surfaceMuted,
      side: const BorderSide(color: AppColors.border),
      labelStyle: font(14, FontWeight.w500, AppColors.textSecondary, 1.4),
      secondaryLabelStyle: font(14, FontWeight.w600, AppColors.primaryInk, 1.4),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.sm,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceAlt,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: const BorderSide(color: AppColors.border),
      ),
      titleTextStyle: font(20, FontWeight.w600, AppColors.textPrimary, 1.32),
      contentTextStyle: font(16, FontWeight.w400, AppColors.textSecondary, 1.6),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceAlt,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      showDragHandle: true,
      dragHandleColor: AppColors.borderStrong,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      scrimColor: AppColors.scrim,
      elevation: 0,
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.textSecondary,
      textColor: AppColors.textPrimary,
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      contentTextStyle: font(14, FontWeight.w500, AppColors.textOnDark, 1.5),
      actionTextColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      textStyle: font(13, FontWeight.w500, AppColors.textOnDark, 1.4),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.surfaceMuted,
      circularTrackColor: AppColors.surfaceMuted,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.surfaceMuted,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withValues(alpha: 0.16),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle:
          font(13, FontWeight.w600, AppColors.onPrimary, 1.4),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.onPrimary
              : AppColors.textMuted),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.surfaceMuted),
      trackOutlineColor:
          const WidgetStatePropertyAll<Color>(AppColors.borderStrong),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent),
      checkColor: const WidgetStatePropertyAll<Color>(AppColors.onPrimary),
      side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm / 2),
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.borderStrong),
    ),

  );
}
