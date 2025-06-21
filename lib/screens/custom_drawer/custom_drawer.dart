import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomEndDrawer extends StatefulWidget {
  const CustomEndDrawer({Key? key}) : super(key: key);

  @override
  State<CustomEndDrawer> createState() => _CustomEndDrawerState();
}

class _CustomEndDrawerState extends State<CustomEndDrawer> {
  bool isDropdownOpen = false;

  Widget _solutionsDropdownContainer() {
    return Container(
      height: 260,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDropdownItem(
              'Whatsapp AI Appointment Center', 'Reach 3 Billion Users.'),
          _buildDropdownItem(
              'Facebook Appointment Integration', 'Connect to Facebook Pages.'),
          _buildDropdownItem(
              'Google Business Booking', 'Appear on Google Search.'),
          _buildDropdownItem(
              'Website Booking Widget', 'Integrate on your own site.'),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D2130),
              )),
          Text(subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[600],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Solutions',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1D2130),
                          ),
                        ),
                        Icon(
                          isDropdownOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        isDropdownOpen = !isDropdownOpen; // toggle on tap
                      });
                    },
                  ),
                  // Remove MouseRegion if you want click-only toggle

                  // Show dropdown only when open
                  if (isDropdownOpen) _solutionsDropdownContainer(),

                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Enterprise',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1D2130),
                      ),
                    ),
                    onTap: () {},
                  ),

                  const SizedBox(height: 20),

                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Login',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1D2130),
                      ),
                    ),
                    onTap: () {},
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Container(
                      height: 48,
                      width: 160,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.arrow_forward,
                                color: Colors.white, size: 20.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
