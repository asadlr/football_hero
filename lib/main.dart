import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // אתחול Supabase
  await Supabase.initialize(
    url: 'https://xdzepwgrzealmgdmfigl.supabase.co', // החלף ב-URL של Supabase שלך
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhkemVwd2dyemVhbG1nZG1maWdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc1NzA5NzAsImV4cCI6MjAyMzE0Njk3MH0.BQ5t4N_1CFCsSAfimbXL8Qui-qlW7cbRDFFQWBUfQmk', // החלף במפתח האנונימי שלך
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Supabase Connection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatelessWidget {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> fetchFirstUser() async {
    print('Testing connection to Supabase...');
    try {
      // שליפת השורה הראשונה מהטבלה
      final response = await supabase
          .from('users') // טבלת users תחת סכמה public
          .select('*')
          .limit(1)
          .execute();

      if (response.error != null) {
        print('Error fetching data: ${response.error!.message}');
        throw Exception(response.error!.message);
      }

      if (response.data != null && response.data.isNotEmpty) {
        print('Connection to Supabase succeeded. First user: ${response.data}');
      } else {
        print('Connection succeeded, but no data found.');
      }
    } catch (e) {
      print('Failed to connect to Supabase: $e');
      throw Exception('Failed to connect to Supabase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchFirstUser();

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Supabase Connection'),
      ),
      body: Center(
        child: Text(
          'Check logs for details',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
