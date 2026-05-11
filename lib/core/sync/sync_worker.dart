import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workmanager/workmanager.dart';
import '../config/device_tier.dart';
import '../database/app_database.dart';
import '../providers/core_providers.dart';

part 'sync_worker.g.dart';

/// SyncWorker — Manages data synchronization between local Drift and remote Appwrite.
class SyncWorker {
  final Databases databases;
  final AppDatabase db;

  SyncWorker({required this.databases, required this.db});

  Future<void> syncAll() async {
    // Priority 1: Vital Metrics & Meds
    await _syncTable('bp_readings', db.bpReadings);
    await _syncTable('glucose_readings', db.glucoseReadings);
    await _syncTable('medications', db.medications);

    // Priority 2: Workouts & Sleep
    await _syncTable('workouts', db.workouts);
    await _syncTable('sleep_logs', db.sleepLogs);

    // Priority 3: Food, Habits, Journal
    await _syncTable('food_logs', db.foodLogs);
    await _syncTable('habits', db.habits);
    await _syncTable('journal_entries', db.journalEntries);

    // Priority 4: Water
    await _syncTable('water_logs', db.waterLogs);
  }

  Future<void> _syncTable(String collectionId, dynamic table) async {
    final query = db.select(table)..where((t) {
      final st = (t as dynamic).syncStatus;
      final fa = (t as dynamic).failedAttempts;
      return st.equals('pending') & fa.isLessThan(3);
    });
    
    final pending = await query.get();

    for (final row in pending) {
      await _pushRecord(collectionId, table, row);
    }
  }

  Future<void> _pushRecord(String collectionId, dynamic table, dynamic row) async {
    try {
      final String? remoteId = row.remoteId;
      final Map<String, dynamic> data = row.toJson();
      
      // Clean up data for Appwrite
      data.remove('syncStatus');
      data.remove('failedAttempts');
      data.remove('updatedAt');
      
      if (remoteId == null) {
        final doc = await databases.createDocument(
          databaseId: 'main',
          collectionId: collectionId,
          documentId: row.id,
          data: data,
        );
        
        await (db.update(table)..where((t) => (t as dynamic).id.equals(row.id))).write(
          (table as dynamic).createCompanion(
            syncStatus: const Value('synced'),
            remoteId: Value(doc.$id),
          ),
        );
      } else {
        await databases.updateDocument(
          databaseId: 'main',
          collectionId: collectionId,
          documentId: remoteId,
          data: data,
        );
        
        await (db.update(table)..where((t) => (t as dynamic).id.equals(row.id))).write(
          (table as dynamic).createCompanion(syncStatus: const Value('synced')),
        );
      }
    } catch (e) {
      final int attempts = row.failedAttempts + 1;
      final String newStatus = attempts >= 3 ? 'dlq' : 'pending';
      
      await (db.update(table)..where((t) => (t as dynamic).id.equals(row.id))).write(
        (table as dynamic).createCompanion(
          syncStatus: Value(newStatus),
          failedAttempts: Value(attempts),
        ),
      );
    }
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────

@riverpod
Stream<ConnectivityResult> connectivityService(ConnectivityServiceRef ref) {
  return Connectivity().onConnectivityChanged.map((results) => results.first);
}

@riverpod
Duration syncInterval(SyncIntervalRef ref) {
  final tier = ref.watch(deviceTierProvider).valueOrNull ?? DeviceTier.mid;
  switch (tier) {
    case DeviceTier.low:
      return const Duration(hours: 6);
    case DeviceTier.mid:
      return const Duration(minutes: 30);
    case DeviceTier.high:
      return const Duration(minutes: 15);
  }
}

@riverpod
Stream<bool> hasDlqRecords(HasDlqRecordsRef ref) {
  final db = ref.watch(appDatabaseProvider);
  // Watch a few key tables for DLQ status
  return db.select(db.foodLogs).watch().map(
    (rows) => rows.any((r) => r.syncStatus == 'dlq')
  );
}

// ─── Background Sync ─────────────────────────────────────────────────────────

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return Future.value(true);
  });
}
