import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The partner strip.
///
/// Every logo here was drawn for a white page — Acuity is near-black, the
/// Zapier and Calendly marks rely on white counters, Google Calendar's wordmark
/// is mid grey and the Meta badge ships its own opaque white plate. On this
/// theme the page *is* white, so the artwork is back in its native habitat:
/// each mark sits directly on the band with no plate, no card and no shadow
/// behind it. All that is shared is the row geometry — one slot size and one
/// gutter — so the marks read at a matched optical weight.
///
/// The row scrolls continuously rather than wrapping onto several lines: it
/// keeps the section to one band on every screen size, and a slow drift reads
/// as "there are more of these" without a control to press.
class IntegrationSection extends StatelessWidget {
  const IntegrationSection({super.key});

  @override
  Widget build(BuildContext context) {
    // The Meta badge carries its own generous internal whitespace, so it runs
    // a touch larger than the row beneath it without looking heavier.
    final metaHeight = context.responsive<double>(
      mobile: 44,
      tablet: 56,
      desktop: 72,
    );

    return SectionContainer(
      // White band. The calculator section above is the warm one, so the two
      // separate without a rule between them.
      color: AppColors.background,
      // The marquee runs the full bleed of the band, so it loses the content
      // gutter and takes the whole width instead of stopping at 1200.
      maxWidth: double.infinity,
      padding: EdgeInsets.symmetric(vertical: context.vPad),
      child: Column(
        children: [
          // The marquee runs edge to edge, but the heading above it still has
          // to obey the same reading width as every other section.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.hPad),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/meta.png",
                    height: metaHeight,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: context.blockGap),
                  TitleText(
                    text: "Integrates seamlessly into your sales flow",
                    style: AppText.h2(context),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.blockGap),
          const _PartnerMarquee(),
        ],
      ),
    );
  }
}

/// One partner mark, described rather than built, so the marquee can stamp the
/// same set out as many times as the viewport needs.
class _Partner {
  /// Fraction of the slot height this mark should occupy. Matching logos by
  /// raw height makes a bare wordmark tower over a badge, so each one is tuned
  /// to read at the same optical weight.
  final double heightFactor;
  final bool isSvg;
  final String asset;

  const _Partner(this.asset, {required this.heightFactor, this.isSvg = false});
}

const List<_Partner> _partners = [
  // Bird + wordmark, so it needs the least height of the four.
  _Partner('assets/images/zapier.svg', heightFactor: 0.42, isSvg: true),
  // Tall square mark with a short wordmark beside it.
  _Partner('assets/images/calender.png', heightFactor: 0.62),
  _Partner('assets/images/calendy.png', heightFactor: 0.52),
  // A bare wordmark on a tight viewBox — matching it by height would make it
  // twice the size of everything else.
  _Partner('assets/images/acuity.svg', heightFactor: 0.26, isSvg: true),
];

/// A seamless, continuously drifting row of partner logos.
///
/// The set is stamped out enough times to cover the viewport plus one whole
/// extra set, and the strip is translated by exactly one set width per cycle —
/// so the moment the animation resets, the pixels are identical and the loop is
/// invisible. Hovering pauses it, and a viewer who has asked the OS to reduce
/// motion gets a static centred row instead.
class _PartnerMarquee extends StatefulWidget {
  const _PartnerMarquee();

  @override
  State<_PartnerMarquee> createState() => _PartnerMarqueeState();
}

class _PartnerMarqueeState extends State<_PartnerMarquee>
    with SingleTickerProviderStateMixin {
  /// Drift speed in logical pixels per second. Slow enough to read as ambient
  /// rather than as something demanding attention.
  static const double _pixelsPerSecond = 42;

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));

  bool _paused = false;

  double _slotHeight = 64;
  double _slotWidth = 180;
  double get _setWidth => _slotWidth * _partners.length;

  /// Breakpoint-dependent geometry and the controller's lifecycle both live
  /// here rather than in `build`: the cycle length is derived from the set
  /// width, and starting a ticker as a side effect of building is the kind of
  /// thing that bites later.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _slotHeight = context.responsive<double>(mobile: 56, tablet: 64, desktop: 72);
    _slotWidth = context.responsive<double>(mobile: 150, tablet: 180, desktop: 200);

    // Speed is what stays constant, so the cycle length follows the set width
    // rather than the other way round — the strip drifts at the same rate on a
    // phone as on a desktop.
    _controller.duration = Duration(
      milliseconds: (_setWidth / _pixelsPerSecond * 1000).round(),
    );

    // Honour the OS "reduce motion" setting: a perpetually moving strip is
    // exactly the kind of thing that switch exists to stop.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_paused) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPaused(bool value) {
    if (_paused == value) return;
    setState(() => _paused = value);
    if (value) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slotHeight = _slotHeight;
    final slotWidth = _slotWidth;
    final setWidth = _setWidth;

    if (MediaQuery.disableAnimationsOf(context)) {
      return _StaticPartnerRow(slotHeight: slotHeight, slotWidth: slotWidth);
    }

    return SizedBox(
      height: slotHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // One extra set beyond what is visible, so there is always a fresh
          // set queued up on the right as the strip slides left.
          final sets = (constraints.maxWidth / setWidth).ceil() + 1;

          final strip = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < sets; i++)
                for (final partner in _partners)
                  _PartnerLogo(
                    height: slotHeight,
                    width: slotWidth,
                    partner: partner,
                  ),
            ],
          );

          return MouseRegion(
            onEnter: (_) => _setPaused(true),
            onExit: (_) => _setPaused(false),
            child: ShaderMask(
              // Fade both ends into the band so logos enter and leave instead
              // of being sliced off at a hard edge.
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0x00000000),
                  Color(0xFF000000),
                  Color(0xFF000000),
                  Color(0x00000000),
                ],
                stops: [0, 0.08, 0.92, 1],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: ClipRect(
                // The strip is deliberately wider than the band — that is the
                // whole point of a marquee. Without this the Row inherits the
                // band's width as a hard maximum and Flutter reports it as a
                // RenderFlex overflow; OverflowBox hands it an unbounded width
                // so it can lay out at its natural size and simply be clipped.
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  maxWidth: double.infinity,
                  child: AnimatedBuilder(
                    animation: _controller,
                    child: strip,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(-_controller.value * setWidth, 0),
                        child: child,
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The reduce-motion fallback: the same marks, centred and still.
class _StaticPartnerRow extends StatelessWidget {
  final double slotHeight;
  final double slotWidth;

  const _StaticPartnerRow({required this.slotHeight, required this.slotWidth});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final partner in _partners)
          _PartnerLogo(
            height: slotHeight,
            width: slotWidth,
            partner: partner,
          ),
      ],
    );
  }
}

/// A single slot in the partner row.
///
/// Geometry only: a shared box so the marks sit on one baseline and never
/// collide. There is deliberately no fill, border or shadow — these logos were
/// drawn for white paper and the page is white paper.
class _PartnerLogo extends StatelessWidget {
  final double height;
  final double width;
  final _Partner partner;

  const _PartnerLogo({
    required this.height,
    required this.width,
    required this.partner,
  });

  @override
  Widget build(BuildContext context) {
    final markHeight = height * partner.heightFactor;

    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: partner.isSvg
              ? SvgPicture.asset(
                  partner.asset,
                  height: markHeight,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  partner.asset,
                  height: markHeight,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}
