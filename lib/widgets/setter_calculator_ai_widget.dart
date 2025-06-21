import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
    return Center(
      child: Container(
        width: 700,
        height: 952,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: ScrollConfiguration(
          behavior: NoScrollIndicator(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: const Text(
                      "Setter AI Value Calculator",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: const Text(
                      "See how Setter AI could multiply your revenue from leads",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 32),
                  buildSliderSection(
                    question: "How many leads do you generate per month?",
                    value: leadsPerMonth,
                    min: 100,
                    max: 20000,
                    onChanged: (val) => setState(() => leadsPerMonth = val),
                  ),
                  const SizedBox(height: 32),
                  buildSliderSection(
                    question:
                        "How fast are you currently following up new leads? (hours)",
                    value: costPerLead,
                    min: 1,
                    max: 48,
                    unit: "h",
                    onChanged: (val) => setState(() => costPerLead = val),
                  ),
                  const SizedBox(height: 32),
                  buildSliderSection(
                    question:
                        "Roughly what percentage of your leads reply to your first message?",
                    value: closeRate,
                    min: 10,
                    max: 90,
                    unit: "%",
                    onChanged: (val) => setState(() => closeRate = val),
                  ),
                  const SizedBox(height: 32),
                  buildSliderSection(
                    question:
                        "Out of conversations you start, how many turn into booked meetings?",
                    value: avgDealSize,
                    min: 5,
                    max: 80,
                    unit: "%",
                    onChanged: (val) => setState(() => avgDealSize = val),
                  ),
                  const SizedBox(height: 32),
                  buildSliderSection(
                    question:
                        "Of the meetings you take, how many become paying customers?",
                    value: salesCycle,
                    min: 10,
                    max: 70,
                    unit: "%",
                    onChanged: (val) => setState(() => salesCycle = val),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 900, // increased width here (adjust as needed)
                    child: buildSliderSection(
                      question: "What's the average deal size in dollars?",
                      value: adBudget,
                      min: 500,
                      max: 500000,
                      unit: "\$",
                      onChanged: (val) => setState(() => adBudget = val),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Add your calculation logic here
                      },

                      // have error here
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Calculate Revenue Potential",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Gap(10),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Backed by a Harvard study",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                question,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
              ),
            ),

            // Wrap with SizedBox with fixed max width or Flexible
            SizedBox(
              width: 105, // Adjust width as needed to fit typical values
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center, // center the text inside container
                child: Text(
                  formatValue(value),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 9,
            activeTrackColor: Colors.deepPurple,
            inactiveTrackColor: Colors.grey.withOpacity(0.1),
            thumbColor: Colors.deepPurple,
            overlayColor: Colors.deepPurple.withOpacity(0.2),
            trackShape: _CustomTrackShape(),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatValue(min),
                style: const TextStyle(color: Colors.black54)),
            Text(formatValue(max),
                style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ],
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
