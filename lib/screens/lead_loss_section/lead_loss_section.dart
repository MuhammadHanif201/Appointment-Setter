import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeadLossSection extends StatelessWidget {
  const LeadLossSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 479;

    final horizontalMargin = isMobile ? 16.0 : 40.0;
    final horizontalPadding = isMobile ? 16.0 : 40.0;
    final verticalPadding = isMobile ? 40.0 : 96.0;

    final headingFontSize = isMobile ? 28.0 : 43.2;
    final subHeadingFontSize = isMobile ? 16.0 : 18.0;
    final videoWidth = isMobile ? screenWidth * 0.9 : 768.0;
    final videoHeight =
        isMobile ? (videoWidth * 9) / 16 : 432.2; // Maintain 16:9 aspect ratio

    final buttonWidth = isMobile ? 180.0 : 225.27;
    final buttonHeight = 56.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Stop losing hot leads.",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: headingFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Follow-up every lead ",
                style: GoogleFonts.inter(
                  fontSize: headingFontSize,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "in 10 seconds.",
                    style: GoogleFonts.inter(
                      fontSize: headingFontSize,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6F2EFF),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 8 : 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    "First message in 10 seconds after form submission.\nThen human-like setting conversion and booking into your calendar.\nThis is how we achieve up to ",
                style: GoogleFonts.inter(
                  fontSize: subHeadingFontSize,
                  height: 1.5,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "52% lead-to-booking rates.",
                    style: GoogleFonts.inter(
                      fontSize: subHeadingFontSize,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 32 : 64),
            SizedBox(
              height: videoHeight,
              width: videoWidth,
              child: const YouTubePlayerWidget(
                videoId: 'ybcZQxpTrCs',
              ),
            ),
            SizedBox(height: isMobile ? 20 : 30),
            Container(
              height: buttonHeight,
              width: buttonWidth,
              decoration: BoxDecoration(
                color: const Color(0xFF6F2EFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Get me a demo",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 20.8,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: isMobile ? 6 : 8),
                    const Icon(
                      Icons.arrow_forward_outlined,
                      size: 25,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
