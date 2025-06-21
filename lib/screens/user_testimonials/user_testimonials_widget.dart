import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserTestimonialsSection extends StatelessWidget {
  const UserTestimonialsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth < 479 ? 16.0 : 40.0;
    final cardMaxWidth = 768.0;
    final cardWidth =
        screenWidth < cardMaxWidth ? screenWidth * 0.9 : cardMaxWidth;

    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "What our users say",
              style: TextStyle(
                fontSize: screenWidth < 479 ? 28 : 40,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _testimonialCard(
                  text:
                      "\"I LOVE it, it's working perfectly!\nOur business generates 30,000 leads per month, which we previously had to reach out manually. Thanks to Setter AI, we now wake up every day to find new meetings seamlessly booked into my calendar. I would gladly pay \$1,000 per day for Setter AI as we scale our operations.\"",
                  imagePath: "assets/images/carlos.jpg",
                  name: "Carlos de Ory",
                  company: "Eco Beach City (Real Estate)",
                  width: cardWidth,
                  minHeight: 300,
                ),
                const Gap(20),
                _testimonialCard(
                  text: "\"Wow, this is good!\"",
                  imagePath: "assets/images/jack.jpg",
                  name: "Jake Rogers",
                  company: "Case Matrix (Legal)",
                  width: cardWidth,
                  minHeight: 250,
                ),
                const Gap(20),
                _testimonialCard(
                  text:
                      "\"Great product - much needed in the market, nothing worse than a 42 hour lead response time!\"",
                  imagePath: "assets/images/daniell.jpg",
                  name: "Matt Daniell",
                  company: "Solar",
                  width: cardWidth,
                  minHeight: 270,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _testimonialCard({
    required String text,
    required String imagePath,
    required String name,
    required String company,
    required double width,
    required double minHeight,
  }) {
    return Container(
      width: width, // Set exact width instead of maxWidth
      constraints: BoxConstraints(
        minHeight: minHeight,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF6199ED)),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              height: 1.5,
            ),
          ),
          Text(
            company,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
