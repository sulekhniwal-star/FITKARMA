import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyAlias = 'fitkarma_master_key';

  /// Retrieves the existing master key or generates a new one.
  static Future<Uint8List> getOrCreateMasterKey() async {
    final existingKey = await _storage.read(key: _keyAlias);
    
    if (existingKey != null) {
      return base64Decode(existingKey);
    }

    // Generate a 256-bit (32-byte) key
    final key = encrypt.Key.fromSecureRandom(32);
    final keyBytes = key.bytes;
    
    await _storage.write(
      key: _keyAlias,
      value: base64Encode(keyBytes),
    );

    return keyBytes;
  }
}
