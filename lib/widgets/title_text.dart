import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double fontSize;
  final FontWeight fontWeight;

  const TitleText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.fontSize = 40,
    this.fontWeight = FontWeight.w700,
    required String title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
