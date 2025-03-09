import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import '../models/user_role.dart' as models;  // Use prefix for model's UserRole
import 'profile.dart';  // Import profile.dart normally

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

  // Current selected bottom nav index
  int _selectedIndex = 2; // Home is the default selected item

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Fetch user profile and role details
        final userData = await Supabase.instance.client
            .from('users')
            .select('profile_image_url, role')
            .eq('id', user.id)
            .single();

        setState(() {
          _profileImageUrl = userData['profile_image_url'] ?? '';
          _userRole = _determineUserRole(userData['role']);
        });
      }
    } catch (e) {
      _logger.severe('Error fetching user profile', e);
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_call),
                title: const Text('הוסף סרטון'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement navigation to video upload screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('הוסף אירוע'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement navigation to event creation screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('הוסף סטטיסטיקה'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement navigation to stats entry screen
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToNotifications() {
    // TODO: Implement actual navigation to notifications screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('מעבר למסך ההתראות')),
    );
  }

  void _navigateToMessages() {
    // TODO: Implement actual navigation to messages screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('מעבר למסך ההודעות')),
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0: // Calendar/Events
        // TODO: Implement navigation to events screen
        break;
      case 1: // Fan Zone
        // TODO: Implement navigation to fan zone screen
        break;
      case 2: // Home (current screen)
        break;
      case 3: // Team
        // TODO: Implement navigation to team screen
        break;
      case 4: // Highlights
        // TODO: Implement navigation to highlights screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left-side Icons
                      Row(
                        children: [
                          // Messages Icon
                          IconButton(
                            icon: const Icon(
                              Icons.mail_outline, 
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _navigateToMessages,
                          ),
                          
                          // Notifications Icon
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none, 
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _navigateToNotifications,
                          ),
                        ],
                      ),

                      // Right-side Profile Photo
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
                        child: CircleAvatar(
                          radius: 23,
                          backgroundImage: _profileImageUrl.isNotEmpty
                              ? NetworkImage(_profileImageUrl)
                              : null,
                          child: _profileImageUrl.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),

                // Home Screen Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TODO: Add home screen content sections
                          // Performance stats
                          // Team discovery
                          // Upcoming activities
                          // Fan zone preview
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Navigation Bar
                BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  onTap: _onBottomNavTapped,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.sports_soccer),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people_outline),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.star_border),
                      label: '',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Floating Action Button
          Positioned(
            bottom: 70,
            left: 16,
            child: FloatingActionButton(
              onPressed: _showQuickActionMenu,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
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