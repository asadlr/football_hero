import 'package:flutter/material.dart';
import '../models/user_role.dart';

class QuickAction {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const QuickAction({
    required this.icon, 
    required this.title, 
    required this.onTap
  });
}

class QuickActionService {
  /// Generate quick actions based on user role
  List<QuickAction> getQuickActions(
    UserRole role, 
    void Function(String) showSnackBarMessage
  ) {
    final List<QuickAction> actions = [
      QuickAction(
        icon: Icons.photo_camera,
        title: 'העלאת תמונה',
        onTap: () => showSnackBarMessage('העלאת תמונה בקרוב'),
      )
    ];
    
    actions.addAll(_getRoleSpecificActions(role, showSnackBarMessage));
    
    return actions;
  }

  /// Get role-specific quick actions
  List<QuickAction> _getRoleSpecificActions(
    UserRole role, 
    void Function(String) showSnackBarMessage
  ) {
    switch (role) {
      case UserRole.player:
        return [
          QuickAction(
            icon: Icons.video_call,
            title: 'הוספת וידאו',
            onTap: () => showSnackBarMessage('העלאת וידאו בקרוב'),
          ),
          QuickAction(
            icon: Icons.bar_chart,
            title: 'הוספת סטטיסטיקות',
            onTap: () => showSnackBarMessage('הזנת סטטיסטיקות בקרוב'),
          ),
        ];
      case UserRole.coach:
        return [
          QuickAction(
            icon: Icons.event,
            title: 'הוספת אימון',
            onTap: () => showSnackBarMessage('הגדרת אימון בקרוב'),
          ),
          QuickAction(
            icon: Icons.people,
            title: 'ניהול קבוצה',
            onTap: () => showSnackBarMessage('ניהול קבוצה בקרוב'),
          ),
        ];
      case UserRole.parent:
        return [
          QuickAction(
            icon: Icons.family_restroom,
            title: 'קישור שחקן',
            onTap: () => showSnackBarMessage('קישור שחקן בקרוב'),
          ),
        ];
      case UserRole.communityManager:
        return [
          QuickAction(
            icon: Icons.event,
            title: 'הוספת אירוע',
            onTap: () => showSnackBarMessage('יצירת אירוע בקרוב'),
          ),
          QuickAction(
            icon: Icons.campaign,
            title: 'הודעה קהילתית',
            onTap: () => showSnackBarMessage('הודעה קהילתית בקרוב'),
          ),
        ];
      case UserRole.mentor:
        return [
          QuickAction(
            icon: Icons.school,
            title: 'הוספת שיעור',
            onTap: () => showSnackBarMessage('יצירת שיעור בקרוב'),
          ),
        ];
    }
  }
}