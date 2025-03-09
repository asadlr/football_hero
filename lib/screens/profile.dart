import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../models/user_role.dart';

// Ensure this enum matches the one in home.dart
enum UserRole {
  player,
  parent,
  coach,
  communityManager,
  mentor
}

class ProfileScreen extends StatefulWidget {
  final String userId;
  final UserRole userRole;

  const ProfileScreen({
    Key? key, 
    required this.userId,
    required this.userRole,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User profile data
  String _profileImageUrl = '';
  Map<String, dynamic> _profileData = {};

  // Current selected bottom nav index
  int _selectedIndex = 4; // Profile is the last item

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Fetch profile details based on user role
        final userData = await Supabase.instance.client
            .from(_getRoleTableName())
            .select()
            .eq('user_id', user.id)
            .single();

        setState(() {
          _profileData = userData;
          _profileImageUrl = userData['profile_image_url'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  String _getRoleTableName() {
    switch (widget.userRole) {
      case UserRole.player:
        return 'players';
      case UserRole.coach:
        return 'coaches';
      case UserRole.parent:
        return 'parents';
      case UserRole.communityManager:
        return 'community_managers';
      case UserRole.mentor:
        return 'mentors';
      default:
        return 'users';
    }
  }

  void _navigateToNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('מעבר למסך ההתראות')),
    );
  }

  void _navigateToMessages() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('מעבר למסך ההודעות')),
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0: // Calendar
        break;
      case 1: // Fan Zone
        break;
      case 2: // Home
        Navigator.of(context).pop(); // Return to home screen
        break;
      case 3: // Team
        break;
      case 4: // Highlights
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
                            icon: Icon(
                              Icons.mail_outline, 
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _navigateToMessages,
                          ),
                          
                          // Notifications Icon
                          IconButton(
                            icon: Icon(
                              Icons.notifications_none, 
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _navigateToNotifications,
                          ),
                        ],
                      ),

                      // Right-side Profile Photo
                      CircleAvatar(
                        radius: 23,
                        backgroundImage: _profileImageUrl.isNotEmpty
                            ? NetworkImage(_profileImageUrl)
                            : null,
                        child: _profileImageUrl.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),

                // Profile Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Picture
                          Center(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: _profileImageUrl.isNotEmpty
                                  ? NetworkImage(_profileImageUrl)
                                  : null,
                              child: _profileImageUrl.isEmpty
                                  ? const Icon(Icons.person, size: 80)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Profile Name
                          Text(
                            _profileData['full_name'] ?? 'שם משתמש',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Role-specific profile details
                          _buildProfileDetails(),
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
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    // Build profile details based on user role
    switch (widget.userRole) {
      case UserRole.player:
        return _buildPlayerDetails();
      case UserRole.coach:
        return _buildCoachDetails();
      case UserRole.parent:
        return _buildParentDetails();
      case UserRole.communityManager:
        return _buildCommunityManagerDetails();
      case UserRole.mentor:
        return _buildMentorDetails();
      default:
        return _buildDefaultDetails();
    }
  }

  Widget _buildPlayerDetails() {
    return Column(
      children: [
        _buildInfoCard('מיקום', _profileData['position'] ?? 'לא צוין'),
        _buildInfoCard('גיל', _calculateAge()),
        _buildInfoCard('קבוצה', _profileData['team_name'] ?? 'לא משוייך לקבוצה'),
      ],
    );
  }

  Widget _buildCoachDetails() {
    return Column(
      children: [
        _buildInfoCard('מספר תעודת מאמן', _profileData['certification_number'] ?? 'לא צוין'),
        _buildInfoCard('קבוצות', _profileData['teams_managed'] ?? 'אין קבוצות'),
      ],
    );
  }

  Widget _buildParentDetails() {
    return Column(
      children: [
        _buildInfoCard('שחקנים', _profileData['players_linked'] ?? 'אין שחקנים מקושרים'),
      ],
    );
  }

  Widget _buildCommunityManagerDetails() {
    return Column(
      children: [
        _buildInfoCard('קהילה', _profileData['community_name'] ?? 'לא צוין'),
      ],
    );
  }

  Widget _buildMentorDetails() {
    return Column(
      children: [
        _buildInfoCard('תחומי התמחות', _profileData['expertise'] ?? 'לא צוין'),
      ],
    );
  }

  Widget _buildDefaultDetails() {
    return Column(
      children: [
        _buildInfoCard('תפקיד', _getRoleTitle()),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(value),
      ),
    );
  }

  String _calculateAge() {
    // Implement age calculation based on birth date
    return 'חישוב גיל לא זמין';
  }

  String _getRoleTitle() {
    switch (widget.userRole) {
      case UserRole.player:
        return 'שחקן';
      case UserRole.parent:
        return 'הורה';
      case UserRole.coach:
        return 'מאמן';
      case UserRole.communityManager:
        return 'מנהל קהילה';
      case UserRole.mentor:
        return 'מנטור';
      default:
        return 'משתמש';
    }
  }
}