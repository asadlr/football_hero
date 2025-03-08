import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../state/onboarding_state.dart';

class CommunityManagerOnboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;

  const CommunityManagerOnboarding({
    super.key,
    required this.userId,
    required this.onboardingState,
  });

  @override
  State<CommunityManagerOnboarding> createState() => _CommunityManagerOnboardingState();
}

class _CommunityManagerOnboardingState extends State<CommunityManagerOnboarding> {
  late String _userId;
  late OnboardingState _onboardingState;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _communityNameController = TextEditingController();
  bool _isCommunityValid = true;
  bool _isInitialized = false;

  static const Color alternateThemeColor = Color(0xFFE0E3E7);

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _initializeFields();
  }

  void _initializeFields() {
    // Pre-fill fields from the onboardingState
    _idNumberController.text = _onboardingState.idNumber ?? '';
    _communityNameController.text = _onboardingState.communityName ?? '';

    setState(() {
      _isInitialized = true;
    });
  }

  void _handleBack() {
    // Update the onboardingState with all current form data
    final updatedState = _onboardingState.copyWith(
      idNumber: _idNumberController.text.trim(),
      communityName: _communityNameController.text.trim(),
    );

    context.go('/onboarding', extra: {
      'userId': _userId,
      'onboardingState': updatedState,
    });
  }

  Future<String?> _getCommunityIdForTeam(String teamId) async {
    try {
      final response = await Supabase.instance.client
          .from('community_teams')
          .select('community_id')
          .eq('team_id', teamId)
          .limit(1)
          .single();
      
      return response['community_id'] as String?;
    } catch (e) {
      AppLogger.error('Error getting community ID for team');
      return null;
    }
  }

  Future<String> _createNewCommunity(String teamName) async {
    try {
      final response = await Supabase.instance.client
          .from('communities')
          .insert({
            'name': teamName,
            'created_at': DateTime.now().toIso8601String(),
            'status': 'pending'
          })
          .select()
          .single();
      
      return response['id'] as String;
    } catch (e) {
      AppLogger.error('Error creating new community');
      throw Exception('Failed to create new community');
    }
  }

  Future<void> _associateTeamWithCommunity(String teamId, String communityId) async {
    try {
      await Supabase.instance.client
          .from('community_teams')
          .insert({
            'team_id': teamId,
            'community_id': communityId,
            'created_at': DateTime.now().toIso8601String()
          });
    } catch (e) {
      AppLogger.error('Error associating team with community');
      throw Exception('Failed to associate team with community');
    }
  }

  Future<void> _submitAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final idNumber = _idNumberController.text.trim();
        final teamName = _communityNameController.text.trim();

        String? teamId;
        String? communityId;
        
        // Only process team and community if a team name was provided
        if (teamName.isNotEmpty) {
          // Get team ID - this function already exists in your file
          teamId = await _getTeamIdByName(teamName);
          if (teamId == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('הקבוצה שהוזנה לא נמצאה במערכת')),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }

          // Check if team is already associated with a community
          communityId = await _getCommunityIdForTeam(teamId);
          
          if (communityId == null) {
            // Create a new community
            communityId = await _createNewCommunity(teamName);
            // Associate team with the new community
            await _associateTeamWithCommunity(teamId, communityId);
          }
        }

        // Update personal_id in users table
        await Supabase.instance.client
            .from('users')
            .update({'personal_id': idNumber})
            .eq('id', _userId);

        // Create community_teams relationship if needed
        if (teamId != null && communityId != null) {
          try {
            await Supabase.instance.client
                .from('community_teams')
                .upsert({
                  'community_id': communityId,
                  'team_id': teamId,
                  'status': 'pending',
                  'created_by': _userId,
                  'assigned_by_id': _userId,
                  'created_at': DateTime.now().toIso8601String()
                });
          } catch (e) {
            AppLogger.warning('Error creating community_teams relationship');
            // Continue since this is not a critical error
          }
        }

        // Update state
        final updatedState = _onboardingState.copyWith(
          idNumber: idNumber,
          teamName: teamName,
        );

        if (mounted) {
          context.go('/onboarding/favorites', extra: {
            'userId': _userId,
            'onboardingState': updatedState,
          });
        }
      } catch (e) {
        AppLogger.error('Error during community manager onboarding');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('אירעה שגיאה בעיבוד הבקשה. אנא נסה שוב.')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
  
  Future<bool> _checkUserExists(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _getTeamIdByName(String teamName) async {
    try {
      final response = await Supabase.instance.client
          .from('teams')
          .select('id')
          .eq('name', teamName)
          .limit(1)
          .single();

      return response['id'] as String?;
    } catch (e) {
      AppLogger.error('Error fetching team ID');
      return null;
    }
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
              Center(
                child: Container(
                  margin: const EdgeInsets.all(18.0),
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(230),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'מנהל קהילה - שלב ההרשמה',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildIdNumberField(),
                              const SizedBox(height: 20),
                              _buildTeamNameField(),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submitAndNavigate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
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
                                  : const Text(
                                      'המשך',
                                      style: TextStyle(fontSize: 15, color: Colors.white),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildIdNumberField() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'מספר תעודת זהות:',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _idNumberController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: alternateThemeColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'נא להזין מספר תעודת זהות';
            }
            if (value.length != 9) {
              return 'מספר תעודת זהות חייב להכיל 9 ספרות';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          maxLength: 9,
        ),
      ],
    );
  }

  Widget _buildTeamNameField() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'הקבוצה שלך: (אופציונלי)',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 10),
        Autocomplete<String>(
          initialValue: TextEditingValue(text: _communityNameController.text),
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }

            try {
              final response = await Supabase.instance.client
                  .from('teams')
                  .select('name')
                  .ilike('name', '%${textEditingValue.text}%')
                  .limit(10);

              final List<dynamic> data = response as List<dynamic>;
              return data.map<String>((team) => team['name'] as String);
            } catch (error) {
              AppLogger.error('Error fetching teams');
              return const Iterable<String>.empty();
            }
          },
          displayStringForOption: (String option) => option,
          onSelected: (String selection) {
            setState(() {
              _communityNameController.text = selection;
              _isCommunityValid = true;
            });
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController fieldController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Sync the controllers
            if (fieldController.text != _communityNameController.text) {
              fieldController.text = _communityNameController.text;
            }

            return TextFormField(
              controller: fieldController,
              focusNode: fieldFocusNode,
              decoration: const InputDecoration(
                labelText: 'שם הקבוצה',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: alternateThemeColor,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              onChanged: (value) {
                _communityNameController.text = value;
                if (value.isNotEmpty) {
                  setState(() {
                    _isCommunityValid = false;
                  });
                } else {
                  setState(() {
                    _isCommunityValid = true;  // Empty value is valid
                  });
                }
              },
              validator: (value) {
                if (value?.isNotEmpty == true && !_isCommunityValid) {
                  return 'יש לבחור קבוצה מהרשימה';
                }
                return null;
              },
            );
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: Alignment.topRight,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 74,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'השאר/י ריק במידה ואין לך קבוצה או שהקבוצה לא נמצאת',
          style: TextStyle(
            fontSize: 11,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    _communityNameController.dispose();
    super.dispose();
  }
}