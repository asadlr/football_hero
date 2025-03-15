// lib/widgets/home/mentor_content.dart
import 'package:flutter/material.dart';
import 'base_home_content.dart';
import '../common/custom_card.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../localization/app_strings.dart';

class MentorHomeContent extends BaseHomeContent {
  const MentorHomeContent({
    super.key,
    required super.userData,
    super.cardColors,
  });

  @override
  List<Widget> buildContentSections(BuildContext context) {
    // Get mentees data
    final menteeData = _getMenteesData();
    
    // Get upcoming sessions
    final upcomingSessions = [
      {
        'title': 'אימון אישי - יוסי כהן',
        'time': 'יום ד׳, 16:00',
        'location': 'מגרש אימונים מרכזי',
        'focus': 'טכניקת בעיטות',
      },
      {
        'title': 'מפגש הערכה - דני ישראלי',
        'time': 'יום ה׳, 18:30',
        'location': 'מגרש אימונים צפוני',
        'focus': 'הערכת ביצועים וקביעת יעדים',
      },
    ];
    
    // Get development plans
    final developmentPlans = [
      {
        'mentee': 'יוסי כהן',
        'goal': 'שיפור טכניקת כדרור',
        'progress': 0.65,
        'status': 'בתהליך',
      },
      {
        'mentee': 'דני ישראלי',
        'goal': 'חיזוק יכולת הגנתית',
        'progress': 0.40,
        'status': 'בתהליך',
      },
      {
        'mentee': 'מיכל לוי',
        'goal': 'פיתוח מנהיגות בשטח',
        'progress': 0.85,
        'status': 'כמעט הושלם',
      },
    ];

    // Get card colors using the base class method
    final effectiveCardColors = getEffectiveCardColors('mentor');

    return [
      // Mentees overview
      CustomCard(
        title: AppStrings.get('my_mentees'),
        backgroundColor: effectiveCardColors['mentees'],
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: menteeData.length,
          itemBuilder: (context, index) {
            final mentee = menteeData[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: mentee['image_url'] != null 
                    ? NetworkImage(mentee['image_url'] as String) 
                    : null,
                child: mentee['image_url'] == null 
                    ? Text(mentee['name'].toString().substring(0, 1)) 
                    : null,
              ),
              title: Text(mentee['name'] as String),
              subtitle: Text('${mentee['age']} שנים | ${mentee['position']}'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to mentee details
              },
            );
          },
        ),
      ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Upcoming sessions
      CustomCard(
        title: AppStrings.get('upcoming_sessions'),
        backgroundColor: effectiveCardColors['sessions'],
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcomingSessions.length,
          itemBuilder: (context, index) {
            final session = upcomingSessions[index];
            return ListTile(
              title: Text(session['title'] as String),
              subtitle: Text('${session['time']} | ${session['location']}'),
              trailing: Tooltip(
                message: session['focus'] as String,
                child: Icon(Icons.info_outline, size: 16),
              ),
            );
          },
        ),
      ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Development plans
      CustomCard(
        title: AppStrings.get('development_plans'),
        backgroundColor: effectiveCardColors['development'],
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: developmentPlans.length,
          itemBuilder: (context, index) {
            final plan = developmentPlans[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan['mentee'] as String,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        plan['status'] as String,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(plan['goal'] as String),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: plan['progress'] as double,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ];
  }
  
  // Helper method to get mentees data
  List<Map<String, dynamic>> _getMenteesData() {
    // In a real app, this would come from the userData
    // For now, we'll use mock data
    return [
      {
        'id': '1',
        'name': 'יוסי כהן',
        'age': 15,
        'position': 'חלוץ',
        'image_url': null,
      },
      {
        'id': '2',
        'name': 'דני ישראלי',
        'age': 16,
        'position': 'מגן',
        'image_url': null,
      },
      {
        'id': '3',
        'name': 'מיכל לוי',
        'age': 14,
        'position': 'קשרית',
        'image_url': null,
      },
    ];
  }
}