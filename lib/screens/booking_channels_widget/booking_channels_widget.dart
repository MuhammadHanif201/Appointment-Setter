import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookingChannelsSection extends StatelessWidget {
  const BookingChannelsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final maxContentWidth = screenWidth > 1000 ? 1000.0 : screenWidth * 0.95;

    final iconSize = screenWidth < 479 ? 28.0 : 36.0;

    final titleFontSize = screenWidth < 479 ? 24.0 : 40.0;

    return Container(
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenWidth < 479 ? 40 : 96,
              horizontal: screenWidth < 479 ? 16 : 0,
            ),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Book More Meetings with Conversational AI.',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenWidth < 479 ? 24 : 40),
                Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: [
                    buildItem(
                      icon: FontAwesomeIcons.whatsapp,
                      iconColor: Colors.black,
                      title: 'WhatsApp',
                      description:
                          'Use WhatsApp to turn leads into meetings – on autopilot. Connect WhatsApp Business in just 5 clicks.',
                      actionText: 'Learn more',
                      iconSize: iconSize,
                      maxWidth: screenWidth < 479 ? screenWidth * 0.9 : 300,
                    ),
                    buildItem(
                      icon: FontAwesomeIcons.sms,
                      iconColor: Colors.black,
                      title: 'Text',
                      description:
                          'Automate lead response via SMS. Turn texts into booked appointments effortlessly using conversational booking.',
                      actionText: 'Learn more',
                      iconSize: iconSize,
                      maxWidth: screenWidth < 479 ? screenWidth * 0.9 : 300,
                    ),
                    buildItem(
                      icon: FontAwesomeIcons.star,
                      iconColor: Colors.black,
                      title: 'Website Embed',
                      description:
                          'Add a lead generation chatbot on your website. Respond to every lead in seconds and book more meetings.',
                      actionText: 'Learn more',
                      iconSize: iconSize,
                      maxWidth: screenWidth < 479 ? screenWidth * 0.9 : 300,
                    ),
                    buildItem(
                      icon: FontAwesomeIcons.facebookMessenger,
                      iconColor: Colors.black,
                      title: 'Facebook Messenger',
                      description:
                          'Automate conversations on Facebook Messenger. Run click-to-messenger ads and book more meetings.',
                      actionText: 'Learn more',
                      iconSize: iconSize,
                      maxWidth: screenWidth < 479 ? screenWidth * 0.9 : 300,
                    ),
                    buildItem(
                      icon: FontAwesomeIcons.instagram,
                      iconColor: Colors.black,
                      title: 'Instagram',
                      description:
                          'Automate lead generation on Instagram: turn comments, replies, and DMs into booked appointments instantly!',
                      actionText: 'Learn more',
                      iconSize: iconSize,
                      maxWidth: screenWidth < 479 ? screenWidth * 0.9 : 300,
                    ),
                    buildItem(
                      icon: FontAwesomeIcons.linkedin,
                      iconColor: Colors.black,
                      title: 'LinkedIn',
                      description:
                          'Automate lead generation on LinkedIn: Turn comments, messages, and connections into booked meetings with AI.',
                      actionText: 'Learn more',
                      iconSize: iconSize,
                      maxWidth: screenWidth < 479 ? screenWidth * 0.9 : 300,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String actionText,
    required double iconSize,
    required double maxWidth,
  }) {
    return SizedBox(
      width: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: iconSize),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 16, height: 1.3),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                actionText,
                style: TextStyle(
                  fontSize: 16,
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                FontAwesomeIcons.arrowRight,
                color: iconColor,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
