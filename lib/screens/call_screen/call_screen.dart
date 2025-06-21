import 'package:appointment_setter/services/livekit_service.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

class CallScreen extends StatefulWidget {
  final Room room;
  final String selectedAgentName;

  const CallScreen({
    super.key,
    required this.room,
    required this.selectedAgentName,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isMicEnabled = true;
  bool hasMicPermission = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final micStatus = await Permission.microphone.status;
    if (mounted) {
      setState(() {
        hasMicPermission = micStatus.isGranted;
      });
    }

    if (hasMicPermission) {
      final mic = widget.room.localParticipant?.isMicrophoneEnabled() ?? true;
      if (mounted) {
        setState(() {
          isMicEnabled = mic;
        });
      }
    } else {
      print("Microphone permission not granted");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Microphone permission is required. Please enable it in settings."),
            action: SnackBarAction(
              label: "Open Settings",
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    }
    print("🔔 Room connection state: ${widget.room.connectionState}");
  }

  void _toggleMic() async {
    if (!hasMicPermission) {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        if (mounted) {
          setState(() {
            hasMicPermission = true;
          });
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Microphone permission is required."),
              action: SnackBarAction(
                label: "Open Settings",
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return;
      }
    }

    final participant = widget.room.localParticipant;
    if (participant == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No local participant available")),
        );
      }
      return;
    }

    try {
      bool hasAudioTrack = false;
      for (var track in participant.trackPublications.values) {
        if (track.kind == TrackType.AUDIO) {
          hasAudioTrack = true;
          break;
        }
      }

      final currentMicState = participant.isMicrophoneEnabled();
      print("🎙️ Mic is currently ${currentMicState ? 'ON' : 'OFF'}");

      await participant.setMicrophoneEnabled(!currentMicState);

      final newMicState = participant.isMicrophoneEnabled();
      print("🎙️ Mic is now ${newMicState ? 'ON' : 'OFF'}");

      if (mounted) {
        setState(() {
          isMicEnabled = newMicState;
        });
      }

      if (!hasAudioTrack) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No audio track available, attempting to publish")),
          );
        }
      }
    } catch (e) {
      print("❌ Error toggling mic: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to toggle microphone: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = widget.selectedAgentName;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('LiveKit Call'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.purple.shade700,
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CallButton(
                    icon: isMicEnabled && hasMicPermission ? Icons.mic : Icons.mic_off,
                    onTap: hasMicPermission ? () => _toggleMic() : null,
                    color: isMicEnabled && hasMicPermission ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 30),
                  _CallButton(
                    icon: Icons.call_end,
                    onTap: () async {
                      // await LiveKitService.disconnectCurrentRoom(
                      //   url: 'wss://appointmentsetter-7p2s97kw.livekit.cloud',
                      //   disconnect: 'disconnected room',
                      // );
                      //
                      // LiveKitService.disconnectCurrentRoom(
                      //   url: 'wss://appointmentsetter-7p2s97kw.livekit.cloud',
                      //   disconnect: "Disconnected", // Correct spelling
                      // );
                      await LiveKitService.disconnectCurrentRoom();
                      print("📴 Disconnected via LiveKitService");
                      String roomStatusMessage = "disconnected room";
                      print("📤 Message to send backend: $roomStatusMessage");
                      LiveKitService.clearRoom(); // Also clear any cached reference

                      if (context.mounted) Navigator.pop(context);
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const _CallButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: color,
      elevation: 6,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Icon(icon, size: 28, color: Colors.white),
        ),
      ),
    );
  }
}
