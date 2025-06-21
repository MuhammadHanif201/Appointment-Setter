import 'package:appointment_setter/model/faq_model.dart';
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

class FAQSectionWidget extends StatelessWidget {
  const FAQSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 479 ? 16.0 : 40.0;
    final isSmallScreen = screenWidth < 800;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF0F0F0),
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frequently asked\nquestions',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...faqList
                        .map((faq) => FAQTile(
                              question: faq.question,
                              answer: faq.answer,
                            ))
                        .toList(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Frequently asked\nquestions',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: faqList
                            .map((faq) => FAQTile(
                                  question: faq.question,
                                  answer: faq.answer,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class FAQTile extends StatefulWidget {
  final String question;
  final String answer;

  const FAQTile({super.key, required this.question, required this.answer});

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 479
        ? screenWidth - 32
        : screenWidth < 700
            ? screenWidth * 0.9
            : 672.0;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.remove : Icons.add,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ],
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.answer,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }
}
