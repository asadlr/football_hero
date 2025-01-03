import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppLogger {
  static final Logger _logger = Logger(
    filter: CustomFilter(),
    printer: PrettyPrinter(),
    output: ConsoleOutput(),
  );

  static void debug(String message) {
    if (_isDevelopment) _logger.d(message);
  }

  static void info(String message) {
    if (_shouldLogInfo) _logger.i(message);
  }

  static void warning(String message) {
    if (_shouldLogWarning) _logger.w(message);
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    if (_shouldLogError) _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static bool get _isDevelopment {
    return dotenv.env['ENV'] == 'development';
  }

  static bool get _shouldLogInfo => dotenv.env['LOG_INFO'] == 'true' || _isDevelopment;
  static bool get _shouldLogWarning => dotenv.env['LOG_WARNING'] == 'true' || _isDevelopment;
  static bool get _shouldLogError => dotenv.env['LOG_ERROR'] == 'true' || _isDevelopment;
}

class CustomFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // Control the log levels based on environment variables or default to development mode logging
    final isProduction = dotenv.env['ENV'] == 'production';
    if (isProduction) {
      // Only log warnings and errors in production
      return event.level.index >= Level.warning.index;
    } else {
      // Log everything in development
      return true;
    }
  }
}
