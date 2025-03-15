// lib/utils/error_handler.dart
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../localization/app_strings.dart';

class ErrorHandler {
  static final Logger _logger = Logger('ErrorHandler');
  
  // Private constructor to prevent instantiation
  ErrorHandler._();
  
  /// Handle general errors
  static void handleError(BuildContext context, dynamic error, {String? customMessage}) {
    _logger.severe('Error occurred', error);
    
    // Show a snackbar with the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(customMessage ?? AppStrings.get('general_error')),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: AppStrings.get('dismiss'),
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  
  /// Handle network errors with retry functionality
  static void handleNetworkError(
    BuildContext context, 
    dynamic error, 
    VoidCallback onRetry
  ) {
    _logger.severe('Network error', error);
    
    // Show a snackbar with retry option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.get('network_error')),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: AppStrings.get('retry'),
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            onRetry();
          },
        ),
      ),
    );
  }
  
  /// Handle form validation errors
  static void handleFormError(BuildContext context, Map<String, String> fieldErrors) {
    _logger.warning('Form validation errors', fieldErrors);
    
    // Display first error as a snackbar
    if (fieldErrors.isNotEmpty) {
      final firstError = fieldErrors.values.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(firstError),
          backgroundColor: Colors.orange[700],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
  /// Handle initialization errors
  static void handleInitializationError(dynamic error) {
    _logger.severe('Initialization error', error);
    // Log only - this is typically handled at the app startup level
  }
  
  /// Handle navigation errors
  static void handleNavigationError(BuildContext context, dynamic error) {
    _logger.severe('Navigation error', error);
    
    // Show a simple error dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get('navigation_error_title')),
        content: Text(AppStrings.get('navigation_error_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.get('ok')),
          ),
        ],
      ),
    );
  }
  
  /// Create a consistent error screen
  static Widget createErrorScreen(String message) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.get('error_title')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 80),
                const SizedBox(height: 24),
                Text(
                  message,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppStrings.get('go_back')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Show a loading overlay
  static OverlayEntry? showLoadingOverlay(BuildContext context, {String? message}) {
    try {
      final overlayState = Overlay.of(context);
      
      final entry = OverlayEntry(
        builder: (context) => Material(
          color: Colors.black.withAlpha(100),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(message),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
      
      // Insert safely after the frame is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        overlayState.insert(entry);
      });
      
      return entry;
    } catch (e) {
      _logger.warning('Could not show loading overlay: $e');
      return null;
    }
  }
  
  /// Hide loading overlay
  static void hideLoadingOverlay(OverlayEntry? overlayEntry) {
    overlayEntry?.remove();
  }
}