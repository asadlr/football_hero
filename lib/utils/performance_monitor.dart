// lib/utils/performance_monitor.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Add this import for FrameTiming
import 'package:logging/logging.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  
  PerformanceMonitor._internal() {
    _logger = Logger('PerformanceMonitor');
    _timers = {};  // Add this line
    _metrics = {
      'avg_frame_build_time': 0.0,
      'frame_count': 0,
      'slow_frames': 0,
      'frozen_frames': 0,
      'memory_usage': 0.0,
    };
  }

  late final Logger _logger;
  late final Map<String, dynamic> _metrics;
  late final Map<String, Stopwatch> _timers;
  bool _isEnabled = false;

  void initialize() {
    _isEnabled = true;
    _setupFrameCallback();
    _logger.info('Performance monitoring initialized');
  }
  /// Start timing an operation
  void startTimer(String operation) {
    if (!_isEnabled) return;
    
    // Create a new stopwatch or reset existing one
    final stopwatch = Stopwatch()..start();
    _timers[operation] = stopwatch;
    _logger.fine('Started timing operation: $operation');
  }
/// Stop timing an operation and log the result
  void stopTimer(String operation) {
    if (!_isEnabled) return;
    
    final stopwatch = _timers[operation];
    if (stopwatch != null) {
      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;
      _logger.fine('$operation took $elapsedMs ms');
      
      // Log warning for slow operations
      if (elapsedMs > 100) {
        _logger.warning('Slow operation: $operation took $elapsedMs ms');
      }
      
      _timers.remove(operation);
    } else {
      _logger.warning('Tried to stop timer for operation that was not started: $operation');
    }
  }


  void _setupFrameCallback() {
    // Only setup callback if enabled
    if (!_isEnabled) return;
    
    WidgetsBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
      for (final timing in timings) {
        final buildDuration = timing.buildDuration;
        final buildMs = buildDuration.inMicroseconds / 1000.0;
        
        _metrics['frame_count'] = (_metrics['frame_count'] as int) + 1;
        _metrics['avg_frame_build_time'] = (_metrics['avg_frame_build_time'] as double) * 0.9 + buildMs * 0.1;
        
        // Track slow frames (> 16ms)
        if (buildMs > 16.0) {
          _metrics['slow_frames'] = (_metrics['slow_frames'] as int) + 1;
        }
        
        // Track frozen frames (> 700ms)
        if (buildMs > 700.0) {
          _metrics['frozen_frames'] = (_metrics['frozen_frames'] as int) + 1;
          _logger.warning('Frozen frame detected: ${buildMs.toStringAsFixed(1)}ms');
        }
      }
    });
  }
  
  Map<String, dynamic> getMetrics() {
    return Map.from(_metrics);
  }
  
  void resetMetrics() {
    // Skip if not enabled
    if (!_isEnabled) return;
    
    _metrics['frame_count'] = 0;
    _metrics['slow_frames'] = 0;
    _metrics['frozen_frames'] = 0;
    _metrics['avg_frame_build_time'] = 0.0;
    _logger.info('Performance metrics reset');
  }
  
  void logPerformanceReport() {
    // Skip if not enabled
    if (!_isEnabled) return;
    
    final frameCount = _metrics['frame_count'] as int;
    final slowFrames = _metrics['slow_frames'] as int;
    final frozenFrames = _metrics['frozen_frames'] as int;
    final avgFrameTime = _metrics['avg_frame_build_time'] as double;
    
    final slowFramePercent = frameCount > 0 ? (slowFrames / frameCount * 100).toStringAsFixed(1) : '0';
    
    _logger.info('=== Performance Report ===');
    _logger.info('Frames: $frameCount (${slowFrames} slow - ${slowFramePercent}%)');
    _logger.info('Frozen frames: $frozenFrames');
    _logger.info('Avg frame build time: ${avgFrameTime.toStringAsFixed(2)}ms');
    _logger.info('========================');
  }
  
  // Add methods for tracking specific operations if needed
  void trackEvent(String event, [Map<String, dynamic>? parameters]) {
    if (!_isEnabled) return;
    
    _logger.info('Event: $event${parameters != null ? ' $parameters' : ''}');
  }
}