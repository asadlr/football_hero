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
    return teamData == null 
      ? _buildAddTeamCard(context) 
      : _buildTeamActivityCard(context);
  }

  Widget _buildAddTeamCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onAddTeam,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        padding: ThemeConstants.cardPadding,
        child: Center(
          child: Text(
            AppStrings.get('add_team'),
            style: theme.textTheme.titleMedium?.copyWith(
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
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onViewTeam,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: ThemeConstants.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            _buildTeamHeader(theme),
            SizedBox(height: ThemeConstants.sm),
            _buildActivitySummary(theme),
            SizedBox(height: ThemeConstants.sm),
            _buildMoreAction(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          teamData!['name'] ?? '',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: ThemeConstants.sm / 2),
        Text(
          'פעילות אחרונה: ${teamData!['last_activity'] ?? ''}',
          style: theme.textTheme.bodySmall,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildActivitySummary(ThemeData theme) {
    return Text(
      teamData!['activity_summary'] ?? '',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      textDirection: TextDirection.rtl,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMoreAction(ThemeData theme) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Text(
        'הוסף קבוצה',
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}