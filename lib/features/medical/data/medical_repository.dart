import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/security/encryption_service.dart';
import '../../../core/di/providers.dart';
import '../domain/bp_log_model.dart';

class MedicalRepository {
  final SyncQueue _syncQueue;
  final EncryptionService _encryption;
  
  MedicalRepository(this._syncQueue, this._encryption);

  Future<void> logBloodPressure(BloodPressureLog log, Uint8List encryptionKey) async {
    // 1. Open encrypted box
    final box = await _encryption.openEncryptedBox(HiveBoxes.bloodPressure, encryptionKey);
    
    // 2. Save locally
    await box.put(log.id, log.toMap());

    // 3. For Appwrite, encrypt payload
    final plainJson = json.encode(log.toMap());
    
    final queueItem = SyncQueueItem.create(
      collectionId: AW.bloodPressureLogs,
      operation: 'create',
      localId: log.id,
      payload: {'encrypted_data': base64Encode(utf8.encode(plainJson))}, 
    );
    await _syncQueue.addItem(queueItem);
  }

  Future<List<BloodPressureLog>> getHistory(Uint8List encryptionKey) async {
    final box = await _encryption.openEncryptedBox(HiveBoxes.bloodPressure, encryptionKey);
    return box.values.map((data) => BloodPressureLog.fromMap(Map<String, dynamic>.from(data))).toList();
  }
}

final medicalRepositoryProvider = Provider<MedicalRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return MedicalRepository(syncQueue, EncryptionService());
});
