// lib/widgets/common/achievement_components.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../localization/app_strings.dart';
import 'custom_card.dart';
import 'achievement_box.dart';

/// A collection of achievement-related components used across the application
/// Follows centralized theme and localization best practices
class AchievementComponents {
  
  /// Achievement badge that displays a player's accomplishment with icon and label
  /// Uses centralized color theme and localized strings
  static Widget achievementBadge({
    required BuildContext context,
    required String achievementKey, 
    required IconData icon,
    required Color color,
    String? value,
    bool isCompleted = false,
  }) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return Tooltip(
      message: _getAchievementTooltip(achievementKey, context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isCompleted 
            ? AppColors.primaryGradient
            : LinearGradient(
                colors: [Colors.grey.withValues(alpha: 0.2), Colors.grey.withValues(alpha: 0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isCompleted) BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(
              icon,
              color: isCompleted ? Colors.white : AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _getAchievementLabel(achievementKey, context),
              style: TextStyle(
                color: isCompleted ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Achievement progress card to show progress towards a goal
  /// Uses centralized theme system and localization
  static Widget achievementProgressCard({
    required BuildContext context,
    required String title,
    required String description,
    required double progress,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 8,
                  width: MediaQuery.of(context).size.width * progress,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  AppStrings.get('achievement_complete'),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Achievement collection card that displays multiple achievements
  /// for a specific category
  static Widget achievementCollectionCard({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> achievements,
    VoidCallback? onViewAll,
  }) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: Text(
                      AppStrings.get('view_all'),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: achievements.map((achievement) {
                return AchievementBox(
                  title: achievement['title'],
                  value: achievement['value'].toString(),
                  icon: achievement['icon'],
                  color: achievement['color'] ?? AppColors.primary,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Achievement milestone card that displays a special accomplishment
  static Widget achievementMilestoneCard({
    required BuildContext context,
    required String title,
    required String description,
    required String imageUrl,
    required DateTime dateAchieved,
    VoidCallback? onShare,
  }) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: double.infinity,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.emoji_events,
                    color: AppColors.primary,
                    size: 48,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppStrings.get('milestone'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDateLocalized(dateAchieved, context),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                if (onShare != null)
                  ElevatedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share, size: 16),
                    label: Text(AppStrings.get('share_achievement')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to get achievement tooltip using AppStrings
  static String _getAchievementTooltip(String key, BuildContext context) {
    return '${AppStrings.get('achievement_tooltip_prefix')}${_getAchievementLabel(key, context)}';
  }

  /// Helper method to get achievement label using AppStrings
  static String _getAchievementLabel(String key, BuildContext context) {
    final labelKey = 'achievement_$key';
    // Try to get specific achievement label, fallback to key if not found
    final label = AppStrings.get(labelKey);
    return label != labelKey ? label : key;
  }

  /// Helper method to format date based on localization
  static String _formatDateLocalized(DateTime date, BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    if (isRTL) {
      // Hebrew date format
      return '${date.day}/${date.month}/${date.year}';
    } else {
      // English date format
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }
}