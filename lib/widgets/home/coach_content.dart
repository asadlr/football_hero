// lib\widgets\home\coach_content.dart

import 'package:flutter/material.dart';
import '../common/upcoming_activities.dart';
import '../common/fan_zone_preview.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

class CoachHomeContent extends StatelessWidget {
  final Map<String, dynamic> userData;

  const CoachHomeContent({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingDouble),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppTheme.spacingDouble + 4),
            
            // Coach Stats Card
            _buildCoachStatsCard(context),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Team Management Section
            _buildTeamManagementSection(context),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Upcoming Activities - Coach-specific
            UpcomingActivitiesSection(
              activities: _getCoachActivities(),
              onViewAll: () {
                // Navigate to full calendar
              },
            ),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Fan Zone Preview - Common component
            FanZonePreview(
              onViewAll: () {
                // Navigate to fan zone
              },
            ),
            
            SizedBox(height: AppTheme.spacingTriple),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachStatsCard(BuildContext context) {
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
                  'Coach Dashboard',
                  style: textTheme.headlineSmall,
                ),
                // License badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'License: ${userData['license_number'] ?? 'N/A'}',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingDouble),
            // Team Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox(
                  context,
                  'Team Size', 
                  '${userData['team_size'] ?? 0}',
                  AppColors.primaryBlue,
                ),
                SizedBox(width: AppTheme.spacingDouble),
                _buildStatBox(
                  context,
                  'Win Rate', 
                  '${userData['win_rate'] ?? 0}%',
                  AppColors.primaryGreen,
                ),
                SizedBox(width: AppTheme.spacingDouble),
                _buildStatBox(
                  context,
                  'Sessions', 
                  '${userData['training_sessions_month'] ?? 0}',
                  AppColors.primaryRed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    String label, 
    String value, 
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: color,
              ),
            ),
            SizedBox(height: AppTheme.spacing),
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamManagementSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
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
                  'Team Management',
                  style: textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to team management screen
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacing + 7),
            // Management Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildManagementOption(
                  context,
                  'Players',
                  Icons.people,
                  AppColors.primaryBlue,
                  () {},
                ),
                SizedBox(width: AppTheme.spacing + 4),
                _buildManagementOption(
                  context,
                  'Schedule',
                  Icons.calendar_month,
                  AppColors.primaryAmber,
                  () {},
                ),
                SizedBox(width: AppTheme.spacing + 4),
                _buildManagementOption(
                  context,
                  'Stats',
                  Icons.bar_chart,
                  AppColors.primaryGreen,
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementOption(
    BuildContext context,
    String title, 
    IconData icon, 
    Color color, 
    VoidCallback onTap
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon, 
                size: 28, 
                color: colorScheme.onSurface,
              ),
              SizedBox(height: AppTheme.spacing),
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get coach-specific activities
  List<Map<String, dynamic>> _getCoachActivities() {
    // This would typically come from an API call
    return [
      {
        'type': 'training',
        'title': 'Team Training Session',
        'time': 'Tue, 5 PM',
        'isRequired': true,
      },
      {
        'type': 'match',
        'title': 'League Match vs FC United',
        'time': 'Sat, 10 AM',
        'isRequired': true,
      },
      {
        'type': 'meeting',
        'title': 'Coaches Meeting',
        'time': 'Wed, 6 PM',
        'isRequired': true,
      },
    ];
  }
}