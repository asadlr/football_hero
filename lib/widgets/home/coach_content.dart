// lib/widgets/home/coach_content.dart
import 'package:flutter/material.dart';
import 'base_home_content.dart';
import '../common/team_card_widget.dart';
import '../common/custom_card.dart'; // Import CustomCard
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart'; // Add AppColors import
import '../../localization/app_strings.dart';

class CoachHomeContent extends BaseHomeContent {
  const CoachHomeContent({
    super.key,
    required super.userData,
    super.cardColors,
  });

  @override
  List<Widget> buildContentSections(BuildContext context) {
    // Team data (null if user has no team)
    final Map<String, dynamic>? teamData = userData['team_id'] != null ? {
      'name': userData['team_name'] ?? AppStrings.get('my_team'),
      'logo_url': userData['team_logo_url'],
      'last_activity': 'אתמול, 18:30',
      'activity_summary': 'האימון האחרון הסתיים בהצלחה עם 15 שחקנים',
    } : null;

    // Define coach-specific data
    final upcomingTrainings = [
      {
        'title': 'אימון קבוצתי',
        'time': 'יום ג׳, 17:00',
        'type': 'training',
        'attendees': 15,
      },
      {
        'title': 'אימון כושר',
        'time': 'יום ה׳, 16:30',
        'type': 'training',
        'attendees': 12,
      },
    ];
    
    final teamPlayers = [
      {
        'name': 'יוסי כהן',
        'position': 'חלוץ',
        'attendance': 92,
      },
      {
        'name': 'אבי לוי',
        'position': 'מגן',
        'attendance': 88,
      },
      {
        'name': 'דני ישראלי',
        'position': 'שוער',
        'attendance': 95,
      },
    ];

    // Get card colors using the base class method
    final effectiveCardColors = getEffectiveCardColors('coach');

    return [
      TeamCardWidget(
        teamData: teamData,
        onAddTeam: () {
          // Handle add team action
        },
        onViewTeam: () {
          // Handle view team action
        },
        backgroundColor: effectiveCardColors['team'],
      ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Coach-specific: Training sessions card
      CustomCard(
        title: AppStrings.get('upcoming_trainings'),
        backgroundColor: effectiveCardColors['events'],
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcomingTrainings.length,
          itemBuilder: (context, index) {
            final training = upcomingTrainings[index];
            return ListTile(
              title: Text(training['title'] as String),
              subtitle: Text(training['time'] as String),
              trailing: Text('${training['attendees']} שחקנים'),
            );
          },
        ),
      ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Coach-specific: Team players card
      CustomCard(
        title: AppStrings.get('team_players'),
        backgroundColor: effectiveCardColors['players'],
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teamPlayers.length,
          itemBuilder: (context, index) {
            final player = teamPlayers[index];
            return ListTile(
              title: Text(player['name'] as String),
              subtitle: Text(player['position'] as String),
              trailing: CircularProgressIndicator(
                value: (player['attendance'] as int) / 100,
                strokeWidth: 5,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              ),
            );
          },
        ),
      ),
    ];
  }
}