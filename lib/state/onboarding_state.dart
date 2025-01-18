class OnboardingState {
  const OnboardingState.empty()
      : teamName = null,
        height = null,
        weight = null,
        positions = const [],
        strongLeg = null,
        skills = null,
        email = null,
        name = null,
        dateOfBirth = null,
        role = null,
        address = null,
        city = null;

  final String? teamName;
  final int? height;
  final int? weight;
  final List<String>? positions;
  final String? strongLeg;
  final PlayerSkills? skills;
  final String? email;
  final String? name;
  final DateTime? dateOfBirth;
  final String? role;
  final String? address;
  final String? city;

  const OnboardingState({
    this.teamName,
    this.height,
    this.weight,
    this.positions,
    this.strongLeg,
    this.skills,
    this.email,
    this.name,
    this.dateOfBirth,
    this.role,
    this.address,
    this.city,
  });

  OnboardingState copyWith({
    String? email,
    String? name,
    DateTime? dateOfBirth,
    String? role,
    String? address,
    String? city,
    String? teamName,
    int? height,
    int? weight,
    List<String>? positions,
    String? strongLeg,
    PlayerSkills? skills,
  }) {
    return OnboardingState(
      teamName: teamName ?? this.teamName,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      positions: positions ?? this.positions,
      strongLeg: strongLeg ?? this.strongLeg,
      skills: skills ?? this.skills,
      email: email ?? this.email,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      role: role ?? this.role,
      address: address ?? this.address,
      city: city ?? this.city,
    );
  }
}

class PlayerSkills {
  final double speed;
  final double headers;
  final double defending;
  final double passing;
  final double scoring;
  final double goalkeeping;

  const PlayerSkills({
    required this.speed,
    required this.headers,
    required this.defending,
    required this.passing,
    required this.scoring,
    required this.goalkeeping,
  });

  Map<String, double> toMap() {
    return {
      'speed': speed,
      'headers': headers,
      'defending': defending,
      'passing': passing,
      'scoring': scoring,
      'goalkeeping': goalkeeping,
    };
  }

  factory PlayerSkills.fromMap(Map<String, dynamic> map) {
    return PlayerSkills(
      speed: map['speed'] as double,
      headers: map['headers'] as double,
      defending: map['defending'] as double,
      passing: map['passing'] as double,
      scoring: map['scoring'] as double,
      goalkeeping: map['goalkeeping'] as double,
    );
  }
}