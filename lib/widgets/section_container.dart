import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final double? height;

  const SectionContainer({
    super.key,
    required this.child,
    this.maxWidth = 1000,
    this.padding,
    this.margin,
    this.color = Colors.white,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      margin: margin,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 96),
          child: child,
        ),
      ),
    );
  }
}
