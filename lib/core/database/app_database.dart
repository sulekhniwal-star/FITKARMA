import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'app_database.g.dart';

// ─── Base Columns Mixin ──────────────────────────────────────────────────────

mixin SyncableColumns on Table {
  TextColumn get id => text()(); // UUID
  TextColumn get userId => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))(); // 'pending'/'synced'/'dlq'
  TextColumn get remoteId => text().nullable()();
  IntColumn get failedAttempts => integer().withDefault(const Constant(0))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Table Definitions ───────────────────────────────────────────────────────

class FoodLogs extends Table with SyncableColumns {
  TextColumn get name => text()();
  RealColumn get calories => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  DateTimeColumn get logDate => dateTime()();
  TextColumn get mealType => text()(); // breakfast, lunch, etc.
}

class BpReadings extends Table with SyncableColumns {
  IntColumn get systolic => integer()();
  IntColumn get diastolic => integer()();
  IntColumn get pulse => integer()();
  DateTimeColumn get measuredAt => dateTime()();
}

class GlucoseReadings extends Table with SyncableColumns {
  RealColumn get value => real()();
  TextColumn get unit => text().withDefault(const Constant('mg/dL'))();
  TextColumn get timing => text()(); // fasting, post-meal, etc.
  DateTimeColumn get measuredAt => dateTime()();
}

class SleepLogs extends Table with SyncableColumns {
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get quality => integer()(); // 1-10
}

class Workouts extends Table with SyncableColumns {
  TextColumn get type => text()();
  IntColumn get durationMinutes => integer()();
  IntColumn get caloriesBurned => integer()();
  DateTimeColumn get startedAt => dateTime()();
}

class Habits extends Table with SyncableColumns {
  TextColumn get title => text()();
  TextColumn get frequency => text()(); // daily, weekly
  DateTimeColumn get startDate => dateTime()();
}

class JournalEntries extends Table with SyncableColumns {
  TextColumn get content => text()();
  TextColumn get mood => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class WaterLogs extends Table with SyncableColumns {
  IntColumn get amountMl => integer()();
  DateTimeColumn get logDate => dateTime()();
}

class Medications extends Table with SyncableColumns {
  TextColumn get name => text()();
  TextColumn get dosage => text()();
  TextColumn get schedule => text()();
  DateTimeColumn get startDate => dateTime()();
}

class FoodItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get source => text()();
  IntColumn get priority => integer()();
  RealColumn get caloriesPer100g => real()();
  TextColumn get group => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get barcode => text().nullable()();
  BoolColumn get isBundled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id, source};
}

class Users extends Table with SyncableColumns {
  TextColumn get email => text()();
  TextColumn get name => text()();
  TextColumn get uxStage => text().withDefault(const Constant('onboarding'))(); // onboarding, firstWeek, established
  
  // Dosha Data
  TextColumn get dominantDosha => text().nullable()();
  RealColumn get vataPercentage => real().nullable()();
  RealColumn get pittaPercentage => real().nullable()();
  RealColumn get kaphaPercentage => real().nullable()();

  // Goals (Stored as comma-separated strings or JSON)
  TextColumn get goals => text().nullable()();

  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ─── App Database ────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  FoodLogs,
  BpReadings,
  GlucoseReadings,
  SleepLogs,
  Workouts,
  Habits,
  JournalEntries,
  WaterLogs,
  Medications,
  FoodItems,
  Users,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDatabase());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 -> v2 migration logic
          }
          if (from < 3) {
            // v2 -> v3 migration logic
          }
          if (from < 4) {
            // v3 -> v4 migration logic
          }
        },
      );

  // ─── Convenience Queries ───────────────────────────────────────────────────

  Stream<List<FoodLog>> watchTodayFoodLogs() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return (select(foodLogs)..where((t) => t.logDate.isBiggerOrEqualValue(startOfDay))).watch();
  }

  Future<List<BpReading>> getRecentBpReadings({int limit = 10}) {
    return (select(bpReadings)
          ..orderBy([(t) => OrderingTerm(expression: t.measuredAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  Stream<List<BpReading>> watchRecentBpReadings({int limit = 30}) {
    return (select(bpReadings)
          ..orderBy([(t) => OrderingTerm(expression: t.measuredAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  Stream<List<GlucoseReading>> watchRecentGlucoseReadings({int limit = 30}) {
    return (select(glucoseReadings)
          ..orderBy([(t) => OrderingTerm(expression: t.measuredAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  Stream<List<SleepLog>> watchRecentSleepLogs({int limit = 30}) {
    return (select(sleepLogs)
          ..orderBy([(t) => OrderingTerm(expression: t.startTime, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  Stream<List<JournalEntry>> watchJournalEntries() {
    return (select(journalEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch();
  }

  Stream<List<Workout>> watchRecentWorkouts({int limit = 20}) {
    return (select(workouts)
          ..orderBy([(t) => OrderingTerm(expression: t.startedAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  Future<int> getTodayWaterMl() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final query = selectOnly(waterLogs)
      ..addColumns([waterLogs.amountMl.sum()])
      ..where(waterLogs.logDate.isBiggerOrEqualValue(startOfDay));
    
    final result = await query.map((row) => row.read(waterLogs.amountMl.sum())).getSingle();
    return result ?? 0;
  }

  Stream<int> watchTodayWaterMl() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final query = selectOnly(waterLogs)
      ..addColumns([waterLogs.amountMl.sum()])
      ..where(waterLogs.logDate.isBiggerOrEqualValue(startOfDay));
    
    return query.map((row) => row.read(waterLogs.amountMl.sum()) ?? 0).watchSingle();
  }

  Future<void> logWater(int amountMl) async {
    final now = DateTime.now();
    await into(waterLogs).insert(
      WaterLogsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'client_user',
        amountMl: amountMl,
        logDate: now,
      ),
    );
  }

  Stream<List<Medication>> watchAllMedications() {
    return (select(medications)..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)])).watch();
  }

  Future<void> addMedicationSchedule(String name, String dosage, String schedule) async {
    await into(medications).insert(
      MedicationsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'client_user',
        name: name,
        dosage: dosage,
        schedule: schedule,
        startDate: DateTime.now(),
      ),
    );
  }

  Future<List<dynamic>> getPendingSync() async {
    final pendingFood = await (select(foodLogs)..where((t) => t.syncStatus.equals('pending'))).get();
    return [...pendingFood];
  }

  Future<int> insertFoodItem(FoodItemsCompanion item) async {
    return await into(foodItems).insert(item, mode: InsertMode.insertOrIgnore);
  }

  Future<void> insertFoodItems(List<FoodItemsCompanion> items) async {
    await batch((b) {
      for (final item in items) {
        b.insert(foodItems, item, mode: InsertMode.insertOrIgnore);
      }
    });
  }

  Stream<List<FoodItem>> searchFoodItems(String query) {
    return (select(foodItems)
          ..where((t) => t.name.contains(query.toLowerCase()))
          ..orderBy([(t) => OrderingTerm(expression: t.priority)])
          ..limit(50))
        .watch();
  }

  Future<List<FoodItem>> getTier1FoodItems() {
    return (select(foodItems)..where((t) => t.isBundled.equals(true))).get();
  }

  Future<int> clearAllFoodItems() async {
    return await delete(foodItems).go();
  }
}

// ─── Connection Logic ────────────────────────────────────────────────────────

QueryExecutor _openDatabase() {
  return LazyDatabase(() async {
    final key = await _getOrCreateDbKey();
    return driftDatabase(
      name: 'fitkarma_db',
      native: DriftNativeOptions(
        setup: (database) {
          database.execute("PRAGMA key = '$key';");
          database.execute("PRAGMA cipher_page_size = 4096;");
          database.execute("PRAGMA kdf_iter = 64000;");
        },
      ),
    );
  });
}

Future<String> _getOrCreateDbKey() async {
  const storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  String? key = await storage.read(key: 'fitkarma_db_key');
  if (key == null) {
    // Generate a random 32-byte key
    final random = Uint8List(32);
    key = base64Url.encode(random); 
    await storage.write(key: 'fitkarma_db_key', value: key);
  }
  return key;
}
