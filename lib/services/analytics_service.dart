// lib/services/analytics_service.dart
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

/// Analytics service for tracking user behavior and app usage
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  
  AnalyticsService._internal() {
    _logger = Logger('AnalyticsService');
    _sessionEvents = [];
    _userProperties = {};
  }

  late final Logger _logger;
  late final List<Map<String, dynamic>> _sessionEvents;
  late final Map<String, dynamic> _userProperties;
  String? _userId;
  bool _isEnabled = true;

  /// Initialize the analytics service
  void initialize({bool enabled = true}) {
    _isEnabled = enabled;
    _logger.info('Analytics initialized (enabled: $_isEnabled)');
    
    if (_isEnabled) {
      _trackAppOpen();
    }
  }
  
  /// Set user ID for user-specific analytics
  void setUserId(String userId) {
    _userId = userId;
    _logger.info('Analytics user ID set: $userId');
  }
  
  /// Set user property for segmentation
  void setUserProperty(String name, dynamic value) {
    if (!_isEnabled) return;
    
    _userProperties[name] = value;
    _logger.fine('User property set: $name = $value');
  }
  
  /// Track a screen view
  void trackScreenView(String screenName) {
    if (!_isEnabled) return;
    
    _trackEvent('screen_view', {
      'screen_name': screenName,
    });
  }
  
  /// Track a user action
  void trackUserAction(String action, [Map<String, dynamic>? parameters]) {
    if (!_isEnabled) return;
    
    _trackEvent('user_action', {
      'action': action,
      ...?parameters,
    });
  }
  
  /// Track content view (videos, profiles, etc.)
  void trackContentView(String contentType, String contentId, [Map<String, dynamic>? parameters]) {
    if (!_isEnabled) return;
    
    _trackEvent('content_view', {
      'content_type': contentType,
      'content_id': contentId,
      ...?parameters,
    });
  }
  
  /// Track search
  void trackSearch(String searchTerm, [Map<String, dynamic>? parameters]) {
    if (!_isEnabled) return;
    
    _trackEvent('search', {
      'search_term': searchTerm,
      ...?parameters,
    });
  }
  
  /// Track authentication events
  void trackAuthentication(String method, bool success, [String? errorMessage]) {
    if (!_isEnabled) return;
    
    _trackEvent('authentication', {
      'method': method,
      'success': success,
      if (errorMessage != null) 'error_message': errorMessage,
    });
  }
  
  /// Track errors encountered by users
  void trackError(String errorType, String message, [StackTrace? stackTrace]) {
    if (!_isEnabled) return;
    
    _trackEvent('error', {
      'error_type': errorType,
      'message': message,
      if (stackTrace != null) 'stack_trace': stackTrace.toString(),
    });
  }
  
  /// Internal method to track any event
  void _trackEvent(String eventName, Map<String, dynamic> parameters) {
    if (!_isEnabled) return;
    
    final eventData = {
      'event_name': eventName,
      'timestamp': DateTime.now().toIso8601String(),
      'parameters': parameters,
      if (_userId != null) 'user_id': _userId,
    };
    
    _sessionEvents.add(eventData);
    _logger.fine('Event tracked: $eventName ${parameters.toString()}');
    
    // In a real implementation, you would send this to your analytics backend
    // For now, we just log it in debug mode
    if (kDebugMode) {
      debugPrint('ANALYTICS: $eventName - ${parameters.toString()}');
    }
    
    // Periodically flush events in a real implementation
    // Here we just keep them in memory for the session
    if (_sessionEvents.length > 100) {
      _flushEvents();
    }
  }
  
  /// Track app open event
  void _trackAppOpen() {
    _trackEvent('app_open', {
      'app_version': '1.0.0', // Replace with actual version
    });
  }
  
  /// Track app close event
  void trackAppClose() {
    if (!_isEnabled) return;
    
    _trackEvent('app_close', {
      'session_duration_ms': DateTime.now().difference(_getSessionStartTime()).inMilliseconds,
      'events_count': _sessionEvents.length,
    });
    
    // Flush events when app closes
    _flushEvents();
  }
  
  /// Get session start time
  DateTime _getSessionStartTime() {
    final openEvent = _sessionEvents.firstWhere(
      (event) => event['event_name'] == 'app_open',
      orElse: () => {'timestamp': DateTime.now().toIso8601String()},
    );
    
    return DateTime.parse(openEvent['timestamp'] as String);
  }
  
  /// Flush events to backend (simulated)
  void _flushEvents() {
    if (_sessionEvents.isEmpty) return;
    
    _logger.info('Flushing ${_sessionEvents.length} analytics events');
    
    // In a real implementation, send events to your backend
    // For now, we just clear them
    _sessionEvents.clear();
  }
}