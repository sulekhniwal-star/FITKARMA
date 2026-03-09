import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';

class EncryptionService {
  static const _keyName = 'fitkarma_encryption_key';
  final _storage = const FlutterSecureStorage();

  Future<List<int>> getOrCreateKey() async {
    final storedKey = await _storage.read(key: _keyName);
    if (storedKey != null) return base64Decode(storedKey);

    final newKey = Hive.generateSecureKey();
    await _storage.write(key: _keyName, value: base64Encode(newKey));
    return newKey;
  }
}
