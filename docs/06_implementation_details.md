# Part VI — Complete Implementation Details

## §B1. Complete Drift Schema — All Tables

```dart
// lib/core/database/app_database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

// ── Tables ───────────────────────────────────────────────────────

class FoodLogs extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  TextColumn  get foodName       => text()();
  TextColumn  get foodNameLocal  => text().nullable()();
  TextColumn  get mealType       => text()();
  IntColumn   get loggedAt       => integer()();
  RealColumn  get calories       => real()();
  RealColumn  get proteinG       => real().nullable()();
  RealColumn  get carbsG         => real().nullable()();
  RealColumn  get fatG           => real().nullable()();
  RealColumn  get fiberG         => real().nullable()();
  TextColumn  get portionUnit    => text().nullable()();
  RealColumn  get portionQty     => real().nullable()();
  TextColumn  get source         => text().nullable()();
  TextColumn  get foodDbId       => text().nullable()();
  TextColumn  get imageUrl       => text().nullable()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  IntColumn   get deletedAt      => integer().nullable()();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class BpReadings extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  IntColumn   get systolic       => integer()();
  IntColumn   get diastolic      => integer()();
  IntColumn   get pulse          => integer().nullable()();
  IntColumn   get measuredAt     => integer()();
  TextColumn  get notes          => text().nullable()();
  TextColumn  get classification => text().nullable()();
  TextColumn  get measuredArm    => text().nullable()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class GlucoseReadings extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  RealColumn  get valueMgDl      => real()();
  TextColumn  get readingType    => text()();
  IntColumn   get measuredAt     => integer()();
  TextColumn  get classification => text().nullable()();
  TextColumn  get linkedFoodLogId => text().nullable()();
  TextColumn  get notes          => text().nullable()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class SleepLogs extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  IntColumn   get sleepStart     => integer()();
  IntColumn   get sleepEnd       => integer()();
  IntColumn   get totalMinutes   => integer().nullable()();
  IntColumn   get remMinutes     => integer().nullable()();
  IntColumn   get deepMinutes    => integer().nullable()();
  IntColumn   get lightMinutes   => integer().nullable()();
  IntColumn   get qualityScore   => integer().nullable()();
  RealColumn  get avgSpO2        => real().nullable()();
  RealColumn  get avgHeartRate   => real().nullable()();
  TextColumn  get source         => text().nullable()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}

class Workouts extends Table {
  TextColumn  get id              => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId          => text()();
  TextColumn  get name            => text()();
  TextColumn  get workoutType     => text().nullable()();
  IntColumn   get startedAt       => integer()();
  IntColumn   get endedAt         => integer().nullable()();
  IntColumn   get durationSeconds => integer().nullable()();
  RealColumn  get caloriesBurned  => real().nullable()();
  IntColumn   get avgHeartRate    => integer().nullable()();
  IntColumn   get maxHeartRate    => integer().nullable()();
  RealColumn  get distanceKm      => real().nullable()();
  TextColumn  get exercisesJson   => text().nullable()();
  TextColumn  get gpsRouteJson    => text().nullable()();
  BoolColumn  get isDeleted       => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus      => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId        => text().nullable()();
  IntColumn   get failedAttempts  => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}

class Habits extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  TextColumn  get name           => text()();
  TextColumn  get icon           => text().nullable()();
  TextColumn  get frequency      => text().nullable()();
  TextColumn  get completedDates => text().nullable()();
  IntColumn   get currentStreak  => integer().withDefault(const Constant(0))();
  IntColumn   get longestStreak  => integer().withDefault(const Constant(0))();
  BoolColumn  get isActive       => boolean().withDefault(const Constant(true))();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))())();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class JournalEntries extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  TextColumn  get title          => text().nullable()();
  TextColumn  get body           => text()();
  IntColumn   get moodScore      => integer().nullable()();
  TextColumn  get moodEmoji      => text().nullable()();
  TextColumn  get tags           => text().nullable()();
  IntColumn   get createdAt      => integer()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  IntColumn   get deletedAt      => integer().nullable()();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class WaterLogs extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  IntColumn   get amountMl       => integer()();
  IntColumn   get loggedAt       => integer()();
  TextColumn  get source         => text().nullable()();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}

class Medications extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  TextColumn  get name           => text()();
  TextColumn  get dosage         => text().nullable()();
  TextColumn  get scheduleJson   => text().nullable()();
  BoolColumn  get isActive       => boolean().withDefault(const Constant(true))();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get notes          => text().nullable()();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  FoodLogs, BpReadings, GlucoseReadings, SleepLogs,
  Workouts, Habits, JournalEntries, WaterLogs, Medications,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(foodLogs, foodLogs.failedAttempts);
        await m.addColumn(bpReadings, bpReadings.failedAttempts);
      }
      if (from < 3) {
        await m.addColumn(foodLogs, foodLogs.remoteId);
        await m.addColumn(bpReadings, bpReadings.remoteId);
        await m.addColumn(foodLogs, foodLogs.fiberG);
        await m.addColumn(foodLogs, foodLogs.foodDbId);
        await m.addColumn(foodLogs, foodLogs.imageUrl);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
```

---

## §B2. Complete Sync Engine

```dart
// lib/core/sync/sync_worker.dart

class SyncWorker {
  final AppDatabase _db;
  final Databases _appwriteDb;
  static const _dbId = 'fitkarma-db';

  SyncWorker(this._db, this._appwriteDb);

  Future<void> syncAll() async {
    final conn = await Connectivity().checkConnectivity();
    if (conn == ConnectivityResult.none) return;

    // Priority order: clinical data first
    await Future.wait([
      _syncBpReadings(),
      _syncGlucoseReadings(),
      _syncMedications(),
    ]);
    await Future.wait([
      _syncWorkouts(),
      _syncSleepLogs(),
    ]);
    await Future.wait([
      _syncFoodLogs(),
      _syncHabits(),
      _syncJournalEntries(),
    ]);
  }
}
```

---

## §B3. Complete Notification Service

```dart
// lib/core/notifications/notification_service.dart

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> scheduleMealReminders({
    required int breakfastHour, required int breakfastMinute,
    required int lunchHour,     required int lunchMinute,
    required int dinnerHour,    required int dinnerMinute,
  }) async {
    // Schedules daily reminders for all 3 meals
  }
}
```

---

## §B4. GoRouter — App Router with Auth Guard

```dart
// lib/core/router/app_router.dart

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      if (!isAuthenticated) return '/auth/login';
      return null;
    },
    routes: [
      GoRoute(path: '/splash',      builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/home/dashboard', builder: (_, __) => const DashboardScreen()),
      // ... more routes
    ],
  );
}
```

---

## §B5. Feature Flags — Full Implementation

```dart
// lib/core/config/feature_flags.dart

@freezed
class FeatureFlags with _$FeatureFlags {
  const factory FeatureFlags({
    @Default(true)  bool aiInsights,
    @Default(true)  bool socialFeed,
    @Default(true)  bool weddingPlanner,
    @Default(true)  bool proSubscription,
  }) = _FeatureFlags;
}
```

---

## §B7. Glucose Classification Logic

```dart
// lib/features/health/domain/glucose_classifier.dart

enum GlucoseClassification { normal, prediabetic, diabetic, hypoglycemic }

class GlucoseClassifier {
  static GlucoseClassification classify(double mgDl, GlucoseReadingType type) {
    if (mgDl < 70) return GlucoseClassification.hypoglycemic;
    // ... logic per type
  }
}
```

---

## §B8. Correlation Insight Engine

```dart
// lib/features/insights/correlation_engine.dart

class CorrelationEngine {
  Future<List<HealthInsight>> generateInsights(String userId) async {
    // Analyzes BP vs Sleep vs Water to find patterns
  }
}
```

---

## §B10. Main Entry Point

```dart
// lib/main.dart

void main() {
  unawaited(SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
    },
    appRunner: _runApp,
  ));
}

void _runApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FitKarmaApp()));
}
```

---

## §B11. Unified Appwrite Function — FitKarma Core

> Consolidates all server-side logic into a single function to stay within the 1-function limit.

```js
// functions/fitkarma-cores/src/main.js
import { Client, Databases, ID, Query, Storage } from "node-appwrite";

export default async ({ req, res, log, error }) => {
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers["x-appwrite-key"]);

  const { action, payload } = JSON.parse(req.body || "{}");

  switch (action) {
    case 'XP_AWARD':
      return handleXp(payload, client, res);
    case 'GENERATE_SHARE_LINK':
      return handleShare(payload, client, res);
    case 'AI_COACH_QUERY':
      return handleAiCoach(payload, client, res);
    case 'FETCH_FEATURE_FLAGS':
      return handleFeatureFlags(payload, client, res);
    default:
      return res.json({ ok: false, error: "Invalid action" }, 400);
  }
};
```

### Calling the Unified Function from Flutter

```dart
Future<void> awardXp(String eventType) async {
  final functions = Functions(ref.read(appwriteClientProvider));
  await functions.createExecution(
    functionId: 'fitkarma-cores',
    body: jsonEncode({
      'action': 'XP_AWARD',
      'payload': { 'userId': uid, 'eventType': eventType }
    }),
  );
}
```

---

## §B12. Single Bucket Management

> Uses path prefixes to organize files within the single `fitkarma-vault` bucket.

```dart
// lib/core/storage/storage_service.dart

Future<String> uploadFile(File file, String folder) async {
  // folder = 'avatars' or 'lab-reports'
  final result = await ref.read(appwriteStorageProvider).createFile(
    bucketId: 'fitkarma-vault',
    fileId: ID.unique(),
    file: InputFile.fromPath(path: file.path, name: '$folder/${ID.unique()}'),
  );
  return result.$id;
}
```

