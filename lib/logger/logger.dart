import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Comprehensive logging utility with environment-based configuration
class AppLogger {
  // Prevent direct instantiation
  const AppLogger._();

  /// Logging configuration enumeration
  static final _config = _LoggerConfig();

  /// Singleton logger instance
  static final Logger _logger = Logger(
    filter: _AppLogFilter(),
    printer: _AppLogPrinter(),
    output: _AppLogOutput(),
  );

  /// Log a debug message
  static void debug({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    if (_config.shouldLogDebug) {
      _logger.d(message, error: error);
      _reportToSentry(
        message: message, 
        level: SentryLevel.debug, 
        exception: error, 
        stackTrace: stackTrace,
      );
    }
  }

  /// Log an informational message
  static void info({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    if (_config.shouldLogInfo) {
      _logger.i(message, error: error);
      _reportToSentry(
        message: message, 
        level: SentryLevel.info, 
        exception: error, 
        stackTrace: stackTrace,
      );
    }
  }

  /// Log a warning message
  static void warning({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    if (_config.shouldLogWarning) {
      _logger.w(message, error: error);
      _reportToSentry(
        message: message, 
        level: SentryLevel.warning, 
        exception: error, 
        stackTrace: stackTrace,
      );
    }
  }

  /// Log an error message
  static void error({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    if (_config.shouldLogError) {
      _logger.e(message, error: error);
      _reportToSentry(
        message: message, 
        level: SentryLevel.error, 
        exception: error, 
        stackTrace: stackTrace,
      );
    }
  }

  /// Log a fatal message
  static void fatal({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    _logger.f(message, error: error);
    _reportToSentry(
      message: message, 
      level: SentryLevel.fatal, 
      exception: error, 
      stackTrace: stackTrace,
    );
  }

  /// Report to Sentry for error tracking
  static void _reportToSentry({
    required String message,
    required SentryLevel level,
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    if (_config.shouldReportToSentry) {
      Sentry.captureException(
        exception ?? message,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Logging configuration based on environment variables
class _LoggerConfig {
  /// Determine if debug logging is enabled
  bool get shouldLogDebug {
    return kDebugMode || 
           dotenv.env['LOG_DEBUG']?.toLowerCase() == 'true' || 
           dotenv.env['ENV']?.toLowerCase() == 'development';
  }

  /// Determine if info logging is enabled
  bool get shouldLogInfo {
    return kDebugMode || 
           dotenv.env['LOG_INFO']?.toLowerCase() == 'true' || 
           dotenv.env['ENV']?.toLowerCase() == 'development';
  }

  /// Determine if warning logging is enabled
  bool get shouldLogWarning {
    return kDebugMode || 
           dotenv.env['LOG_WARNING']?.toLowerCase() == 'true' || 
           dotenv.env['ENV']?.toLowerCase() == 'development';
  }

  /// Determine if error logging is enabled
  bool get shouldLogError {
    return true; // Always log errors
  }

  /// Determine if error reporting to Sentry is enabled
  bool get shouldReportToSentry {
    return dotenv.env['SENTRY_ENABLED']?.toLowerCase() == 'true';
  }
}

/// Custom log filter to control log levels
class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    final config = _LoggerConfig();
    
    switch (event.level) {
      case Level.debug:
        return config.shouldLogDebug;
      case Level.info:
        return config.shouldLogInfo;
      case Level.warning:
        return config.shouldLogWarning;
      case Level.error:
      case Level.fatal:
        return config.shouldLogError;
      default:
        return false;
    }
  }
}

/// Custom log printer for consistent formatting
class _AppLogPrinter extends PrettyPrinter {
  _AppLogPrinter() : super(
    methodCount: 2,
    errorMethodCount: 5,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  );
}

/// Custom log output for flexible logging
class _AppLogOutput extends ConsoleOutput {
  @override
  void output(OutputEvent event) {
    // Add custom output logic if needed
    // For example, you could add file logging or network logging here
    super.output(event);
  }
}