// lib\screens\home.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import '../models/user_role.dart' as models;
import 'profile.dart';
import '../localization/app_strings.dart';

// Import role-specific content providers
import '../widgets/home/player_content.dart';
import '../widgets/home/coach_content.dart';
import '../widgets/home/parent_content.dart';
import '../widgets/home/mentor_content.dart';
import '../widgets/home/community_manager_content.dart';

// App color palette
class AppColors {
  static const Color achievements = Color(0xFFF5F5F5);
  static const Color team = Color(0xFFF0F8FF);
  static const Color events = Color(0xFFF0FFF0);
  static const Color news = Color.fromARGB(255, 255, 240, 245);
  static const Color primary = Color(0xFF3498DB);
  static const Color secondary = Color(0xFF2ECC71);
  static const Color accent = Color(0xFFE74C3C);
}

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Logger for better error tracking
  final _logger = Logger('HomeScreenLogger');

  // User profile data
  String _profileImageUrl = '';
  models.UserRole? _userRole;
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;

  // Current selected bottom nav index
  int _selectedIndex = 2; // Home is the default selected item

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Fetch user profile and role details
        final userData = await Supabase.instance.client
            .from('users')
            .select('*')  // Get all user data
            .eq('id', user.id)
            .single();

        // Get role-specific data based on user role
        final roleString = userData['role'] as String?;
        final roleData = await _fetchRoleSpecificData(user.id, roleString);

        setState(() {
          _profileImageUrl = userData['profile_image_url'] ?? '';
          _userRole = _determineUserRole(roleString);
          _userData = {...userData, ...roleData};
          _isLoading = false;
        });
      }
    } catch (e) {
      _logger.severe('Error fetching user profile', e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchRoleSpecificData(String userId, String? roleString) async {
    // Get role-specific data from the appropriate table
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

  models.UserRole _determineUserRole(String? roleString) {
    switch (roleString) {
      case 'player':
        return models.UserRole.player;
      case 'parent':
        return models.UserRole.parent;
      case 'coach':
        return models.UserRole.coach;
      case 'community_manager':
        return models.UserRole.communityManager;
      case 'mentor':
        return models.UserRole.mentor;
      default:
        return models.UserRole.player; // Default fallback
    }
  }

  void _showQuickActionMenu() {
    // Show role-specific quick actions
    final actions = _getRoleSpecificQuickActions();
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: actions.map((action) => 
                ListTile(
                  leading: Icon(action.icon),
                  title: Text(action.title),
                  onTap: () {
                    Navigator.pop(context);
                    action.onTap();
                  },
                )
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  List<QuickAction> _getRoleSpecificQuickActions() {
    // Define role-specific quick actions
    final List<QuickAction> actions = [];
    
    // Common actions for all roles
    actions.add(
      QuickAction(
        icon: Icons.photo_camera,
        title: 'העלאת תמונה',
        onTap: () => _showSnackBarMessage('העלאת תמונה בקרוב'),
      )
    );
    
    // Role-specific actions
    switch (_userRole) {
      case models.UserRole.player:
        actions.addAll([
          QuickAction(
            icon: Icons.video_call,
            title: 'הוספת וידאו',
            onTap: () => _showSnackBarMessage('העלאת וידאו בקרוב'),
          ),
          QuickAction(
            icon: Icons.bar_chart,
            title: 'הוספת סטטיסטיקות',
            onTap: () => _showSnackBarMessage('הזנת סטטיסטיקות בקרוב'),
          ),
        ]);
        break;
      case models.UserRole.coach:
        actions.addAll([
          QuickAction(
            icon: Icons.event,
            title: 'הוספת אימון',
            onTap: () => _showSnackBarMessage('הגדרת אימון בקרוב'),
          ),
          QuickAction(
            icon: Icons.people,
            title: 'ניהול קבוצה',
            onTap: () => _showSnackBarMessage('ניהול קבוצה בקרוב'),
          ),
        ]);
        break;
      case models.UserRole.parent:
        actions.addAll([
          QuickAction(
            icon: Icons.family_restroom,
            title: 'קישור שחקן',
            onTap: () => _showSnackBarMessage('קישור שחקן בקרוב'),
          ),
        ]);
        break;
      case models.UserRole.communityManager:
        actions.addAll([
          QuickAction(
            icon: Icons.event,
            title: 'הוספת אירוע',
            onTap: () => _showSnackBarMessage('יצירת אירוע בקרוב'),
          ),
          QuickAction(
            icon: Icons.campaign,
            title: 'הודעה קהילתית',
            onTap: () => _showSnackBarMessage('הודעה קהילתית בקרוב'),
          ),
        ]);
        break;
      case models.UserRole.mentor:
        actions.addAll([
          QuickAction(
            icon: Icons.school,
            title: 'הוספת שיעור',
            onTap: () => _showSnackBarMessage('יצירת שיעור בקרוב'),
          ),
        ]);
        break;
      default:
        break;
    }
    
    return actions;
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(message),
        ),
      ),
    );
  }

  void _navigateToNotifications() {
    _showSnackBarMessage('מעבר למסך התראות');
  }

  void _navigateToMessages() {
    _showSnackBarMessage('מעבר למסך הודעות');
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0: // Highlights (Star)
        _showSnackBarMessage('מעבר למסך הישגים');
        break;
      case 1: // Team (People)
        _showSnackBarMessage('מעבר למסך קבוצה');
        break;
      case 2: // Home (House)
        break;
      case 3: // Fan Zone (Football)
        _showSnackBarMessage('מעבר למסך מועדון אוהדים');
        break;
      case 4: // Events (Calendar)
        _showSnackBarMessage('מעבר למסך אירועים');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Global RTL for the entire screen
      child: Scaffold(
        body: _isLoading
            ? _buildLoadingView()
            : _buildHomeContent(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.asset(
          'assets/images/mainBackground.webp',
          fit: BoxFit.cover,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.loading,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.asset(
          'assets/images/mainBackground.webp',
          fit: BoxFit.cover,
        ),

        // Safe Area with Content
        SafeArea(
          child: Column(
            children: [
              // Top Navigation Bar
              _buildTopNavigationBar(),

              // Home Screen Content - Role-specific
              Expanded(
                child: _buildRoleSpecificContent(),
              ),

              // Bottom Navigation Bar
              _buildBottomNavigationBar(),
            ],
          ),
        ),

        // Floating Action Button - Moved to left side
        Positioned(
          bottom: 70,
          left: 20, // Left side in LTR (will be right in RTL)
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: _showQuickActionMenu,
              elevation: 0, // Remove default elevation since we have custom shadow
              backgroundColor: Colors.transparent, // Transparent to show gradient
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl, // RTL support
        children: [
          // Profile Icon moved to left corner (right in RTL) - WITHOUT the colored background
          GestureDetector(
            onTap: () {
              if (_userRole != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      userId: widget.userId, 
                      userRole: _convertToProfileUserRole(_userRole!),
                    ),
                  ),
                );
              }
            },
            child: _profileImageUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      _profileImageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent, // Transparent background
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
          ),
          
          // Notification and Message Icons (without backgrounds)
          Row(
            textDirection: TextDirection.rtl, // RTL support
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none, 
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: _navigateToNotifications,
                padding: EdgeInsets.zero,
              ),
              
              const SizedBox(width: 8),
              
              IconButton(
                icon: const Icon(
                  Icons.mail_outline, 
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: _navigateToMessages,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificContent() {
    // Return the appropriate content widget based on user role
    if (_userRole == null) {
      return Center(
        child: Text(
          'שגיאה בטעינת סוג משתמש',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // Pass card colors to role-specific content
    final cardColors = {
      'achievements': AppColors.achievements,
      'team': AppColors.team,
      'events': AppColors.events,
      'news': AppColors.news,
    };

    // Render role-specific content
    switch (_userRole) {
      case models.UserRole.player:
        return PlayerHomeContent(
          userData: _userData,
          cardColors: cardColors,
        );
      case models.UserRole.coach:
        return CoachHomeContent(userData: _userData);
      case models.UserRole.parent:
        return ParentHomeContent(userData: _userData);
      case models.UserRole.communityManager:
        return CommunityManagerHomeContent(userData: _userData);
      case models.UserRole.mentor:
        return MentorHomeContent(userData: _userData);
      default:
        return Center(
          child: Text(
            'סוג משתמש לא מוכר',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 50, // Smaller nav bar
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.rtl, // RTL support
        children: [
          _buildNavItem(Icons.star, 0), // Star (Highlights)
          _buildNavItem(Icons.people, 1), // People (Team)
          _buildNavItem(Icons.home, 2), // House (Home)
          _buildNavItem(Icons.sports_soccer, 3), // Football (Fan Zone)
          _buildNavItem(Icons.calendar_today, 4), // Calendar (Events)
        ],
      ),
    );
  }

  // Helper method for nav items - removed text
Widget _buildNavItem(IconData icon, int index) {
  final bool isSelected = _selectedIndex == index;
  
  return Container(
    decoration: isSelected 
        ? BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.7),
              ],
            ),
            shape: BoxShape.circle,
          )
        : null,
    child: IconButton(
      onPressed: () => _onBottomNavTapped(index),
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey,
        size: 24,
      ),
    ),
  );
}

    
    // Helper method to convert between the two UserRole enums
    UserRole _convertToProfileUserRole(models.UserRole modelUserRole) {
      switch (modelUserRole) {
        case models.UserRole.player:
          return UserRole.player;
        case models.UserRole.parent:
          return UserRole.parent;
        case models.UserRole.coach:
          return UserRole.coach;
        case models.UserRole.communityManager:
          return UserRole.communityManager;
        case models.UserRole.mentor:
          return UserRole.mentor;
      }
    }
  }

// Model class for quick actions
class QuickAction {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  QuickAction({
    required this.icon, 
    required this.title, 
    required this.onTap
  });
}