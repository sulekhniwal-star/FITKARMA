import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<Box<T>> openSecureBox<T>(
      String name, List<int> encryptionKey) async {
    return Hive.openBox<T>(
      name,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }
}
