import 'package:flutter/material.dart';

class UserTestimonialCard extends StatelessWidget {
  final String quote;
  final String userName;
  final String userTitle;
  final String imagePath;

  const UserTestimonialCard({
    super.key,
    required this.quote,
    required this.userName,
    required this.userTitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 768,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF6199ED)),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Text(
            quote,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(height: 10),
          Text(
            userName,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20, height: 1.5),
          ),
          Text(
            userTitle,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
