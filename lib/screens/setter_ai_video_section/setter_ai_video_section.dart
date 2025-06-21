import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetterAIVideoSection extends StatelessWidget {
  const SetterAIVideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 479;

    final horizontalPadding = isMobile ? 16.0 : 58.0;
    final verticalPadding = isMobile ? 40.0 : 120.0;

    final videoWidth = isMobile ? screenWidth * 0.9 : 400.0;
    final videoHeight = videoWidth * 9 / 16; // Maintain 16:9 aspect ratio

    final headingFontSize = isMobile ? 24.0 : 43.2;
    final headingHeight = 1.2;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: isMobile
          ?
      Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: videoWidth,
                  height: videoHeight,
                  child: YouTubePlayerWidget(
                    videoId: 'ybcZQxpTrCs',
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Setter AI requires ",
                    style: GoogleFonts.inter(
                      fontSize: headingFontSize,
                      height: headingHeight,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "zero change\n",
                        style: GoogleFonts.inter(
                          fontSize: headingFontSize,
                          height: headingHeight,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6F2EFF),
                        ),
                      ),
                      TextSpan(
                        text: "to your business.",
                        style: GoogleFonts.inter(
                          fontSize: headingFontSize,
                          height: headingHeight,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: videoWidth,
                  height: 500,
                  child: YouTubePlayerWidget(
                    videoId: 'ybcZQxpTrCs',
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: "Setter AI requires ",
                      style: GoogleFonts.inter(
                        fontSize: headingFontSize,
                        height: headingHeight,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "zero change\n",
                          style: GoogleFonts.inter(
                            fontSize: headingFontSize,
                            height: headingHeight,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6F2EFF),
                          ),
                        ),
                        TextSpan(
                          text: "to your business.",
                          style: GoogleFonts.inter(
                            fontSize: headingFontSize,
                            height: headingHeight,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
