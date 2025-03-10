// lib\widgets\common\upcoming_events_card.dart

import 'package:flutter/material.dart';
import 'activity_item.dart';
import 'custom_card.dart';
import '../../localization/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

class UpcomingEventsCard extends StatelessWidget {
  final List<Map<String, dynamic>> events;
  final Color? backgroundColor;

  const UpcomingEventsCard({
    super.key,
    required this.events,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return CustomCard(
      title: AppStrings.upcomingEvents,
      height: 200,
      backgroundColor: backgroundColor,
      child: events.isEmpty
          ? Center(
              child: Text(
                AppStrings.noEvents,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
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
                  color: event['type'] == 'training' 
                      ? AppColors.primaryBlue 
                      : AppColors.primaryGreen,
                  onTap: () {
                    // Handle event tap
                  },
                );
              },
            ),
    );
  }
}