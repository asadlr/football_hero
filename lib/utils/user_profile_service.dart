import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import '../models/user_role.dart';

class UserProfileService {
  final _logger = Logger('UserProfileService');

  /// Fetch user profile data from Supabase
  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    try {
      // Fetch user profile and role details
      final userData = await Supabase.instance.client
          .from('users')
          .select('*')
          .eq('id', userId)
          .single();

      // Get role-specific data based on user role
      final roleString = userData['role'] as String?;
      final roleData = await _fetchRoleSpecificData(userId, roleString);

      return {
        ...userData,
        ...roleData,
        'role': roleString,
      };
    } catch (e) {
      _logger.severe('Error fetching user profile', e);
      rethrow;
    }
  }

  /// Get role-specific data from the appropriate table
  Future<Map<String, dynamic>> _fetchRoleSpecificData(
    String userId, 
    String? roleString
  ) async {
    try {
      final tableName = _getRoleTableName(roleString);
      if (tableName.isEmpty) return {};

      final data = await Supabase.instance.client
          .from(tableName)
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();
      
      return data ?? {};
    } catch (e) {
      _logger.warning('Error fetching role-specific data', e);
      return {};
    }
  }

  /// Determine the correct table name based on user role
  String _getRoleTableName(String? roleString) {
    switch (roleString) {
      case 'player':
        return 'players';
      case 'parent':
        return 'parents';
      case 'coach':
        return 'coaches';
      case 'community_manager':
        return 'community_managers';
      case 'mentor':
        return 'mentors';
      default:
        return '';
    }
  }

  /// Determine user role from role string
  UserRole determineUserRole(String? roleString) {
    return UserRole.tryFromString(roleString ?? 'player') ?? UserRole.player;
  }
}