import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        // Define device breakpoints
        bool isDesktop = maxWidth >= 1024;
        bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        bool isMobile = maxWidth < 600;

        return Container(
          color: const Color(0xFF1E1E2F),
          padding: const EdgeInsets.only(top: 40, bottom: 40),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section
              Wrap(
                spacing: 32,
                runSpacing: 32,
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                children: [
                  _buildLinkColumn('Links', [
                    'Book demo',
                    'Blog',
                    'Login',
                    'Help',
                    'Affiliate Program',
                    'Manage Subscription',
                  ]),
                  _buildLinkColumn('Solutions', [
                    'WhatsApp Appointment Setter',
                    'WhatsApp Reminder Software',
                    'Calendly Booking API',
                    'WhatsApp API',
                    'AI Sales Agent',
                  ]),
                  _buildLinkColumn('Free Tools', [
                    'Free Sales Tools',
                    'Appointment Setting Script Generator',
                    'WhatsApp Appointment Setting Script Generator',
                    'WhatsApp Link Generator',
                    'WhatsApp Button Generator',
                  ]),
                  Gap(40),
                  _buildEmailSubscribeColumn(),
                ],
              ),

              const SizedBox(height: 40),

              // Legal & Industry Section
              Wrap(
                spacing: 122,
                runSpacing: 24,
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                children: [
                  _buildLinkColumn('Legal', [
                    'Privacy Policy',
                    'Terms and Conditions',
                  ]),
                  _buildLinkColumn('Industries', ['Solar']),
                ],
              ),

              const SizedBox(height: 30),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        if (!isMobile)
                          Container(
                            margin: const EdgeInsets.only(left: 32, right: 32),
                            child: Row(
                              children: [
                                const Text(
                                  "Setter AI LLC",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 40),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: FaIcon(
                                    FontAwesomeIcons.youtube,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: FaIcon(
                                    FontAwesomeIcons.facebook,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: FaIcon(
                                    FontAwesomeIcons.twitter,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: FaIcon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: FaIcon(
                                    FontAwesomeIcons.linkedin,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Expanded(
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (isMobile)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Text("Setter AI LLC",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.youtube,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.twitter,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.instagram,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLinkColumn(String title, List<String> links) {
    return SizedBox(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
            const SizedBox(height: 12),
            for (var link in links)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  link,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSubscribeColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logos
            Row(
              children: [
                Image.asset('assets/images/setter_ai.png',
                    width: 144, height: 48),
                const SizedBox(width: 16),
                Image.asset('assets/images/meta.png', width: 85.33, height: 48),
              ],
            ),
            const SizedBox(height: 64),

            // Email Field
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D40),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your Email',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 56,
                    width: 151,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Subscribe",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
            SvgPicture.asset(
              'assets/images/featured.svg',
              width: 250,
              height: 54,
            ),
          ],
        ),
      ),
    );
  }
}
