// lib\widgets\common\upcoming_activities.dart

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class UpcomingActivitiesSection extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final VoidCallback? onViewAll;

  const UpcomingActivitiesSection({
    super.key,
    required this.activities,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      ),
      child: Padding(
        padding: AppTheme.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Activities',
                  style: textTheme.headlineSmall,
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('View All'),
                  ),
              ],
            ),
            SizedBox(height: AppTheme.spacing + 2),
            if (activities.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppTheme.spacingDouble + 4),
                child: Center(
                  child: Text(
                    'No upcoming activities',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              )
            else
              Column(
                children: activities.map((activity) => _buildActivityItem(activity, context)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    // Determine color and icon based on activity type
    Color textColor;
    IconData iconData;
    Gradient backgroundGradient;

    switch (activity['type']) {
      case 'training':
        textColor = AppColors.primaryBlue;
        iconData = Icons.fitness_center;
        backgroundGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(AppColors.primaryBlue.red, AppColors.primaryBlue.green, AppColors.primaryBlue.blue, 0.3),
            Color.fromRGBO(AppColors.primaryBlue.red, AppColors.primaryBlue.green, AppColors.primaryBlue.blue, 0.1),
          ],
        );
        break;
      case 'match':
        textColor = AppColors.primaryGreen;
        iconData = Icons.sports_soccer;
        backgroundGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(AppColors.primaryGreen.red, AppColors.primaryGreen.green, AppColors.primaryGreen.blue, 0.3),
            Color.fromRGBO(AppColors.primaryGreen.red, AppColors.primaryGreen.green, AppColors.primaryGreen.blue, 0.1),
          ],
        );
        break;
      case 'meeting':
        textColor = AppColors.primaryAmber;
        iconData = Icons.people;
        backgroundGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(AppColors.primaryAmber.red, AppColors.primaryAmber.green, AppColors.primaryAmber.blue, 0.3),
            Color.fromRGBO(AppColors.primaryAmber.red, AppColors.primaryAmber.green, AppColors.primaryAmber.blue, 0.1),
          ],
        );
        break;
      default:
        textColor = Colors.grey;
        iconData = Icons.event;
        backgroundGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(128, 128, 128, 0.3),
            const Color.fromRGBO(128, 128, 128, 0.1),
          ],
        );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl, // RTL support
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                iconData,
                color: textColor,
                size: AppTheme.iconSizeSmall + 4, // 20
              ),
              SizedBox(width: AppTheme.spacing + 4), // 12
              Text(
                activity['title'],
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          Text(
            activity['time'],
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}