import 'package:appwrite/models.dart' as models;

enum Gender { male, female, other, preferNot }
enum FitnessGoal { loseWeight, gainMuscle, maintain, endurance }
enum ActivityLevel { sedentary, light, moderate, active, veryActive }
enum SubscriptionTier { free, premium, family }

class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime? dob;
  final Gender gender;
  final double heightCm;
  final double weightKg;
  final FitnessGoal goal;
  final ActivityLevel activityLevel;
  final String? doshaType;
  final String? bloodGroup;
  final String language;
  final SubscriptionTier subscriptionTier;
  final int karmaTotal;
  final int karmaLevel;
  final bool isLowDataMode;
  final List<String> chronicConditions;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.dob,
    this.gender = Gender.preferNot,
    this.heightCm = 0.0,
    this.weightKg = 0.0,
    this.goal = FitnessGoal.maintain,
    this.activityLevel = ActivityLevel.sedentary,
    this.doshaType,
    this.bloodGroup,
    this.language = 'en',
    this.subscriptionTier = SubscriptionTier.free,
    this.karmaTotal = 0,
    this.karmaLevel = 1,
    this.isLowDataMode = false,
    this.chronicConditions = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromAppwrite(models.Document doc) {
    return UserModel(
      id: doc.$id,
      name: doc.data['name'] ?? '',
      email: doc.data['email'] ?? '',
      dob: doc.data['dob'] != null ? DateTime.parse(doc.data['dob']) : null,
      gender: _parseGender(doc.data['gender']),
      heightCm: (doc.data['height_cm'] as num?)?.toDouble() ?? 0.0,
      weightKg: (doc.data['weight_kg'] as num?)?.toDouble() ?? 0.0,
      goal: _parseGoal(doc.data['goal']),
      activityLevel: _parseActivityLevel(doc.data['activity_level']),
      doshaType: doc.data['dosha_type'],
      bloodGroup: doc.data['blood_group'],
      language: doc.data['language'] ?? 'en',
      subscriptionTier: _parseSubscriptionTier(doc.data['subscription_tier']),
      karmaTotal: doc.data['karma_total'] ?? 0,
      karmaLevel: doc.data['karma_level'] ?? 1,
      isLowDataMode: doc.data['is_low_data_mode'] ?? false,
      chronicConditions: List<String>.from(doc.data['chronic_conditions'] ?? []),
      createdAt: DateTime.parse(doc.$createdAt),
      updatedAt: DateTime.parse(doc.$updatedAt),
    );
  }

  Map<String, dynamic> toAppwrite() {
    return {
      'name': name,
      'email': email,
      'dob': dob?.toIso8601String(),
      'gender': gender.name,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'goal': goal.name,
      'activity_level': activityLevel.name,
      'dosha_type': doshaType,
      'blood_group': bloodGroup,
      'language': language,
      'subscription_tier': subscriptionTier.name,
      'karma_total': karmaTotal,
      'karma_level': karmaLevel,
      'is_low_data_mode': isLowDataMode,
      'chronic_conditions': chronicConditions,
    };
  }

  static Gender _parseGender(String? val) {
    return Gender.values.firstWhere((e) => e.name == val, orElse: () => Gender.preferNot);
  }

  static FitnessGoal _parseGoal(String? val) {
    return FitnessGoal.values.firstWhere((e) => e.name == val, orElse: () => FitnessGoal.maintain);
  }

  static ActivityLevel _parseActivityLevel(String? val) {
    return ActivityLevel.values.firstWhere((e) => e.name == val, orElse: () => ActivityLevel.sedentary);
  }

  static SubscriptionTier _parseSubscriptionTier(String? val) {
    return SubscriptionTier.values.firstWhere((e) => e.name == val, orElse: () => SubscriptionTier.free);
  }
}
