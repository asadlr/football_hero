import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

// Configuration imports
import './config/app_config.dart';
import './config/router_config.dart';
import './config/dependency_injection.dart';
import './utils/error_handler.dart';
import './localization/localization_manager.dart';
import './providers/theme_provider.dart';
import './app_lifecycle_observer.dart';

// Separate concerns: Create a configuration class
class AppInitializer {
  /// Initialize app dependencies
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Configure logging
    _setupLogging();

    try {
      // Environment variable loading
      await _loadEnvironmentVariables();

      // Initialize Supabase
      await _initializeSupabase();

      // Initialize dependency injection
      dependencyInjection.init();
    } catch (error) {
      ErrorHandler.handleInitializationError(error);
    }
  }

  /// Set up logging with different levels based on build mode
  static void _setupLogging() {
    Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
      if (record.error != null) {
        debugPrint('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        debugPrint('Stack trace: ${record.stackTrace}');
      }
    });
  }

  /// Load environment variables with robust error handling
  static Future<void> _loadEnvironmentVariables() async {
    const List<String> possibleEnvFiles = [
      '.env',
      'assets/.env',
    ];

    for (final envFile in possibleEnvFiles) {
      try {
        await dotenv.load(fileName: envFile);
        _validateEnvironmentVariables();
        return;
      } catch (e) {
        debugPrint('Error loading env file: $envFile');
      }
    }

    throw Exception('Failed to load environment variables');
  }

  /// Validate critical environment variables
  static void _validateEnvironmentVariables() {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null || 
        supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception('Missing or invalid Supabase configuration');
    }
  }

  /// Initialize Supabase with configuration
  static Future<void> _initializeSupabase() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      debug: kDebugMode,
    );
  }
}

/// Main application entry point
Future<void> main() async {
  final stopwatch = Stopwatch()..start();
  
  // Initialize app dependencies
  await AppInitializer.initialize();
  
  // Run the app with providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalizationManager()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const FootballHeroApp(),
    ),
  );
  
  // Log app startup time
  stopwatch.stop();
  Logger('AppStartup').info('App started in ${stopwatch.elapsedMilliseconds}ms');
  
  // Start tracking metrics after app is launched
  WidgetsBinding.instance.addPostFrameCallback((_) {
    dependencyInjection.performanceMonitor.trackEvent('app_launched', {
      'startup_time_ms': stopwatch.elapsedMilliseconds,
    });
    
    // Also track with analytics service
    dependencyInjection.analyticsService.trackUserAction('app_launched', {
      'startup_time_ms': stopwatch.elapsedMilliseconds,
    });
  });
}

/// Main application widget
class FootballHeroApp extends StatefulWidget {
  const FootballHeroApp({super.key});

  @override
  State<FootballHeroApp> createState() => _FootballHeroAppState();
}

class _FootballHeroAppState extends State<FootballHeroApp> {
  late final AppLifecycleObserver _lifecycleObserver;
  
  @override
  void initState() {
    super.initState();
    _lifecycleObserver = AppLifecycleObserver();
  }
  
  @override
  void dispose() {
    _lifecycleObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the providers
    final localizationManager = Provider.of<LocalizationManager>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme configuration from provider
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      
      // Localization configuration
      supportedLocales: AppConfig.supportedLocales,
      localizationsDelegates: AppConfig.localizationsDelegates,
      locale: localizationManager.currentLocale,
      
      // Router configuration
      routerConfig: AppRouterConfig.router,
    );
  }
}