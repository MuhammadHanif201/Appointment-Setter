import 'package:appointment_setter/screens/home_screen/home_screen.dart';
import 'package:appointment_setter/widgets/vedio_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSectionWidget extends StatelessWidget {
  const HeroSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: ShaderMask(
            shaderCallback: (bounds) => kPrimaryGradient
                .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: Text(
              'Reliable AI Sales Agents for Enterprise',
              style: GoogleFonts.inter(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Gap(32),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Scale Your Business\n",
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 60,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            children: [
              TextSpan(
                text: "Without Hiring.",
                style: GoogleFonts.inter(
                  color: const Color(0xFF6F2EFF),
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const Gap(16),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Follow up leads in 10 seconds - with 15-52% lead-to-booking rate.",
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 18,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Gap(48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 56,
              width: 196.05,
              decoration: BoxDecoration(
                color: const Color(0xFF6F2EFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Get Started",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20.8,
                        fontWeight: FontWeight.w700,
                        height: 1.1538,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 25.6),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Container(
              height: 60,
              width: 214.47,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF6F2EFF), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Book a demo",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6F2EFF),
                    fontSize: 20.8,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Gap(48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            text: TextSpan(
              text: "Industry leading teams replace",
              style: GoogleFonts.inter(
                  color: Colors.black, fontSize: 18, height: 1.5),
              children: [
                TextSpan(
                  text: " slow SDRs ",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: "with Setter AI",
                  style: GoogleFonts.inter(
                      color: Colors.black, fontSize: 18, height: 1.5),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Image.asset(
          "assets/images/company_logo.png",
          width: 812.25,
          height: 138.41,
        ),
        const Gap(70),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Case Study:",
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              height: 2.0,
            ),
            children: [
              TextSpan(
                text: " 352 high-ticket appointments per month.\n",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 2.0,
                ),
              ),
              TextSpan(
                text: "Without lifting a finger.",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  height: 2.0,
                ),
              ),
            ],
          ),
        ),
        const Gap(20),
        SizedBox(
          height: 506,
          width: 900,
          child: const YouTubePlayerWidget(
            videoId: 'ybcZQxpTrCs',
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
