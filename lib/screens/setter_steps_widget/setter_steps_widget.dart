import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:flutter/material.dart';

/// The "how it works" list. It reads as a premium light feature list: white
/// cards on the warm band, a hairline each, and no accent at all — the section
/// carries no action for gold to point at, and four gold eyebrows down a
/// column would be decoration rather than emphasis. The ladder is typographic:
/// muted marker, ink title, secondary sentence.
///
/// The band is [AppColors.surfaceAlt] because the sections either side of it
/// are white — the change of ground is what separates them, not a rule.
class SetterStepsSection extends StatelessWidget {
  const SetterStepsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Two columns only once there is real room for them; everything below that
    // stacks into a single readable column.
    final isWide = context.isDesktop;
    final steps = _stepsFor(isWide);

    final title = TitleText(
      text: isWide
          ? "Here’s how Setter AI books\nYOU more meetings in 3\nsimple steps."
          : "Here’s how Setter AI books YOU more meetings in 3 simple steps.",
      textAlign: TextAlign.left,
      style: isWide ? AppText.h1(context) : AppText.h2(context),
    );

    final cards = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s12),
          _StepCard(step: steps[i]),
        ],
      ],
    );

    return SectionContainer(
      color: AppColors.surfaceAlt,
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: title),
                SizedBox(width: context.blockGap),
                Expanded(flex: 5, child: cards),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                SizedBox(height: context.blockGap),
                cards,
              ],
            ),
    );
  }

  /// The wide layout keeps the copy's own line breaks; the stacked layout lets
  /// the same sentences flow.
  List<_Step> _stepsFor(bool isWide) => [
        _Step(
          marker: "Step 1:",
          title: "Instant Response (10 Seconds)",
          description: isWide
              ? "Your lead gets a message in under 10 seconds. No\n delays. No drop-off."
              : "Your lead gets a message in under 10 seconds. No delays. No drop-off.",
        ),
        _Step(
          marker: "Step 2:",
          title: "Automated Follow-Ups",
          description: isWide
              ? "Your AI agent keeps following up – until the lead\n replies or books."
              : "Your AI agent keeps following up – until the lead replies or books.",
        ),
        _Step(
          marker: "Step 3:",
          title: "Conversational Booking",
          description: isWide
              ? "The lead books directly *inside the chat*. No forms.\n No friction."
              : "The lead books directly *inside the chat*. No forms. No friction.",
        ),
        _Step(
          marker: "Step 4:",
          title: "Meeting Reminders",
          description: isWide
              ? "Automatic reminders on text/WhatsApp to reduce\n no-shows and boost your show-up rate."
              : "Automatic reminders on text/WhatsApp to reduce no-shows and boost your show-up rate.",
        ),
      ];
}

/// One entry of the steps list: the [marker] eyebrow, the [title] it belongs to
/// and the sentence underneath.
class _Step {
  final String marker;
  final String title;
  final String description;

  const _Step({
    required this.marker,
    required this.title,
    required this.description,
  });
}

class _StepCard extends StatefulWidget {
  final _Step step;

  const _StepCard({required this.step});

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final step = widget.step;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppDurations.medium,
        curve: AppCurves.standard,
        width: double.infinity,
        padding: EdgeInsets.all(context.cardPad),
        decoration: BoxDecoration(
          // The card stays white on the warm band and lifts on hover instead
          // of washing — a wash here would sink it into the band.
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: _hovered ? AppColors.borderStrong : AppColors.border,
          ),
          boxShadow: _hovered ? AppShadows.soft : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata, not emphasis: `overline` defaults to the readable
            // gold, but the title below already carries the weight and there
            // are four of these stacked in the band.
            Text(
              step.marker,
              style: AppText.overline(context, color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(step.title, style: AppText.title(context)),
            const SizedBox(height: AppSpacing.sm),
            Text(step.description, style: AppText.body(context)),
          ],
        ),
      ),
    );
  }
}
