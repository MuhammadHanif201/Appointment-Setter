import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class OutboundWhatsAppDemo extends StatelessWidget {
  const OutboundWhatsAppDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 479;

    final horizontalMargin = isMobile ? 16.0 : 168.0;
    final horizontalPadding = isMobile ? 16.0 : 40.0;
    final topPadding = isMobile ? 40.0 : 90.0;

    final headingFontSize = isMobile ? 28.0 : 43.2;
    final formWidth = isMobile ? screenWidth * 0.9 : 576.0;
    final formHeight = isMobile ? null : 536.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: horizontalPadding, right: horizontalPadding, top: topPadding),
        child:
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Try The Outbound\n WhatsApp Demo Below",
                style: GoogleFonts.inter(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              height: formHeight,
              width: formWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  // Added scrolling for small height devices
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Receive an ",
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 18 : 24,
                            height: 1.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "instant-follow-up ",
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 18 : 24,
                                height: 1.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6f2eff),
                              ),
                            ),
                            TextSpan(
                              text: "from our AI Setter",
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 18 : 24,
                                height: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Enter your Name",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.2),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.2),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Enter your Email (only work email)",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.2),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.2),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Enter your WhatsApp Phone Number",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter your number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.2),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.2),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6f2eff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Add your button onPressed logic here
                          },
                          child: Text(
                            "Chat with Setter AI",
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 16 : 19.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap(40),
          ],
        ),
      ),
    );
  }
}
