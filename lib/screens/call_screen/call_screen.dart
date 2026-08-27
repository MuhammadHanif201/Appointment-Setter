import 'package:appointment_setter/services/livekit_service.dart';
import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

/// Lifts a surface off [AppColors.surfaceDark].
///
/// This screen is the one deliberately dark surface in the product, so depth
/// here cannot come from a shadow — a black shadow on a near-black page is
/// invisible. Instead a panel is a faint wash of [AppColors.textOnDark] plus a
/// hairline of the same, which is the dark-surface equivalent of the light
/// theme's `surface + border`.
Color _lift(double alpha) => AppColors.textOnDark.withValues(alpha: alpha);

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

  /// Drives the one-off entrance fade of the call card.
  bool _entered = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _entered = true);
    });
  }

  Future<void> _initialize() async {
    final micStatus = await Permission.microphone.status;
    if (!mounted) return;

    setState(() {
      hasMicPermission = micStatus.isGranted;
    });

    if (hasMicPermission) {
      final mic = widget.room.localParticipant?.isMicrophoneEnabled() ?? true;
      setState(() {
        isMicEnabled = mic;
      });
    } else {
      debugPrint("Microphone permission not granted");
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
    debugPrint("🔔 Room connection state: ${widget.room.connectionState}");
  }

  Future<void> _toggleMic() async {
    if (!hasMicPermission) {
      final status = await Permission.microphone.request();
      if (!mounted) return;

      if (status.isGranted) {
        setState(() {
          hasMicPermission = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Microphone permission is required."),
            action: SnackBarAction(
              label: "Open Settings",
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        return;
      }
    }

    final participant = widget.room.localParticipant;
    if (participant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No local participant available")),
      );
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
      debugPrint("🎙️ Mic is currently ${currentMicState ? 'ON' : 'OFF'}");

      await participant.setMicrophoneEnabled(!currentMicState);

      final newMicState = participant.isMicrophoneEnabled();
      debugPrint("🎙️ Mic is now ${newMicState ? 'ON' : 'OFF'}");
      if (!mounted) return;

      setState(() {
        isMicEnabled = newMicState;
      });

      if (!hasAudioTrack) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No audio track available, attempting to publish")),
        );
      }
    } catch (e) {
      debugPrint("❌ Error toggling mic: $e");
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to toggle microphone: $e")),
      );
    }
  }

  Future<void> _endCall() async {
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
    debugPrint("📴 Disconnected via LiveKitService");
    const String roomStatusMessage = "disconnected room";
    debugPrint("📤 Message to send backend: $roomStatusMessage");
    LiveKitService.clearRoom(); // Also clear any cached reference

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = widget.selectedAgentName;

    final double avatarSize = context.responsive(
      mobile: 112.0,
      tablet: 128.0,
      desktop: 144.0,
    );
    final bool micActive = isMicEnabled && hasMicPermission;

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        // Deliberately transparent: the bar floats on the call background
        // rather than introducing a second surface at the top of the screen.
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        // The global app bar theme is tuned for the white pages; on the one
        // dark screen the chrome has to flip with it.
        foregroundColor: AppColors.textOnDark,
        iconTheme: const IconThemeData(color: AppColors.textOnDark, size: 22),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'LiveKit Call',
          style: AppText.title(context, color: AppColors.textOnDark),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.hPad,
              vertical: AppSpacing.lg,
            ),
            child: AnimatedOpacity(
              opacity: _entered ? 1 : 0,
              duration: AppDurations.slow,
              curve: AppCurves.standard,
              child: AnimatedSlide(
                offset: _entered ? Offset.zero : const Offset(0, 0.05),
                duration: AppDurations.slow,
                curve: AppCurves.emphasized,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.responsive(
                      mobile: 360.0,
                      tablet: 440.0,
                      desktop: 480.0,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.cardPad,
                      vertical: context.blockGap,
                    ),
                    decoration: BoxDecoration(
                      color: _lift(0.05),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(color: _lift(0.12)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CallerAvatar(size: avatarSize, active: micActive),
                        const SizedBox(height: AppSpacing.lg),
                        TitleText(
                          text: displayName,
                          style: AppText.h2(
                            context,
                            color: AppColors.textOnDark,
                          ),
                        ),
                        SizedBox(height: context.blockGap),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: context.responsive(
                            mobile: AppSpacing.lg,
                            tablet: AppSpacing.xl,
                            desktop: AppSpacing.xl,
                          ),
                          runSpacing: AppSpacing.md,
                          children: [
                            _CallButton(
                              icon: micActive ? Icons.mic : Icons.mic_off,
                              onTap: hasMicPermission ? _toggleMic : null,
                              // The controls speak in state colours: live is
                              // success, muted is a warning, ending is danger.
                              // Gold is spent once on this screen, on the
                              // avatar ring.
                              color: micActive
                                  ? AppColors.success
                                  : AppColors.warning,
                              active: micActive,
                            ),
                            _CallButton(
                              icon: Icons.call_end,
                              onTap: _endCall,
                              color: AppColors.danger,
                              filled: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The large caller bubble at the top of the call. Sized by the caller so it
/// can shrink on a phone and grow on a desktop; the ring around it warms to
/// gold while the microphone is live — the single gold moment on this screen.
class _CallerAvatar extends StatelessWidget {
  final double size;
  final bool active;

  const _CallerAvatar({required this.size, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppCurves.standard,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Gold clears contrast comfortably on the dark surface, so the live
        // ring can be the brand colour itself rather than primaryInk.
        border: Border.all(
          color: active
              ? AppColors.primary.withValues(alpha: 0.6)
              : _lift(0.14),
          width: 1.5,
        ),
      ),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [_lift(0.12), _lift(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.fromBorderSide(BorderSide(color: _lift(0.10))),
        ),
        child: Icon(
          Icons.person,
          size: size * 0.44,
          color: AppColors.textOnDarkMuted,
        ),
      ),
    );
  }
}

/// A circular call control. Defaults to a tonal treatment — a lifted disc with
/// a tinted hairline — and only takes a solid fill for the destructive end-call
/// action, so the two controls never compete for attention.
class _CallButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;

  /// The tone that carries meaning: success when live, warning when muted,
  /// danger for the end-call control.
  final Color color;

  /// Fills the disc with [color] instead of tinting it. Reserved for the
  /// destructive control.
  final bool filled;

  /// Draws the halo and the stronger rim that mark the control as "on".
  final bool active;

  const _CallButton({
    required this.icon,
    required this.onTap,
    required this.color,
    this.filled = false,
    this.active = false,
  });

  @override
  State<_CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<_CallButton> {
  bool _hovered = false;
  bool _pressed = false;

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onTap != null;
    final Color tone = enabled ? widget.color : AppColors.textOnDarkMuted;

    final double diameter = context.responsive(
      mobile: 56.0,
      tablet: 64.0,
      desktop: 72.0,
    );
    final double iconSize = context.responsive(
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );

    // Hover and press are shifts in the fill itself: a shadow would be lost
    // against the dark page, so the disc brightens on hover and sinks on press.
    final Color fill;
    if (!enabled) {
      fill = _lift(0.06);
    } else if (widget.filled) {
      fill = _pressed
          ? Color.lerp(tone, AppColors.onPrimary, 0.22)!
          : (_hovered ? Color.lerp(tone, AppColors.textOnDark, 0.12)! : tone);
    } else if (widget.active) {
      fill = tone.withValues(alpha: _hovered ? 0.24 : 0.16);
    } else {
      fill = _hovered ? _lift(0.12) : _lift(0.06);
    }

    // On a saturated fill the near-white ink is the only label colour that
    // clears contrast at this icon size; on a tinted disc the tone reads best.
    final Color iconColor = widget.filled ? AppColors.textOnDark : tone;

    final double rimAlpha =
        widget.active ? 0.75 : (_hovered ? 0.60 : 0.40);
    final BorderSide side = widget.filled
        ? BorderSide.none
        : BorderSide(
            color: enabled ? tone.withValues(alpha: rimAlpha) : _lift(0.16),
          );

    return AnimatedScale(
      scale: _pressed ? 0.94 : 1,
      duration: AppDurations.fast,
      curve: AppCurves.standard,
      child: AnimatedContainer(
        duration: AppDurations.medium,
        curve: AppCurves.standard,
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.active
              ? tone.withValues(alpha: 0.14)
              : Colors.transparent,
        ),
        child: Material(
          animationDuration: AppDurations.fast,
          color: fill,
          shape: CircleBorder(side: side),
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onTap,
            onHover: _setHovered,
            onHighlightChanged: _setPressed,
            splashColor: iconColor.withValues(alpha: 0.18),
            highlightColor: iconColor.withValues(alpha: 0.10),
            child: SizedBox(
              width: diameter,
              height: diameter,
              child: Center(
                child: Icon(widget.icon, size: iconSize, color: iconColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
