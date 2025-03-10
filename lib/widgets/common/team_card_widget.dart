// lib\widgets\common\team_card_widget.dart

import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'team_card.dart';
import '../../localization/app_strings.dart';
import '../../theme/app_theme.dart';

class TeamCardWidget extends StatelessWidget {
  final Map<String, dynamic>? teamData;
  final Function() onAddTeam;
  final Function() onViewTeam;
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
    // Use CustomCard which is already themed
    return CustomCard(
      title: AppStrings.myTeam,
      height: 160,
      backgroundColor: backgroundColor,
      borderRadius: AppTheme.cardBorderRadius,
      child: TeamCard(
        teamData: teamData,
        onAddTeam: onAddTeam,
        onViewTeam: onViewTeam,
      ),
    );
  }
}