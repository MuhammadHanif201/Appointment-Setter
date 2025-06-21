import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetterAISetupSection extends StatelessWidget {
  const SetterAISetupSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 479;

    final horizontalPadding = isMobile ? 16.0 : 58.0;
    final verticalPadding = isMobile ? 40.0 : 120.0;
    final fontSize = isMobile ? 24.0 : 43.2;
    final lineHeight = 1.2;

    return Container(
      width: double.infinity,
      color: const Color(0xfff0f0f0),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "We setup you up.\nYour response time drops to 10 seconds.\nYour booking rate skyrockets.\nYour team talks only to real buyers.\nYour business grows without more hires.",
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              height: lineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
