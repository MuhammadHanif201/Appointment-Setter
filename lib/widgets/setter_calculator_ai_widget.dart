import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:flutter/material.dart';

/// The six-slider revenue calculator.
///
/// One gold moment, and it is the "Calculate Revenue Potential" button at the
/// bottom. Everything above it — six tracks, six thumbs, six value chips — is
/// deliberately neutral, because a repeated control is chrome, not emphasis.
class SetterAICalculatorWidget extends StatefulWidget {
  const SetterAICalculatorWidget({super.key});

  @override
  State<SetterAICalculatorWidget> createState() =>
      _SetterAICalculatorWidgetState();
}

class _SetterAICalculatorWidgetState extends State<SetterAICalculatorWidget> {
  double leadsPerMonth = 1000;
  double costPerLead = 3.0;
  double closeRate = 15;
  double avgDealSize = 10;
  double salesCycle = 25;
  double adBudget = 100000;

  @override
  Widget build(BuildContext context) {
    final fieldGap = context.responsive<double>(
      mobile: AppSpacing.lg,
      tablet: AppSpacing.lg,
      desktop: AppSpacing.xl,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.cardPad),
          decoration: BoxDecoration(
            // The enclosing section is the warm band, so the card is the white
            // sheet on top of it. Depth is a hairline plus a quiet shadow —
            // nothing heavier reads as premium on a light page.
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Setter AI Value Calculator",
                  style: AppText.h3(context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  "See how Setter AI could multiply your revenue from leads",
                  style: AppText.body(context),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: context.cardPad),
              const Divider(),
              SizedBox(height: fieldGap),
              buildSliderSection(
                question: "How many leads do you generate per month?",
                value: leadsPerMonth,
                min: 100,
                max: 20000,
                onChanged: (val) => setState(() => leadsPerMonth = val),
              ),
              SizedBox(height: fieldGap),
              buildSliderSection(
                question:
                    "How fast are you currently following up new leads? (hours)",
                value: costPerLead,
                min: 1,
                max: 48,
                unit: "h",
                onChanged: (val) => setState(() => costPerLead = val),
              ),
              SizedBox(height: fieldGap),
              buildSliderSection(
                question:
                    "Roughly what percentage of your leads reply to your first message?",
                value: closeRate,
                min: 10,
                max: 90,
                unit: "%",
                onChanged: (val) => setState(() => closeRate = val),
              ),
              SizedBox(height: fieldGap),
              buildSliderSection(
                question:
                    "Out of conversations you start, how many turn into booked meetings?",
                value: avgDealSize,
                min: 5,
                max: 80,
                unit: "%",
                onChanged: (val) => setState(() => avgDealSize = val),
              ),
              SizedBox(height: fieldGap),
              buildSliderSection(
                question:
                    "Of the meetings you take, how many become paying customers?",
                value: salesCycle,
                min: 10,
                max: 70,
                unit: "%",
                onChanged: (val) => setState(() => salesCycle = val),
              ),
              SizedBox(height: fieldGap),
              buildSliderSection(
                question: "What's the average deal size in dollars?",
                value: adBudget,
                min: 500,
                max: 500000,
                unit: "\$",
                onChanged: (val) => setState(() => adBudget = val),
              ),
              SizedBox(height: context.blockGap),
              ActionButton(
                text: "Calculate Revenue Potential",
                icon: Icons.arrow_forward,
                size: ActionButtonSize.large,
                expand: true,
                onPressed: () {
                  // Add your calculation logic here
                },
              ),
              const SizedBox(height: AppSpacing.s12),
              Center(
                child: Text(
                  "Backed by a Harvard study",
                  style: AppText.caption(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSliderSection({
    required String question,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    String unit = "",
  }) {
    String formatValue(double val) {
      if (unit == "\$") {
        return "\$${val.toInt()}";
      } else if (unit == "%") {
        return "${val.toInt()}%";
      } else if (unit == "h") {
        return "${val.toStringAsFixed(1)}h";
      }
      return val.toInt().toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                question,
                style: AppText.label(context),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            _ValuePill(label: formatValue(value)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SliderTheme(
          // The global slider theme is gold, and this card stacks six sliders.
          // Six gold tracks and six gold thumbs above the "Calculate Revenue
          // Potential" button would leave the actual call to action with
          // nothing to stand out against, so the slider chrome is demoted to
          // ink on a hairline track. The filled run still reads as the value —
          // it just stops competing for the accent.
          data: SliderTheme.of(context).copyWith(
            trackHeight: AppSpacing.sm,
            activeTrackColor: AppColors.textPrimary,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.textPrimary,
            overlayColor: AppColors.textPrimary.withValues(alpha: 0.08),
            // Full-bleed track, so the min / max labels below line up with the
            // two ends of the run.
            trackShape: _CustomTrackShape(),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 0,
              pressedElevation: 0,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            // These are discrete sliders with tens of divisions, so Material
            // would stipple tick marks along the track. The chip beside the
            // question is already the exact readout; the stipple is noise.
            tickMarkShape: SliderTickMarkShape.noTickMark,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                formatValue(min),
                style: AppText.caption(context),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                formatValue(max),
                style: AppText.caption(context),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The live readout beside each slider question.
///
/// A neutral chip, not a gold one: six of these stack down the card, and gilding
/// a repeated readout spends the accent the primary button needs. It reads as a
/// quiet input value — warm off-white fill, hairline edge, ink label. Tabular
/// figures keep the chip from twitching while the slider is dragged, and the
/// width floor stops it resizing between "5%" and "80%".
class _ValuePill extends StatelessWidget {
  final String label;

  const _ValuePill({required this.label});

  @override
  Widget build(BuildContext context) {
    // Deliberately not animated: this redraws on every drag frame, so an
    // implicit tween would only ever lag behind the thumb.
    return Container(
      constraints: const BoxConstraints(minWidth: 72),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppText.label(context, color: AppColors.textPrimary).copyWith(
          fontWeight: FontWeight.w600,
          height: 1.2,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 6;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(
        offset.dx, trackTop, parentBox.size.width, trackHeight);
  }
}

class NoScrollIndicator extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
