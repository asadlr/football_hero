// lib\widgets\home\community_manager_content.dart

import 'package:flutter/material.dart';
import '../common/upcoming_activities.dart';
import '../common/fan_zone_preview.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

class CommunityManagerHomeContent extends StatelessWidget {
  final Map<String, dynamic> userData;

  const CommunityManagerHomeContent({
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
            SizedBox(height: AppTheme.spacingDouble),
            
            // Community Overview Card
            _buildCommunityOverviewCard(context),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Community Management Tools
            _buildManagementToolsSection(context),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Upcoming Events
            UpcomingActivitiesSection(
              activities: _getCommunityEvents(),
              onViewAll: () {
                // Navigate to events screen
              },
            ),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Fan Zone Preview
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

  Widget _buildCommunityOverviewCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // Use communityColor for consistent community role styling
    final communityColor = AppColors.communityColor;
    
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
                  'Community Dashboard',
                  style: textTheme.headlineSmall,
                ),
                // Community badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A085),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    userData['community_name'] ?? 'Community',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingDouble),
            // Community Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox(
                  context,
                  'Total Members', 
                  '${userData['member_count'] ?? 0}',
                  const Color(0xFF16A085),
                ),
                SizedBox(width: AppTheme.spacingDouble),
                _buildStatBox(
                  context,
                  'Teams', 
                  '${userData['team_count'] ?? 0}',
                  AppColors.primaryBlue,
                ),
                SizedBox(width: AppTheme.spacingDouble),
                _buildStatBox(
                  context,
                  'Events (Month)', 
                  '${userData['events_count'] ?? 0}',
                  AppColors.primaryAmber,
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingDouble),
            // Engagement meter
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Community Engagement',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${userData['engagement_percentage'] ?? 65}%',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: (userData['engagement_percentage'] ?? 65) / 100,
                    minHeight: 10,
                    backgroundColor: AppColors.divider,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF16A085)),
                  ),
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

  Widget _buildManagementToolsSection(BuildContext context) {
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
            Text(
              'Community Management',
              style: textTheme.headlineSmall,
            ),
            SizedBox(height: AppTheme.spacingDouble),
            // Management tools grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
              children: [
                _buildManagementTool(
                  context,
                  'Events',
                  Icons.event,
                  AppColors.primaryAmber,
                  () {},
                ),
                _buildManagementTool(
                  context,
                  'Members',
                  Icons.people,
                  AppColors.primaryBlue,
                  () {},
                ),
                _buildManagementTool(
                  context,
                  'Teams',
                  Icons.group_work,
                  const Color(0xFF16A085),
                  () {},
                ),
                _buildManagementTool(
                  context,
                  'Announcements',
                  Icons.campaign,
                  AppColors.primaryRed,
                  () {},
                ),
                _buildManagementTool(
                  context,
                  'Facilities',
                  Icons.business,
                  AppColors.mentorColor,
                  () {},
                ),
                _buildManagementTool(
                  context,
                  'Reports',
                  Icons.bar_chart,
                  const Color(0xFF7F8C8D),
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTool(
    BuildContext context,
    String label, 
    IconData icon, 
    Color color, 
    VoidCallback onTap,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              size: AppTheme.iconSize + 8, 
              color: colorScheme.onSurface,
            ),
            SizedBox(height: AppTheme.spacing),
            Text(
              label,
              textAlign: TextAlign.center,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get community events
  List<Map<String, dynamic>> _getCommunityEvents() {
    // This would typically come from an API call
    return [
      {
        'type': 'match',
        'title': 'Community Tournament',
        'time': 'Sat, 10 AM',
        'isRequired': false,
      },
      {
        'type': 'meeting',
        'title': 'Community Board Meeting',
        'time': 'Tue, 7 PM',
        'isRequired': true,
      },
      {
        'type': 'training',
        'title': 'Coaching Workshop',
        'time': 'Wed, 6 PM',
        'isRequired': false,
      },
      {
        'type': 'meeting',
        'title': 'Parents Information Session',
        'time': 'Thu, 8 PM',
        'isRequired': true,
      },
    ];
  }
}