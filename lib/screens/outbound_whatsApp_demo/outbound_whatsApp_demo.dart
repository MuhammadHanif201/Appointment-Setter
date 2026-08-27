import 'package:appointment_setter/theme/app_theme.dart';
import 'package:appointment_setter/widgets/action_button.dart';
import 'package:appointment_setter/widgets/percentage_size_ext%20.dart';
import 'package:appointment_setter/widgets/section_container.dart';
import 'package:appointment_setter/widgets/title_text.dart';
import 'package:flutter/material.dart';

class OutboundWhatsAppDemo extends StatelessWidget {
  const OutboundWhatsAppDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      // `background` and `surface` are both pure white, so a white card on a
      // white band was held up by its hairline alone. The band steps down to
      // the off-white so the card genuinely lifts off it.
      color: AppColors.surfaceAlt,
      child: Column(
        children: [
          const TitleText(text: "Try The Outbound\n WhatsApp Demo Below"),
          SizedBox(height: context.blockGap),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 576),
            child: const _DemoFormCard(),
          ),
        ],
      ),
    );
  }
}

class _DemoFormCard extends StatelessWidget {
  const _DemoFormCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        context.responsive(
          mobile: AppSpacing.s20,
          tablet: AppSpacing.lg,
          desktop: AppSpacing.xl,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Two-tone ink rather than gold: the card already has one gold
          // moment — the submit button, which is the whole point of it — and a
          // gold headline in the same 576px panel would compete with it. The
          // phrase steps up the ink ramp instead.
          Text.rich(
            TextSpan(
              text: "Receive an ",
              style: AppText.h3(context, color: AppColors.textSecondary),
              children: [
                TextSpan(
                  text: "instant-follow-up ",
                  style: AppText.h3(context, color: AppColors.textPrimary),
                ),
                TextSpan(
                  text: "from our AI Setter",
                  style: AppText.h3(context, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _FormField(
            label: "Enter your Name",
            hintText: "Enter your name",
            keyboardType: TextInputType.name,
            autofillHints: [AutofillHints.name],
          ),
          const SizedBox(height: AppSpacing.s20),
          const _FormField(
            label: "Enter your Email (only work email)",
            hintText: "Enter your email",
            keyboardType: TextInputType.emailAddress,
            autofillHints: [AutofillHints.email],
          ),
          const SizedBox(height: AppSpacing.s20),
          const _FormField(
            label: "Enter your WhatsApp Phone Number",
            hintText: "Enter your number",
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofillHints: [AutofillHints.telephoneNumber],
          ),
          const SizedBox(height: AppSpacing.xl),
          ActionButton(
            text: "Chat with Setter AI",
            size: ActionButtonSize.large,
            expand: true,
            onPressed: () {
              // Add your button onPressed logic here
            },
          ),
        ],
      ),
    );
  }
}

/// A labelled text field. The field itself is left to the global
/// `inputDecorationTheme`, which owns the fill, the hairline border, the gold
/// 1.5px focus ring and the red error border/message — the only thing added
/// here is the label, which tracks the focus state.
class _FormField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<String> autofillHints;

  const _FormField({
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.autofillHints = const [],
  });

  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A focused label is text, so the gold it lifts to is the readable ink
    // step — the fill gold would drop it to 2.4:1 on white.
    final Color labelColor =
        _focused ? AppColors.primaryInk : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          style: AppText.label(context, color: labelColor),
          child: Text(widget.label),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          cursorColor: AppColors.primaryInk,
          style: AppText.body(context, color: AppColors.textPrimary),
          // Fill, hairline border, the gold focus ring and the red error
          // border/message all come from the global `inputDecorationTheme`, so
          // every field on the page is the same height and the same shape.
          decoration: InputDecoration(hintText: widget.hintText),
        ),
      ],
    );
  }
}
