// lib\widgets\home\mentor_content.dart

import 'package:flutter/material.dart';
import '../common/upcoming_activities.dart';
import '../common/fan_zone_preview.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

class MentorHomeContent extends StatelessWidget {
  final Map<String, dynamic> userData;

  const MentorHomeContent({
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
            
            // Mentor Info Card
            _buildMentorInfoCard(context),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Mentees Section
            _buildMenteesSection(context),
            
            SizedBox(height: AppTheme.spacingDouble),
            
            // Upcoming Sessions
            UpcomingActivitiesSection(
              activities: _getMentorActivities(),
              onViewAll: () {
                // Navigate to full session list
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

  Widget _buildMentorInfoCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // Use mentorColor for consistent mentor role styling
    final mentorColor = AppColors.mentorColor;
    
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
                  'Mentor Dashboard',
                  style: textTheme.headlineSmall,
                ),
                // Expertise badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: mentorColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    userData['expertise'] ?? 'Football',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingDouble),
            // Mentor Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox(
                  context,
                  'Active Mentees', 
                  '${userData['active_mentees'] ?? 0}',
                  mentorColor,
                ),
                SizedBox(width: AppTheme.spacingDouble),
                _buildStatBox(
                  context,
                  'Hours This Month', 
                  '${userData['mentoring_hours_month'] ?? 0}',
                  AppColors.primaryBlue,
                ),
                SizedBox(width: AppTheme.spacingDouble),
                _buildStatBox(
                  context,
                  'Rating', 
                  userData['rating'] != null ? '${userData['rating']}/5' : 'N/A',
                  AppColors.primaryAmber,
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

  Widget _buildMenteesSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final mentees = _getMenteesData();
    
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
                  'My Mentees',
                  style: textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full mentee list
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacing + 2),
            if (mentees.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppTheme.spacing + 2),
                child: Center(
                  child: Text(
                    'No active mentees',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              )
            else
              Column(
                children: mentees.map((mentee) => _buildMenteeItem(context, mentee)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenteeItem(BuildContext context, Map<String, dynamic> mentee) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.spacing),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: mentee['profile_image'] != null 
              ? NetworkImage(mentee['profile_image'])
              : null,
          child: mentee['profile_image'] == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
          backgroundColor: AppColors.mentorColor,
        ),
        title: Text(
          mentee['name'] ?? 'Unknown',
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          '${mentee['age'] ?? ''} • ${mentee['focus_area'] ?? 'General mentoring'}',
          style: textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {
                // Message mentee
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: () {
                // Schedule session
              },
            ),
          ],
        ),
      ),
    );
  }

  // Get sample mentees data
  List<Map<String, dynamic>> _getMenteesData() {
    // This would typically come from an API call
    return [
      {
        'id': '1',
        'name': 'David Levy',
        'age': 16,
        'focus_area': 'Leadership',
        'profile_image': null,
      },
      {
        'id': '2',
        'name': 'Hannah Klein',
        'age': 15,
        'focus_area': 'Technical Skills',
        'profile_image': null,
      },
      {
        'id': '3',
        'name': 'Yossi Ben',
        'age': 17,
        'focus_area': 'Career Planning',
        'profile_image': null,
      },
    ];
  }

  // Get mentor-specific activities
  List<Map<String, dynamic>> _getMentorActivities() {
    // This would typically come from an API call
    return [
      {
        'type': 'meeting',
        'title': 'Mentoring Session - David',
        'time': 'Mon, 4 PM',
        'isRequired': true,
      },
      {
        'type': 'meeting',
        'title': 'Mentoring Session - Hannah',
        'time': 'Wed, 5 PM',
        'isRequired': true,
      },
      {
        'type': 'meeting',
        'title': 'Group Workshop',
        'time': 'Fri, 6 PM',
        'isRequired': true,
      },
    ];
  }
}