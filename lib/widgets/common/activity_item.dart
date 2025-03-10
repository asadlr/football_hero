// lib\widgets\common\activity_item.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final VoidCallback onTap;

  const ActivityItem({
    super.key,
    required this.title,
    required this.time,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl, // RTL support
          children: [
            Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                color: Color.fromRGBO(color.red, color.green, color.blue, 0.8),
              ),
              textDirection: TextDirection.rtl,
            ),
            Text(
              time,
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}