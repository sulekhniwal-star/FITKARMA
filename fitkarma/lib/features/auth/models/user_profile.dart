// lib/features/auth/models/user_profile.dart

/// User profile model for onboarding data
class UserProfile {
  String? name;
  String? gender;
  DateTime? dateOfBirth;
  double? heightCm;
  double? weightKg;
  String? fitnessGoal;
  String? activityLevel;
  List<String> chronicConditions;
  DoshaProfile? doshaProfile;
  String? language;
  List<String> healthPermissions;
  String? wearableDevice;
  bool onboardingCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int xp;
  int karmaLevel;

  UserProfile({
    this.name,
    this.gender,
    this.dateOfBirth,
    this.heightCm,
    this.weightKg,
    this.fitnessGoal,
    this.activityLevel,
    List<String>? chronicConditions,
    this.doshaProfile,
    this.language,
    this.healthPermissions = const [],
    this.wearableDevice,
    this.onboardingCompleted = false,
    this.createdAt,
    this.updatedAt,
    this.xp = 0,
    this.karmaLevel = 1,
  }) : chronicConditions = chronicConditions ?? [];

  /// Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// Create from JSON (Appwrite/Hive)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      fitnessGoal: json['fitnessGoal'] as String?,
      activityLevel: json['activityLevel'] as String?,
      chronicConditions:
          (json['chronicConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      doshaProfile: json['doshaProfile'] != null
          ? DoshaProfile.fromJson(json['doshaProfile'] as Map<String, dynamic>)
          : null,
      language: json['language'] as String?,
      healthPermissions:
          (json['healthPermissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      wearableDevice: json['wearableDevice'] as String?,
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      xp: json['xp'] as int? ?? 0,
      karmaLevel: json['karmaLevel'] as int? ?? 1,
    );
  }

  /// Convert to JSON (for Appwrite/Hive storage)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'heightCm': heightCm,
      'weightKg': weightKg,
      'fitnessGoal': fitnessGoal,
      'activityLevel': activityLevel,
      'chronicConditions': chronicConditions,
      'doshaProfile': doshaProfile?.toJson(),
      'language': language,
      'healthPermissions': healthPermissions,
      'wearableDevice': wearableDevice,
      'onboardingCompleted': onboardingCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'xp': xp,
      'karmaLevel': karmaLevel,
    };
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? name,
    String? gender,
    DateTime? dateOfBirth,
    double? heightCm,
    double? weightKg,
    String? fitnessGoal,
    String? activityLevel,
    List<String>? chronicConditions,
    DoshaProfile? doshaProfile,
    String? language,
    List<String>? healthPermissions,
    String? wearableDevice,
    bool? onboardingCompleted,
    int? xp,
    int? karmaLevel,
  }) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      doshaProfile: doshaProfile ?? this.doshaProfile,
      language: language ?? this.language,
      healthPermissions: healthPermissions ?? this.healthPermissions,
      wearableDevice: wearableDevice ?? this.wearableDevice,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: DateTime.now(),
      xp: xp ?? this.xp,
      karmaLevel: karmaLevel ?? this.karmaLevel,
    );
  }
}

/// Dosha profile for Ayurveda
class DoshaProfile {
  int vataPercentage;
  int pittaPercentage;
  int kaphaPercentage;
  String dominantDosha;
  List<int> quizAnswers;

  DoshaProfile({
    required this.vataPercentage,
    required this.pittaPercentage,
    required this.kaphaPercentage,
    required this.dominantDosha,
    List<int>? quizAnswers,
  }) : quizAnswers = quizAnswers ?? [];

  factory DoshaProfile.fromJson(Map<String, dynamic> json) {
    return DoshaProfile(
      vataPercentage: json['vataPercentage'] as int? ?? 0,
      pittaPercentage: json['pittaPercentage'] as int? ?? 0,
      kaphaPercentage: json['kaphaPercentage'] as int? ?? 0,
      dominantDosha: json['dominantDosha'] as String? ?? 'balanced',
      quizAnswers:
          (json['quizAnswers'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vataPercentage': vataPercentage,
      'pittaPercentage': pittaPercentage,
      'kaphaPercentage': kaphaPercentage,
      'dominantDosha': dominantDosha,
      'quizAnswers': quizAnswers,
    };
  }

  /// Calculate dosha percentages from quiz answers
  /// Each answer contributes to different doshas
  static DoshaProfile calculateFromAnswers(List<int> answers) {
    int vata = 0, pitta = 0, kapha = 0;

    // 12 questions, each with 4 options
    // Option 1 -> Vata, Option 2 -> Pitta, Option 3 -> Kapha, Option 4 -> Balanced
    for (int i = 0; i < answers.length && i < 12; i++) {
      final answer = answers[i];
      if (answer == 1)
        vata++;
      else if (answer == 2)
        pitta++;
      else if (answer == 3)
        kapha++;
      // Option 4 is neutral/balanced
    }

    // Calculate percentages
    final total = vata + pitta + kapha;
    if (total == 0) {
      return DoshaProfile(
        vataPercentage: 33,
        pittaPercentage: 33,
        kaphaPercentage: 34,
        dominantDosha: 'balanced',
      );
    }

    final vataPct = (vata * 100 / total).round();
    final pittaPct = (pitta * 100 / total).round();
    final kaphaPct = 100 - vataPct - pittaPct;

    String dominant;
    if (vata >= pitta && vata >= kapha) {
      dominant = 'vata';
    } else if (pitta >= vata && pitta >= kapha) {
      dominant = 'pitta';
    } else if (kapha >= vata && kapha >= pitta) {
      dominant = 'kapha';
    } else {
      dominant = 'balanced';
    }

    return DoshaProfile(
      vataPercentage: vataPct,
      pittaPercentage: pittaPct,
      kaphaPercentage: kaphaPct,
      dominantDosha: dominant,
      quizAnswers: answers,
    );
  }
}

/// Available languages
class LanguageOptions {
  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी'},
    {'code': 'ta', 'name': 'Tamil', 'nativeName': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'nativeName': 'తెలుగు'},
    {'code': 'kn', 'name': 'Kannada', 'nativeName': 'ಕನ್ನಡ'},
    {'code': 'ml', 'name': 'Malayalam', 'nativeName': 'മലയാളം'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'বাংলা'},
    {'code': 'mr', 'name': 'Marathi', 'nativeName': 'मराठी'},
  ];
}

/// Fitness goal options
class FitnessGoalOptions {
  static const List<Map<String, String>> goals = [
    {'id': 'lose_weight', 'name': 'Lose Weight', 'icon': 'scale'},
    {'id': 'gain_muscle', 'name': 'Gain Muscle', 'icon': 'fitness_center'},
    {'id': 'maintain', 'name': 'Maintain', 'icon': 'check_circle'},
    {'id': 'endurance', 'name': 'Endurance', 'icon': 'directions_run'},
  ];
}

/// Activity level options
class ActivityLevelOptions {
  static const List<Map<String, dynamic>> levels = [
    {
      'id': 'sedentary',
      'name': 'Sedentary',
      'description': 'Little to no exercise',
      'value': 1,
    },
    {
      'id': 'lightly_active',
      'name': 'Lightly Active',
      'description': 'Light exercise 1-3 days/week',
      'value': 2,
    },
    {
      'id': 'moderately_active',
      'name': 'Moderately Active',
      'description': 'Moderate exercise 3-5 days/week',
      'value': 3,
    },
    {
      'id': 'very_active',
      'name': 'Very Active',
      'description': 'Hard exercise 6-7 days/week',
      'value': 4,
    },
    {
      'id': 'extremely_active',
      'name': 'Extremely Active',
      'description': 'Very hard exercise, physical job',
      'value': 5,
    },
  ];
}

/// Chronic condition options
class ChronicConditionOptions {
  static const List<String> conditions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'PCOD/PCOS',
    'Thyroid',
    'Asthma',
    'Arthritis',
    'None',
  ];
}

/// Health permission options
class HealthPermissionOptions {
  static const List<Map<String, String>> permissions = [
    {
      'id': 'steps',
      'name': 'Step Counting',
      'description': 'Access step count data',
    },
    {
      'id': 'heart_rate',
      'name': 'Heart Rate',
      'description': 'Access heart rate data',
    },
    {
      'id': 'sleep',
      'name': 'Sleep Data',
      'description': 'Access sleep patterns',
    },
    {
      'id': 'activity',
      'name': 'Activity Rings',
      'description': 'Access activity summary',
    },
  ];
}

/// Dosha quiz questions
class DoshaQuizQuestions {
  static const List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'question': 'How would you describe your body frame?',
      'options': ['Thin, slender', 'Medium, muscular', 'Large, stocky'],
    },
    {
      'id': 2,
      'question': 'What is your skin type?',
      'options': ['Dry, rough', 'Oily, sensitive', 'Thick, oily'],
    },
    {
      'id': 3,
      'question': 'How do you handle stress?',
      'options': ['Get anxious/worried', 'Get frustrated/angry', 'Stay calm'],
    },
    {
      'id': 4,
      'question': 'What is your appetite like?',
      'options': ['Irregular, small', 'Strong, intense', 'Steady, slow'],
    },
    {
      'id': 5,
      'question': 'How is your digestion?',
      'options': [
        'Tends to be constipated',
        'Fast, sometimes burning',
        'Slow, heavy',
      ],
    },
    {
      'id': 6,
      'question': 'What is your typical energy level?',
      'options': [
        'Fluctuating, get tired quickly',
        'High, but can burn out',
        'Steady, consistent',
      ],
    },
    {
      'id': 7,
      'question': 'How do you prefer to exercise?',
      'options': [
        'Light, gentle movements',
        'Intense, challenging',
        'Moderate, consistent',
      ],
    },
    {
      'id': 8,
      'question': 'What weather affects you most?',
      'options': ['Cold, dry weather', 'Hot weather', 'Cold, humid weather'],
    },
    {
      'id': 9,
      'question': 'How is your memory?',
      'options': [
        'Good short-term, forgetful',
        'Sharp, quick',
        'Slow but long-lasting',
      ],
    },
    {
      'id': 10,
      'question': 'What is your sleep pattern?',
      'options': [
        'Light, easily disturbed',
        'Moderate, sometimes restless',
        'Deep, heavy',
      ],
    },
    {
      'id': 11,
      'question': 'How do you make decisions?',
      'options': ['Quick, impulsive', 'Decisive, direct', 'Slow, careful'],
    },
    {
      'id': 12,
      'question': 'What is your personality like?',
      'options': [
        'Energetic, restless',
        'Ambitious, competitive',
        'Calm, patient',
      ],
    },
  ];
}
