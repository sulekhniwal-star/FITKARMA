import 'dart:convert';
import 'dart:math';

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

class WorkoutSets extends Table with SyncableColumns {
  TextColumn get workoutId => text()();
  TextColumn get exerciseName => text()();
  IntColumn get reps => integer()();
  RealColumn get weight => real()();
  IntColumn get setOrder => integer()();
}

class KarmaEvents extends Table with SyncableColumns {
  IntColumn get xp => integer()();
  TextColumn get eventType => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
}

class DietPlans extends Table with SyncableColumns {
  TextColumn get dayIndex => text()();
  TextColumn get mealsJson => text()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
}

class RecoveryLogs extends Table with SyncableColumns {
  IntColumn get score => integer()();
  IntColumn get sleepQuality => integer().nullable()();
  IntColumn get sorenessLevel => integer().nullable()();
  IntColumn get stressLevel => integer().nullable()();
  IntColumn get energyLevel => integer().nullable()();
  IntColumn get restingHR => integer().nullable()();
  IntColumn get hrv => integer().nullable()();
  TextColumn get sorenessRegions => text().nullable()();
  DateTimeColumn get loggedAt => dateTime()();
}

@DataClassName('LocalUser')
class Users extends Table with SyncableColumns {
  TextColumn get email => text()();
  TextColumn get name => text()();
  TextColumn get uxStage => text().withDefault(const Constant('welcomeDone'))();

  // Dosha Data
  TextColumn get dominantDosha => text().nullable()();
  RealColumn get vataPercentage => real().nullable()();
  RealColumn get pittaPercentage => real().nullable()();
  RealColumn get kaphaPercentage => real().nullable()();

  // Demographics
  IntColumn get age => integer().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  TextColumn get gender => text().nullable()();

  // Goals (Stored as comma-separated strings or JSON)
  TextColumn get goals => text().nullable()();

  // Missing columns per B2a - Phase 0
  TextColumn get workStyle => text().nullable()();
  TextColumn get currentProgram => text().nullable()();
  TextColumn get tone => text().nullable()();
  RealColumn get bmi => real().nullable()();
  TextColumn get activityLevel => text().nullable()();
  IntColumn get tdee => integer().nullable()();
  IntColumn get dailyStepsTarget => integer().nullable()();
  IntColumn get dailyCalorieTarget => integer().nullable()();
  IntColumn get dailyProteinTargetG => integer().nullable()();
  IntColumn get dailyWaterTargetL => integer().nullable()();
  TextColumn get region => text().nullable()();

  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ─── v10 New Tables ──────────────────────────────────────────────────────────

class BodyMeasurements extends Table with SyncableColumns {
  RealColumn get waistCm     => real().nullable()();
  RealColumn get chestCm     => real().nullable()();
  RealColumn get hipCm       => real().nullable()();
  RealColumn get bicepCm     => real().nullable()();
  RealColumn get neckCm      => real().nullable()();
  RealColumn get thighCm     => real().nullable()();
  RealColumn get weightKg    => real().nullable()();
  RealColumn get bodyFatPct  => real().nullable()();
  TextColumn  get photoFileId => text().nullable()();
  DateTimeColumn get measuredAt => dateTime()();
}

class TransformationChecks extends Table with SyncableColumns {
  IntColumn  get weekNumber   => integer()();
  RealColumn get weightKg     => real().nullable()();
  IntColumn  get moodScore    => integer().nullable()(); // 1-10
  IntColumn  get energyScore  => integer().nullable()(); // 1-10
  TextColumn get notes        => text().nullable()();
  DateTimeColumn get checkedAt => dateTime()();
}

class SquadGroups extends Table with SyncableColumns {
  TextColumn get name        => text()();
  TextColumn get createdBy   => text()();  // userId
  TextColumn get membersJson => text().withDefault(const Constant('[]'))();
  TextColumn get groupType   => text().withDefault(const Constant('accountability'))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class SquadMembers extends Table with SyncableColumns {
  TextColumn get groupId => text()();
  TextColumn get memberId => text()();  // userId
  TextColumn get role    => text().withDefault(const Constant('member'))(); // admin/member
  DateTimeColumn get joinedAt => dateTime().withDefault(currentDateAndTime)();
}

class AiInsights extends Table with SyncableColumns {
  TextColumn get title       => text()();
  TextColumn get description => text()();
  TextColumn get category    => text()(); // sleep_bp, hydration_steps, glucose, etc.
  RealColumn get confidence  => real()();
  BoolColumn get isActionable => boolean().withDefault(const Constant(true))();
  BoolColumn get isDismissed  => boolean().withDefault(const Constant(false))();
  DateTimeColumn get generatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt   => dateTime().nullable()();
}

class ReadinessLogs extends Table with SyncableColumns {
  IntColumn  get score         => integer()();           // 0-100
  TextColumn get zone          => text()();              // optimal/good/moderate/low/rest
  IntColumn  get sleepMinutes  => integer().nullable()();
  IntColumn  get sleepQuality  => integer().nullable()(); // 1-10
  IntColumn  get sorenessLevel => integer().nullable()(); // 1-10
  IntColumn  get stressLevel   => integer().nullable()(); // 1-10
  IntColumn  get energyLevel   => integer().nullable()(); // 1-10
  IntColumn  get restingHr     => integer().nullable()();
  TextColumn get recommendation => text().nullable()();
  DateTimeColumn get loggedAt  => dateTime().withDefault(currentDateAndTime)();
}

class DailyMissions extends Table with SyncableColumns {
  TextColumn get title           => text()();
  TextColumn get description     => text()();
  TextColumn get workoutIntensity => text()(); // light/moderate/intense/rest
  IntColumn  get waterTargetMl   => integer()();
  IntColumn  get stepTarget      => integer()();
  IntColumn  get calorieTarget   => integer()();
  TextColumn get aiRecommendation => text().nullable()();
  BoolColumn get isCompleted     => boolean().withDefault(const Constant(false))();
  DateTimeColumn get missionDate => dateTime()();
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
  WorkoutSets,
  KarmaEvents,
  DietPlans,
  RecoveryLogs,
  // v10 additions
  BodyMeasurements,
  TransformationChecks,
  SquadGroups,
  SquadMembers,
  AiInsights,
  ReadinessLogs,
  DailyMissions,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDatabase());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // v10: First stable migration baseline.
          // Versions 1–9 were experimental; all production installs upgrade to v10.
          // Safe additive-only migrations — no tables are dropped.
          if (from < 10) {
            await _migrateToV10(m);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// v9 → v10: Add all new tables. Users/existing tables are preserved intact.
  Future<void> _migrateToV10(Migrator m) async {
    // Create the 5 new tables added in v10
    await m.createTable(bodyMeasurements);
    await m.createTable(transformationChecks);
    await m.createTable(squadGroups);
    await m.createTable(squadMembers);
    await m.createTable(aiInsights);
    await m.createTable(readinessLogs);
    await m.createTable(dailyMissions);

    // Safe column additions to existing tables (new nullable columns only)
    // Users table: add missing columns that may not exist on older installs
    try { await m.addColumn(users, users.workStyle); } catch (_) {}
    try { await m.addColumn(users, users.currentProgram); } catch (_) {}
    try { await m.addColumn(users, users.tone); } catch (_) {}
    try { await m.addColumn(users, users.bmi); } catch (_) {}
    try { await m.addColumn(users, users.activityLevel); } catch (_) {}
    try { await m.addColumn(users, users.tdee); } catch (_) {}
    try { await m.addColumn(users, users.dailyStepsTarget); } catch (_) {}
    try { await m.addColumn(users, users.dailyCalorieTarget); } catch (_) {}
    try { await m.addColumn(users, users.dailyProteinTargetG); } catch (_) {}
    try { await m.addColumn(users, users.dailyWaterTargetL); } catch (_) {}
    try { await m.addColumn(users, users.region); } catch (_) {}
  }

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
    // Generate a cryptographically secure random 32-byte key (256-bit AES key).
    // IMPORTANT: Uint8List(32) initialises to all-zeros — do NOT use it directly.
    final rng = Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(32, (_) => rng.nextInt(256)),
    );
    key = base64Url.encode(bytes);
    await storage.write(key: 'fitkarma_db_key', value: key);
  }
  return key;
}
