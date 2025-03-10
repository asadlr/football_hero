// lib/widgets/common/achievements_card.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class AchievementsCard extends StatelessWidget {
  final Map<String, String>? achievements;
  final Color? backgroundColor;

  const AchievementsCard({
    super.key,
    this.achievements,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Get theme styles for consistent appearance
    final textTheme = Theme.of(context).textTheme;
   
    // Get achievements data from props or use defaults
    final achievementsData = achievements ?? {
      'Challenges': '3/5',
      'Stars': '12',
      'Profile': '80%',
    };
   
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingDouble),
      child: Row(
        children: [
          Expanded(
            child: _buildAchievementBox(
              'כרטיס שחקן',
              achievementsData['Profile'] ?? '80%',
              AppColors.profileBox,
              textTheme,
              context,
            ),
          ),
          SizedBox(width: AppTheme.spacing),
          Expanded(
            child: _buildAchievementBox(
              'כוכבים',
              achievementsData['Stars'] ?? '12',
              AppColors.starsBox,
              textTheme,
              context,
              useStarIcon: true,
            ),
          ),
          SizedBox(width: AppTheme.spacing),
          Expanded(
            child: _buildAchievementBox(
              'אתגרים',
              achievementsData['Challenges'] ?? '3/5',
              AppColors.challengesBox,
              textTheme,
              context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBox(
    String title,
    String value,
    Color backgroundColor,
    TextTheme textTheme,
    BuildContext context, {
    bool useStarIcon = false,
  }) {
    // Determine color based on achievement type
    final Color themeColor = title.contains('אתגרים')
        ? AppColors.primaryBlue
        : title.contains('כוכבים')
            ? AppColors.primaryAmber
            : AppColors.primaryGreen;
    
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (useStarIcon)
            Icon(
              Icons.star,
              color: AppColors.primaryAmber,
              size: 18,
            )
          else
            Text(
              title,
              style: textTheme.labelMedium?.copyWith(
                color: themeColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: AppTheme.spacing),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: themeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppTheme.spacing),
          LinearProgressIndicator(
            value: title.contains('אתגרים')
                ? 0.6
                : title.contains('כוכבים')
                    ? 0.7
                    : 0.8,
            backgroundColor: Colors.white.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation(themeColor),
          ),
        ],
      ),
    );
  }
}