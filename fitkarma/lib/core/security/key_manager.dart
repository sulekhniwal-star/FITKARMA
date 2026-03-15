// lib/core/security/key_manager.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'encryption_service.dart';

/// Key manager for deriving and caching the encryption key.
///
/// Combines device ID, user password, and stored salt to derive
/// the 256-bit encryption key used for Hive encrypted boxes.
///
/// This implements the pattern from Section 16.2:
/// - Device ID + User Password + Salt → PBKDF2 (100k iterations) → 256-bit key
class KeyManager {
  static KeyManager? _instance;
  static KeyManager get instance => _instance ??= KeyManager._internal();
  KeyManager._internal();

  final EncryptionService _encryptionService = EncryptionService();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Cached encryption key - cleared on logout
  Uint8List? _cachedKey;

  // Device ID - set once on app init
  String? _deviceId;

  /// Initializes the key manager with the device ID.
  /// Should be called on app startup.
  Future<void> initialize() async {
    _deviceId = await _getDeviceId();
  }

  /// Gets the device ID for key derivation.
  Future<String> _getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return 'android_${androidInfo.id}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return 'ios_${iosInfo.identifierForVendor}';
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfo.macOsInfo;
        return 'macos_${macInfo.systemGUID}';
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        return 'linux_${linuxInfo.machineId}';
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        return 'windows_${windowsInfo.deviceId}';
      }
    } catch (e) {
      // Fallback on any error
    }

    // Fallback: use timestamp-based ID
    return 'fitkarma_device_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Derives and caches the encryption key.
  ///
  /// Parameters:
  /// - [password]: User's password or PIN
  ///
  /// Returns the derived 256-bit key
  Future<Uint8List> getOrCreateKey(String password) async {
    if (_cachedKey != null) {
      return _cachedKey!;
    }

    if (_deviceId == null) {
      await initialize();
    }

    _cachedKey = await _encryptionService.deriveKeyWithStoredSalt(
      password: password,
      deviceId: _deviceId!,
    );

    return _cachedKey!;
  }

  /// Checks if a salt exists in secure storage.
  /// Indicates if this is a first-time setup or returning user.
  Future<bool> hasExistingKey() async {
    return await _encryptionService.hasSalt();
  }

  /// Clears the cached key (call on logout).
  void clearCache() {
    _cachedKey = null;
  }

  /// Clears all stored keys and salts (call on account deletion).
  Future<void> clearAll() async {
    _cachedKey = null;
    await _encryptionService.clearSalt();
  }

  /// Creates a new encryption key for first-time setup.
  ///
  /// Parameters:
  /// - [password]: User's chosen password or PIN
  ///
  /// Returns the newly created 256-bit key
  Future<Uint8List> createNewKey(String password) async {
    if (_deviceId == null) {
      await initialize();
    }

    // Create new salt
    await _encryptionService.createAndStoreSalt();

    // Derive key with new salt
    _cachedKey = await _encryptionService.deriveKeyWithStoredSalt(
      password: password,
      deviceId: _deviceId!,
    );

    return _cachedKey!;
  }

  /// Gets the current cached key if available.
  Uint8List? get cachedKey => _cachedKey;
}
