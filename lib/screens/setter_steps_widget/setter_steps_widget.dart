import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetterStepsSection extends StatelessWidget {
  const SetterStepsSection ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Breakpoint to switch between layouts
    const breakpoint = 800;

    // Common padding for all sides, adaptable if you want
    final horizontalPadding = screenWidth > breakpoint ? 58.0 : 16.0;
    final verticalPadding = screenWidth > breakpoint ? 120.0 : 30.0;

    if (screenWidth > breakpoint) {
      // Wide layout with two columns
      return Container(
        height: 1076,
        width: double.infinity,
        color: const Color(0xfff0f0f0),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child:
        Row(
          children: [
            // Left side text
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                // padding: const EdgeInsets.all(24),
                child: Text(
                  "Here’s how Setter AI books\nYOU more meetings in 3\nsimple steps.",
                  style: GoogleFonts.inter(
                    fontSize: 43.2,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 40),

            // Right side scrollable steps
            Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStepCard(
                            width: 450,
                            title: "Step 1: Instant Response (10 Seconds)",
                            description:
                                "Your lead gets a message in under 10 seconds. No\n delays. No drop-off.",
                          ),
                          const SizedBox(height: 20),
                          _buildStepCard(
                            width: 450,
                            title: "Step 2: Automated Follow-Ups",
                            description:
                                "Your AI agent keeps following up – until the lead\n replies or books.",
                          ),
                          const SizedBox(height: 20),
                          _buildStepCard(
                            width: 450,
                            titlePrefix: "Step 3: ",
                            titleHighlight: "Conversational Booking",
                            description:
                                "The lead books directly *inside the chat*. No forms.\n No friction.",
                            highlightColor: const Color(0xFF6f2eff),
                          ),
                          const SizedBox(height: 20),
                          _buildStepCard(
                            width: 450,
                            title: "Step 4: Meeting Reminders",
                            description:
                                "Automatic reminders on text/WhatsApp to reduce\n no-shows and boost your show-up rate.",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      // Narrow layout (mobile): single column scrollable
      return Container(
        width: double.infinity,
        color: const Color(0xfff0f0f0),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top title
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  "Here’s how Setter AI books YOU more meetings in 3 simple steps.",
                  style: GoogleFonts.inter(
                    fontSize: 32, // smaller font for smaller screens
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
              ),

              // Step cards full width with margin between
              _buildStepCard(
                width: double.infinity,
                title: "Step 1: Instant Response (10 Seconds)",
                description:
                    "Your lead gets a message in under 10 seconds. No delays. No drop-off.",
              ),
              const SizedBox(height: 20),
              _buildStepCard(
                width: double.infinity,
                title: "Step 2: Automated Follow-Ups",
                description:
                    "Your AI agent keeps following up – until the lead replies or books.",
              ),
              const SizedBox(height: 20),
              _buildStepCard(
                width: double.infinity,
                titlePrefix: "Step 3: ",
                titleHighlight: "Conversational Booking",
                description:
                    "The lead books directly *inside the chat*. No forms. No friction.",
                highlightColor: const Color(0xFF6f2eff),
              ),
              const SizedBox(height: 20),
              _buildStepCard(
                width: double.infinity,
                title: "Step 4: Meeting Reminders",
                description:
                    "Automatic reminders on text/WhatsApp to reduce no-shows and boost your show-up rate.",
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildStepCard({
    required double width,
    String? title,
    String? titlePrefix,
    String? titleHighlight,
    required String description,
    Color? highlightColor,
  }) {
    final bool hasHighlight = titleHighlight != null && titlePrefix != null;

    return Container(
      width: width == double.infinity ? null : width,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 30, right: 10, top: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasHighlight)
            Wrap(
              children: [
                Text(
                  titlePrefix!,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 1.5,
                  ),
                ),
                Text(
                  titleHighlight!,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 1.5,
                    color: highlightColor ?? Colors.black,
                  ),
                ),
              ],
            )
          else if (title != null)
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 1.5,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
