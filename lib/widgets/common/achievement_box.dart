// lib\widgets\common\achievement_box.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AchievementBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Gradient? gradient;

  const AchievementBox({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Color bgColor = gradient == null 
        ? Color.fromRGBO(color.red, color.green, color.blue, 0.1)
        : Colors.transparent;
        
    return Container(
      width: 90, // Make the box a bit smaller
      height: 90, // Make the box a bit smaller
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? bgColor : null,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: AppTheme.iconSizeSmall + 6, // 22
          ),
          SizedBox(height: AppTheme.spacing - 2), // 6
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppTheme.spacing - 5), // 3
          Text(
            title,
            style: textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}