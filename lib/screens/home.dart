//lib\screens\home.dart

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import '../localization/localization_manager.dart';
import '../widgets/common/language_selector.dart';
import '../utils/error_handler.dart'; // Add this import for ErrorHandler
import '../localization/app_strings.dart'; // Add this import for AppStrings
import 'settings_screen.dart';


// Core dependencies
import '../models/user_role.dart' as app_models;
import '../config/dependency_injection.dart';
// Removed unused imports

// Widgets
import '../widgets/home/player_content.dart';
import '../widgets/home/coach_content.dart';
import '../widgets/home/parent_content.dart';
import '../widgets/home/mentor_content.dart';
import '../widgets/home/community_manager_content.dart';
import '../widgets/common/animated_bottom_nav.dart';

/// Represents the state of the home screen
class HomeScreenState {
  final bool isLoading;
  final Map<String, dynamic> userData;
  final app_models.UserRole? userRole;
  final String profileImageUrl;
  final bool hasNewAchievements;

  const HomeScreenState({
    this.isLoading = true,
    this.userData = const {},
    this.userRole,
    this.profileImageUrl = '',
    this.hasNewAchievements = false,
  });

  /// Create a copy of the state with optional updates
  HomeScreenState copyWith({
    bool? isLoading,
    Map<String, dynamic>? userData,
    app_models.UserRole? userRole,
    String? profileImageUrl,
    bool? hasNewAchievements,
  }) {
    return HomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      userData: userData ?? this.userData,
      userRole: userRole ?? this.userRole,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      hasNewAchievements: hasNewAchievements ?? this.hasNewAchievements,
    );
  }
}

/// Home screen with dependency injection and service-based architecture
class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({
    super.key, 
    required this.userId
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Services
  final _userProfileService = dependencyInjection.userProfileService;
  // Removed unused _quickActionService
  final _achievementManager = dependencyInjection.achievementManager;

  // Logger
  final _logger = Logger('HomeScreenLogger');

  // State management
  HomeScreenState _state = const HomeScreenState();

  // Changed from final to regular int for the selected index
  int _selectedIndex = 2; // Home is default

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _achievementManager.addListener(_onAchievementStateChanged);
    
    // Track screen view
    dependencyInjection.analyticsService.trackScreenView('home');
  }

  @override
  void dispose() {
    _achievementManager.removeListener(_onAchievementStateChanged);
    super.dispose();
  }

  /// Fetch user profile with comprehensive error handling
// Update the _fetchUserProfile method in home.dart
 
  Future<void> _fetchUserProfile() async {
    dependencyInjection.performanceMonitor.startTimer('fetch_user_profile');
    
    try {
      setState(() {
        _state = _state.copyWith(isLoading: true);
      });

      final userData = await _userProfileService.fetchUserProfile(widget.userId);
      final userRole = _userProfileService.determineUserRole(userData['role']);

      if (mounted) {
        setState(() {
          _state = _state.copyWith(
            isLoading: false,
            userData: userData,
            userRole: userRole,
            profileImageUrl: userData['profile_image_url'] ?? '',
          );
        });
        
        // Track user properties for analytics
        final analyticsService = dependencyInjection.analyticsService;
        analyticsService.setUserId(widget.userId);
        analyticsService.setUserProperty('user_role', userRole.toString());
        
        dependencyInjection.performanceMonitor.trackEvent('user_profile_loaded', {
          'role': userRole.toString(),
        });
      }
    } catch (e) {
      _logger.severe('Error fetching user profile', e);
      
      if (mounted) {
        setState(() {
          _state = _state.copyWith(
            isLoading: false,
            userRole: app_models.UserRole.player, // Fallback
          );
        });
        
        // Track error
        dependencyInjection.analyticsService.trackError(
          'profile_load_error',
          e.toString(),
        );
        
        dependencyInjection.performanceMonitor.trackEvent('user_profile_load_failed', {
          'error': e.toString(),
        });
        
        // Show error after the build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ErrorHandler.handleNetworkError(
              context,
              e,
              () => _fetchUserProfile(), // Retry function
            );
          }
        });
      }
    } finally {
      dependencyInjection.performanceMonitor.stopTimer('fetch_user_profile');
    }
  }
 
  /// Handle achievement state changes
  void _onAchievementStateChanged() {
    setState(() {
      _state = _state.copyWith(
        hasNewAchievements: _achievementManager.hasNewAchievements,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the localization manager
    final localizationManager = Provider.of<LocalizationManager>(context, listen: false);
    
    return Scaffold(
      body: _state.isLoading
          ? _buildLoadingView()
          : _buildHomeContent(localizationManager),
    );
  }

  /// Build loading view
  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Build home content based on user role
  Widget _buildHomeContent(LocalizationManager localizationManager) {
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
          child: Directionality(
            textDirection: localizationManager.textDirection,
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
        ),

        // Floating Action Button - positioned based on text direction
        Positioned(
          bottom: 70,
          // Position based on text direction
          left: localizationManager.isRTL ? null : 20,
          right: localizationManager.isRTL ? 20 : null,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue,
                  Colors.blue.withAlpha(178), // Using withAlpha instead of withOpacity
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withAlpha(76), // Using withAlpha instead of withOpacity
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                // Show quick actions
              },
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  /// Build top navigation bar

// Update _buildTopNavigationBar() in home.dart
  Widget _buildTopNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - App logo or title
          const Text(
            'FootballHero',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Right side - User avatar, language selector, settings, etc.
          Row(
            children: [
              // Settings button
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 22),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              
              // Language selector
              const LanguageSelector(),
              
              const SizedBox(width: 16),
              
              // Profile icon
              GestureDetector(
                onTap: () {
                  // Navigate to profile screen
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withAlpha(51),
                  child: _state.profileImageUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          _state.profileImageUrl,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return AnimatedBottomNav(
      selectedIndex: _selectedIndex,
      onItemSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
        
        // Track navigation item selection
        final analyticsService = dependencyInjection.analyticsService;
        final tabNames = ['highlights', 'team', 'home', 'fan_zone', 'events'];
        
        if (index < tabNames.length) {
          analyticsService.trackUserAction('tab_selected', {
            'tab_name': tabNames[index],
          });
        }
      },
    );
  }

  // Removed unused _buildNavItem method

  /// Build error view for undefined role
  Widget _buildErrorView() {
    return Center(
      child: Text(
        'Unable to determine user role',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  /// Render role-specific home content
  Widget _buildRoleSpecificContent() {
    switch (_state.userRole) {
      case app_models.UserRole.player:
        return PlayerHomeContent(userData: _state.userData);
      case app_models.UserRole.coach:
        return CoachHomeContent(userData: _state.userData);
      case app_models.UserRole.parent:
        return ParentHomeContent(userData: _state.userData);
      case app_models.UserRole.communityManager:
        return CommunityManagerHomeContent(userData: _state.userData);
      case app_models.UserRole.mentor:
        return MentorHomeContent(userData: _state.userData);
      default:
        return _buildErrorView();
    }
  }
}