// lib/widgets/debug/performance_dashboard.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../../config/dependency_injection.dart';
import '../../utils/performance_monitor.dart'; // Add this import

class PerformanceDashboard extends StatefulWidget {
  const PerformanceDashboard({super.key}); // Fixed super parameter

  @override
  State<PerformanceDashboard> createState() => _PerformanceDashboardState();
}

class _PerformanceDashboardState extends State<PerformanceDashboard> {
  late Timer _refreshTimer;
  late Map<String, dynamic> _metrics;
  
  @override
  void initState() {
    super.initState();
    _metrics = dependencyInjection.performanceMonitor.getMetrics();
    
    // Refresh metrics every second
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _metrics = dependencyInjection.performanceMonitor.getMetrics();
      });
    });
  }
  
  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              dependencyInjection.performanceMonitor.resetMetrics();
              setState(() {
                _metrics = dependencyInjection.performanceMonitor.getMetrics();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Frame Metrics'),
            _buildMetricCard('Total Frames', '${_metrics['frame_count']}'),
            _buildMetricCard('Slow Frames', '${_metrics['slow_frames']}'),
            _buildMetricCard('Frozen Frames', '${_metrics['frozen_frames']}'),
            _buildMetricCard('Avg Frame Build Time', '${(_metrics['avg_frame_build_time'] as double).toStringAsFixed(2)} ms'),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('Actions'),
            ElevatedButton(
              onPressed: () {
                dependencyInjection.performanceMonitor.logPerformanceReport();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Performance report logged')),
                );
              },
              child: const Text('Log Performance Report'),
            ),
            
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () {
                // Simulate a heavy operation
                final stopwatch = Stopwatch()..start();
                // Use sum to avoid compiler warning about unused variable
                int sum = 0;
                for (int i = 0; i < 10000000; i++) {
                  sum += i;
                }
                // Print sum to use the variable
                debugPrint('Sum: $sum');
                stopwatch.stop();
                
                setState(() {});
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Heavy operation completed in ${stopwatch.elapsedMilliseconds}ms')),
                );
              },
              child: const Text('Simulate Heavy Operation'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildMetricCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}