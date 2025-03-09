// lib\widgets\common\upcoming_activities.dart

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart'; // Add this import for AppColors

class UpcomingActivitiesSection extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final VoidCallback? onViewAll;

  const UpcomingActivitiesSection({
    super.key,
    required this.activities,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (activities.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text('No upcoming activities'),
                ),
              )
            else
              Column(
                children: activities.map((activity) => _buildActivityItem(activity)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    // Define colors directly if AppColors is not available
    final Color primaryBlue = const Color(0xFF2979FF);
    final Color vibrantGreen = const Color(0xFF00E676);
    
    // Determine gradient based on activity type
    Gradient backgroundGradient;
    Color textColor;
    IconData iconData;

    switch (activity['type']) {
      case 'training':
        backgroundGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue.withOpacity(0.3),
            primaryBlue.withOpacity(0.1),
          ],
        );
        textColor = primaryBlue;
        iconData = Icons.fitness_center;
        break;
      case 'match':
        backgroundGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            vibrantGreen.withOpacity(0.3),
            vibrantGreen.withOpacity(0.1),
          ],
        );
        textColor = vibrantGreen;
        iconData = Icons.sports_soccer;
        break;
      default:
        backgroundGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.withOpacity(0.3),
            Colors.grey.withOpacity(0.1),
          ],
        );
        textColor = Colors.grey;
        iconData = Icons.event;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl, // RTL support
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                iconData,
                color: textColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                activity['title'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          Text(
            activity['time'],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2c3e50),
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}