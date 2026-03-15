// lib/core/storage/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_boxes.dart';
import '../security/key_manager.dart';

/// Service for initializing and managing Hive local storage boxes.
///
/// Non-encrypted boxes are opened immediately on app start.
/// Encrypted boxes require an encryption key from the security module
/// (see Section 16.2 for key derivation).
class HiveService {
  // Static instance for singleton access
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  // Encryption key - set after authentication
  static List<int>? _encryptionKey;

  /// Sets the encryption key for encrypted boxes.
  /// Should be called after user authentication using KeyManager.
  static void setEncryptionKey(List<int> key) {
    _encryptionKey = key;
  }

  /// Initializes Hive and opens all non-encrypted boxes.
  static Future<void> init() async {
    await Hive.initFlutter();
    await _openNonEncryptedBoxes();
  }

  /// Opens encrypted boxes after user authentication.
  /// Call this after the user logs in with their password.
  ///
  /// Parameters:
  /// - [password]: User's password used for key derivation
  static Future<void> initEncryptedBoxes(String password) async {
    // Initialize key manager and derive key
    final keyManager = KeyManager.instance;
    await keyManager.initialize();

    // Derive the encryption key from password
    final key = await keyManager.getOrCreateKey(password);
    setEncryptionKey(key);

    // Open encrypted boxes
    await openEncryptedBoxes();
  }

  /// Opens all non-encrypted Hive boxes.
  static Future<void> _openNonEncryptedBoxes() async {
    // Core boxes - food, steps, workouts, sleep, mood
    await Hive.openBox(HiveBoxes.foodLogs);
    await Hive.openBox(HiveBoxes.stepLogs);
    await Hive.openBox(HiveBoxes.workoutLogs);
    await Hive.openBox(HiveBoxes.sleepLogs);
    await Hive.openBox(HiveBoxes.moodLogs);

    // Other health data
    await Hive.openBox(HiveBoxes.medications);
    await Hive.openBox(HiveBoxes.habits);
    await Hive.openBox(HiveBoxes.bodyMetrics);
    await Hive.openBox(HiveBoxes.spo2);
    await Hive.openBox(HiveBoxes.fasting);

    // Cache & sync
    await Hive.openBox(HiveBoxes.foodItems);
    await Hive.openBox(HiveBoxes.syncQueue);
    await Hive.openBox(HiveBoxes.wearableSync);

    // User data
    await Hive.openBox(HiveBoxes.userPrefs);
    await Hive.openBox(HiveBoxes.karma);
    await Hive.openBox(HiveBoxes.nutritionGoals);

    // Extended features
    await Hive.openBox(HiveBoxes.mealPlans);
    await Hive.openBox(HiveBoxes.recipes);
    await Hive.openBox(HiveBoxes.personalRecords);
    await Hive.openBox(HiveBoxes.healthReports);
  }

  /// Opens all encrypted Hive boxes.
  /// Requires encryption key to be set via setEncryptionKey().
  /// See Section 16.2 for key derivation using PBKDF2.
  static Future<void> openEncryptedBoxes() async {
    if (_encryptionKey == null) {
      throw StateError(
        'Encryption key not set. Call setEncryptionKey() with key derived '
        'from deriveKey() in lib/core/security/encryption_service.dart',
      );
    }

    final cipher = HiveAesCipher(_encryptionKey!);

    // Encrypted boxes - sensitive health data
    await Hive.openBox(HiveBoxes.periodLogs, encryptionCipher: cipher);
    await Hive.openBox(HiveBoxes.journal, encryptionCipher: cipher);
    await Hive.openBox(HiveBoxes.bloodPressure, encryptionCipher: cipher);
    await Hive.openBox(HiveBoxes.glucose, encryptionCipher: cipher);
    await Hive.openBox(HiveBoxes.doctorAppointments, encryptionCipher: cipher);
  }

  /// Convenience getters for commonly used boxes
  static Box get foodLogsBox => Hive.box(HiveBoxes.foodLogs);
  static Box get stepLogsBox => Hive.box(HiveBoxes.stepLogs);
  static Box get workoutLogsBox => Hive.box(HiveBoxes.workoutLogs);
  static Box get sleepLogsBox => Hive.box(HiveBoxes.sleepLogs);
  static Box get moodLogsBox => Hive.box(HiveBoxes.moodLogs);
  static Box get userPrefsBox => Hive.box(HiveBoxes.userPrefs);
  static Box get karmaBox => Hive.box(HiveBoxes.karma);
}
