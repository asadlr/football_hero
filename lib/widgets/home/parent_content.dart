// lib\widgets\home\parent_content.dart

import 'package:flutter/material.dart';
import '../common/upcoming_activities.dart';
import '../common/fan_zone_preview.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

class ParentHomeContent extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ParentHomeContent({
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
            
            // Child Info Card
            _buildChildInfoCard(context),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Parent Dashboard
            _buildParentDashboard(context),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Upcoming Activities
            UpcomingActivitiesSection(
              activities: _getParentActivities(),
              onViewAll: () {
                // Navigate to full calendar
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

  Widget _buildChildInfoCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final children = _getChildrenData();
    
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
              'My Children',
              style: textTheme.headlineSmall,
            ),
            SizedBox(height: AppTheme.spacing + 7),
            if (children.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppTheme.spacing + 2),
                child: Center(
                  child: Text(
                    'No children linked',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              )
            else
              Column(
                children: children.map((child) {
                  return _buildChildItem(context, child);
                }).toList(),
              ),
            
            SizedBox(height: AppTheme.spacing + 2),
            // Add child button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  // Link child functionality
                },
                icon: const Icon(Icons.add),
                label: const Text('Link a Child'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildItem(BuildContext context, Map<String, dynamic> child) {
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.spacing + 4),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: child['profile_image'] != null 
              ? NetworkImage(child['profile_image'])
              : null,
          child: child['profile_image'] == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
          backgroundColor: AppColors.primaryBlue,
        ),
        title: Text(
          child['name'] ?? 'Unknown',
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          '${child['team'] ?? 'No team'} • ${child['position'] ?? 'Unknown position'}',
          style: textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios, 
            size: AppTheme.iconSizeSmall,
          ),
          onPressed: () {
            // Navigate to child details
          },
        ),
      ),
    );
  }

  Widget _buildParentDashboard(BuildContext context) {
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
              'Parent Dashboard',
              style: textTheme.headlineSmall,
            ),
            SizedBox(height: AppTheme.spacingDouble),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardItem(
                  context,
                  'Upcoming Events',
                  '${userData['upcoming_events_count'] ?? 0}',
                  Icons.event,
                  AppColors.primaryBlue,
                  () {},
                ),
                SizedBox(width: AppTheme.spacingDouble),
                _buildDashboardItem(
                  context,
                  'Messages',
                  '${userData['unread_messages'] ?? 0}',
                  Icons.message,
                  AppColors.primaryRed,
                  () {},
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingDouble),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardItem(
                  context,
                  'Payments',
                  '${userData['pending_payments'] ?? 0}',
                  Icons.payment,
                  AppColors.primaryAmber,
                  () {},
                ),
                SizedBox(width: AppTheme.spacingDouble),
                _buildDashboardItem(
                  context,
                  'Sign-ups',
                  '${userData['pending_signups'] ?? 0}',
                  Icons.app_registration,
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

  Widget _buildDashboardItem(
    BuildContext context,
    String title, 
    String value, 
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
          padding: AppTheme.cardPadding,
          decoration: BoxDecoration(
            color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colorScheme.onSurface),
              SizedBox(height: AppTheme.spacing + 2),
              Text(
                value,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: AppTheme.spacing - 3),
              Text(
                title,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Get sample children data 
  List<Map<String, dynamic>> _getChildrenData() {
    // This would typically come from an API call based on parent ID
    // For now mocking sample data
    return [
      {
        'id': '1',
        'name': 'Daniel Cohen',
        'age': 12,
        'team': 'Junior Eagles',
        'position': 'Forward',
        'profile_image': null,
      },
      {
        'id': '2',
        'name': 'Sarah Cohen',
        'age': 9,
        'team': 'Mini Hawks',
        'position': 'Midfielder',
        'profile_image': null,
      },
    ];
  }

  // Get parent-specific activities
  List<Map<String, dynamic>> _getParentActivities() {
    // This would typically come from an API call
    return [
      {
        'type': 'match',
        'title': 'Daniel\'s Match vs FC United',
        'time': 'Sat, 10 AM',
        'isRequired': false,
      },
      {
        'type': 'training',
        'title': 'Sarah\'s Training Session',
        'time': 'Tue, 5 PM',
        'isRequired': false,
      },
      {
        'type': 'meeting',
        'title': 'Parents Meeting',
        'time': 'Wed, 6 PM',
        'isRequired': true,
      },
    ];
  }
}