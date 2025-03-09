// lib\widgets\common\achievements_card.dart

import 'package:flutter/material.dart';
import 'achievement_box.dart';
import 'custom_card.dart';
import '../../localization/app_strings.dart';
import '../../theme/app_colors.dart';

class AchievementsCard extends StatelessWidget {
  final Map<String, dynamic> achievements;
  final Color? backgroundColor;

  const AchievementsCard({
    Key? key,
    required this.achievements,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a subtle gradient background for the card
    final cardGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        backgroundColor ?? AppColors.achievements,
        (backgroundColor ?? AppColors.achievements).withOpacity(0.8),
      ],
    );

    return CustomCard(
      title: AppStrings.personalAchievements,
      height: 180,
      gradient: cardGradient,
      borderRadius: 20.0, // Slightly more rounded corners
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.rtl, // RTL support
        children: [
          // Challenges box with gradient
          AchievementBox(
            title: AppStrings.challenges,
            value: achievements['challenges'] ?? '0',
            icon: Icons.flag,
            color: AppColors.primaryBlue,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.challengesBox,
                AppColors.challengesBox.withOpacity(0.7),
              ],
            ),
          ),
          
          // Stars box with gradient
          AchievementBox(
            title: AppStrings.stars,
            value: achievements['stars'] ?? '0',
            icon: Icons.star,
            color: AppColors.energeticOrange,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.starsBox,
                AppColors.starsBox.withOpacity(0.7),
              ],
            ),
          ),
          
          // Profile box with gradient
          AchievementBox(
            title: AppStrings.playerCard,
            value: achievements['profile'] ?? '0%',
            icon: Icons.person,
            color: AppColors.vibrantGreen,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.profileBox,
                AppColors.profileBox.withOpacity(0.7),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
