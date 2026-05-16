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
        name: json['name'] as String? ?? '',
        gender: json['gender'] as String? ?? '',
        age: json['age'] as int? ?? 0,
        heightCm: (json['heightCm'] as num? ?? 0.0).toDouble(),
        weightKg: (json['weightKg'] as num? ?? 0.0).toDouble(),
      );
}

class ProfileNotifier extends Notifier<UserProfileMetrics> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_profile_metrics_v2';

  @override
  UserProfileMetrics build() {
    Future.microtask(() => _loadState());
    return UserProfileMetrics(
      name: '',
      gender: '',
      age: 0,
      heightCm: 0.0,
      weightKg: 0.0,
    );
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

final userProfileMetricsProvider = NotifierProvider<ProfileNotifier, UserProfileMetrics>(ProfileNotifier.new);
