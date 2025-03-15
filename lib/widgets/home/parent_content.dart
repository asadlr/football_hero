// lib/widgets/home/parent_content.dart
import 'package:flutter/material.dart';
import 'base_home_content.dart';
import '../common/team_card_widget.dart';
import '../common/custom_card.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../localization/app_strings.dart';

class ParentHomeContent extends BaseHomeContent {
  const ParentHomeContent({
    super.key,
    required super.userData,
    super.cardColors,
  });

  @override
  List<Widget> buildContentSections(BuildContext context) {
    // Get children data
    final childrenData = _getChildrenData();
    
    // Get upcoming events
    final upcomingEvents = [
      {
        'title': 'אימון קבוצתי - יוסי',
        'time': 'יום ג׳, 17:00',
        'type': 'training',
        'child': 'יוסי',
      },
      {
        'title': 'משחק קהילתי - מיכל',
        'time': 'שבת, 10:00',
        'type': 'match',
        'child': 'מיכל',
      },
    ];
    
    // Get payments data
    final paymentsData = [
      {
        'description': 'תשלום חודשי - קבוצת כדורגל',
        'amount': 200,
        'status': 'שולם',
        'date': '01/03/2025',
      },
      {
        'description': 'ציוד ספורט - יוסי',
        'amount': 150,
        'status': 'ממתין',
        'date': '15/03/2025',
      },
    ];

    // Get card colors using the base class method
    final effectiveCardColors = getEffectiveCardColors('parent');

    return [
      // Children overview
      CustomCard(
        title: AppStrings.get('my_children'),
        backgroundColor: effectiveCardColors['children'],
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: childrenData.length,
          itemBuilder: (context, index) {
            final child = childrenData[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: child['image_url'] != null 
                    ? NetworkImage(child['image_url'] as String) 
                    : null,
                child: child['image_url'] == null 
                    ? Text(child['name'].toString().substring(0, 1)) 
                    : null,
              ),
              title: Text(child['name'] as String),
              subtitle: Text('${child['age']} שנים | ${child['team']}'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to child details
              },
            );
          },
        ),
      ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Upcoming events
      CustomCard(
        title: AppStrings.get('upcoming_events'),
        backgroundColor: effectiveCardColors['events'],
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            final event = upcomingEvents[index];
            return ListTile(
              title: Text(event['title'] as String),
              subtitle: Text(event['time'] as String),
              trailing: Chip(
                label: Text(event['child'] as String),
                backgroundColor: Colors.blue.withOpacity(0.1),
                labelStyle: TextStyle(fontSize: 12),
              ),
            );
          },
        ),
      ),
      
      SizedBox(height: ThemeConstants.sm),
      
      // Payments
      CustomCard(
        title: AppStrings.get('payments'),
        backgroundColor: effectiveCardColors['payments'],
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paymentsData.length,
          itemBuilder: (context, index) {
            final payment = paymentsData[index];
            final bool isPaid = payment['status'] == 'שולם';
            
            return ListTile(
              title: Text(payment['description'] as String),
              subtitle: Text('${payment['date']} | ${payment['amount']} ₪'),
              trailing: Chip(
                label: Text(payment['status'] as String),
                backgroundColor: isPaid 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.orange.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: isPaid ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
            );
          },
        ),
      ),
    ];
  }
  
  // Helper method to get children data
  List<Map<String, dynamic>> _getChildrenData() {
    // In a real app, this would come from the userData
    // For now, we'll use mock data
    return [
      {
        'id': '1',
        'name': 'יוסי כהן',
        'age': 12,
        'team': 'הפועל כדורגל נוער',
        'image_url': null,
      },
      {
        'id': '2',
        'name': 'מיכל כהן',
        'age': 10,
        'team': 'מכבי כדורגל נערות',
        'image_url': null,
      },
    ];
  }
}