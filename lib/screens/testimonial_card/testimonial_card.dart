import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestimonialCard extends StatelessWidget {
  const TestimonialCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen width le lo
    final screenWidth = MediaQuery.of(context).size.width;

    // Side padding: Mobile pe zyada (16), bada screen pe kam (40)
    final horizontalPadding = screenWidth < 479 ? 16.0 : 40.0;

    // Card max width rakhna responsive layout ke liye
    final cardMaxWidth = 768.0;

    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: cardMaxWidth,
          ),
          child:
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '"I LOVE it, it\'s working perfectly!\nOur business generates 30,000 leads per month, which we previously had to reach out manually. Thanks to Setter AI, we now wake up every day to find new meetings seamlessly booked into my calendar. I would gladly pay \$1,000 per day for Setter AI as we scale our operations."',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/carlos.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Carlos de Ory",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    height: 1.5,
                  ),
                ),
                Text(
                  "Eco Beach City (Real Estate)",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.5,
                    color: const Color(0xFF1D2130),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
