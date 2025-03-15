import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    // Determine background color with improved color handling
    final backgroundColor = gradient == null 
        ? color.withOpacity(0.1)
        : Colors.transparent;

    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: ThemeConstants.iconMedium,
          ),
          SizedBox(height: ThemeConstants.sm - 2),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: ThemeConstants.sm - 5),
          Text(
            title,
            style: textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}