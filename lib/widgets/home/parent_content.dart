// lib\widgets\home\parent_content.dart

import 'package:flutter/material.dart';
import '../common/upcoming_activities.dart';
import '../common/fan_zone_preview.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Child Info Card
            _buildChildInfoCard(),
            
            const SizedBox(height: 20),
            
            // Parent Dashboard
            _buildParentDashboard(),
            
            const SizedBox(height: 20),
            
            // Upcoming Activities
            UpcomingActivitiesSection(
              activities: _getParentActivities(),
              onViewAll: () {
                // Navigate to full calendar
              },
            ),
            
            const SizedBox(height: 20),
            
            // Fan Zone Preview
            FanZonePreview(
              onViewAll: () {
                // Navigate to fan zone
              },
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildChildInfoCard() {
    final children = _getChildrenData();
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Children',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 15),
            if (children.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: Text('No children linked')),
              )
            else
              Column(
                children: children.map((child) {
                  return _buildChildItem(child);
                }).toList(),
              ),
            
            const SizedBox(height: 10),
            // Add child button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  // Link child functionality
                },
                icon: const Icon(Icons.add),
                label: const Text('Link a Child'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3498DB),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildItem(Map<String, dynamic> child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
          backgroundColor: const Color(0xFF3498DB),
        ),
        title: Text(
          child['name'] ?? 'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${child['team'] ?? 'No team'} • ${child['position'] ?? 'Unknown position'}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () {
            // Navigate to child details
          },
        ),
      ),
    );
  }

  Widget _buildParentDashboard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Parent Dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardItem(
                  'Upcoming Events',
                  '${userData['upcoming_events_count'] ?? 0}',
                  Icons.event,
                  const Color(0x1A3498DB),
                  () {},
                ),
                const SizedBox(width: 16),
                _buildDashboardItem(
                  'Messages',
                  '${userData['unread_messages'] ?? 0}',
                  Icons.message,
                  const Color(0x1AE74C3C),
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardItem(
                  'Payments',
                  '${userData['pending_payments'] ?? 0}',
                  Icons.payment,
                  const Color(0x1AF39C12),
                  () {},
                ),
                const SizedBox(width: 16),
                _buildDashboardItem(
                  'Sign-ups',
                  '${userData['pending_signups'] ?? 0}',
                  Icons.app_registration,
                  const Color(0x1A2ECC71),
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
    String title, 
    String value, 
    IconData icon, 
    Color bgColor, 
    VoidCallback onTap
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF2C3E50)),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7F8C8D),
                ),
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