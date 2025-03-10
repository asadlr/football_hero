// lib\widgets\common\team_discovery.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

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
            Text(
              isTeamMember ? 'Team Options' : 'Find Your Team',
              style: textTheme.headlineSmall,
            ),
            SizedBox(height: AppTheme.spacingDouble + 4),
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
                        color: Color.fromRGBO(
                          AppColors.primaryGreen.red,
                          AppColors.primaryGreen.green,
                          AppColors.primaryGreen.blue,
                          0.1
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Search Teams',
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          SizedBox(height: AppTheme.spacing / 2),
                          Text(
                            isTeamMember ? 'Find Other Teams' : 'Near Your Location',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                  AppColors.primaryGreen.red,
                                  AppColors.primaryGreen.green,
                                  AppColors.primaryGreen.blue,
                                  0.2
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search,
                                color: AppColors.primaryGreen,
                                size: AppTheme.iconSize + 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppTheme.spacingDouble),
                // Join by Invitation Option
                Expanded(
                  child: GestureDetector(
                    onTap: onJoinTeam,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(
                          AppColors.primaryAmber.red,
                          AppColors.primaryAmber.green,
                          AppColors.primaryAmber.blue,
                          0.1
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTeamMember ? 'My Team' : 'Join Team',
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                              color: AppColors.primaryAmber,
                            ),
                          ),
                          SizedBox(height: AppTheme.spacing / 2),
                          Text(
                            isTeamMember ? 'Team Details' : 'By Invitation',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                  AppColors.primaryAmber.red,
                                  AppColors.primaryAmber.green,
                                  AppColors.primaryAmber.blue,
                                  0.2
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isTeamMember ? Icons.group : Icons.link,
                                color: AppColors.primaryAmber,
                                size: AppTheme.iconSize + 6,
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