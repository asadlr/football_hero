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
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/player',
          arguments: {
            'userId': widget.userId,
            'onboardingState': widget.onboardingState,
          },
        );
      case 'parent':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/parent',
          arguments: {
            'userId': widget.userId,
            'onboardingState': widget.onboardingState,
          },
        );
      case 'coach':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/coach',
          arguments: {
            'userId': widget.userId,
            'onboardingState': widget.onboardingState,
          },
        );
      case 'mentor':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/mentor',
          arguments: {
            'userId': widget.userId,
            'onboardingState': widget.onboardingState,
          },
        );
      case 'community':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/community',
          arguments: {
            'userId': widget.userId,
            'onboardingState': widget.onboardingState,
          },
        );
      default:
        // If role is not set, go back to main onboarding
        Navigator.pushReplacementNamed(
          context,
          '/onboarding',
          arguments: {
            'userId': widget.userId,
            'onboardingState': widget.onboardingState,
          },
        );
    }
  }

  Future<void> _saveFavorites() async {
    if (!mounted) return; // Ensure the widget is still mounted

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
          AppLogger.warning('Could not find club: $clubName, error: $e');
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userId: widget.userId),
            ),
          );
        });
      }
    } catch (e) {
      if (mounted) { // Ensure the widget is still mounted before using context
        AppLogger.error('Error saving favorite clubs', error: e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בשמירת קבוצות אהובות: $e')),
        );
      }
    }
  }
  
  Future<void> _searchClubs(String query, int searchFieldIndex) async {
    if (!mounted) return; // Ensure the widget is still mounted
    final currentContext = context;

    try {
      final response = await Supabase.instance.client
          .from('football_clubs')
          .select('id, name')
          .ilike('name', '%$query%');

      List<String> results = response.map((club) => club['name'].toString()).toList();

      setState(() {
        if (searchFieldIndex == 1) {
          searchResults1 = results;
        } else if (searchFieldIndex == 2) {
          searchResults2 = results;
        } else if (searchFieldIndex == 3) {
          searchResults3 = results;
        }
      });
    } catch (e) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppLogger.error('Error searching for clubs', error: e);
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(content: Text('שגיאה בחיפוש מועדונים: $e')),
          );
        });
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
          ),
          onChanged: (value) => _searchClubs(value, searchFieldIndex),
        ),
        const SizedBox(height: 10.0),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Use onPopInvokedWithResult instead of onPopInvoked
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
              onPressed: () {
                _handleBack();
              },
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
                    color: const Color.fromRGBO(255, 255, 255, 0.9),
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
                              fontSize: 28,
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
                            onPressed: _saveFavorites,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50.0,
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'סיום ההרשמה',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'VarelaRound',
                              ),
                            ),
                          ),
                        ],
                      ),
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
