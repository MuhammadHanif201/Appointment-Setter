import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';

class FacebookLeadAdsSection extends StatelessWidget {
  const FacebookLeadAdsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth < 479 ? 16.0 : 40.0;
    final maxContentWidth = 900.0;

    // Video width adapts to screen but max at 768
    final videoWidth = screenWidth * 0.8 > 768 ? 768.0 : screenWidth * 0.8;
    final videoHeight = videoWidth * (432.2 / 768); // maintain aspect ratio

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 26),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Use Case: How to Automate Facebook\nLead Ads - Full Tutorial",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth < 479 ? 28 : 43.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        "First message in 10 seconds after form submission.\nThen human-like setting conversion and booking into your calendar.\nThis is how we achieve up to ",
                    style: TextStyle(
                      fontSize: screenWidth < 479 ? 14 : 18,
                      height: 1.5,
                      color: Colors.black,
                    ),
                    children: const [
                      TextSpan(
                        text: "52% lead-to-booking rates.",
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth < 479 ? 40 : 64),
                SizedBox(
                  width: videoWidth,
                  height: videoHeight,
                  child: const YouTubePlayerWidget(videoId: 'ybcZQxpTrCs'),
                ),
                SizedBox(height: screenWidth < 479 ? 24 : 40),
                SizedBox(
                  width: screenWidth < 479 ? screenWidth * 0.7 : 225.27,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6f2eff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Add your demo action here
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Get me a demo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.8,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40), // extra bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
