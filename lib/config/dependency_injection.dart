//lib\config\dependency_injection.dart

//lib\config\dependency_injection.dart
import 'dart:async';
import 'package:logging/logging.dart';

import '../services/quick_action_service.dart';
import '../utils/user_profile_service.dart';
import '../state/achievement_manager.dart';
import '../utils/performance_monitor.dart';
import '../services/analytics_service.dart';

/// Centralized dependency injection configuration
class DependencyInjection {
  // Logger for tracking initialization
  static final _logger = Logger('DependencyInjection');

  // Singleton instance
  static final DependencyInjection _instance = DependencyInjection._internal();
  factory DependencyInjection() => _instance;
  DependencyInjection._internal();

  // Service instances
  QuickActionService? _quickActionService;
  UserProfileService? _userProfileService;
  AchievementManager? _achievementManager;
  PerformanceMonitor? _performanceMonitor;
  AnalyticsService? _analyticsService;

  // Initialization tracking
  bool _isInitialized = false;

  // Getters with null safety
  QuickActionService get quickActionService {
    _ensureInitialized();
    return _quickActionService!;
  }

  UserProfileService get userProfileService {
    _ensureInitialized();
    return _userProfileService!;
  }

  AchievementManager get achievementManager {
    _ensureInitialized();
    return _achievementManager!;
  }

  PerformanceMonitor get performanceMonitor {
    _ensureInitialized();
    return _performanceMonitor!;
  }

  AnalyticsService get analyticsService {
    _ensureInitialized();
    return _analyticsService!;
  }

  /// Initialize all services
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Initialize services with fallback to sync initialization
      _quickActionService = QuickActionService();
      _userProfileService = UserProfileService();
      _achievementManager = AchievementManager();

      // Ensure performance monitor initialization
      _performanceMonitor = PerformanceMonitor();
      await _safeInitialize(() async {
        _performanceMonitor!.initialize();
      });

      // Ensure analytics service initialization
      _analyticsService = AnalyticsService();
      await _safeInitialize(() async {
        _analyticsService!.initialize(enabled: true);
      });

      // Mark as initialized
      _isInitialized = true;

      _logger.info('Dependency Injection initialized successfully');
    } catch (e) {
      _logger.severe('Dependency Injection initialization failed', e);
      rethrow;
    }
  }

  /// Safe initialization method to handle various initialization patterns
  Future<void> _safeInitialize(Future<void> Function() initializeMethod) async {
    try {
      await initializeMethod();
    } catch (e) {
      _logger.warning('Service initialization failed', e);
      rethrow;
    }
  }

  /// Ensure services are initialized before access
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'DependencyInjection must be initialized before accessing services. '
        'Call DependencyInjection().init() first.'
      );
    }
  }

  /// Reset all services
  Future<void> reset() async {
    _isInitialized = false;
    _quickActionService = null;
    _userProfileService = null;
    _achievementManager = null;
    _performanceMonitor = null;
    _analyticsService = null;
    await init();
  }
}

// Global instance for easy access
final dependencyInjection = DependencyInjection();