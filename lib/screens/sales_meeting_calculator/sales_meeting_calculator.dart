import 'package:appointment_setter/widgets/setter_calculator_ai_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalesMeetingCalculatorSection extends StatelessWidget {
  const SalesMeetingCalculatorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 479;
        final isTablet = width >= 479 && width < 768;
        final isDesktop = width >= 769;

        // Responsive margins and paddings
        final horizontalMargin = isMobile
            ? 16.0
            : isTablet
                ? 24.0
                : 40.0;
        final horizontalPadding = isMobile
            ? 16.0
            : isTablet
                ? 24.0
                : 40.0;
        final verticalPadding = isMobile
            ? 24.0
            : isTablet
                ? 48.0
                : 96.0;

        // Responsive font sizes
        final titleFontSize = isMobile
            ? 24.0
            : isTablet
                ? 36.0
                : 40.0;
        final subtitleFontSize = isMobile ? 14.0 : 18.0;
        final subtitleBoldFontSize = isMobile ? 15.0 : 19.0;
        final buttonFontSize = isMobile ? 16.0 : 20.8;
        final buttonHeight = isMobile ? 48.0 : 56.0;
        final buttonWidth = isMobile ? 180.0 : 236.77;

        // Spacing
        final gap16 = isMobile ? 8.0 : 16.0;
        final gap10 = isMobile ? 6.0 : 10.0;
        final gap32 = isMobile ? 20.0 : 32.0;

        return SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "How Many Sales Meetings Are You\n Leaving on the Table?",
                        style: GoogleFonts.inter(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: gap16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Use the calculator below to see what ",
                        style: GoogleFonts.inter(
                          fontSize: subtitleFontSize,
                          height: 1.5,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "slow lead follow-up ",
                            style: GoogleFonts.inter(
                              fontSize: subtitleBoldFontSize,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                "is costing you - and how fast\n you could grow with Setter AI.",
                            style: GoogleFonts.inter(
                              fontSize: subtitleBoldFontSize,
                              height: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: gap10),
                    const SetterAICalculatorWidget(),
                    SizedBox(height: gap32),
                    Container(
                      height: buttonHeight,
                      width: buttonWidth,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6F2EFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "GO live for 7 days",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: buttonFontSize,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.arrow_forward_outlined,
                            color: Colors.white,
                            size: 25.6,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
