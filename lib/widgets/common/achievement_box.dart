// lib\widgets\common\achievement_box.dart

import 'package:flutter/material.dart';

class AchievementBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Gradient? gradient;

  const AchievementBox({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90, // Make the box a bit smaller
      height: 90, // Make the box a bit smaller
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? color.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 22, // Smaller icon
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18, // Slightly smaller value font
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2c3e50),
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: 10, // Smaller title font
              color: Colors.grey[700],
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}