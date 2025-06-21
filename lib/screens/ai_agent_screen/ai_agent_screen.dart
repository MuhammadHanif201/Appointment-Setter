import 'package:appointment_setter/auth_controller/auth_controller.dart';
import 'package:appointment_setter/screens/call_screen/call_screen.dart';
import 'package:appointment_setter/services/livekit_service.dart';
import 'package:appointment_setter/services/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class AiAgentSection extends StatefulWidget {
  const AiAgentSection({super.key});

  @override
  State<AiAgentSection> createState() => _AiAgentSectionState();
}

class _AiAgentSectionState extends State<AiAgentSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String _activeAgent = 'ERIC';
  String _selectedLabel = 'Doctor';

  bool _visible = true;

  final AuthController authController = Get.put(AuthController());

  final Map<String, List<Color>> agentGradients = {
    'JESSICA': [Colors.pinkAccent, Colors.orange, Colors.pink],
    'LILY': [Colors.purple, Colors.pinkAccent, Colors.amber],
    'ERIC': [Color(0xFFFFD700), Color(0xFF8B6000), Colors.yellow],
  };

  final List<String> labels = [
    "Doctor",
    "Restaurant",
    "Real Estate",
    "Bus Ticket",
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAgentTap(String agentName) {
    setState(() {
      _activeAgent = agentName;
      _visible = false;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _visible = true;
      });
    });
  }

  void _onLabelTap(String label) {
    setState(() {
      _selectedLabel = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeGradient = agentGradients[_activeAgent]!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 479;

    return Container(
      height: isMobile ? null : 422,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 0, right: 20, left: 20),
      child: isMobile
          ? _buildMobileLayout(activeGradient)
          : _buildDesktopLayout(activeGradient),
    );
  }

  Widget _buildMobileLayout(List<Color> activeGradient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          children: [
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: Icon(Icons.star)),
            const Gap(10),
            Expanded(
              child: Text(
                "Conversational AI",
                style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
          ],
        ),
        const Gap(20),

        // Title and Description
        Text(
          "Build AI Agents that speak",
          style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none),
        ),
        const SizedBox(height: 10),
        Text(
          "Add voice to your agents on web, mobile or telephony in minutes. Our realtime API delivers low latency, full configurability, and seamless scalability.",
          style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 16,
              height: 1.5,
              decoration: TextDecoration.none),
        ),
        const SizedBox(height: 20),

        // Buttons
        Column(
          children: [
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  "GET STARTED FREE",
                  style: const TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text(
                  "CONTACT SALES",
                  style: const TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        // Animated Circle with Try Call Button
        Center(
          child: SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: activeGradient,
                              stops: const [0.0, 0.6, 1.0],
                              transform: const GradientRotation(pi / 2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 48,
                  width: 151,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        print("🔍 Getting AuthController...");
                        final authController = Get.find<AuthController>();

                        print("🎯 Requesting token with:");
                        print("👉 selectedLabel: $_selectedLabel");
                        print("👉 selectedAgent: $_activeAgent");

                        final token = await authController.getLiveKitToken(
                          selectedLabel: _selectedLabel,
                          selectedAgent: _activeAgent,
                        );

                        print("🪪 Token received: $token");

                        if (token == null) {
                          print('❌ Failed to get token');
                          return;
                        }
                        // print("⏳ Waiting for 5 seconds before connecting to room...");
                        // await Future.delayed(Duration(seconds: 5));

  print("🔌 Connecting to LiveKit room...");
  final room = await LiveKitService.connectToRoom(
    url: 'wss://appointmentsetter-7p2s97kw.livekit.cloud',
    token: token,
  );

                        print("🎙️ Enabling microphone...");
                        await room.localParticipant?.setMicrophoneEnabled(true);

                        print("✅ Navigating to CallScreen with agent: $_activeAgent");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CallScreen(
                              room: room,
                              selectedAgentName: _activeAgent,
                            ),
                          ),
                        );
                      } catch (e) {
                        print('❌ Error connecting to room: $e');
                      }
                    },
                    icon: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child:
                          const Icon(Icons.graphic_eq, color: Colors.white54),
                    ),
                    label: const Text(
                      "TRY A CALL",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Labels and Agents in Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Labels Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...labels.map((label) {
                    final isActive = label == _selectedLabel;
                    return GestureDetector(
                      onTap: () => _onLabelTap(label),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: isActive
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              )
                            : Text(
                                label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: Colors.black,
                                  height: 2.0,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // Agents Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Agents",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...agentGradients.keys.map((name) {
                    final isActive = _activeAgent == name;
                    final gradientColors = agentGradients[name]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: GestureDetector(
                        onTap: () => _onAgentTap(name),
                        child: isActive
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: gradientColors,
                                          center: Alignment.center,
                                          radius: 0.8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  height: 2.0,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDesktopLayout(List<Color> activeGradient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: Icon(Icons.star)),
            const Gap(10),
            Text(
              "Conversational AI",
              style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
          ],
        ),
        const Gap(10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT SIDE
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Build AI Agents that speak",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Add voice to your agents on web, mobile or telephony in\n minutes. Our realtime API delivers low latency, full\n configurability, and seamless scalability.",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 18,
                            height: 1.5,
                            decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 161,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                "GET STARTED FREE",
                                style: const TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 40,
                            width: 161,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                "CONTACT SALES",
                                style: const TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // RIGHT SIDE
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    height: 422,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        // Center Circular Animated Container with fade animation
                        Center(
                          child: SizedBox(
                            width: 280,
                            height: 280,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedOpacity(
                                  opacity: _visible ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.easeInOut,
                                  child: AnimatedBuilder(
                                    animation: _animation,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _animation.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: SweepGradient(
                                              colors: activeGradient,
                                              stops: const [0.0, 0.6, 1.0],
                                              transform: const GradientRotation(
                                                  pi / 2),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  height: 48,
                                  width: 151,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        print("🔍 Getting AuthController...");
                                        final authController = Get.find<AuthController>();

                                        print("🎯 Requesting token with:");
                                        print("👉 selectedLabel: $_selectedLabel");
                                        print("👉 selectedAgent: $_activeAgent");

                                        final token = await authController.getLiveKitToken(
                                          selectedLabel: _selectedLabel,
                                          selectedAgent: _activeAgent,
                                        );
                                        print("🪪 New Token: $token");

                                        if (token == null) {
                                          print('❌ Failed to get token');
                                          return;
                                        }
                                        // print("⏳ Waiting for 5 seconds before connecting to room...");
                                        // await Future.delayed(Duration(seconds: 5));

                                        print("🔌 Connecting to LiveKit room...");
                                        final room = await LiveKitService.connectToRoom(
                                          url: 'wss://appointmentsetter-7p2s97kw.livekit.cloud',
                                          token: token,
                                        );

                                        print("🎙️ Enabling microphone...");
                                        await room.localParticipant?.setMicrophoneEnabled(true);

                                        print("✅ Navigating to CallScreen with agent: $_activeAgent");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CallScreen(
                                              room: room,
                                              selectedAgentName: _activeAgent,
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        print('❌ Error connecting to room: $e');
                                      }
                                    },

                                    icon: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black),
                                      child: const Icon(Icons.graphic_eq,
                                          color: Colors.white54),
                                    ),
                                    label: const Text(
                                      "TRY A CALL",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Left Labels
                        Positioned(
                          left: 0,
                          top: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: labels.map((label) {
                              final isActive = label == _selectedLabel;
                              return GestureDetector(
                                onTap: () => _onLabelTap(label),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: isActive
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Text(
                                            label,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Colors.white,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          label,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Colors.black,
                                            height: 2.6,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // Right Agent Names
                        Positioned(
                          right: 10,
                          top: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: agentGradients.keys.map((name) {
                              final isActive = _activeAgent == name;
                              final gradientColors = agentGradients[name]!;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: GestureDetector(
                                  onTap: () => _onAgentTap(name),
                                  child: isActive
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: RadialGradient(
                                                    colors: gradientColors,
                                                    center: Alignment.center,
                                                    radius: 0.8,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Text(
                                          name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                            height: 2.6,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
