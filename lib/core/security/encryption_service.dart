import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _saltKey = 'fitkarma_encryption_salt';
  
  /// Get or create a unique salt for the user
  Future<String> getOrCreateSalt() async {
    String? salt = await _storage.read(key: _saltKey);
    if (salt == null) {
      salt = const Uuid().v4();
      await _storage.write(key: _saltKey, value: salt);
    }
    return salt;
  }

  /// Derive a 256-bit key using PBKDF2 (Simplified here for performance, 
  /// using HMAC-SHA256 with iterations in production should be more robust)
  Future<Uint8List> deriveKey(String password, String deviceId) async {
    final salt = await getOrCreateSalt();
    final input = '$password:$deviceId:$salt';
    
    // Using SHA256 as a basic key derivation function
    // In a real production app, use pbkdf2 with thousands of iterations
    List<int> key = utf8.encode(input);
    for (var i = 0; i < 1000; i++) {
      key = sha256.convert(key).bytes;
    }
    
    return Uint8List.fromList(key);
  }

  /// Open an encrypted Hive box
  Future<Box<T>> openEncryptedBox<T>(String boxName, Uint8List encryptionKey) async {
    return await Hive.openBox<T>(
      boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }
}
