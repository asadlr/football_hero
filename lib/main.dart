import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Step 1: Log environment initialization
    debugPrint('Step 1: Loading environment variables...');
    await dotenv.load(fileName: "assets/.env");


    // Validate required environment variables
    debugPrint('Step 2: Validating environment variables...');
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env file');
    }
    debugPrint('Environment variables loaded successfully.');

    // Step 3: Initialize Supabase
    debugPrint('Step 3: Initializing Supabase...');
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    debugPrint('Supabase initialized successfully.');

    // Run the application
    debugPrint('Step 4: Running the application...');
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error during initialization: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building MyApp...');
    return MaterialApp(
      title: 'Supabase Connection Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SupabaseTestPage(),
    );
  }
}

class SupabaseTestPage extends StatefulWidget {
  const SupabaseTestPage({super.key});

  @override
  State<SupabaseTestPage> createState() => _SupabaseTestPageState();
}

class _SupabaseTestPageState extends State<SupabaseTestPage> {
  String _status = "Initializing...";
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _testSupabaseConnection();
  }

  Future<void> _testSupabaseConnection() async {
    debugPrint('Testing Supabase connection...');
    try {
      setState(() {
        _status = "Connecting to Supabase...";
        debugPrint(_status);
      });

      // Test connection by fetching the first row from the 'users' table
      debugPrint('Fetching data from the "users" table...');
      final response = await _supabase
          .from('users')
          .select()
          .limit(1)
          .maybeSingle();

      if (response == null) {
        setState(() {
          _status = "No data found in the 'users' table.";
          debugPrint(_status);
        });
      } else {
        setState(() {
          _status = "Connection successful! Data: $response";
          debugPrint(_status);
        });
      }
    } catch (e) {
      setState(() {
        _status = "Error: $e";
        debugPrint(_status);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building SupabaseTestPage...');
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Test')),
      body: Center(child: Text(_status)),
    );
  }
}
