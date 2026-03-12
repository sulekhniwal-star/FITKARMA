import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/di/providers.dart';
import '../domain/medication_model.dart';

class MedicationsRepository {
  final SyncQueue _syncQueue;

  MedicationsRepository(this._syncQueue);

  /// Add a new medication
  Future<void> addMedication(Medication medication) async {
    // 1. Save locally to Hive
    final box = Hive.box(HiveBoxes.medications);
    await box.put(medication.id, medication.toMap());

    // 2. Queue for Appwrite sync
    final queueItem = SyncQueueItem.create(
      collectionId: AW.medications,
      operation: 'create',
      localId: medication.id,
      payload: medication.toMap(),
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Get all medications
  Future<List<Medication>> getAll() async {
    final box = Hive.box(HiveBoxes.medications);
    final medications = box.values
        .map((data) => Medication.fromMap(Map<String, dynamic>.from(data)))
        .toList();
    medications.sort((a, b) => a.name.compareTo(b.name));
    return medications;
  }

  /// Get active medications only
  Future<List<Medication>> getActive() async {
    final all = await getAll();
    return all.where((med) => med.isActive && !med.hasEnded).toList();
  }

  /// Get a specific medication by ID
  Future<Medication?> getById(String id) async {
    final box = Hive.box(HiveBoxes.medications);
    final data = box.get(id);
    if (data == null) return null;
    return Medication.fromMap(Map<String, dynamic>.from(data));
  }

  /// Update a medication
  Future<void> updateMedication(Medication medication) async {
    final box = Hive.box(HiveBoxes.medications);
    await box.put(medication.id, medication.toMap());

    final queueItem = SyncQueueItem.create(
      collectionId: AW.medications,
      operation: 'update',
      localId: medication.id,
      payload: medication.toMap(),
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Toggle medication active status
  Future<void> toggleActive(String id) async {
    final medication = await getById(id);
    if (medication == null) return;
    
    final updated = medication.copyWith(isActive: !medication.isActive);
    await updateMedication(updated);
  }

  /// Delete a medication
  Future<void> deleteMedication(String id) async {
    final box = Hive.box(HiveBoxes.medications);
    await box.delete(id);

    final queueItem = SyncQueueItem.create(
      collectionId: AW.medications,
      operation: 'delete',
      localId: id,
      payload: {},
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Get medications needing refill soon
  Future<List<Medication>> getMedicationsNeedingRefill() async {
    final active = await getActive();
    return active.where((med) => med.refillNeeded).toList();
  }

  /// Get medications by category
  Future<List<Medication>> getByCategory(MedicationCategory category) async {
    final all = await getAll();
    return all.where((med) => med.category == category).toList();
  }

  /// Get medications for today (active ones)
  Future<List<Medication>> getTodayMedications() async {
    final active = await getActive();
    final now = DateTime.now();
    final dayOfWeek = _getDayName(now.weekday);
    
    return active.where((med) {
      final days = med.frequency['days'] ?? 'daily';
      if (days == 'daily') return true;
      if (days == 'weekdays' && now.weekday < 6) return true;
      if (days == 'weekends' && now.weekday >= 6) return true;
      if (days is List && days.contains(dayOfWeek)) return true;
      return false;
    }).toList();
  }

  String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  /// Check for known drug interactions (basic warnings)
  List<String> checkInteractions(List<Medication> medications) {
    final warnings = <String>[];
    final names = medications.map((m) => m.name.toLowerCase()).toList();
    
    // Basic example interactions - in production, this would be a comprehensive database
    if (names.any((n) => n.contains('aspirin')) && names.any((n) => n.contains('warfarin'))) {
      warnings.add('Aspirin and Warfarin may increase bleeding risk');
    }
    if (names.any((n) => n.contains('ibuprofen')) && names.any((n) => n.contains('aspirin'))) {
      warnings.add('Taking Ibuprofen with Aspirin may reduce aspirins effect');
    }
    if (names.any((n) => n.contains('metformin')) && names.any((n) => n.contains('alcohol'))) {
      warnings.add('Metformin and alcohol may increase lactic acid risk');
    }
    
    return warnings;
  }

  /// Mark as synced
  Future<void> markSynced(String id) async {
    final box = Hive.box(HiveBoxes.medications);
    final data = box.get(id);
    if (data != null) {
      final medication = Medication.fromMap(Map<String, dynamic>.from(data));
      final updated = medication.copyWith(syncStatus: 'synced');
      await box.put(id, updated.toMap());
    }
  }
}

final medicationsRepositoryProvider = Provider<MedicationsRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return MedicationsRepository(syncQueue);
});
