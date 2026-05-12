import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfileMetrics {
  final String name;
  final String gender;
  final int age;
  final double heightCm;
  final double weightKg;

  UserProfileMetrics({
    required this.name,
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
        'age': age,
        'heightCm': heightCm,
        'weightKg': weightKg,
      };

  factory UserProfileMetrics.fromJson(Map<String, dynamic> json) => UserProfileMetrics(
        name: json['name'] as String? ?? 'Aanya Patel',
        gender: json['gender'] as String? ?? 'Female',
        age: json['age'] as int? ?? 28,
        heightCm: (json['heightCm'] as num? ?? 165.0).toDouble(),
        weightKg: (json['weightKg'] as num? ?? 62.0).toDouble(),
      );
}

class ProfileNotifier extends StateNotifier<UserProfileMetrics> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _storageKey = 'user_profile_editable_metrics';

  ProfileNotifier() : super(UserProfileMetrics(
    name: 'Aanya Patel',
    gender: 'Female',
    age: 28,
    heightCm: 165.0,
    weightKg: 62.0,
  )) {
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final data = await _storage.read(key: _storageKey);
      if (data != null) {
        state = UserProfileMetrics.fromJson(jsonDecode(data) as Map<String, dynamic>);
      }
    } catch (_) {}
  }

  Future<void> updateMetrics({
    String? name,
    String? gender,
    int? age,
    double? heightCm,
    double? weightKg,
  }) async {
    final updated = UserProfileMetrics(
      name: name ?? state.name,
      gender: gender ?? state.gender,
      age: age ?? state.age,
      heightCm: heightCm ?? state.heightCm,
      weightKg: weightKg ?? state.weightKg,
    );
    state = updated;
    try {
      await _storage.write(key: _storageKey, value: jsonEncode(updated.toJson()));
    } catch (_) {}
  }
}

final userProfileMetricsProvider = StateNotifierProvider<ProfileNotifier, UserProfileMetrics>((ref) {
  return ProfileNotifier();
});
