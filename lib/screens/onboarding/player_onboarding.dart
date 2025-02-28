import 'dart:convert';
import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../state/onboarding_state.dart';

const Color alternateThemeColor = Color(0xFFF5F5F5); // Light grey color

class PlayerOnboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;
  const PlayerOnboarding({super.key, required this.userId, required this.onboardingState});

  @override
  State<PlayerOnboarding> createState() => _PlayerOnboardingState();
}

class _PlayerOnboardingState extends State<PlayerOnboarding> {
  late String _userId;
  late OnboardingState _onboardingState;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final Set<String> _selectedPositions = {};
  String? _selectedLeg;
  double _speed = 0;
  double _headers = 0;
  double _defending = 0;
  double _passing = 0;
  double _scoring = 0;
  double _goalkeeping = 0;
  bool _isTeamValid = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _initializeFields();
    debugPrint('PlayerOnboarding initialized with userId: $_userId');
  }

  void _initializeFields() {
    // Pre-fill fields from the onboardingState
    _teamNameController.text = _onboardingState.teamName ?? '';
    _heightController.text = _onboardingState.height?.toString() ?? '';
    _weightController.text = _onboardingState.weight?.toString() ?? '';
    _selectedPositions.addAll(_onboardingState.positions ?? []);
    _selectedLeg = _onboardingState.strongLeg;
    final skills = _onboardingState.skills;
    if (skills != null) {
      _speed = skills.speed;
      _headers = skills.headers;
      _defending = skills.defending;
      _passing = skills.passing;
      _scoring = skills.scoring;
      _goalkeeping = skills.goalkeeping;
    }
  }

  void _handleBack() {
    // Update the onboardingState with the current form data
    final updatedState = _onboardingState.copyWith(
      teamName: _teamNameController.text.trim(),
      height: int.tryParse(_heightController.text.trim()),
      weight: int.tryParse(_weightController.text.trim()),
      positions: _selectedPositions.toList(),
      strongLeg: _selectedLeg,
      skills: PlayerSkills(
        speed: _speed,
        headers: _headers,
        defending: _defending,
        passing: _passing,
        scoring: _scoring,
        goalkeeping: _goalkeeping,
      ),
    );

    Navigator.pushReplacementNamed(
      context,
      '/onboarding',
      arguments: {
        'userId': _userId,
        'onboardingState': updatedState,
      },
    );
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
      debugPrint('Error fetching team ID: $e');
      return null;
    }
  }
  
Future<void> _submitAndNavigate() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });
    final teamName = _teamNameController.text.trim();
    final height = int.tryParse(_heightController.text.trim());
    final weight = int.tryParse(_weightController.text.trim());
    final positions = _selectedPositions.toList();
    final strongLeg = _selectedLeg;

    // Create the PlayerSkills object
    final skills = PlayerSkills(
      speed: _speed,
      headers: _headers,
      defending: _defending,
      passing: _passing,
      scoring: _scoring,
      goalkeeping: _goalkeeping,
    );

    // Create updated state BEFORE navigation
    final updatedState = _onboardingState.copyWith(
      teamName: teamName,
      height: height,
      weight: weight,
      positions: positions,
      strongLeg: strongLeg,
      skills: skills,
    );

    AppLogger.info('Player Onboarding form submitted');
    AppLogger.info(
      'Team Name: $teamName, Height: $height, Weight: $weight, Positions: $positions, Leg: $strongLeg, Skills: $skills',
    );

    try {
      String? teamId;
      // Only get team ID if a team name was provided
      if (teamName.isNotEmpty) {
        teamId = await _getTeamIdByName(teamName);
        if (teamId == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('הקבוצה שהוזנה לא נמצאה במערכת')),
          );
          setState(() {
            _isLoading = false;
          });
          return; // Stop the submission process here
        }
      }

      if (!mounted) return;

      // Try to use existing players table first
      try {
        await Supabase.instance.client
          .from('players')
          .insert({
            'id': _userId,
            'height': height,
            'weight': weight,
            'positions': positions,
            'strong_leg': strongLeg,
            'skills': jsonEncode(skills.toMap()), // Encode the PlayerSkills object to a Map
          });
      } catch (playerInsertError) {
        AppLogger.warning('Could not insert into players table, possibly removed. Storing player data in metadata: $playerInsertError');
        
        // If players table is gone, store the data as metadata in a JSON field in users table
        final Map<String, dynamic> playerMetadata = {
          'height': height,
          'weight': weight,
          'positions': positions,
          'strong_leg': strongLeg,
          'skills': skills.toMap(),
        };
        
        await Supabase.instance.client
          .from('users')
          .update({
            'player_metadata': playerMetadata
          })
          .eq('id', _userId);
      }

      if (teamId != null) {
        try {
          // Insert using composite key approach
          await Supabase.instance.client
            .from('team_members')
            .insert({
              'user_id': _userId,
              'team_id': teamId,
              'role': 'player',
              'status': 'pending'
            });
        } catch (teamMemberError) {
          AppLogger.error('Error adding user to team', error: teamMemberError);
          // Don't rethrow, since joining a team is not critical to continue
        }
      }
      
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/favorites',
          arguments: {
            'userId': _userId,
            'onboardingState': updatedState,
          },
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error during player onboarding', error: e, stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });     
      }
    }
  }
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
                    color: const Color.fromRGBO(255, 255, 255, 0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'שחקן - שלב ההרשמה',
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
                              _buildTeamNameField(),
                              const SizedBox(height: 2),
                              _buildPositionSelection(),
                              const SizedBox(height: 10),
                              _buildHeightWeightFields(),
                              const SizedBox(height: 10),
                              _buildLegSelection(),
                              const SizedBox(height: 10),
                              _buildSkillsSliders(),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _submitAndNavigate,
                                child: const Text(
                                  'המשך',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_isLoading)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
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
  
Widget _buildTeamNameField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'הקבוצה שלך: (אופציונלי)',
        style: TextStyle(fontSize: 15),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }

                try {
                  // Now this should work with your new RLS policy
                  final response = await Supabase.instance.client
                      .from('teams')
                      .select('name')
                      .ilike('name', '%${textEditingValue.text}%')
                      .limit(10);

                  final List<dynamic> data = response as List<dynamic>;
                  return data.map<String>((team) => team['name'] as String);
                } catch (error) {
                  debugPrint('Error fetching teams: $error');
                  return const Iterable<String>.empty();
                }
              },
              displayStringForOption: (String option) => option,
              onSelected: (String selection) {
                setState(() {
                  _teamNameController.text = selection;
                  _isTeamValid = true;
                });
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController fieldController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted,
              ) {
                // Keep a reference to the autocomplete controller
                // This allows us to sync it with _teamNameController
                if (fieldController.text != _teamNameController.text) {
                  fieldController.text = _teamNameController.text;
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
                  onChanged: (value) async {
                    // Update our main controller
                    _teamNameController.text = value;
                    
                    if (value.isEmpty) {
                      setState(() {
                        _isTeamValid = true; // Empty is valid for optional field
                      });
                      return;
                    }
                    
                    // Only validate if the text has a reasonable length
                    if (value.length >= 3) {
                      try {
                        // Check if team exists with exact name match
                        final exactMatch = await Supabase.instance.client
                            .from('teams')
                            .select('name')
                            .eq('name', value)
                            .limit(1);
                        
                        setState(() {
                          // If we get any results back, the team exists
                          _isTeamValid = exactMatch != null && exactMatch.isNotEmpty;
                        });
                      } catch (error) {
                        debugPrint('Error validating team: $error');
                        setState(() {
                          _isTeamValid = false;
                        });
                      }
                    } else {
                      setState(() {
                        _isTeamValid = false;
                      });
                    }
                  },
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return null; // Optional field can be empty
                    }
                    if (!_isTeamValid) {
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
          ),
        ],
      ),
      const SizedBox(height: 8), // Add some spacing
      const Text(
        'השאר/י  ריק במידה ואין לך קבוצה או שהקבוצה לא נמצאת',
        style: TextStyle(
          fontSize: 11,
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  );
}


  Widget _buildPositionSelection() {
    const positions = [
      {'label': 'שער', 'value': 'goalkeeper'},
      {'label': 'הגנה', 'value': 'defense'},
      {'label': 'קישור', 'value': 'midfield'},
      {'label': 'התקפה', 'value': 'offense'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'תפקיד:',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 10),
        Center(
          child: Wrap(
            spacing: 2,
            runSpacing: 10,
            children: positions.map((position) {
              return FilterChip(
                label: Text(
                  position['label']!,
                  style: const TextStyle(fontSize: 12),
                ),
                selected: _selectedPositions.contains(position['value']),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedPositions.add(position['value']!);
                    } else {
                      _selectedPositions.remove(position['value']!);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeightWeightFields() {
    return Row(
      children: [
        const Text('גובה: ', style: TextStyle(fontSize: 15)),
        Expanded(
          child: _buildTextFormField(
            controller: _heightController,
            labelText: '(בס"מ)',
            validatorMessage: 'נא להזין גובה',
          ),
        ),
        const SizedBox(width: 10),
        const Text('משקל: ', style: TextStyle(fontSize: 15)),
        Expanded(
          child: _buildTextFormField(
            controller: _weightController,
            labelText: '(בק"ג)',
            validatorMessage: 'נא להזין משקל',
          ),
        ),
      ],
    );
  }

  Widget _buildLegSelection() {
    return Row(
      children: [
        const Text(
          'רגל חזקה:',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedLeg,
            items: const [
              DropdownMenuItem(value: 'right', child: Text('ימין')),
              DropdownMenuItem(value: 'left', child: Text('שמאל')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedLeg = value;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: alternateThemeColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            validator: (value) => value == null ? 'נא לבחור רגל חזקה' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSliders() {
    final skills = [
      {'label': 'מהירות', 'value': _speed, 'setter': (double v) => _speed = v},
      {'label': 'נגיחות', 'value': _headers, 'setter': (double v) => _headers = v},
      {'label': 'הגנה', 'value': _defending, 'setter': (double v) => _defending = v},
      {'label': 'מסירה', 'value': _passing, 'setter': (double v) => _passing = v},
      {'label': 'הבקעה', 'value': _scoring, 'setter': (double v) => _scoring = v},
      {'label': 'שוערות', 'value': _goalkeeping, 'setter': (double v) => _goalkeeping = v},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: skills.map((skill) => _buildSlider(
        skill['label'] as String,
        skill['value'] as double,
        (value) => setState(() => (skill['setter'] as Function(double))(value)),
      )).toList(),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Makes the column as compact as possible
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4), // Small padding above label
          child: Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        SizedBox(
          height: 30, // Reduced height for the slider
          child: Slider(
            value: value,
            min: 0,
            max: 10,
            divisions: 10,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String validatorMessage,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: alternateThemeColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? validatorMessage : null,
    );
  }
  
}