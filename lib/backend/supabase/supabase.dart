import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import '/flutter_flow/flutter_flow_util.dart';

export 'database/database.dart';
export 'storage/storage.dart';

String _kSupabaseUrl = 'https://xdzepwgrzealmgdmfigl.supabase.co/';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhkemVwd2dyemVhbG1nZG1maWdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc1NzA5NzAsImV4cCI6MjAyMzE0Njk3MH0.BQ5t4N_1CFCsSAfimbXL8Qui-qlW7cbRDFFQWBUfQmk';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        anonKey: _kSupabaseAnonKey,
        debug: false,
      );
}
