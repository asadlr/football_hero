/// Enum representing different user roles in the FootballHero application
///
/// Each role represents a distinct type of user with specific permissions
/// and access levels within the application.
enum UserRole {
  /// A player who participates in sports activities
  player,

  /// A parent or guardian of a player
  parent,

  /// A coach who trains and manages players
  coach,

  /// A community manager responsible for community engagement
  communityManager,

  /// A mentor who provides guidance and support
  mentor;

  /// Converts the role to a human-readable string
  String get displayName {
    switch (this) {
      case UserRole.player:
        return 'Player';
      case UserRole.parent:
        return 'Parent';
      case UserRole.coach:
        return 'Coach';
      case UserRole.communityManager:
        return 'Community Manager';
      case UserRole.mentor:
        return 'Mentor';
    }
  }

  /// Determines if the role has administrative privileges
  bool get isAdministrative {
    return this == UserRole.coach || 
           this == UserRole.communityManager || 
           this == UserRole.mentor;
  }

  /// Parses a string to a UserRole
  /// 
  /// Returns the matching role or throws an ArgumentError if no match is found
  static UserRole fromString(String roleString) {
    try {
      return UserRole.values.firstWhere(
        (role) => role.name.toLowerCase() == roleString.toLowerCase(),
      );
    } catch (e) {
      throw ArgumentError('Invalid role: $roleString');
    }
  }

  /// Safely parses a string to a UserRole
  /// 
  /// Returns null if no matching role is found
  static UserRole? tryFromString(String roleString) {
    try {
      return UserRole.values.firstWhere(
        (role) => role.name.toLowerCase() == roleString.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}

/// Extension to add additional functionality to UserRole
extension UserRoleExtension on UserRole {
  /// Provides role-specific permissions
  List<String> get permissions {
    switch (this) {
      case UserRole.player:
        return ['view_profile', 'track_achievements'];
      case UserRole.parent:
        return ['view_child_profile', 'track_child_progress'];
      case UserRole.coach:
        return [
          'manage_team', 
          'create_training_sessions', 
          'track_player_progress'
        ];
      case UserRole.communityManager:
        return [
          'manage_events', 
          'create_announcements', 
          'manage_community_content'
        ];
      case UserRole.mentor:
        return [
          'provide_guidance', 
          'create_mentorship_programs', 
          'track_mentee_progress'
        ];
    }
  }
}