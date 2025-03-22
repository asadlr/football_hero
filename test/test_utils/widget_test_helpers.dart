import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper functions for widget testing
class WidgetTestHelpers {
  /// Wrap a widget in MaterialApp for testing
  static Widget wrapWithMaterialApp(Widget widget) {
    return MaterialApp(home: widget);
  }
}

