import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:flutter/material.dart';

/// How much visual weight a button carries.
///
/// * [filled] — the one gold call to action in a viewport.
/// * [outlined] — the secondary action beside it: a hairline, no fill.
/// * [ghost] — a tertiary action that only reveals itself on hover.
enum ActionButtonVariant { filled, outlined, ghost }

enum ActionButtonSize { small, medium, large }

/// The app's call to action. Sizes itself to its label instead of a fixed
/// width, so it never overflows on a narrow phone.
///
/// Interaction is handled here rather than by each caller: hover, press, focus,
/// disabled and loading all resolve from [onPressed] and [loading]. A button
/// with a null [onPressed] renders disabled and takes no ink.
class ActionButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ActionButtonVariant variant;
  final ActionButtonSize size;

  /// Fill for the [ActionButtonVariant.filled] variant only — the other two
  /// variants deliberately sit on whatever surface is behind them.
  final Color backgroundColor;

  /// Label / icon colour. Leave it null: the button picks whichever of
  /// [AppColors.onPrimary] and [AppColors.textPrimary] actually reads on the
  /// resolved fill, which is what keeps text off a failing contrast pair.
  final Color? foregroundColor;

  /// Stretch to the full width of the parent — useful on mobile.
  final bool expand;

  /// Swaps the label for a spinner without changing the button's width, and
  /// stops it accepting taps.
  final bool loading;

  const ActionButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.variant = ActionButtonVariant.filled,
    this.size = ActionButtonSize.medium,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor,
    this.expand = false,
    this.loading = false,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _isFilled => widget.variant == ActionButtonVariant.filled;
  bool get _isOutlined => widget.variant == ActionButtonVariant.outlined;

  /// Disabled is driven purely by the absence of a handler, the same contract
  /// every Material button uses.
  bool get _disabled => widget.onPressed == null;

  /// A loading button still *looks* enabled — it just cannot be tapped.
  bool get _interactive => !_disabled && !widget.loading;

  // Control heights on the 8pt grid.
  double get _height => switch (widget.size) {
        ActionButtonSize.small => 40,
        ActionButtonSize.medium => 48,
        ActionButtonSize.large => 56,
      };

  double get _horizontalPadding => switch (widget.size) {
        ActionButtonSize.small => AppSpacing.md,
        ActionButtonSize.medium => AppSpacing.s20,
        ActionButtonSize.large => AppSpacing.xl,
      };

  double get _fontSize => switch (widget.size) {
        ActionButtonSize.small => 14,
        ActionButtonSize.medium => 16,
        ActionButtonSize.large => 18,
      };

  static double _contrast(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    return ((la > lb ? la : lb) + 0.05) / ((la > lb ? lb : la) + 0.05);
  }

  /// Steps a fill towards [AppColors.onPrimary] by [amount] — the light-page
  /// answer to hover and press.
  static Color _deepen(Color base, double amount) =>
      Color.alphaBlend(AppColors.onPrimary.withValues(alpha: amount), base);

  /// Near-white on gold fails contrast badly, deep navy on gold clears 7:1 —
  /// and the reverse is true on a dark fill. Measure instead of guessing.
  static Color _readableOn(Color fill) =>
      _contrast(AppColors.onPrimary, fill) >=
              _contrast(AppColors.textPrimary, fill)
          ? AppColors.onPrimary
          : AppColors.textPrimary;

  Color get _fillColor {
    if (_isFilled) {
      if (_disabled) return AppColors.surfaceMuted;

      final base = widget.backgroundColor;
      final isBrandGold = base == AppColors.primary;

      // On a light page a fill *deepens* as it is touched. Lifting gold towards
      // [AppColors.primaryLight] on hover was a dark-page habit: at 1.9:1
      // against white the button all but dissolved into the page at the exact
      // moment the pointer was on it.
      if (_pressed) {
        return isBrandGold ? AppColors.primaryDark : _deepen(base, 0.14);
      }
      if (_hovered || _focused) {
        return _deepen(base, isBrandGold ? 0.06 : 0.08);
      }
      return base;
    }

    // Outlined and ghost read as part of the page until they are touched.
    if (!_interactive) return Colors.transparent;
    if (_pressed) return AppColors.surfaceMuted;
    if (_hovered || _focused) return AppColors.surfaceAlt;
    return Colors.transparent;
  }

  Border? get _border {
    if (!_isOutlined) return null;
    if (_disabled) return Border.all(color: AppColors.border);
    return Border.all(
      color: _hovered || _pressed
          ? AppColors.textMuted
          : AppColors.borderStrong,
    );
  }

  /// Keyboard focus is an active state, so it is one of the few places gold is
  /// allowed outside the fill itself — but it has to survive both backdrops it
  /// touches. A single wash of the fill gold resolved to about #EDE1BA on the
  /// white page (~1.2:1) and vanished, so the ring is drawn in the readable
  /// gold at full strength with a page-coloured band between it and the
  /// button; that band is what keeps it legible against a gold fill too.
  ///
  /// Order matters: the list is painted front to back, so the wide gold ring
  /// goes first and the narrow separator lands on top of its inner edge.
  List<BoxShadow>? get _focusRing => _focused && _interactive
      ? const [
          BoxShadow(color: AppColors.primaryInk, spreadRadius: 4),
          BoxShadow(color: AppColors.background, spreadRadius: 2),
        ]
      : null;

  Color get _labelColor {
    if (_disabled) return AppColors.textMuted;
    if (widget.foregroundColor != null) return widget.foregroundColor!;
    return _isFilled
        ? _readableOn(widget.backgroundColor)
        : AppColors.textPrimary;
  }

  void _set(void Function() change) {
    if (!mounted) return;
    setState(change);
  }

  @override
  void didUpdateWidget(covariant ActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A button that stops accepting input stops receiving hover/press
    // callbacks, so clear the flags rather than leave it stuck lit.
    if (!_interactive && (_hovered || _pressed || _focused)) {
      _hovered = false;
      _pressed = false;
      _focused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = _labelColor;
    final iconSize = context.sp(_fontSize) + 4;
    final radius = BorderRadius.circular(AppRadius.md);

    final content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            widget.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.button(context, color: labelColor)
                .copyWith(fontSize: context.sp(_fontSize)),
          ),
        ),
        if (widget.icon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(widget.icon, size: iconSize, color: labelColor),
        ],
      ],
    );

    // The label stays in the tree while loading so the button keeps exactly
    // the width it had — only its opacity changes.
    final body = Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          opacity: widget.loading ? 0 : 1,
          child: content,
        ),
        if (widget.loading)
          SizedBox.square(
            dimension: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: labelColor,
            ),
          ),
      ],
    );

    return SizedBox(
      height: _height,
      width: widget.expand ? double.infinity : null,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: AppDurations.fast,
        curve: AppCurves.standard,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          decoration: BoxDecoration(
            color: _fillColor,
            border: _border,
            borderRadius: radius,
            boxShadow: _focusRing,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _interactive ? widget.onPressed : null,
              onHover: _interactive ? (v) => _set(() => _hovered = v) : null,
              onHighlightChanged:
                  _interactive ? (v) => _set(() => _pressed = v) : null,
              onFocusChange:
                  _interactive ? (v) => _set(() => _focused = v) : null,
              borderRadius: radius,
              mouseCursor: _interactive
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              splashColor: (_isFilled ? AppColors.onPrimary : AppColors.textPrimary)
                  .withValues(alpha: 0.12),
              // Hover, press and focus are already drawn by the container
              // above, so the ink layer only contributes the tap ripple.
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: Center(child: body),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
