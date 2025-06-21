import 'package:appointment_setter/model/faq_model.dart';
import 'package:appointment_setter/screens/ai_agent_screen/ai_agent_screen.dart';
import 'package:appointment_setter/screens/booking_channels_widget/booking_channels_widget.dart';
import 'package:appointment_setter/screens/custom_drawer/custom_drawer.dart';
import 'package:appointment_setter/screens/facebook_leadAds/facebook_leadAds_widget.dart';
import 'package:appointment_setter/screens/faq_section/faq_section.dart';
import 'package:appointment_setter/screens/footer/footer.dart';
import 'package:appointment_setter/screens/header/header_widget.dart';
import 'package:appointment_setter/screens/integration_section/integration_section.dart';
import 'package:appointment_setter/screens/lead_conversion_section/lead_conversion_section.dart';
import 'package:appointment_setter/screens/lead_loss_section/lead_loss_section.dart';
import 'package:appointment_setter/screens/lead_response/lead_response_screen.dart';
import 'package:appointment_setter/screens/outbound_whatsApp_demo/outbound_whatsApp_demo.dart';
import 'package:appointment_setter/screens/sales_meeting_calculator/sales_meeting_calculator.dart';
import 'package:appointment_setter/screens/setter_ai_setup_section/setter_ai_setup_section.dart';
import 'package:appointment_setter/screens/setter_ai_video_section/setter_ai_video_section.dart';
import 'package:appointment_setter/screens/setter_steps_widget/setter_steps_widget.dart';
import 'package:appointment_setter/screens/testimonial_card/testimonial_card.dart';
import 'package:appointment_setter/screens/user_testimonials/user_testimonials_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const LinearGradient kPrimaryGradient = LinearGradient(
  colors: [
    Color(0xFF4D5BF3),
    Color(0xFF19CFFB),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      endDrawer: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Container(
              height: 300,
              width: double.infinity,
              color: Colors.yellow,
              child: const CustomEndDrawer(),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  HeaderNavBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 60),
                          child: AiAgentSection(),
                        ),
                      ],
                    ),
                  ),
                  Gap(40),
                  LeadResponseSection(),
                  SalesMeetingCalculatorSection(),
                  IntegrationSection(),
                  TestimonialCard(),
                  LeadConversionSection(),
                  SetterAIVideoSection(),
                  SetterAISetupSection(),
                  LeadLossSection(),
                  OutboundWhatsAppDemo(),
                  SetterStepsSection (),
                  BookingChannelsSection(),
                  FacebookLeadAdsSection(),
                  UserTestimonialsSection(),
                  FAQSectionWidget(),
                  FooterSection(),
                ],
              ),
            ),
          ),

          // WhatsApp Chat Button
          Positioned(
            bottom: 35,
            right: 40,
            child: Container(
              height: 50,
              width: 210.08,
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextButton(
                onPressed: () {
                  // Chat action
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Chat with Megan (AI)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
