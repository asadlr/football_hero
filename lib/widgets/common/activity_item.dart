// lib\widgets\common\activity_item.dart

import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final VoidCallback onTap;

  const ActivityItem({
    Key? key,
    required this.title,
    required this.time,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl, // RTL support
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: color.withOpacity(0.8),
              ),
              textDirection: TextDirection.rtl,
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2c3e50),
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
