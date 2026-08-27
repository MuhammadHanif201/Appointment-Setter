import 'package:appointment_setter/model/faq_model.dart';
import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:flutter/material.dart';

// FAQ List
final List<FAQ> faqList = [
  FAQ(
    question: 'Will it work with our current lead sources (Meta ads, etc.)?',
    answer:
        'Yes, Setter AI seamlessly integrates with like Meta ads, Google Ads, and others.',
  ),
  FAQ(
    question: 'We want exclusivity in our market.',
    answer:
        'We offer market exclusivity in select packages. Contact our sales team for details specific to your region.',
  ),
  FAQ(
    question: 'We already have a call center / SDR team.',
    answer:
        'Setter AI complements your SDRs by handling initial qualification, allowing your team to focus on closing deals.',
  ),
  FAQ(
    question: 'Will it break our CRM / lead flow?',
    answer:
        'No, Setter AI integrates without disrupting your existing CRM or lead flow processes.',
  ),
  FAQ(
    question: 'We don’t want another tool to manage.',
    answer:
        'Setter AI is fully managed for you, requiring minimal oversight and no additional tool management.',
  ),
  FAQ(
    question: 'How do I embed the WhatsApp Link on my website?',
    answer:
        'We provide a simple embed code or plugin you can paste directly into your website for WhatsApp integration.',
  ),
  FAQ(
    question: 'How do I connect my lead forms?',
    answer:
        'You can connect your lead forms using Zapier, direct API, or supported CRM integrations.',
  ),
  FAQ(
    question: 'Which languages do you support?',
    answer:
        'Currently, Setter AI supports English, Spanish, French, German, and Portuguese.',
  ),
  FAQ(
    question: 'How much effort is required from my side?',
    answer:
        'Very little. We handle setup, training, and maintenance — you only need to share lead access.',
  ),
  FAQ(
    question: 'How do you charge?',
    answer:
        'We charge a flat monthly fee based on usage volume and feature requirements. Custom pricing is available.',
  ),
  FAQ(
    question: 'How reliable is the AI in achieving accurate results?',
    answer:
        'Our AI is trained on millions of sales conversations and maintains high accuracy through ongoing optimization.',
  ),
];

/// The FAQ block: the heading holds the left column on desktop, the accordion
/// the right, and everything stacks on smaller screens.
class FAQSectionWidget extends StatelessWidget {
  const FAQSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const heading = TitleText(
      text: 'Frequently asked\nquestions',
      textAlign: TextAlign.left,
    );

    final tiles = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < faqList.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s12),
          FAQTile(question: faqList[i].question, answer: faqList[i].answer),
        ],
      ],
    );

    return SectionContainer(
      color: AppColors.background,
      child: context.isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: heading,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxl),
                Expanded(flex: 7, child: tiles),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                heading,
                SizedBox(height: context.blockGap),
                tiles,
              ],
            ),
    );
  }
}

/// One expandable question. Fills the width it is given and toggles its answer
/// when the row is tapped.
///
/// The tile is a white card with a hairline; opening it firms the hairline and
/// lifts it with a soft shadow rather than repainting the whole row.
class FAQTile extends StatefulWidget {
  final String question;
  final String answer;

  const FAQTile({super.key, required this.question, required this.answer});

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool isExpanded = false;

  void _toggle() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.md);
    // Once the answer is showing, the tap target is only the top of the tile,
    // so its ink stops rounding off corners it no longer owns.
    final headerRadius = isExpanded
        ? const BorderRadius.vertical(top: Radius.circular(AppRadius.md))
        : borderRadius;
    final pad = context.cardPad;

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppCurves.standard,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadius,
        border: Border.all(
          color: isExpanded ? AppColors.borderStrong : AppColors.border,
        ),
        boxShadow: isExpanded ? AppShadows.soft : const <BoxShadow>[],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _toggle,
              borderRadius: headerRadius,
              // On a light page a hover is a warm wash, not a gold tint.
              hoverColor: AppColors.surfaceAlt,
              highlightColor: AppColors.surfaceMuted,
              splashColor: AppColors.surfaceMuted,
              child: Padding(
                padding: EdgeInsets.all(pad),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: AppText.title(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _ExpandIndicator(isExpanded: isExpanded),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: AppDurations.medium,
              curve: AppCurves.standard,
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(pad, 0, pad, pad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 1,
                            child: ColoredBox(color: AppColors.border),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            widget.answer,
                            style: AppText.body(context),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

/// The open/close affordance. The only gold in the section, and only once the
/// row is actually open — a pale gold badge with a readable [AppColors.primaryInk]
/// chevron, never the raw fill gold, which is unreadable at this size.
class _ExpandIndicator extends StatelessWidget {
  final bool isExpanded;

  const _ExpandIndicator({required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppCurves.standard,
      height: 36,
      width: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isExpanded ? AppColors.primarySoft : AppColors.surfaceAlt,
        border: Border.all(
          color: isExpanded ? AppColors.primaryLight : AppColors.border,
        ),
      ),
      child: AnimatedRotation(
        turns: isExpanded ? 0.5 : 0,
        duration: AppDurations.medium,
        curve: AppCurves.standard,
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 20,
          color: isExpanded ? AppColors.primaryInk : AppColors.textSecondary,
        ),
      ),
    );
  }
}
