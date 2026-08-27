import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:appointment_setter/widgets/user_testimonial_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// The customer quote grid: one column on a phone, two on a tablet and three
/// on desktop, where the cards are stretched to a common height so the
/// attributions line up.
///
/// The band is the warm off-white so the white cards read as cards; the
/// sections either side of it are plain white.
class UserTestimonialsSection extends StatelessWidget {
  const UserTestimonialsSection({super.key});

  static const List<_Testimonial> _testimonials = [
    _Testimonial(
      quote:
          "\"I LOVE it, it's working perfectly!\nOur business generates 30,000 leads per month, which we previously had to reach out manually. Thanks to Setter AI, we now wake up every day to find new meetings seamlessly booked into my calendar. I would gladly pay \$1,000 per day for Setter AI as we scale our operations.\"",
      imagePath: "assets/images/carlos.jpg",
      name: "Carlos de Ory",
      company: "Eco Beach City (Real Estate)",
    ),
    _Testimonial(
      quote: "\"Wow, this is good!\"",
      imagePath: "assets/images/jack.jpg",
      name: "Jake Rogers",
      company: "Case Matrix (Legal)",
    ),
    _Testimonial(
      quote:
          "\"Great product - much needed in the market, nothing worse than a 42 hour lead response time!\"",
      imagePath: "assets/images/daniell.jpg",
      name: "Matt Daniell",
      company: "Solar",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      color: AppColors.surfaceAlt,
      child: Column(
        children: [
          const TitleText(text: "What our users say"),
          Gap(context.blockGap),
          if (context.isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < _testimonials.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.lg),
                    Expanded(child: _card(_testimonials[i])),
                  ],
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                const gap = AppSpacing.lg;
                final columns = context.responsive(mobile: 1, tablet: 2);
                final cardWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final testimonial in _testimonials)
                      SizedBox(width: cardWidth, child: _card(testimonial)),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _card(_Testimonial testimonial) => UserTestimonialCard(
        quote: testimonial.quote,
        userName: testimonial.name,
        userTitle: testimonial.company,
        imagePath: testimonial.imagePath,
      );
}

/// The copy behind one card in the grid.
class _Testimonial {
  final String quote;
  final String imagePath;
  final String name;
  final String company;

  const _Testimonial({
    required this.quote,
    required this.imagePath,
    required this.name,
    required this.company,
  });
}
