import 'dart:convert';
import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerOnboarding extends StatefulWidget {
  final String userId;

  const PlayerOnboarding({super.key, required this.userId});

  @override
  State<PlayerOnboarding> createState() => _PlayerOnboardingState();
}

class _PlayerOnboardingState extends State<PlayerOnboarding> {
  late String _userId;
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
  bool _isTeamValid = true; // Add this with other state variables
  
  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    debugPrint('PlayerOnboarding initialized with userId: $_userId');
  }

  static const Color alternateThemeColor = Color(0xFFE0E3E7);

  Future<void> _submitAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      final teamName = _teamNameController.text.trim();
      final height = int.tryParse(_heightController.text.trim());
      final weight = int.tryParse(_weightController.text.trim());
      final positions = _selectedPositions.toList();
      final strongLeg = _selectedLeg;
      
      // Create skills object in the correct format for the players.skills JSONB column
      final skills = {
        'speed': _speed,
        'headers': _headers,
        'defending': _defending,
        'passing': _passing,
        'scoring': _scoring,
        'goalkeeping': _goalkeeping,
      };

      AppLogger.info('Player Onboarding form submitted');
      AppLogger.info(
          'Team Name: $teamName, Height: $height, Weight: $weight, Positions: $positions, Leg: $strongLeg, Skills: $skills');

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
            return;  // Stop the submission process here
          }
        }

        if (!mounted) return;

        // Insert into users table if not exists (should be handled by auth)
        
        final userExists = await _checkUserExists(_userId);
        if (!userExists) {
          await Supabase.instance.client.from('users').insert({
            'id': _userId,
            'role': 'player',  // Set default role for player
          });
        }

        // Insert into players table using user_id as id
        await Supabase.instance.client
            .from('players')
            .insert({
              'id': _userId,
              'current_team_id': teamId,
              'height': height,
              'weight': weight,
              'positions': positions,
              'strong_leg': strongLeg,
              'skills': jsonEncode(skills), // Now this should work after importing 'dart:convert'
            });

        Navigator.pushReplacementNamed(
          context,
          '/onboarding/favorites',
          arguments: {'userId': _userId},
        );
      } catch (e, stackTrace) {
        AppLogger.error('Error during player onboarding', error: e, stackTrace: stackTrace);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  Future<bool> _checkUserExists(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();  // Use maybeSingle() instead of single()
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
      debugPrint('Error fetching team ID: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('שחקן - שלב ההרשמה'),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 18),
                        _buildTeamNameField(),
                        const SizedBox(height: 18),
                        _buildPositionSelection(),
                        const SizedBox(height: 10),
                        _buildHeightWeightFields(),
                        const SizedBox(height: 10),
                        _buildLegSelection(),
                        const SizedBox(height: 10),
                        _buildSkillsSliders(),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: _submitAndNavigate,
                          child: const Text(
                            'המשך',
                            style: TextStyle(fontSize: 16.2),
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
    );
  }

Widget _buildTeamNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'קבוצה (אופציונלי):',
          style: TextStyle(fontSize: 16.2),
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
                  return TextFormField(
                    controller: fieldController,
                    focusNode: fieldFocusNode,
                    decoration: const InputDecoration(
                      labelText: 'הזן את שם הקבוצה',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: alternateThemeColor,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _isTeamValid = false;
                        });
                      }
                    },
                    validator: (value) {
                      if (value?.isNotEmpty == true && !_isTeamValid) {
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
          style: TextStyle(fontSize: 16.2),
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
        const Text('גובה: ', style: TextStyle(fontSize: 16.2)),
        Expanded(
          child: _buildTextFormField(
            controller: _heightController,
            labelText: '(בס"מ)',
            validatorMessage: 'נא להזין גובה',
          ),
        ),
        const SizedBox(width: 10),
        const Text('משקל: ', style: TextStyle(fontSize: 16.2)),
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
          style: TextStyle(fontSize: 16.2),
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
      children: skills.map((skill) {
        return _buildSlider(
          skill['label'] as String,
          skill['value'] as double,
          (value) {
            setState(() {
              (skill['setter'] as Function(double))(value);
            });
          },
        );
      }).toList(),
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
      ),
      validator: (value) =>
          value == null || value.isEmpty ? validatorMessage : null,
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.2),
        ),
        Slider(
          value: value,
          min: 0,
          max: 10,
          divisions: 10,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}