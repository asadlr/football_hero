// lib\widgets\common\team_discovery.dart

import 'package:flutter/material.dart';

class TeamDiscoverySection extends StatelessWidget {
  final bool isTeamMember;
  final VoidCallback onSearchTeams;
  final VoidCallback onJoinTeam;

  const TeamDiscoverySection({
    super.key,
    this.isTeamMember = false,
    required this.onSearchTeams,
    required this.onJoinTeam,
  });

  @override
  Widget build(BuildContext context) {
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
            Text(
              isTeamMember ? 'Team Options' : 'Find Your Team',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Search Teams Option
                Expanded(
                  child: GestureDetector(
                    onTap: onSearchTeams,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0x1A2ECC71), // Light green with opacity
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Search Teams',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF27AE60),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isTeamMember ? 'Find Other Teams' : 'Near Your Location',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0x332ECC71),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Color(0xFF27AE60),
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Join by Invitation Option
                Expanded(
                  child: GestureDetector(
                    onTap: onJoinTeam,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0x1AF39C12), // Light orange with opacity
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTeamMember ? 'My Team' : 'Join Team',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFD35400),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isTeamMember ? 'Team Details' : 'By Invitation',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0x33F39C12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isTeamMember ? Icons.group : Icons.link,
                                color: const Color(0xFFD35400),
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}