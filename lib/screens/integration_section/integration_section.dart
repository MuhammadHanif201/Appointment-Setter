import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SvgPicture ke liye
import 'package:gap/gap.dart'; // Gap ke liye

class IntegrationSection extends StatelessWidget {
  const IntegrationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 479;
        final isTablet = width >= 479 && width < 768;
        final isDesktop = width >= 769;

        final metaHeight = isMobile ? 40.0 : 63.0;
        final metaWidth = isMobile ? 70.0 : 110.0;

        final iconHeights =
            isMobile ? [40.0, 40.0, 30.0, 30.0] : [64.0, 84.0, 90.0, 20.0];
        final iconWidths =
            isMobile ? [65.0, 65.0, 90.0, 90.0] : [20.0, 114.0, 90.0, 20.0];

        final verticalSpacing = isMobile ? 24.0 : 48.0;
        final textFontSize = isMobile ? 14.0 : 18.0;
        final gapBetweenIcons = isMobile ? 24.0 : 20.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: verticalSpacing, horizontal: isMobile ? 16 : 40),
          child: Column(
            children: [
              Image.asset(
                "assets/images/meta.png",
                height: metaHeight,
                width: metaWidth,
              ),
              SizedBox(height: verticalSpacing),
              Text(
                "Integrates seamlessly into your sales flow",
                style: GoogleFonts.inter(
                  fontSize: textFontSize,
                  height: 1.5,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: verticalSpacing),

              // **Mobile mein Column, Tablet/Desktop mein Row**
              if (isMobile)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/zapier.svg',
                      width: iconWidths[0],
                      height: iconHeights[0],
                    ),
                    SizedBox(height: gapBetweenIcons),
                    Image.asset(
                      "assets/images/calender.png",
                      width: iconWidths[1],
                      height: iconHeights[1],
                    ),
                    SizedBox(height: gapBetweenIcons),
                    Image.asset(
                      "assets/images/calendy.png",
                      width: iconWidths[2],
                      height: iconHeights[2],
                    ),
                    SizedBox(height: gapBetweenIcons),
                    SvgPicture.asset(
                      'assets/images/acuity.svg',
                      width: iconWidths[3],
                      height: iconHeights[3],
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/zapier.svg',
                      width: iconWidths[0],
                      height: iconHeights[0],
                    ),
                    SizedBox(width: gapBetweenIcons),
                    Image.asset(
                      "assets/images/calender.png",
                      width: iconWidths[1],
                      height: iconHeights[1],
                    ),
                    SizedBox(width: gapBetweenIcons),
                    Image.asset(
                      "assets/images/calendy.png",
                      width: iconWidths[2],
                      height: iconHeights[2],
                    ),
                    SizedBox(width: gapBetweenIcons),
                    SvgPicture.asset(
                      'assets/images/acuity.svg',
                      width: iconWidths[3],
                      height: iconHeights[3],
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
