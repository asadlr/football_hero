import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'team_card.dart';
import '../../localization/app_strings.dart';

class TeamCardWidget extends StatelessWidget {
  final Map<String, dynamic>? teamData;
  final VoidCallback onAddTeam;
  final VoidCallback onViewTeam;
  final Color? backgroundColor;

  const TeamCardWidget({
    super.key,
    this.teamData,
    required this.onAddTeam,
    required this.onViewTeam,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: AppStrings.get('my_team'),
      height: 160,
      backgroundColor: backgroundColor,
      child: TeamCard(
        teamData: teamData,
        onAddTeam: onAddTeam,
        onViewTeam: onViewTeam,
      ),
    );
  }
}