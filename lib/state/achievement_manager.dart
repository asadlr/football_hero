// lib/state/achievement_manager.dart

import 'dart:async';
import 'package:flutter/material.dart';

class AchievementManager extends ChangeNotifier {
  // Singleton pattern
  static final AchievementManager _instance = AchievementManager._internal();
  factory AchievementManager() => _instance;
  AchievementManager._internal();

  // State
  bool _hasNewAchievements = false;
  Map<String, String> _achievements = {
    'אתגרים': '3/5',
    'כוכבים': '12',
    'כרטיס שחקן': '80%',
  };

  // Getters
  bool get hasNewAchievements => _hasNewAchievements;
  Map<String, String> get achievements => _achievements;

  // Mark achievements as seen
  void markAchievementsSeen() {
    if (_hasNewAchievements) {
      _hasNewAchievements = false;
      notifyListeners();
    }
  }

  // Update achievements (simulating new achievements coming in)
  void updateAchievements(Map<String, String> newAchievements) {
    _achievements = newAchievements;
    _hasNewAchievements = true;
    notifyListeners();
  }

  // Example method to simulate receiving a new achievement
  void simulateNewAchievement() {
    int currentStars = int.parse(_achievements['כוכבים'] ?? '0');
    _achievements['כוכבים'] = (currentStars + 1).toString();
    _hasNewAchievements = true;
    notifyListeners();
  }
}