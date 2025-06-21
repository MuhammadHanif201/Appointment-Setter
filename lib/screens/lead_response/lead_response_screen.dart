import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeadResponseSection extends StatelessWidget {
  const LeadResponseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Breakpoints
        final isMobile = width < 479;
        final isTablet = width >= 479 && width < 768;
        final isDesktop = width >= 769;

        // Responsive paddings
        final horizontalPadding = isMobile
            ? 20.0
            : isTablet
                ? 40.0
                : 57.594;

        final verticalPadding = isMobile
            ? 40.0
            : isTablet
                ? 80.0
                : 120.0;

        // Responsive font sizes
        final titleFontSize = isMobile
            ? 28.8
            : isTablet
                ? 43.2
                : 43.2;

        final subtitleFontSize = isMobile
            ? 18.0
            : isTablet
                ? 18.0
                : 18.0;

        final containerHeight = isMobile ? null : 419.0;

        final sizedBoxHeight = isMobile ? 12.0 : 20.0;

        return Container(
          height: containerHeight,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xfff0f0f0)),
          child: Padding(
            padding: EdgeInsets.only(
              top: verticalPadding,
              bottom: verticalPadding,
              right: horizontalPadding,
              left: horizontalPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Hiring More SDRs Won’t Fix\n a ",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: "Broken Lead Response.",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6F2EFF),
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sizedBoxHeight),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Automate first contact in under ",
                    style: GoogleFonts.inter(
                      fontSize: subtitleFontSize,
                      color: Colors.black,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: " 10 seconds",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text:
                            " - and convert up to 52%\n of your leads into meetings - without expanding your sales team.",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: subtitleFontSize,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
