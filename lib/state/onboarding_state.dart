import 'dart:convert';

/// Represents the skills of a player
class PlayerSkills {
  /// Speed skill rating
  final double speed;

  /// Headers skill rating
  final double headers;

  /// Defending skill rating
  final double defending;

  /// Passing skill rating
  final double passing;

  /// Scoring skill rating
  final double scoring;

  /// Goalkeeping skill rating
  final double goalkeeping;

  /// Create a new PlayerSkills instance
  const PlayerSkills({
    required this.speed,
    required this.headers,
    required this.defending,
    required this.passing,
    required this.scoring,
    required this.goalkeeping,
  });

  /// Convert PlayerSkills to a Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'speed': speed,
      'headers': headers,
      'defending': defending,
      'passing': passing,
      'scoring': scoring,
      'goalkeeping': goalkeeping,
    };
  }

  /// Create PlayerSkills from a Map
  factory PlayerSkills.fromMap(Map<String, dynamic> map) {
    return PlayerSkills(
      speed: (map['speed'] as num?)?.toDouble() ?? 0.0,
      headers: (map['headers'] as num?)?.toDouble() ?? 0.0,
      defending: (map['defending'] as num?)?.toDouble() ?? 0.0,
      passing: (map['passing'] as num?)?.toDouble() ?? 0.0,
      scoring: (map['scoring'] as num?)?.toDouble() ?? 0.0,
      goalkeeping: (map['goalkeeping'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert PlayerSkills to JSON string
  String toJson() => json.encode(toMap());

  /// Create PlayerSkills from JSON string
  factory PlayerSkills.fromJson(String source) => 
    PlayerSkills.fromMap(json.decode(source));

  /// Create a copy of PlayerSkills with optional parameter overrides
  PlayerSkills copyWith({
    double? speed,
    double? headers,
    double? defending,
    double? passing,
    double? scoring,
    double? goalkeeping,
  }) {
    return PlayerSkills(
      speed: speed ?? this.speed,
      headers: headers ?? this.headers,
      defending: defending ?? this.defending,
      passing: passing ?? this.passing,
      scoring: scoring ?? this.scoring,
      goalkeeping: goalkeeping ?? this.goalkeeping,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PlayerSkills &&
      other.speed == speed &&
      other.headers == headers &&
      other.defending == defending &&
      other.passing == passing &&
      other.scoring == scoring &&
      other.goalkeeping == goalkeeping;
  }

  @override
  int get hashCode {
    return speed.hashCode ^
      headers.hashCode ^
      defending.hashCode ^
      passing.hashCode ^
      scoring.hashCode ^
      goalkeeping.hashCode;
  }
}

/// Represents the state of the onboarding process for different user roles
class OnboardingState {
  /// Team name
  final String? teamName;

  /// Flag indicating if the user is a professional coach
  final bool? isProfessionalCoach;

  /// Coach's certificate number
  final String? certificateNumber;

  /// Filename of the uploaded certificate
  final String? certificateFileName;

  /// URL of the uploaded certificate
  final String? certificateUrl;

  /// Player's height
  final int? height;

  /// Player's weight
  final int? weight;

  /// Player's positions
  final List<String>? positions;

  /// Player's strong leg
  final String? strongLeg;

  /// Player's skills
  final PlayerSkills? skills;

  /// User's email
  final String? email;

  /// User's name
  final String? name;

  /// User's date of birth
  final DateTime? dateOfBirth;

  /// User's role
  final String? role;

  /// User's address
  final String? address;

  /// User's city
  final String? city;

  /// User's phone number
  final String? phoneNumber;

  /// Parent's ID
  final String? parentId;

  /// Player's user ID (for parent role)
  final String? playerUserId;

  /// User's ID number
  final String? idNumber;

  /// Community name
  final String? communityName;

  /// Constructor for OnboardingState
  const OnboardingState({
    this.teamName,
    this.isProfessionalCoach,
    this.certificateNumber,
    this.certificateFileName,
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
    this.phoneNumber,
    this.parentId,
    this.playerUserId,
    this.idNumber,
    this.communityName,
  });

  /// Creates an empty OnboardingState
  const OnboardingState.empty()
      : teamName = null,
        isProfessionalCoach = null,
        certificateNumber = null,
        certificateFileName = null,
        certificateUrl = null,
        height = null,
        weight = null,
        positions = null,
        strongLeg = null,
        skills = null,
        email = null,
        name = null,
        dateOfBirth = null,
        role = null,
        address = null,
        city = null,
        phoneNumber = null,
        parentId = null,
        playerUserId = null,
        idNumber = null,
        communityName = null;

  /// Creates a copy of OnboardingState with optional parameter overrides
  OnboardingState copyWith({
    String? teamName,
    bool? isProfessionalCoach,
    String? certificateNumber,
    String? certificateFileName,
    String? certificateUrl,
    int? height,
    int? weight,
    List<String>? positions,
    String? strongLeg,
    PlayerSkills? skills,
    String? email,
    String? name,
    DateTime? dateOfBirth,
    String? role,
    String? address,
    String? city,
    String? phoneNumber,
    String? parentId,
    String? playerUserId,
    String? idNumber,
    String? communityName,
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
      phoneNumber: phoneNumber ?? this.phoneNumber,
      parentId: parentId ?? this.parentId,
      playerUserId: playerUserId ?? this.playerUserId,
      idNumber: idNumber ?? this.idNumber,
      communityName: communityName ?? this.communityName,
    );
  }

  /// Convert OnboardingState to a Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'teamName': teamName,
      'isProfessionalCoach': isProfessionalCoach,
      'certificateNumber': certificateNumber,
      'certificateFileName': certificateFileName,
      'certificateUrl': certificateUrl,
      'height': height,
      'weight': weight,
      'positions': positions,
      'strongLeg': strongLeg,
      'skills': skills?.toMap(),
      'email': email,
      'name': name,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'role': role,
      'address': address,
      'city': city,
      'phoneNumber': phoneNumber,
      'parentId': parentId,
      'playerUserId': playerUserId,
      'idNumber': idNumber,
      'communityName': communityName,
    };
  }

  /// Create OnboardingState from a Map
  factory OnboardingState.fromMap(Map<String, dynamic> map) {
    return OnboardingState(
      teamName: map['teamName'] as String?,
      isProfessionalCoach: map['isProfessionalCoach'] as bool?,
      certificateNumber: map['certificateNumber'] as String?,
      certificateFileName: map['certificateFileName'] as String?,
      certificateUrl: map['certificateUrl'] as String?,
      height: map['height'] as int?,
      weight: map['weight'] as int?,
      positions: map['positions'] != null 
        ? List<String>.from(map['positions']) 
        : null,
      strongLeg: map['strongLeg'] as String?,
      skills: map['skills'] != null 
        ? PlayerSkills.fromMap(map['skills']) 
        : null,
      email: map['email'] as String?,
      name: map['name'] as String?,
      dateOfBirth: map['dateOfBirth'] != null 
        ? DateTime.tryParse(map['dateOfBirth']) 
        : null,
      role: map['role'] as String?,
      address: map['address'] as String?,
      city: map['city'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      parentId: map['parentId'] as String?,
      playerUserId: map['playerUserId'] as String?,
      idNumber: map['idNumber'] as String?,
      communityName: map['communityName'] as String?,
    );
  }

  /// Convert OnboardingState to JSON string
  String toJson() => json.encode(toMap());

  /// Create OnboardingState from JSON string
  factory OnboardingState.fromJson(String source) => 
    OnboardingState.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OnboardingState &&
      other.teamName == teamName &&
      other.isProfessionalCoach == isProfessionalCoach &&
      other.certificateNumber == certificateNumber &&
      other.certificateFileName == certificateFileName &&
      other.certificateUrl == certificateUrl &&
      other.height == height &&
      other.weight == weight &&
      _listEquals(other.positions, positions) &&
      other.strongLeg == strongLeg &&
      other.skills == skills &&
      other.email == email &&
      other.name == name &&
      other.dateOfBirth == dateOfBirth &&
      other.role == role &&
      other.address == address &&
      other.city == city &&
      other.phoneNumber == phoneNumber &&
      other.parentId == parentId &&
      other.playerUserId == playerUserId &&
      other.idNumber == idNumber &&
      other.communityName == communityName;
  }

  @override
  int get hashCode {
    return teamName.hashCode ^
      isProfessionalCoach.hashCode ^
      certificateNumber.hashCode ^
      certificateFileName.hashCode ^
      certificateUrl.hashCode ^
      height.hashCode ^
      weight.hashCode ^
      _hashList(positions) ^
      strongLeg.hashCode ^
      skills.hashCode ^
      email.hashCode ^
      name.hashCode ^
      dateOfBirth.hashCode ^
      role.hashCode ^
      address.hashCode ^
      city.hashCode ^
      phoneNumber.hashCode ^
      parentId.hashCode ^
      playerUserId.hashCode ^
      idNumber.hashCode ^
      communityName.hashCode;
  }

  /// Helper method to compare lists
  bool _listEquals(List<String>? a, List<String>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Helper method to generate hash for lists
  int _hashList(List<String>? list) {
    if (list == null) return 0;
    return list.fold(0, (prev, element) => prev ^ element.hashCode);
  }
}