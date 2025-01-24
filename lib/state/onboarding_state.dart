class OnboardingState {
  final String? teamName;
  final bool? isProfessionalCoach;
  final String? certificateNumber;
  final String? certificateFileName;  // Add this field
  final String? certificateUrl;
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
  final String? parentId;     // Add this field for parent's ID number
  final String? playerUserId;

  const OnboardingState({
    this.teamName,
    this.isProfessionalCoach,
    this.certificateNumber,
    this.certificateFileName,  // Add this
    this.certificateUrl,
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
    this.parentId,
    this.playerUserId,
  });

  const OnboardingState.empty()
      : teamName = null,
        isProfessionalCoach = null,
        certificateNumber = null,
        certificateFileName = null,  // Add this
        certificateUrl = null,
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
        city = null,
        parentId = null,
        playerUserId = null;

  OnboardingState copyWith({
    String? teamName,
    bool? isProfessionalCoach,
    String? certificateNumber,
    String? certificateFileName,  // Add this
    String? certificateUrl,       // Add this
    String? email,
    String? name,
    DateTime? dateOfBirth,
    String? role,
    String? address,
    String? city,
    int? height,
    int? weight,
    List<String>? positions,
    String? strongLeg,
    PlayerSkills? skills,
    String? parentId,
    String? playerUserId,
  }) {
    return OnboardingState(
      teamName: teamName ?? this.teamName,
      isProfessionalCoach: isProfessionalCoach ?? this.isProfessionalCoach,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      certificateFileName: certificateFileName ?? this.certificateFileName,
      certificateUrl: certificateUrl ?? this.certificateUrl,
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
      parentId: parentId ?? this.parentId,
      playerUserId: playerUserId ?? this.playerUserId,
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