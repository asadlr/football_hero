// lib\widgets\home\mentor_content.dart

import 'package:flutter/material.dart';
import '../common/upcoming_activities.dart';
import '../common/fan_zone_preview.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Mentor Info Card
            _buildMentorInfoCard(),
            
            const SizedBox(height: 20),
            
            // Mentees Section
            _buildMenteesSection(),
            
            const SizedBox(height: 20),
            
            // Upcoming Sessions
            UpcomingActivitiesSection(
              activities: _getMentorActivities(),
              onViewAll: () {
                // Navigate to full session list
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

  Widget _buildMentorInfoCard() {
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
                  'Mentor Dashboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                // Expertise badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B59B6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    userData['expertise'] ?? 'Football',
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
            // Mentor Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox(
                  'Active Mentees', 
                  '${userData['active_mentees'] ?? 0}',
                  const Color(0x1A9B59B6),
                  const Color(0xFF8E44AD),
                ),
                const SizedBox(width: 16),
                _buildStatBox(
                  'Hours This Month', 
                  '${userData['mentoring_hours_month'] ?? 0}',
                  const Color(0x1A3498DB),
                  const Color(0xFF2980B9),
                ),
                const SizedBox(width: 16),
                _buildStatBox(
                  'Rating', 
                  userData['rating'] != null ? '${userData['rating']}/5' : 'N/A',
                  const Color(0x1AF39C12),
                  const Color(0xFFD35400),
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

  Widget _buildMenteesSection() {
    final mentees = _getMenteesData();
    
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
                  'My Mentees',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full mentee list
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (mentees.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: Text('No active mentees')),
              )
            else
              Column(
                children: mentees.map((mentee) => _buildMenteeItem(mentee)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenteeItem(Map<String, dynamic> mentee) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
          backgroundColor: const Color(0xFF9B59B6),
        ),
        title: Text(
          mentee['name'] ?? 'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${mentee['age'] ?? ''} • ${mentee['focus_area'] ?? 'General mentoring'}',
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