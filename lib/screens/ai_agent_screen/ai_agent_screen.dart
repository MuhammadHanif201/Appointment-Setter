import 'dart:math';

import 'package:appointment_setter/auth_controller/auth_controller.dart';
import 'package:appointment_setter/screens/call_screen/call_screen.dart';
import 'package:appointment_setter/services/livekit_service.dart';
import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

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

  /// One orb gradient per agent.
  ///
  /// The orbs are the single deliberately dark object on this white page, so
  /// every stop stays inside the [AppColors.surfaceDark] family. The agent's
  /// identity is a *warm* stop in the middle — gold knocked back into the navy
  /// far enough that it reads as a lit bronze rather than as a second gold
  /// fill. A full-strength gold stop across a 300px disc put a large gold-lit
  /// area right next to the gold call to action, and neither one then read as
  /// the primary thing on the screen.
  ///
  /// Read as `[lifted navy edge, warm highlight, deep edge]` — the middle stop
  /// is the identity, the outer two keep the disc navy.
  static final Map<String, List<Color>> agentGradients = {
    // Brightest: the navy is lifted furthest and the highlight is warmest.
    'JESSICA': [
      _navy(0.16),
      _highlight(AppColors.primaryLight, 0.34),
      AppColors.surfaceDark,
    ],
    // Mid luminance, straight brand gold knocked back.
    'LILY': [
      _navy(0.08),
      _highlight(AppColors.primary, 0.28),
      AppColors.surfaceDark,
    ],
    // Deepest and most bronzed.
    'ERIC': [
      _navy(0.03),
      _highlight(AppColors.primaryDark, 0.22),
      AppColors.surfaceDark,
    ],
  };

  /// [AppColors.surfaceDark] lifted towards [AppColors.textOnDark] by [amount].
  /// Composed from tokens rather than declared as a second dark hex, so the orb
  /// stays inside the one dark surface the palette allows.
  static Color _navy(double amount) => Color.alphaBlend(
        AppColors.textOnDark.withValues(alpha: amount),
        AppColors.surfaceDark,
      );

  /// [gold] dissolved into the navy at [amount]. The result stays dark enough
  /// to be part of the disc — the agents are told apart by warmth and
  /// luminance, not by a bright gold band.
  static Color _highlight(Color gold, double amount) => Color.alphaBlend(
        gold.withValues(alpha: amount),
        _navy(0.10),
      );

  static const List<String> labels = [
    "Doctor",
    "Restaurant",
    "Real Estate",
    "Bus Ticket",
  ];

  static const String _stackedDescription =
      "Add voice to your agents on web, mobile or telephony in minutes. Our realtime API delivers low latency, full configurability, and seamless scalability.";

  static const String _wideDescription =
      "Add voice to your agents on web, mobile or telephony in\n minutes. Our realtime API delivers low latency, full\n configurability, and seamless scalability.";

  /// Below this the orb sits above the selectors instead of between them.
  static const double _flankedLayoutMinWidth = 420;

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

    // Dip the orb and bring it back so the gradient swap is not a jump cut.
    Future.delayed(AppDurations.medium, () {
      if (!mounted) return;
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

  Future<void> _startCall() async {
    // Ask before connecting, so the agent can hear the caller from the first
    // word. Android does not always prompt on its own when the call starts.
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      debugPrint('❌ Microphone permission denied: $micStatus');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Microphone permission is required to talk to the agent.'),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
      return;
    }

    try {
      debugPrint("🔍 Getting AuthController...");
      final authController = Get.find<AuthController>();

      debugPrint("🎯 Requesting token with:");
      debugPrint("👉 selectedLabel: $_selectedLabel");
      debugPrint("👉 selectedAgent: $_activeAgent");

      final session = await authController.startSession(
        selectedLabel: _selectedLabel,
        selectedAgent: _activeAgent,
      );

      if (session == null) {
        debugPrint('❌ Failed to get token');
        return;
      }

      debugPrint("🪪 Token received for room ${session.roomName}");

      debugPrint("🔌 Connecting to LiveKit at ${session.serverUrl}...");
      final room = await LiveKitService.connectToRoom(
        url: session.serverUrl,
        token: session.token,
      );

      debugPrint("🎙️ Enabling microphone...");
      await room.localParticipant?.setMicrophoneEnabled(true);

      debugPrint("✅ Navigating to CallScreen with agent: $_activeAgent");
      if (!mounted) return;
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
      debugPrint('❌ Error connecting to room: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeGradient = agentGradients[_activeAgent]!;

    return SectionContainer(
      // A page band, not a card: it takes the page colour and lets the orb be
      // the only thing on it with any weight.
      color: AppColors.background,
      child: context.isMobile
          ? _buildStackedLayout(context, activeGradient)
          : _buildWideLayout(context, activeGradient),
    );
  }

  // ---------------------------------------------------------------------------
  // Layouts
  // ---------------------------------------------------------------------------

  Widget _buildStackedLayout(BuildContext context, List<Color> gradient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEyebrow(context),
        SizedBox(height: context.blockGap),
        _buildCopyBlock(context, _stackedDescription),
        SizedBox(height: context.blockGap),
        _buildAgentPlayground(context, gradient),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context, List<Color> gradient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEyebrow(context),
        SizedBox(height: context.blockGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: _buildCopyBlock(context, _wideDescription),
            ),
            SizedBox(width: context.blockGap),
            Expanded(
              flex: 6,
              child: _buildAgentPlayground(context, gradient),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Copy
  // ---------------------------------------------------------------------------

  /// A quiet section marker. The one gold moment in this viewport belongs to
  /// "GET STARTED FREE", so the eyebrow stays neutral.
  Widget _buildEyebrow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              "Conversational AI",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.overline(context, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyBlock(BuildContext context, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleText(
          text: "Build AI Agents that speak",
          textAlign: TextAlign.left,
          style: AppText.display(context),
        ),
        const SizedBox(height: AppSpacing.md),
        SectionSubtitle(
          text: description,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: context.blockGap),
        _buildCtas(context),
      ],
    );
  }

  Widget _buildCtas(BuildContext context) {
    // A null handler renders an ActionButton disabled, which on this palette is
    // a grey pill — these are the section's live calls to action, so they are
    // wired to a no-op until the routes exist rather than shipped greyed out.
    //
    // Exactly one of the two is filled. It is the only gold fill in the
    // section: the orb's pill is white and the agent dot only golds when it is
    // the selected one, so nothing competes with it for the eye.
    final primary = ActionButton(
      text: "GET STARTED FREE",
      size: ActionButtonSize.large,
      onPressed: () {},
      expand: context.isMobile,
    );

    final secondary = ActionButton(
      text: "CONTACT SALES",
      variant: ActionButtonVariant.outlined,
      size: ActionButtonSize.large,
      onPressed: () {},
      expand: context.isMobile,
    );

    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          primary,
          const SizedBox(height: AppSpacing.s12),
          secondary,
        ],
      );
    }

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.s12,
      children: [primary, secondary],
    );
  }

  // ---------------------------------------------------------------------------
  // Orb + selectors
  // ---------------------------------------------------------------------------

  /// The animated orb with the category / agent selectors around it. Flanks the
  /// orb when there is room and stacks underneath it when there is not, so the
  /// chips never fight the orb for horizontal space.
  Widget _buildAgentPlayground(BuildContext context, List<Color> gradient) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < _flankedLayoutMinWidth) {
          final orbSize = width.clamp(160.0, 280.0);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOrb(context, gradient, orbSize),
              SizedBox(height: context.blockGap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCategorySelector(context, showHeading: true),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildAgentSelector(context, showHeading: true),
                  ),
                ],
              ),
            ],
          );
        }

        final orbSize = (width * 0.44).clamp(180.0, 300.0);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: _buildCategorySelector(context)),
            const SizedBox(width: AppSpacing.sm),
            _buildOrb(context, gradient, orbSize),
            const SizedBox(width: AppSpacing.sm),
            Flexible(child: _buildAgentSelector(context, alignEnd: true)),
          ],
        );
      },
    );
  }

  Widget _buildOrb(BuildContext context, List<Color> gradient, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            // The orb dips rather than disappears: on a white page a vanishing
            // disc reads as a broken image, not as a transition.
            opacity: _visible ? 1.0 : 0.3,
            duration: AppDurations.fast,
            curve: AppCurves.standard,
            // The lift sits outside the rotation so the shadow stays put while
            // the gradient turns. It is a soft neutral drop, not the gold halo
            // the disc wore on the old dark page.
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: AppShadows.card,
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value,
                    child: child,
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: gradient,
                      stops: const [0.0, 0.6, 1.0],
                      transform: const GradientRotation(pi / 2),
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          _buildTryCallButton(context),
        ],
      ),
    );
  }

  /// The demo trigger, sitting on the dark orb.
  ///
  /// It is a white pill with primary ink on it, not a second gold fill: the one
  /// gold moment in this viewport belongs to "GET STARTED FREE" in the copy
  /// column. Against the navy disc white is the highest-contrast object on the
  /// screen, so the pill still reads as the thing to press without spending the
  /// accent twice.
  Widget _buildTryCallButton(BuildContext context) {
    final compact = context.isMobile;

    return _TryCallPill(
      onTap: _startCall,
      compact: compact,
    );
  }

  Widget _buildCategorySelector(
    BuildContext context, {
    bool showHeading = false,
    bool alignEnd = false,
  }) {
    // IntrinsicWidth sizes the column to its widest chip and `stretch` pushes
    // every other chip out to match, so the list reads as one control instead
    // of a ragged stack sized by how long each word happens to be.
    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showHeading) ...[
              Text(
                "Categories",
                style: _selectorHeadingStyle(context),
                textAlign: alignEnd ? TextAlign.end : TextAlign.start,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            for (final label in labels)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: _SelectorChip(
                  label: label,
                  selected: label == _selectedLabel,
                  onTap: () => _onLabelTap(label),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentSelector(
    BuildContext context, {
    bool showHeading = false,
    bool alignEnd = false,
  }) {
    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showHeading) ...[
              Text(
                "Agents",
                style: _selectorHeadingStyle(context),
                textAlign: alignEnd ? TextAlign.end : TextAlign.start,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            for (final entry in agentGradients.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: _SelectorChip(
                  label: entry.key,
                  selected: _activeAgent == entry.key,
                  onTap: () => _onAgentTap(entry.key),
                  leading: _AgentSwatch(selected: _activeAgent == entry.key),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// The two column labels. They title the lists rather than annotate them, so
  /// they carry real weight and sit on the secondary ink rather than the muted
  /// step — without reaching for the accent, which belongs to the selection.
  TextStyle _selectorHeadingStyle(BuildContext context) =>
      AppText.overline(context, color: AppColors.textSecondary)
          .copyWith(fontWeight: FontWeight.w700);
}

/// The white pill that starts a call, drawn on the dark orb.
///
/// Its states are the light-page set inverted onto a dark backdrop: the fill
/// steps down from white towards the warm off-white on hover and one further on
/// press, so the pill acknowledges the pointer without picking up a colour.
class _TryCallPill extends StatefulWidget {
  final VoidCallback onTap;
  final bool compact;

  const _TryCallPill({required this.onTap, required this.compact});

  @override
  State<_TryCallPill> createState() => _TryCallPillState();
}

class _TryCallPillState extends State<_TryCallPill> {
  static const BorderRadius _radius =
      BorderRadius.all(Radius.circular(AppRadius.pill));

  bool _hovered = false;
  bool _pressed = false;

  Color get _fill {
    if (_pressed) return AppColors.surfaceMuted;
    if (_hovered) return AppColors.surfaceAlt;
    return AppColors.surface;
  }

  void _set(void Function() change) {
    if (!mounted) return;
    setState(change);
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact;

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppCurves.standard,
      decoration: BoxDecoration(
        color: _fill,
        borderRadius: _radius,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: _radius,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (v) => _set(() => _hovered = v),
          onHighlightChanged: (v) => _set(() => _pressed = v),
          borderRadius: _radius,
          mouseCursor: SystemMouseCursors.click,
          splashColor: AppColors.textPrimary.withValues(alpha: 0.10),
          // Hover and press are drawn by the container above; the ink layer
          // only contributes the tap ripple.
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? AppSpacing.md : AppSpacing.s20,
              vertical: AppSpacing.s12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.graphic_eq,
                  size: compact ? 18 : 20,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    "TRY A CALL",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.button(
                      context,
                      color: AppColors.textPrimary,
                    ).copyWith(
                      // A genuine one-off: the label has to live inside a disc
                      // that can be as small as 160px.
                      fontSize: context.sp(compact ? 14 : 16),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The selection marker on an agent row.
///
/// It reads as a radio dot, not as a miniature orb: the agent's name is what
/// identifies it, and three gold-cored dots sitting permanently in the list
/// spent the accent on decoration. Gold appears here only when the row is the
/// active one — which is exactly what the accent is for.
class _AgentSwatch extends StatelessWidget {
  final bool selected;

  const _AgentSwatch({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppCurves.standard,
      width: AppSpacing.s12,
      height: AppSpacing.s12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // A filled dot is a shape, not something to read, so the active state
        // can take the fill gold; the hairline around it has to be the
        // readable one.
        color: selected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primaryInk : AppColors.borderStrong,
        ),
      ),
    );
  }
}

/// A category / agent pill.
///
/// Selected is a pale gold wash with a light gold hairline and a
/// [AppColors.primaryInk] label — the only gold that survives at this size.
/// Unselected is a warm off-white pill behind a plain hairline. Hover deepens
/// the surface by one step instead of tinting it gold, which is what depth
/// looks like on a light page.
class _SelectorChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  const _SelectorChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  @override
  State<_SelectorChip> createState() => _SelectorChipState();
}

class _SelectorChipState extends State<_SelectorChip> {
  static const BorderRadius _radius =
      BorderRadius.all(Radius.circular(AppRadius.pill));

  bool _hovered = false;
  bool _pressed = false;

  bool get _active => _hovered || _pressed;

  Color get _fill {
    if (widget.selected) {
      return _active
          ? Color.alphaBlend(
              AppColors.primaryLight.withValues(alpha: 0.20),
              AppColors.primarySoft,
            )
          : AppColors.primarySoft;
    }
    return _active ? AppColors.surfaceMuted : AppColors.surfaceAlt;
  }

  Color get _borderColor {
    if (widget.selected) return AppColors.primaryLight;
    return _active ? AppColors.borderStrong : AppColors.border;
  }

  TextStyle _labelStyle(BuildContext context) => AppText.bodySmall(
        context,
        color:
            widget.selected ? AppColors.primaryInk : AppColors.textSecondary,
      ).copyWith(
        fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
        height: 1.2,
      );

  void _set(void Function() change) {
    if (!mounted) return;
    setState(change);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppCurves.standard,
      decoration: BoxDecoration(
        color: _fill,
        borderRadius: _radius,
        border: Border.all(color: _borderColor),
      ),
      child: Material(
        // Transparent so the ink is visible over the animated fill above.
        color: Colors.transparent,
        borderRadius: _radius,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (v) => _set(() => _hovered = v),
          onHighlightChanged: (v) => _set(() => _pressed = v),
          borderRadius: _radius,
          splashColor: AppColors.primaryInk.withValues(alpha: 0.10),
          // Hover and press are already drawn by the container above, so the
          // ink layer only contributes the tap ripple.
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            // The pill is stretched to the column's width, so the row fills it
            // and the labels all start on the same left edge.
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(
                  child: AnimatedDefaultTextStyle(
                    duration: AppDurations.fast,
                    curve: AppCurves.standard,
                    style: _labelStyle(context),
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
