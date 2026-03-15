// lib/core/security/encryption_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encryption service using AES-256-GCM with PBKDF2 key derivation.
///
/// Implements the encryption pattern from Section 16.2:
/// - AES-256-GCM for symmetric encryption
/// - PBKDF2 with 100,000 iterations for key derivation
/// - Salt stored in flutter_secure_storage (never in Hive or plaintext)
class EncryptionService {
  static const _saltKey = 'fitkarma_encryption_salt';

  // PBKDF2 algorithm with SHA-256 and 100,000 iterations
  static final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );

  // AES-256-GCM for encryption
  static final _aesGcm = AesGcm.with256bits();

  final FlutterSecureStorage _secureStorage;

  EncryptionService({FlutterSecureStorage? secureStorage})
    : _secureStorage =
          secureStorage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  /// Derives a 256-bit encryption key from user password, device ID, and salt.
  ///
  /// Parameters:
  /// - [password]: User's password or PIN
  /// - [deviceId]: Unique device identifier
  /// - [salt]: Salt for key derivation (generated if not provided)
  /// - [iterations]: PBKDF2 iterations (default: 100,000)
  ///
  /// Returns the derived key as a List<int> (32 bytes for AES-256)
  static Future<List<int>> deriveKey({
    required String password,
    required String deviceId,
    List<int>? salt,
    int iterations = 100000,
  }) async {
    // Combine password with device ID for additional entropy
    final combinedSecret = '$password$deviceId';

    final secretKey = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(combinedSecret)),
      nonce: salt ?? _generateSalt(),
    );

    final keyBytes = await secretKey.extractBytes();
    return keyBytes;
  }

  /// Generates a random 16-byte salt for PBKDF2.
  static List<int> _generateSalt() {
    final random = SecretKeyData.random(length: 16);
    return random.bytes;
  }

  /// Gets or creates the encryption salt from secure storage.
  Future<List<int>> getOrCreateSalt() async {
    final existingSalt = await _secureStorage.read(key: _saltKey);

    if (existingSalt != null) {
      return base64Decode(existingSalt);
    }

    // Generate new salt if none exists
    final newSalt = _generateSalt();
    await _secureStorage.write(key: _saltKey, value: base64Encode(newSalt));
    return newSalt;
  }

  /// Derives the encryption key using stored salt.
  ///
  /// This is the main entry point for key derivation after initial setup.
  Future<Uint8List> deriveKeyWithStoredSalt({
    required String password,
    required String deviceId,
  }) async {
    final salt = await getOrCreateSalt();
    final keyBytes = await deriveKey(
      password: password,
      deviceId: deviceId,
      salt: salt,
    );
    return Uint8List.fromList(keyBytes);
  }

  /// Gets the existing salt from secure storage.
  Future<List<int>?> getSalt() async {
    final existingSalt = await _secureStorage.read(key: _saltKey);

    if (existingSalt != null) {
      return base64Decode(existingSalt);
    }

    return null;
  }

  /// Creates a new salt and stores it in secure storage.
  Future<List<int>> createAndStoreSalt() async {
    final newSalt = _generateSalt();
    await _secureStorage.write(key: _saltKey, value: base64Encode(newSalt));
    return newSalt;
  }

  /// Checks if a salt already exists in secure storage.
  Future<bool> hasSalt() async {
    final salt = await _secureStorage.read(key: _saltKey);
    return salt != null;
  }

  /// Clears the stored salt (for account reset/logout).
  Future<void> clearSalt() async {
    await _secureStorage.delete(key: _saltKey);
  }

  /// Encrypts data using AES-256-GCM.
  ///
  /// Parameters:
  /// - [plaintext]: The data to encrypt
  /// - [key]: 256-bit encryption key
  ///
  /// Returns the encrypted data with nonce prepended
  static Future<Uint8List> encrypt({
    required String plaintext,
    required List<int> key,
  }) async {
    final secretKey = SecretKey(key);

    // Generate random nonce (12 bytes for GCM)
    final nonce = _aesGcm.newNonce();
    final secretBox = await _aesGcm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: nonce,
    );

    // Prepend nonce to encrypted data (cipherText includes the auth tag)
    final cipherText = secretBox.cipherText;
    final result = Uint8List(nonce.length + cipherText.length);
    result.setRange(0, nonce.length, nonce);
    result.setRange(nonce.length, result.length, cipherText);

    return result;
  }

  /// Decrypts data using AES-256-GCM.
  ///
  /// Parameters:
  /// - [ciphertext]: The encrypted data (nonce + encrypted content)
  /// - [key]: 256-bit encryption key
  ///
  /// Returns the decrypted plaintext
  static Future<String> decrypt({
    required Uint8List ciphertext,
    required List<int> key,
  }) async {
    final secretKey = SecretKey(key);

    // Extract nonce (first 12 bytes for GCM)
    final nonce = ciphertext.sublist(0, 12);
    final encrypted = ciphertext.sublist(12);

    // For AES-GCM, the last 16 bytes are the authentication tag (MAC)
    final cipherTextWithoutMac = encrypted.sublist(0, encrypted.length - 16);
    final macBytes = encrypted.sublist(encrypted.length - 16);

    // Create SecretBox with the cipherText, nonce, and MAC
    final secretBox = SecretBox(
      cipherTextWithoutMac,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final decrypted = await _aesGcm.decrypt(secretBox, secretKey: secretKey);

    return utf8.decode(decrypted);
  }
}
