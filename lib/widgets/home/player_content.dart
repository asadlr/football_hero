// lib/widgets/home/player_content.dart
import 'package:flutter/material.dart';
import 'base_home_content.dart';
import '../common/team_card_widget.dart';
import '../common/component_library.dart';
import '../../theme/app_theme.dart';
import '../../localization/app_strings.dart';

class PlayerHomeContent extends BaseHomeContent {
  const PlayerHomeContent({
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

    // Define the missing variables
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

    // Get card colors using the base class method
    final effectiveCardColors = getEffectiveCardColors('player');

    return [
      // Team Card - Still using specialized TeamCardWidget
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
      
      // Upcoming Events - Using Component Library
      ComponentLibrary.buildCard(
        context: context,
        title: AppStrings.get('upcoming_events'),
        backgroundColor: effectiveCardColors['events'],
        content: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            final event = upcomingEvents[index];
            final isTraining = event['type'] == 'training';
            
            return ComponentLibrary.buildListItem(
              context: context,
              title: event['title'] as String,
              subtitle: event['time'] as String,
              leading: ComponentLibrary.buildAvatar(
                name: isTraining ? 'T' : 'M',
                backgroundColor: isTraining ? Colors.blue[100] : Colors.green[100],
              ),
              isLast: index == upcomingEvents.length - 1,
            );
          },
        ),
      ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Fan Club News - Using Component Library
      ComponentLibrary.buildCard(
        context: context,
        title: '${AppStrings.get('fan_club')}: $clubName',
        backgroundColor: effectiveCardColors['news'],
        trailing: ComponentLibrary.buildChip(
          label: AppStrings.get('news'),
          backgroundColor: Colors.orange.withOpacity(0.1),
          textColor: Colors.orange,
        ),
        content: fanClubNews.isEmpty 
            ? Center(child: Text(AppStrings.get('no_news')))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fanClubNews.length,
                itemBuilder: (context, index) {
                  final news = fanClubNews[index];
                  return ComponentLibrary.buildListItem(
                    context: context,
                    title: news['title'] as String,
                    subtitle: '${news['source']} • ${news['time']}',
                    isLast: index == fanClubNews.length - 1,
                  );
                },
              ),
      ),
    ];
  }
}