// lib\widgets\common\team_card.dart

import 'package:flutter/material.dart';
import '../../localization/app_strings.dart';

class TeamCard extends StatelessWidget {
  final Map<String, dynamic>? teamData;
  final VoidCallback onAddTeam;
  final VoidCallback onViewTeam;

  const TeamCard({
    Key? key,
    this.teamData,
    required this.onAddTeam,
    required this.onViewTeam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (teamData == null) {
      return _buildAddTeamCard();
    }
    return _buildTeamActivityCard();
  }

  Widget _buildAddTeamCard() {
    return GestureDetector(
      onTap: onAddTeam,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            AppStrings.addTeam,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamActivityCard() {
    return GestureDetector(
      onTap: onViewTeam,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2c3e50),
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 4),
                Text(
                  'פעילות אחרונה: ${teamData!['last_activity'] ?? ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Recent activity summary
            Text(
              teamData!['activity_summary'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2c3e50),
              ),
              textDirection: TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Add a "more" button at the bottom
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'הוסף קבוצה',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
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