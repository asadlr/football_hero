// lib\widgets\home\coach_content.dart

import 'package:flutter/material.dart';
import '../common/upcoming_activities.dart';
import '../common/fan_zone_preview.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Coach Stats Card
            _buildCoachStatsCard(),
            
            const SizedBox(height: 20),
            
            // Team Management Section
            _buildTeamManagementSection(),
            
            const SizedBox(height: 20),
            
            // Upcoming Activities - Coach-specific
            UpcomingActivitiesSection(
              activities: _getCoachActivities(),
              onViewAll: () {
                // Navigate to full calendar
              },
            ),
            
            const SizedBox(height: 20),
            
            // Fan Zone Preview - Common component
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

  Widget _buildCoachStatsCard() {
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
                  'Coach Dashboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                // License badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'License: ${userData['license_number'] ?? 'N/A'}',
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
            // Team Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox(
                  'Team Size', 
                  '${userData['team_size'] ?? 0}',
                  const Color(0x1A3498DB),
                  const Color(0xFF2980B9),
                ),
                const SizedBox(width: 16),
                _buildStatBox(
                  'Win Rate', 
                  '${userData['win_rate'] ?? 0}%',
                  const Color(0x1A2ECC71),
                  const Color(0xFF27AE60),
                ),
                const SizedBox(width: 16),
                _buildStatBox(
                  'Sessions', 
                  '${userData['training_sessions_month'] ?? 0}',
                  const Color(0x1AE74C3C),
                  const Color(0xFFC0392B),
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

  Widget _buildTeamManagementSection() {
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
                  'Team Management',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to team management screen
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Management Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildManagementOption(
                  'Players',
                  Icons.people,
                  const Color(0x1A3498DB),
                  () {},
                ),
                const SizedBox(width: 12),
                _buildManagementOption(
                  'Schedule',
                  Icons.calendar_month,
                  const Color(0x1AF39C12),
                  () {},
                ),
                const SizedBox(width: 12),
                _buildManagementOption(
                  'Stats',
                  Icons.bar_chart,
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

  Widget _buildManagementOption(String title, IconData icon, Color bgColor, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: const Color(0xFF2C3E50)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
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