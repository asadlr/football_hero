// lib\widgets\home\community_manager_content.dart

import 'package:flutter/material.dart';
import '../common/upcoming_activities.dart';
import '../common/fan_zone_preview.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Community Overview Card
            _buildCommunityOverviewCard(),
            
            const SizedBox(height: 20),
            
            // Community Management Tools
            _buildManagementToolsSection(),
            
            const SizedBox(height: 20),
            
            // Upcoming Events
            UpcomingActivitiesSection(
              activities: _getCommunityEvents(),
              onViewAll: () {
                // Navigate to events screen
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

  Widget _buildCommunityOverviewCard() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Community Dashboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Community Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox(
                  'Total Members', 
                  '${userData['member_count'] ?? 0}',
                  const Color(0x1A16A085),
                  const Color(0xFF16A085),
                ),
                const SizedBox(width: 16),
                _buildStatBox(
                  'Teams', 
                  '${userData['team_count'] ?? 0}',
                  const Color(0x1A3498DB),
                  const Color(0xFF2980B9),
                ),
                const SizedBox(width: 16),
                _buildStatBox(
                  'Events (Month)', 
                  '${userData['events_count'] ?? 0}',
                  const Color(0x1AF39C12),
                  const Color(0xFFD35400),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Engagement meter
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Community Engagement',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                    Text(
                      '${userData['engagement_percentage'] ?? 65}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: (userData['engagement_percentage'] ?? 65) / 100,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFBDC3C7),
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

  Widget _buildStatBox(String label, String value, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementToolsSection() {
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
              'Community Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
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
                  'Events',
                  Icons.event,
                  const Color(0x1AF39C12),
                  () {},
                ),
                _buildManagementTool(
                  'Members',
                  Icons.people,
                  const Color(0x1A3498DB),
                  () {},
                ),
                _buildManagementTool(
                  'Teams',
                  Icons.group_work,
                  const Color(0x1A16A085),
                  () {},
                ),
                _buildManagementTool(
                  'Announcements',
                  Icons.campaign,
                  const Color(0x1AE74C3C),
                  () {},
                ),
                _buildManagementTool(
                  'Facilities',
                  Icons.business,
                  const Color(0x1A9B59B6),
                  () {},
                ),
                _buildManagementTool(
                  'Reports',
                  Icons.bar_chart,
                  const Color(0x1A7F8C8D),
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTool(String label, IconData icon, Color bgColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF2C3E50)),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
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