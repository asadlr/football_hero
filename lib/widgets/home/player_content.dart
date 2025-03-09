// lib\widgets\home\player_content.dart

import 'package:flutter/material.dart';
import '../common/achievements_card.dart';
import '../common/team_card_widget.dart';
import '../common/upcoming_events_card.dart';
import '../common/fan_club_news_card.dart';
import '../../localization/app_strings.dart';

class PlayerHomeContent extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Map<String, Color>? cardColors;

  const PlayerHomeContent({
    Key? key,
    required this.userData,
    this.cardColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data - in real app, this would come from userData
    final achievements = {
      'challenges': '3/5',
      'stars': '12',
      'profile': '80%',
    };

    // Team data (null if user has no team)
    final Map<String, dynamic>? teamData = userData['team_id'] != null ? {
      'name': userData['team_name'] ?? 'הקבוצה שלי',
      'logo_url': userData['team_logo_url'],
      'last_activity': 'אתמול, 18:30',
      'activity_summary': 'האימון האחרון הסתיים בהצלחה עם 15 שחקנים',
    } : null;

    final upcomingEvents = [
      {
        'title': 'אימון קבוצתי',
        'time': 'יום ג׳, 17:00',
        'type': 'training',
      },
      {
        'title': 'משחק קהילתי',
        'time': 'שבת, 10:00',
        'type': 'match',
      },
    ];

    final fanClubNews = [
      {
        'title': 'מכבי חיפה מנצחת 3-0 את הפועל באר שבע במשחק הגמר',
        'source': 'ONE',
        'time': 'לפני שעתיים',
      },
      {
        'title': 'שחקן חדש הצטרף למכבי תל אביב לקראת העונה החדשה',
        'source': 'ספורט 5',
        'time': 'היום, 12:30',
      },
    ];

    // Get the user's favorite club name - default if not found
    final clubName = userData['favorite_club'] ?? 'מכבי חיפה';

    return Directionality(
      textDirection: TextDirection.rtl, // RTL support for entire component
      child: ListView(
        padding: const EdgeInsets.only(top: 16.0, bottom: 80.0),
        children: [
          AchievementsCard(
            achievements: achievements,
            backgroundColor: cardColors?['achievements'],
          ),
          
          const SizedBox(height: 8),
          
          TeamCardWidget(
            teamData: teamData,
            onAddTeam: () {
              // Handle add team action
            },
            onViewTeam: () {
              // Handle view team action
            },
            backgroundColor: cardColors?['team'],
          ),
          
          const SizedBox(height: 8),
          
          UpcomingEventsCard(
            events: upcomingEvents,
            backgroundColor: cardColors?['events'],
          ),
          
          const SizedBox(height: 8),
          
          FanClubNewsCard(
            news: fanClubNews,
            clubName: clubName,
            backgroundColor: cardColors?['news'],
          ),
        ],
      ),
    );
  }
}