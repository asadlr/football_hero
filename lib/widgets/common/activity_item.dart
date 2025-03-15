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
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: ThemeConstants.sm),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.md, 
          vertical: ThemeConstants.sm + 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            _buildTitleText(theme),
            _buildTimeText(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleText(ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: color.withOpacity(0.8),
      ),
      textDirection: TextDirection.rtl,
    );
  }

  Widget _buildTimeText(ThemeData theme) {
    return Text(
      time,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      textDirection: TextDirection.rtl,
    );
  }
}