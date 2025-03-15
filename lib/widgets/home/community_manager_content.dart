// lib/widgets/home/community_manager_content.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'base_home_content.dart';
import '../common/component_library.dart';
import '../common/localized_text.dart';
import '../../utils/ui_utils.dart';
import '../../theme/app_theme.dart';
// Removed unused import: import '../../theme/app_colors.dart';
import '../../localization/localization_manager.dart';
import '../../localization/app_strings.dart';

class CommunityManagerHomeContent extends BaseHomeContent {
  const CommunityManagerHomeContent({
    super.key,
    required super.userData,
    super.cardColors,
  });

  @override
  List<Widget> buildContentSections(BuildContext context) {
    // Get current localization manager - using it through Provider later
    // Remove unused variable: final localizationManager = Provider.of<LocalizationManager>(context);
    
    // Get community data
    final communityData = _getCommunityData();
    
    // Get teams data
    final teamsData = _getTeamsData();
    
    // Get upcoming community events
    final upcomingEvents = _getUpcomingEvents();
    
    // Get announcements data
    final announcementsData = _getAnnouncementsData();

    // Get card colors using the base class method
    final effectiveCardColors = getEffectiveCardColors('community_manager');

    return [
      // Community overview with optimized rebuilds
      if (communityData != null)
        ComponentLibrary.buildCard(
          context: context,
          title: AppStrings.get('my_community'),
          backgroundColor: effectiveCardColors['community'],
          content: LocalizedDirectionality(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Community logo with optimized image loading
                  UIUtils.loadImage(
                    imageUrl: communityData['logo_url'] as String?,
                    width: 60,
                    height: 60,
                    placeholder: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Icon(Icons.group_work, color: Colors.grey[400], size: 30),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Community info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          communityData['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        LocalizedRichText(
                          textSpans: [
                            LocalizedTextSpan(
                              text: '${teamsData.length}',
                              isKey: false,
                            ),
                            LocalizedTextSpan(
                              text: ' ',
                              isKey: false,
                            ),
                            LocalizedTextSpan(
                              text: 'teams',
                            ),
                            LocalizedTextSpan(
                              text: ' | ',
                              isKey: false,
                            ),
                            LocalizedTextSpan(
                              text: '${communityData['members']}',
                              isKey: false,
                            ),
                            LocalizedTextSpan(
                              text: ' ',
                              isKey: false,
                            ),
                            LocalizedTextSpan(
                              text: 'members',
                            ),
                          ],
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          communityData['location'] as String,
                          style: TextStyle(color: Colors.grey[700], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Teams list with optimized lazy loading
      ComponentLibrary.buildCard(
        context: context,
        title: AppStrings.get('community_teams'),
        backgroundColor: effectiveCardColors['teams'],
        content: Column(
          children: [
            UIUtils.buildLazyList(
              items: teamsData.length > 3 ? teamsData.sublist(0, 3) : teamsData,
              emptyMessage: AppStrings.get('no_teams'),
              itemBuilder: (context, team, index) {
                return ComponentLibrary.buildListItem(
                  context: context,
                  title: team['name'] as String,
                  subtitle: '${team['age_group']} | ${team['coach']}',
                  leading: ComponentLibrary.buildAvatar(
                    name: team['name'] as String,
                    imageUrl: team['logo_url'] as String?,
                  ),
                  isLast: index == (teamsData.length > 3 ? 2 : teamsData.length - 1),
                );
              },
            ),
            
            if (teamsData.length > 3)
              TextButton(
                onPressed: () {
                  // View all teams
                },
                child: LocalizedText(
                  textKey: 'view_all_teams',
                ),
              ),
          ],
        ),
      ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Upcoming events with optimized event card
      ComponentLibrary.buildCard(
        context: context,
        title: AppStrings.get('upcoming_events'),
        backgroundColor: effectiveCardColors['events'],
        content: UIUtils.buildLazyList(
          items: upcomingEvents,
          emptyMessage: AppStrings.get('no_events'),
          itemBuilder: (context, event, index) {
            return _buildEventItem(
              context,
              event,
              index == upcomingEvents.length - 1,
            );
          },
        ),
      ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Announcements with optimized announcement cards
      ComponentLibrary.buildCard(
        context: context,
        title: AppStrings.get('announcements'),
        backgroundColor: effectiveCardColors['announcements'],
        content: UIUtils.buildLazyList(
          items: announcementsData,
          emptyMessage: AppStrings.get('no_announcements'),
          itemBuilder: (context, announcement, index) {
            return _buildAnnouncementItem(
              context,
              announcement,
              index == announcementsData.length - 1,
            );
          },
        ),
      ),
    ];
  }
  
  // Optimized event item builder
  Widget _buildEventItem(BuildContext context, Map<String, dynamic> event, bool isLast) {
    return ComponentLibrary.buildListItem(
      context: context,
      title: event['title'] as String,
      subtitle: '${event['time']} | ${event['location']}',
      trailing: ComponentLibrary.buildChip(
        label: '${event['participants']} ${AppStrings.get('participants')}',
        backgroundColor: Colors.blue.withAlpha(25),  // Using withAlpha instead of withOpacity
      ),
      isLast: isLast,
      onTap: () {
        // Navigate to event details
      },
    );
  }
  
  // Optimized announcement item builder
  Widget _buildAnnouncementItem(BuildContext context, Map<String, dynamic> announcement, bool isLast) {
    final bool isUrgent = announcement['urgent'] as bool;
    
    // Create the subtitle text as a string instead of a Column widget
    final subtitleText = '${announcement['content']}\n${announcement['date']}';
    
    return ComponentLibrary.buildListItem(
      context: context,
      title: announcement['title'] as String,
      subtitle: subtitleText,  // Fixed the type issue - using String instead of Column
      leading: isUrgent
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withAlpha(25),  // Using withAlpha instead of withOpacity
              ),
              child: const Center(
                child: Icon(
                  Icons.priority_high,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            )
          : null,
      isLast: isLast,
    );
  }
  
  // Helper methods with mock data
  Map<String, dynamic>? _getCommunityData() {
    return {
      'id': '1',
      'name': 'מועדון כדורגל אזורי',
      'logo_url': null,
      'location': 'חיפה והסביבה',
      'members': 120,
    };
  }
  
  List<Map<String, dynamic>> _getTeamsData() {
    return [
      {
        'id': '1',
        'name': 'מכבי נוער',
        'logo_url': null,
        'age_group': 'גילאי 16-18',
        'coach': 'יוסי לוי',
        'players': 22,
      },
      {
        'id': '2',
        'name': 'הפועל ילדים',
        'logo_url': null,
        'age_group': 'גילאי 12-14',
        'coach': 'משה כהן',
        'players': 18,
      },
      {
        'id': '3',
        'name': 'בנות מכבי',
        'logo_url': null,
        'age_group': 'גילאי 14-16',
        'coach': 'מיכל גולן',
        'players': 16,
      },
      {
        'id': '4',
        'name': 'פרחי כדורגל',
        'logo_url': null,
        'age_group': 'גילאי 8-10',
        'coach': 'דן גבע',
        'players': 24,
      },
    ];
  }
  
  List<Map<String, dynamic>> _getUpcomingEvents() {
    return [
      {
        'title': 'טורניר קהילתי',
        'time': 'יום שבת, 10:00',
        'location': 'מגרש מרכזי',
        'participants': 8,
        'type': 'tournament',
      },
      {
        'title': 'אסיפת מאמנים',
        'time': 'יום ג׳, 19:00',
        'location': 'מרכז קהילתי',
        'participants': 12,
        'type': 'meeting',
      },
      {
        'title': 'יום משפחות',
        'time': 'יום ו׳, 16:00',
        'location': 'פארק עירוני',
        'participants': 45,
        'type': 'community',
      },
    ];
  }
  
  List<Map<String, dynamic>> _getAnnouncementsData() {
    return [
      {
        'title': 'עדכון לוח אימונים',
        'content': 'לוח האימונים לחודש הבא עודכן, אנא בדקו את השינויים',
        'date': '03/03/2025',
        'urgent': false,
      },
      {
        'title': 'ציוד חדש הגיע',
        'content': 'ציוד חדש הגיע למחסן. כל קבוצה יכולה לקחת 5 כדורים חדשים',
        'date': '01/03/2025',
        'urgent': true,
      },
    ];
  }
}