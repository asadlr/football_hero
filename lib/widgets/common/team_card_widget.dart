
// lib\widgets\common\team_card_widget.dart

import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'team_card.dart';
import '../../localization/app_strings.dart';

class TeamCardWidget extends StatelessWidget {
  final Map<String, dynamic>? teamData;
  final Function() onAddTeam;
  final Function() onViewTeam;
  final Color? backgroundColor;

  const TeamCardWidget({
    Key? key,
    this.teamData,
    required this.onAddTeam,
    required this.onViewTeam,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: AppStrings.myTeam,
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