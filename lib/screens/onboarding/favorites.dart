import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logger/logger.dart';
import '../home.dart';
import '../../state/onboarding_state.dart';

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
          AppLogger.warning('Could not find club');
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
        AppLogger.error('Error saving favorite clubs');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('שגיאה בשמירת קבוצות אהובות. אנא נסה שוב.')),
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
        AppLogger.error('Error searching for clubs');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('שגיאה בחיפוש מועדונים. אנא נסה שוב.')),
        );
      }
    }
  }

  Widget _buildSearchField(int searchFieldIndex, List<String> searchResults) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'חפש מועדון כדורגל',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _searchClubs(value, searchFieldIndex),
        ),
        const SizedBox(height: 10.0),
        if (searchResults.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: searchResults.map((clubName) {
                return ListTile(
                  title: Text(clubName),
                  trailing: IconButton(
                    icon: Icon(
                      favoriteClubs.contains(clubName)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoriteClubs.contains(clubName) ? Colors.red : null,
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
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'הקבוצות שבחרת:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: favoriteClubs.map((club) => Chip(
                    label: Text(club),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        favoriteClubs.remove(club);
                      });
                    },
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: Colors.black,
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
                    color: Colors.white.withAlpha(230),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'בחר את הקבוצות האהובות עליך',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'RubikDirt',
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          _buildSearchField(1, searchResults1),
                          const SizedBox(height: 20.0),
                          _buildSearchField(2, searchResults2),
                          const SizedBox(height: 20.0),
                          _buildSearchField(3, searchResults3),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _saveFavorites,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              backgroundColor: Colors.blue,
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
                              : const Text(
                                  'סיום ההרשמה',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
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
                    child: const Center(
                      child: CircularProgressIndicator(),
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