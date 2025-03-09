// lib\widgets\common\upcoming_events_card.dart

import 'package:flutter/material.dart';
import 'activity_item.dart';
import 'custom_card.dart';
import '../../localization/app_strings.dart';

class UpcomingEventsCard extends StatelessWidget {
  final List<Map<String, dynamic>> events;
  final Color? backgroundColor;

  const UpcomingEventsCard({
    Key? key,
    required this.events,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: AppStrings.upcomingEvents,
      height: 200,
      backgroundColor: backgroundColor,
      child: events.isEmpty
          ? Center(
              child: Text(
                AppStrings.noEvents,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textDirection: TextDirection.rtl,
              ),
            )
          : ListView.builder(
              itemCount: events.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final event = events[index];
                return ActivityItem(
                  title: event['title'],
                  time: event['time'],
                  color: event['type'] == 'training' ? Colors.blue : Colors.green,
                  onTap: () {
                    // Handle event tap
                  },
                );
              },
            ),
    );
  }
}

