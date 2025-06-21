import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeadConversionSection extends StatelessWidget {
  const LeadConversionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 479;
    // Dynamic paddings
    final horizontalPadding = isMobile ? 16.0 : 58.0;
    final verticalPadding = isMobile ? 40.0 : 120.0;
    // Font sizes responsive
    final headingFontSize = isMobile ? 24.0 : 43.2;
    final headingHeight = isMobile ? 1.3 : 1.2;
    final buttonFontSize = isMobile ? 16.0 : 20.8;
    final bigNumberFontSize = isMobile ? 80.0 : 180.0;
    final descriptionFontSize = isMobile ? 14.0 : 16.0;
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top section (heading + button)
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Setter AI is the\n",
                    style: GoogleFonts.inter(
                      fontSize: headingFontSize,
                      height: headingHeight,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "fastest",
                        style: GoogleFonts.inter(
                          fontSize: headingFontSize,
                          height: headingHeight,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6F2EFF),
                        ),
                      ),
                      TextSpan(
                        text:
                            " way to turn leads\n into sales calls for\n businesses.",
                        style: GoogleFonts.inter(
                          fontSize: headingFontSize,
                          height: headingHeight * 1.25,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 48,
                  width: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6F2EFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get Started",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.arrow_forward_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "10s",
                  style: GoogleFonts.inter(
                    fontSize: bigNumberFontSize,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                    color: const Color(0xFF6F2EFF),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Setter AI follow-up with your leads in just 10 seconds.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: descriptionFontSize,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left section: Heading + Button
                Flexible(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: "Setter AI is the\n",
                          style: GoogleFonts.inter(
                            fontSize: headingFontSize,
                            height: headingHeight,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "fastest",
                              style: GoogleFonts.inter(
                                fontSize: headingFontSize,
                                height: headingHeight,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6F2EFF),
                              ),
                            ),
                            TextSpan(
                              text:
                                  " way to turn leads\n into sales calls for\n businesses.",
                              style: GoogleFonts.inter(
                                fontSize: headingFontSize,
                                height: headingHeight * 1.25,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 56,
                        width: 196,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6F2EFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Get Started",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                size: 25,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                // Right section: Big number + description
                Flexible(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "10s",
                        style: GoogleFonts.inter(
                          fontSize: bigNumberFontSize,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          color: const Color(0xFF6F2EFF),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Setter AI follow-up with your leads in just 10 seconds.",
                        style: GoogleFonts.inter(
                          fontSize: descriptionFontSize,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
