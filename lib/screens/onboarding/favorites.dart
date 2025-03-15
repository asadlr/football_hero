// lib\screens\onboarding\favorites.dart

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logger/logger.dart';
import '../../state/onboarding_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../localization/app_strings.dart';
import '../../localization/localization_manager.dart';

class FavoritesScreen extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;
  
  const FavoritesScreen({
    super.key,
    required this.userId,
    required this.onboardingState,
  });

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteClubs = [];
  List<String> searchResults1 = [];
  List<String> searchResults2 = [];
  List<String> searchResults3 = [];
  bool _isLoading = false;

  void _handleBack() {
    // Get the role from onboardingState
    final role = widget.onboardingState.role;
    
    final args = {
      'userId': widget.userId,
      'onboardingState': widget.onboardingState,
    };
    
    // Navigate back based on role
    switch (role) {
      case 'player':
        context.go('/onboarding/player', extra: args);
      case 'parent':
        context.go('/onboarding/parent', extra: args);
      case 'coach':
        context.go('/onboarding/coach', extra: args);
      case 'mentor':
        context.go('/onboarding/mentor', extra: args);
      case 'community_manager':
        context.go('/onboarding/community', extra: args);
      default:
        // If role is not set, go back to main onboarding
        context.go('/onboarding', extra: args);
    }
  }
    
  Future<void> _saveFavorites() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Remove any duplicates from favoriteClubs
      final uniqueClubs = favoriteClubs.toSet().toList();

      // Create a batch of operations for efficiency
      final batch = [];

      for (String clubName in uniqueClubs) {
        try {
          // First get the club_id for the club name
          final clubResponse = await Supabase.instance.client
              .from('football_clubs')
              .select('id')
              .eq('name', clubName)
              .single();

          // Add to the batch
          batch.add({
            'user_id': widget.userId,
            'club_id': clubResponse['id'],
          });
        } catch (e) {
          AppLogger.warning(message: 'Could not find club');
          // Continue with the next club
        }
      }

      // Insert all favorites using upsert to handle potential conflicts
      if (batch.isNotEmpty) {
        await Supabase.instance.client
            .from('favorite_clubs')
            .upsert(
              batch,
              onConflict: 'user_id,club_id' // Use the composite primary key
            );
      }

      // Use a post-frame callback to ensure the navigation context is valid
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/home', extra: {'userId': widget.userId});
        });
      }
    } catch (e) {
      if (mounted) {
        AppLogger.error(message: 'Error saving favorite clubs');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('favorites_save_error'))),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _searchClubs(String query, int searchFieldIndex) async {
    if (!mounted) return;
    
    if (query.trim().isEmpty) {
      setState(() {
        if (searchFieldIndex == 1) {
          searchResults1 = [];
        } else if (searchFieldIndex == 2) {
          searchResults2 = [];
        } else if (searchFieldIndex == 3) {
          searchResults3 = [];
        }
      });
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('football_clubs')
          .select('id, name')
          .ilike('name', '%$query%')
          .limit(10); // Adding a limit for better performance

      List<String> results = response.map((club) => club['name'].toString()).toList();

      if (mounted) {
        setState(() {
          if (searchFieldIndex == 1) {
            searchResults1 = results;
          } else if (searchFieldIndex == 2) {
            searchResults2 = results;
          } else if (searchFieldIndex == 3) {
            searchResults3 = results;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        AppLogger.error(message: 'Error searching for clubs');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('clubs_search_error'))),
        );
      }
    }
  }

  Widget _buildSearchField(ThemeData theme, int searchFieldIndex, List<String> searchResults) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: AppStrings.get('search_football_club'),
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: AppColors.background,
          ),
          onChanged: (value) => _searchClubs(value, searchFieldIndex),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: ThemeConstants.sm),
        if (searchResults.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(ThemeConstants.sm),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: searchResults.map((clubName) {
                return ListTile(
                  title: Text(
                    clubName,
                    style: theme.textTheme.bodyMedium,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      favoriteClubs.contains(clubName)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoriteClubs.contains(clubName) ? AppColors.accent : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (favoriteClubs.contains(clubName)) {
                          favoriteClubs.remove(clubName);
                        } else {
                          favoriteClubs.add(clubName);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        if (favoriteClubs.isNotEmpty && searchFieldIndex == 1) // Show selected clubs once
          Padding(
            padding: const EdgeInsets.only(top: ThemeConstants.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get('selected_clubs'),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: ThemeConstants.sm),
                Wrap(
                  spacing: ThemeConstants.sm,
                  children: favoriteClubs.map((club) => Chip(
                    label: Text(club),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        favoriteClubs.remove(club);
                      });
                    },
                    backgroundColor: AppColors.background,
                    side: BorderSide(color: AppColors.divider),
                  )).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  @override
  
    Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationManager = LocalizationManager();
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Directionality(
        textDirection: localizationManager.textDirection,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: AppColors.textPrimary,
              onPressed: _handleBack,
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/mainBackground.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    elevation: theme.cardTheme.elevation,
                    shape: theme.cardTheme.shape,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.get('choose_favorite_clubs'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontFamily: 'RubikDirt',
                            ),
                          ),
                          const SizedBox(height: ThemeConstants.md),
                          _buildSearchField(theme, 1, searchResults1),
                          const SizedBox(height: ThemeConstants.md),
                          _buildSearchField(theme, 2, searchResults2),
                          const SizedBox(height: ThemeConstants.md),
                          _buildSearchField(theme, 3, searchResults3),
                          const SizedBox(height: ThemeConstants.md),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _saveFavorites,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  AppStrings.get('finish_registration'),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontFamily: 'VarelaRound',
                                    color: Colors.white,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(77),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
  
 