// lib\widgets\common\team_card.dart

import 'package:flutter/material.dart';
import '../../localization/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class TeamCard extends StatelessWidget {
  final Map<String, dynamic>? teamData;
  final VoidCallback onAddTeam;
  final VoidCallback onViewTeam;

  const TeamCard({
    super.key,
    this.teamData,
    required this.onAddTeam,
    required this.onViewTeam,
  });

  @override
  Widget build(BuildContext context) {
    if (teamData == null) {
      return _buildAddTeamCard(context);
    }
    return _buildTeamActivityCard(context);
  }

  Widget _buildAddTeamCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return GestureDetector(
      onTap: onAddTeam,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(
            AppColors.primaryBlue.red,
            AppColors.primaryBlue.green,
            AppColors.primaryBlue.blue,
            0.1
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color.fromRGBO(
              AppColors.primaryBlue.red,
              AppColors.primaryBlue.green,
              AppColors.primaryBlue.blue,
              0.3
            ),
            width: 1
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            AppStrings.addTeam,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamActivityCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onViewTeam,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            // Team name and last activity in a clean layout without icons
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  teamData!['name'] ?? '',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: AppTheme.spacing / 2),
                Text(
                  'פעילות אחרונה: ${teamData!['last_activity'] ?? ''}',
                  style: textTheme.bodySmall,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingDouble - 4),
            // Recent activity summary
            Text(
              teamData!['activity_summary'] ?? '',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              textDirection: TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Add a "more" button at the bottom
            SizedBox(height: AppTheme.spacing),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'הוסף קבוצה',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}