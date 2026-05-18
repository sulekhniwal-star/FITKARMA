import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SystemSettingsState {
  final bool isDarkMode;
  final String language; // 'English' or 'Hindi'
  final bool notificationsEnabled;
  final bool dyslexicFont;
  final double textScale;
  final bool lowDataMode;
  final bool biometricLock;
  final int waterDailyGoalMl;
  final int stepDailyGoal;
  final int workoutDailyGoalMinutes;

  SystemSettingsState({
    this.isDarkMode = true,
    this.language = 'English',
    this.notificationsEnabled = true,
    this.dyslexicFont = false,
    this.textScale = 1.0,
    this.lowDataMode = false,
    this.biometricLock = true,
    this.waterDailyGoalMl = 3000,
    this.stepDailyGoal = 10000,
    this.workoutDailyGoalMinutes = 30,
  });

  SystemSettingsState copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
    bool? dyslexicFont,
    double? textScale,
    bool? lowDataMode,
    bool? biometricLock,
    int? waterDailyGoalMl,
    int? stepDailyGoal,
    int? workoutDailyGoalMinutes,
  }) {
    return SystemSettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dyslexicFont: dyslexicFont ?? this.dyslexicFont,
      textScale: textScale ?? this.textScale,
      lowDataMode: lowDataMode ?? this.lowDataMode,
      biometricLock: biometricLock ?? this.biometricLock,
      waterDailyGoalMl: waterDailyGoalMl ?? this.waterDailyGoalMl,
      stepDailyGoal: stepDailyGoal ?? this.stepDailyGoal,
      workoutDailyGoalMinutes: workoutDailyGoalMinutes ?? this.workoutDailyGoalMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
        'isDarkMode': isDarkMode,
        'language': language,
        'notificationsEnabled': notificationsEnabled,
        'dyslexicFont': dyslexicFont,
        'textScale': textScale,
        'lowDataMode': lowDataMode,
        'biometricLock': biometricLock,
        'waterDailyGoalMl': waterDailyGoalMl,
        'stepDailyGoal': stepDailyGoal,
        'workoutDailyGoalMinutes': workoutDailyGoalMinutes,
      };

  factory SystemSettingsState.fromJson(Map<String, dynamic> json) => SystemSettingsState(
        isDarkMode: json['isDarkMode'] as bool? ?? true,
        language: json['language'] as String? ?? 'English',
        notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
        dyslexicFont: json['dyslexicFont'] as bool? ?? false,
        textScale: (json['textScale'] as num?)?.toDouble() ?? 1.0,
        lowDataMode: json['lowDataMode'] as bool? ?? false,
        biometricLock: json['biometricLock'] as bool? ?? true,
        waterDailyGoalMl: json['waterDailyGoalMl'] as int? ?? 3000,
        stepDailyGoal: json['stepDailyGoal'] as int? ?? 10000,
        workoutDailyGoalMinutes: json['workoutDailyGoalMinutes'] as int? ?? 30,
      );
}

class SystemSettingsNotifier extends Notifier<SystemSettingsState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storeKey = 'app_system_settings_preferences_v1';

  @override
  SystemSettingsState build() {
    Future.microtask(() => _loadPrefs());
    return SystemSettingsState();
  }

  Future<void> _loadPrefs() async {
    try {
      final str = await _storage.read(key: _storeKey);
      if (str != null) {
        state = SystemSettingsState.fromJson(jsonDecode(str) as Map<String, dynamic>);
      }
    } catch (_) {}
  }

  Future<void> _savePrefs(SystemSettingsState updated) async {
    state = updated;
    try {
      await _storage.write(key: _storeKey, value: jsonEncode(updated.toJson()));
    } catch (_) {}
  }

  void toggleTheme() => _savePrefs(state.copyWith(isDarkMode: !state.isDarkMode));
  void setLanguage(String lang) => _savePrefs(state.copyWith(language: lang));
  void toggleNotifications() => _savePrefs(state.copyWith(notificationsEnabled: !state.notificationsEnabled));
  void toggleDyslexicFont() => _savePrefs(state.copyWith(dyslexicFont: !state.dyslexicFont));
  void setTextScale(double scale) => _savePrefs(state.copyWith(textScale: scale));
  void toggleLowDataMode() => _savePrefs(state.copyWith(lowDataMode: !state.lowDataMode));
  void toggleBiometricLock() => _savePrefs(state.copyWith(biometricLock: !state.biometricLock));
  void updateWaterGoal(int ml) => _savePrefs(state.copyWith(waterDailyGoalMl: ml));
  void updateStepGoal(int steps) => _savePrefs(state.copyWith(stepDailyGoal: steps));
  void updateWorkoutGoal(int minutes) => _savePrefs(state.copyWith(workoutDailyGoalMinutes: minutes));
}

final systemSettingsProvider = NotifierProvider<SystemSettingsNotifier, SystemSettingsState>(SystemSettingsNotifier.new);
