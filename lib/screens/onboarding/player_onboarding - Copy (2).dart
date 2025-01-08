import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerOnboarding extends StatefulWidget {
  const PlayerOnboarding({super.key});

  @override
  State<PlayerOnboarding> createState() => _PlayerOnboardingState();
}

class _PlayerOnboardingState extends State<PlayerOnboarding> {
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

  static const Color alternateThemeColor = Color(0xFFE0E3E7);

  Future<void> _submitAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      final teamName = _teamNameController.text.trim();
      final height = _heightController.text.trim();
      final weight = _weightController.text.trim();

      AppLogger.info('Player Onboarding form submitted');
      AppLogger.info(
          'Team Name: $teamName, Height: $height, Weight: $weight, Positions: $_selectedPositions, Leg: $_selectedLeg, Speed: $_speed, Headers: $_headers, Defending: $_defending, Passing: $_passing, Scoring: $_scoring, Goalkeeping: $_goalkeeping');

      try {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/onboarding/favorites');
      } catch (e, stackTrace) {
        AppLogger.error('Error during player onboarding', error: e, stackTrace: stackTrace);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
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
                  color: Colors.white.withOpacity(0.9),
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
                        const SizedBox(height: 10),
                        _buildPopupMessage(),
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
  return Row(
    children: [
      const Text(
        'שם הקבוצה:',
        style: TextStyle(fontSize: 16.2),
      ),
      const SizedBox(width: 10),
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
              validator: (value) =>
                  value == null || value.isEmpty ? 'נא להזין שם קבוצה' : null,
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
  );
}

  Widget _buildPopupMessage() {
  return GestureDetector(
    onTap: _showCreateTeamDialog,
    child: const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        'אין לך עדיין קבוצה או שקבוצתך לא רשומה?',
        style: TextStyle(
          fontSize: 14,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

void _showCreateTeamDialog() {
  final TextEditingController _newTeamNameController = TextEditingController();
  final TextEditingController _newTeamAddressController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('צור קבוצה חדשה'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _newTeamNameController,
                decoration: const InputDecoration(
                  labelText: 'שם הקבוצה',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _newTeamAddressController,
                decoration: const InputDecoration(
                  labelText: 'כתובת',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('ביטול'),
          ),
          TextButton(
            onPressed: () async {
              final String teamName = _newTeamNameController.text.trim();
              final String teamAddress = _newTeamAddressController.text.trim();
              await _saveNewTeam(teamName, teamAddress);
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text('שמירה'),
          ),
        ],
      );
    },
  );
}
Future<void> _saveNewTeam(String teamName, String teamAddress) async {
  try {
    await Supabase.instance.client.from('teams').insert({
      'name': teamName,
      'address': teamAddress,
    });

    setState(() {
      _teamNameController.text = teamName;
    });
  } catch (e) {
    debugPrint('Save team error: $e');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving team: $e')),
    );
  }
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
                style: const TextStyle(fontSize: 12), // Set font size to 12
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
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
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
