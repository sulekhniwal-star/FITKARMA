# Part II — Technical Implementation (Complete Build)

## 21. Architecture Overview

```text
┌────────────────────────────────────────────────────────────┐
│                    Flutter App (Client)                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Feature │  │  Shared  │  │   Core   │  │  Router  │  │
│  │  Modules │  │ Widgets  │  │ Providers│  │ GoRouter │  │
│  └────┬─────┘  └──────────┘  └────┬─────┘  └──────────┘  │
│       │              Riverpod 2.x State Layer               │
│       │    Local (Drift) ◄──────────────► Remote (Appwrite) │
│       │    SQLite · AES-256           REST / Realtime WS    │
└────────────────────────────────────────────────────────────┘
```

### Data Flow — Offline-First

```text
User action
    │
    ▼
1. Write to Drift immediately (syncStatus = 'pending')
   UI updates optimistically ← no network wait
    │
    ├─ Online? → Push to Appwrite
    │            ├─ Success: syncStatus = 'synced'
    │            └─ Failure: failedAttempts++
    │                        ≥3: syncStatus = 'dlq' → DLQAlertBanner
    └─ Offline? → Remain 'pending' → SyncWorker retries on connectivity
```

---

## 22. Prerequisites & Tooling

```bash
flutter --version   # 3.22.x or higher
dart --version      # 3.4.x or higher
appwrite --version  # 5.x
node --version      # 20.x

# Install Appwrite CLI
curl -sL https://appwrite.io/cli/install.sh | bash
```

---

## 23. Project Setup

```bash
flutter create fitkarma --org com.fitkarma --platforms android,ios
cd fitkarma

flutter pub add \
  flutter_riverpod riverpod_annotation go_router \
  drift sqlite3_flutter_libs path_provider path \
  flutter_secure_storage sqflite_cipher \
  appwrite dio connectivity_plus \
  shimmer fl_chart health local_auth \
  device_info_plus cached_network_image image_picker file_picker \
  flutter_map latlong2 flutter_quill \
  flutter_local_notifications workmanager home_widget \
  http purchases_flutter \
  intl uuid equatable freezed_annotation json_annotation collection

flutter pub add --dev \
  build_runner riverpod_generator drift_dev \
  freezed json_serializable mocktail fake_async flutter_lints
```

### Environment Configuration

```dart
class AppConfig {
  AppConfig._();
  static const String appwriteEndpoint =
      String.fromEnvironment('APPWRITE_ENDPOINT',
          defaultValue: 'https://cloud.appwrite.io/v1');
  static const String appwriteProjectId =
      String.fromEnvironment('APPWRITE_PROJECT_ID');
  static const String dbId =
      String.fromEnvironment('APPWRITE_DB_ID', defaultValue: 'fitkarma-db');

  // Consolidated Appwrite Resources
  static const String coreFunctionId = 'fitkarma-core';
  static const String mainBucketId   = 'fitkarma-vault';

  // Collection IDs
  static const String usersCol      = 'users';
  static const String foodCol       = 'food_logs';
  static const String bpCol         = 'bp_readings';
  static const String glucoseCol    = 'glucose_readings';
  static const String sleepCol      = 'sleep_logs';
  static const String workoutsCol   = 'workouts';
  static const String habitsCol     = 'habits';
  static const String journalCol    = 'journal';
  static const String labCol        = 'lab_reports';
  static const String karmaCol      = 'karma_events';
  static const String festivalCol   = 'festivals';
  static const String medicationCol = 'medications';
  static const String waterCol      = 'water_logs';
  static const String socialCol     = 'social_posts';
  static const String groupsCol     = 'groups';
  static const String shareCol      = 'share_tokens';
  static const String foodDbCol     = 'food_database';    // [§F1 NEW]
}
```

### Android Permissions

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.health.READ_STEPS"/>
<uses-permission android:name="android.permission.health.READ_HEART_RATE"/>
<uses-permission android:name="android.permission.health.READ_SLEEP_SESSION"/>
<uses-permission android:name="android.permission.health.READ_BLOOD_PRESSURE"/>
<uses-permission android:name="android.permission.health.READ_BLOOD_GLUCOSE"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<queries>
  <package android:name="com.google.android.apps.healthdata"/>
</queries>
```

---

## 24. Appwrite CLI — Complete Setup

```bash
appwrite login
appwrite init project   # creates appwrite.json

# Database
appwrite databases create --databaseId "fitkarma-db" --name "FitKarma Database"
```

### Collections — Core (condensed; full attribute lists in §39–41)

```bash
# Users, Food Logs, BP Readings, Glucose, Sleep, Workouts,
# Habits, Journal, Lab Reports, Karma Events — follow same pattern:
appwrite databases createCollection \
  --databaseId "fitkarma-db" \
  --collectionId "{id}" \
  --name "{Name}" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'
```

### Storage Buckets (Consolidated)

```bash
# Single bucket for all assets - use path prefixes for organization
appwrite storage createBucket \
  --bucketId "fitkarma-vault" --name "FitKarma Vault" \
  --allowedFileExtensions pdf,jpg,jpeg,png,webp \
  --encryption true --antivirus true --compression gzip
```

### Functions (Consolidated)

```bash
# Unified function for all server-side logic
appwrite functions create \
  --functionId "fitkarma-core" \
  --name "FitKarma Core" \
  --runtime node-20.0 --timeout 60
```

```bash
appwrite push tables    --all --force
appwrite push buckets   --all --force
appwrite push functions --all --force --activate true
```

---

## 25. Database Schema (Appwrite + Drift)

| Collection ID      | Purpose               | Key Fields                                    |
| ------------------ | --------------------- | --------------------------------------------- |
| `users`            | Profile, karma level  | `userId`, `karmaXP`, `karmaLevel`             |
| `food_logs`        | Meal tracking         | `mealType`, `calories`, `loggedAt`            |
| `food_database`    | Indian food master DB | `name`, `nameHindi`, `calories`, `barcode`    |
| `bp_readings`      | Blood pressure        | `systolic`, `diastolic`, `classification`     |
| `glucose_readings` | Blood glucose         | `valueMgDl`, `readingType`, `linkedFoodLogId` |
| `sleep_logs`       | Sleep sessions        | `sleepStart`, `sleepEnd`, `qualityScore`      |
| `workouts`         | Sessions + types      | `workoutType`, `totalVolume`, `occurredAt`    |
| `workout_sets`     | Exercise detail       | `exerciseName`, `reps`, `weight`, `setOrder`  |
| `habits`           | Definitions + streaks | `completedDates`, `currentStreak`             |
| `journal`          | Rich text + mood      | `body`, `moodScore`, `tags`                   |
| `karma_events`     | XP log                | `eventType`, `xpAwarded`                      |
| `festivals`        | Indian calendar       | `name`, `date`, `type`                        |
| `medications`      | Schedules             | `name`, `dosage`, `schedule`                  |
| `water_logs`       | Water intake          | `amountMl`, `loggedAt`                        |
| `lab_reports`      | Results + files       | `valuesJson`, `fileId`                        |
| `social_posts`     | Group posts           | `content`, `groupId`, `reactions`             |
| `groups`           | Family/friend groups  | `members`, `groupType`                        |
| `share_tokens`     | Expiring share links  | `reportId`, `token`, `expiresAt`              |

**Common field pattern:** Every collection except `users` and `karma_events` has:
`localId` (UUID on device) · `userId` · `syncStatus` ('pending' / 'synced' / 'dlq')

---

## 26. State Management — Riverpod 2.x

```dart
// AsyncNotifier pattern — standard for all mutations
@riverpod
class FoodLogNotifier extends _$FoodLogNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> logFood(FoodLogsCompanion entry) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(appDatabaseProvider).into(db.foodLogs).insert(entry);
      await ref.read(syncWorkerProvider).syncTable('food_logs');
    });
  }
}

// Stream provider for live data
@riverpod
Stream<List<FoodLog>> todayFoodLogs(TodayFoodLogsRef ref) {
  final db = ref.watch(appDatabaseProvider);
  final now = DateTime.now();
  final startTs = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000;
  return (db.select(db.foodLogs)
    ..where((t) => t.loggedAt.isBetweenValues(startTs, startTs + 86400))
    ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
    .watch();
}
```

---

## 27. Offline-First Architecture — Drift

### Sync Status Lifecycle

```text
pending → synced     (push succeeds)
pending → dlq        (3 consecutive failures → DLQAlertBanner)
```

### Drift Schema (excerpt)

```dart
@DriftDatabase(tables: [FoodLogs, BpReadings, GlucoseReadings,
    SleepLogs, Workouts, Habits, Journal, WaterLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);
  @override int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.addColumn(foodLogs, foodLogs.failedAttempts);
      if (from < 3) {
        await m.addColumn(foodLogs, foodLogs.remoteId);
        await m.addColumn(bpReadings, bpReadings.remoteId);
      }
      if (from < 4) {
        await m.addColumn(users, users.isPro);
        await m.addColumn(users, users.weddingDate);
        await m.createTable(sleepLogs);
        // ... see app_database.dart for full v4 migration
      }
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );
}

// Encrypted DB factory
Future<AppDatabase> openEncryptedDatabase() async {
  final dir  = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'fitkarma.db');
  final key  = await _getOrCreateDbKey();
  return AppDatabase(NativeDatabase.createInBackground(
    File(path),
    setup: (db) {
      db.execute("PRAGMA key = '$key'");
      db.execute("PRAGMA cipher_page_size = 4096");
    },
  ));
}
```

---

## 28. Sync Engine

```dart
class SyncWorker {
  Future<void> syncPending() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) return;
    // Priority order: critical first
    await _syncBpReadings();
    await _syncGlucoseReadings();
    await _syncMedications();
    await _syncFoodLogs();
    await _syncWorkouts();
    await _syncSleepLogs();
    await _syncWaterLogs();
  }

  // Each sync method: select pending rows → push to Appwrite
  // Success: syncStatus = 'synced', remoteId stored
  // Failure: failedAttempts++; ≥3 → syncStatus = 'dlq'
}

Duration syncInterval(DeviceTier tier) => switch (tier) {
  DeviceTier.low  => const Duration(hours: 6),
  DeviceTier.mid  => const Duration(minutes: 30),
  DeviceTier.high => const Duration(minutes: 15),
};
```

---

## 29. Authentication

```dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    try { return await Account(ref.read(appwriteClientProvider)).get(); }
    on AppwriteException { return null; }
  }

  Future<void> login(String email, String password) async {
    await Account(ref.read(appwriteClientProvider))
        .createEmailPasswordSession(email: email, password: password);
    ref.invalidateSelf();
  }

  Future<void> logout() async {
    await Account(ref.read(appwriteClientProvider))
        .deleteSession(sessionId: 'current');
    ref.invalidateSelf();
  }
}
```

### Biometric Lock

```dart
class BiometricLock {
  static Future<bool> authenticate() async {
    final canAuth = await LocalAuthentication().canCheckBiometrics;
    if (!canAuth) return true;
    return LocalAuthentication().authenticate(
      localizedReason: 'Authenticate to view health data',
      options: const AuthenticationOptions(stickyAuth: true, biometricOnly: false),
    );
  }
}
// Required on first enter per session: Journal, Period Tracker, BP/Glucose, Lab Reports
```

---

## 30. Storage & File Handling

```dart
Future<String> uploadLabReport(File file) async {
  final result = await ref.read(appwriteStorageProvider).createFile(
    bucketId: 'lab-reports',
    fileId: ID.unique(),
    file: InputFile.fromPath(path: file.path, contentType: 'application/pdf'),
    permissions: [
      Permission.read(Role.user(userId)),
      Permission.delete(Role.user(userId)),
    ],
  );
  return result.$id;
}
```

---

## 31. Health Integrations

```dart
class HealthService {
  static final _health = Health();

  static Future<bool> requestPermissions() async {
    return _health.requestAuthorization([
      HealthDataType.STEPS, HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_OXYGEN, HealthDataType.SLEEP_SESSION,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_GLUCOSE,
    ]);
  }

  static Future<int> todaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final data = await _health.getHealthDataFromTypes(
      startTime: midnight, endTime: now, types: [HealthDataType.STEPS]);
    return data.fold<int>(0, (sum, d) =>
        sum + (d.value as NumericHealthValue).numericValue.toInt());
  }
}
```

---

## 32. Security & Encryption

| Data Type        | Local            | Remote             | Encryption              |
| ---------------- | ---------------- | ------------------ | ----------------------- |
| Health readings  | SQLCipher        | Appwrite Documents | AES-256 + TLS           |
| Journal entries  | SQLCipher        | Appwrite Documents | AES-256 + TLS           |
| Lab report files | —                | Appwrite Storage   | Server-side + antivirus |
| Auth tokens      | Appwrite session | HTTP-only cookie   | TLS in transit          |

---

## 33. Performance Considerations

- `CachedNetworkImage` always — never `Image.network`
- Drift `.watch()` for reactive queries — never poll
- `ListView.builder` for all lists — lazy rendering
- `ref.watch(provider.select(...))` for narrow rebuilds
- `RepaintBoundary` on `ActivityRings` and `BreathingCircle`
- Parse large JSON in `compute()` isolates

### Render Budget Targets

| Metric                  | Target         |
| ----------------------- | -------------- |
| Cold launch             | < 2.5s         |
| Frame render            | < 16ms (60fps) |
| Drift date-range query  | < 50ms         |
| Sync batch (50 records) | < 3s on 4G     |

---

## 34. Testing Strategy

| Type          | Coverage Target                           | Tools                                     |
| ------------- | ----------------------------------------- | ----------------------------------------- |
| Unit          | Repositories, use cases                   | `flutter_test`, `mocktail`                |
| Widget        | Design token enforcement, GlassCard tiers | `flutter_test`, `ProviderScope` overrides |
| Golden        | Screen visual consistency                 | `golden_toolkit`                          |
| Integration   | Full sync flow, offline→online            | `integration_test`                        |
| Migration     | DB schema v1→vN                           | `drift_dev` verifier                      |
| Accessibility | Semantic labels on custom painters        | `flutter_test` semantics                  |

---

## 35. CI/CD & Deployment

```yaml
name: FitKarma CI
on:
  push: { branches: [main, develop] }
  pull_request: { branches: [main] }

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: "3.22.x", cache: true }
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: flutter test --coverage

  deploy-appwrite:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: curl -sL https://appwrite.io/cli/install.sh | bash
      - run: |
          appwrite client \
            --endpoint ${{ secrets.APPWRITE_ENDPOINT }} \
            --project-id ${{ secrets.APPWRITE_PROJECT_ID }} \
            --key ${{ secrets.APPWRITE_API_KEY }}
      - run: appwrite push functions --all --force --activate true

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: "3.22.x", cache: true }
      - run: flutter pub get && dart run build_runner build --delete-conflicting-outputs
      - run: |
          flutter build apk --release \
            --dart-define=APPWRITE_ENDPOINT=${{ secrets.APPWRITE_ENDPOINT }} \
            --dart-define=APPWRITE_PROJECT_ID=${{ secrets.APPWRITE_PROJECT_ID }} \
            --dart-define=APPWRITE_DB_ID=fitkarma-db
```

---

## 36. Appwrite Functions — Server-Side Code

### XP Calculator

```js
// functions/xp-calculator/src/main.js
import { Client, Databases, ID, Query } from "node-appwrite";

const XP_TABLE = {
  food_log: 5,
  food_log_complete: 20,
  workout_complete: 30,
  steps_goal: 25,
  sleep_logged: 10,
  bp_reading: 10,
  glucose_reading: 10,
  habit_complete: 15,
  journal_entry: 10,
  streak_7day: 50,
  streak_30day: 150,
  lab_report: 20,
  referral: 500,
};

const LEVEL_THRESHOLDS = [
  0, 200, 500, 1000, 1800, 2800, 4200, 6000, 8500, 12000, 16000, 21000, 27000,
];
const LEVEL_NAMES = [
  "Newcomer",
  "Beginner",
  "Starter",
  "Mover",
  "Achiever",
  "Consistent",
  "Dedicated",
  "Warrior",
  "Champion",
  "Elite",
  "Legend",
  "Grandmaster",
  "Karma Master",
];

function computeLevel(xp) {
  let level = 1;
  for (let i = 1; i < LEVEL_THRESHOLDS.length; i++) {
    if (xp >= LEVEL_THRESHOLDS[i]) level = i + 1;
    else break;
  }
  return LEVEL_NAMES[level - 1];
}

export default async ({ req, res, log, error }) => {
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers["x-appwrite-key"]);
  const db = new Databases(client);
  const DB = "fitkarma-db";

  const { userId, eventType } = JSON.parse(req.body || "{}");
  const xp = XP_TABLE[eventType];
  if (!xp) return res.json({ ok: false, error: "Unknown eventType" }, 400);

  await db.createDocument(
    DB,
    "karma_events",
    ID.unique(),
    {
      userId,
      eventType,
      xpAwarded: xp,
      occurredAt: Math.floor(Date.now() / 1000),
      syncStatus: "synced",
    },
    [`read("user:${userId}")`, `update("user:${userId}")`],
  );

  const users = await db.listDocuments(DB, "users", [
    Query.equal("userId", userId),
  ]);
  const user = users.documents[0];
  const newXP = (user.karmaXP || 0) + xp;
  const level = computeLevel(newXP);
  await db.updateDocument(DB, "users", user.$id, {
    karmaXP: newXP,
    karmaLevel: level,
  });

  return res.json({ ok: true, xpAwarded: xp, totalXP: newXP, level });
};
```

---

## 37. Karma & Gamification Engine

### XP Table

| Event                             | XP  |
| --------------------------------- | --- |
| `food_log`                        | 5   |
| `food_log_complete` (all 3 meals) | 20  |
| `workout_complete`                | 30  |
| `steps_goal`                      | 25  |
| `sleep_logged`                    | 10  |
| `bp_reading`                      | 10  |
| `glucose_reading`                 | 10  |
| `habit_complete`                  | 15  |
| `journal_entry`                   | 10  |
| `streak_7day`                     | 50  |
| `streak_30day`                    | 150 |
| `lab_report`                      | 20  |
| `referral`                        | 500 |

### Level System

| Level | Name         | XP Required |
| ----- | ------------ | ----------- |
| 1     | Newcomer     | 0           |
| 2     | Beginner     | 200         |
| 3     | Starter      | 500         |
| 4     | Mover        | 1,000       |
| 5     | Achiever     | 1,800       |
| 6     | Consistent   | 2,800       |
| 7     | Dedicated    | 4,200       |
| 8     | Warrior      | 6,000       |
| 9     | Champion     | 8,500       |
| 10    | Elite        | 12,000      |
| 11    | Legend       | 16,000      |
| 12    | Grandmaster  | 21,000      |
| 13    | Karma Master | 27,000      |

---

## 38. Festival & Wedding Data

Festival collection: `name`, `nameHindi`, `date` (Unix), `type` (religious/national/regional), `dietaryNotes`, `region`.

Dashboard shows upcoming festival in 7-day lookahead. Fasting mode auto-suggested on known fasting festivals (Navratri, Ekadashi, Karva Chauth, Ramzan).

Wedding planner collection: `weddingDate`, `targetWeightKg`, `skinGoal`, `notes`.

---

## 39. Medication & Water Tracking Collections

Medication: `name`, `dosage`, `scheduleJson` (array of `{time, days[]}`), `isActive`.

Water: `amountMl`, `loggedAt`, `source` (manual/reminder/auto).

---

## 40. Notification System

| Channel          | Importance | When                                     |
| ---------------- | ---------- | ---------------------------------------- |
| `meal_reminders` | High       | Breakfast/lunch/dinner (user-configured) |
| `medications`    | Max        | Per medication schedule                  |
| `step_goal`      | Default    | 8pm if goal not reached                  |
| `water_reminder` | Low        | Every 2h if not logged                   |
| `sync_failed`    | High       | DLQ count > 0                            |
| `ai_coach`       | Default    | Proactive nudge from AI coach [§F2]      |

---

## 41. Social Collections

`social_posts`: `userId`, `groupId`, `content`, `postType`, `reactions` (JSON), `createdAt`.
`groups`: `name`, `createdBy`, `members` (JSON array), `groupType` (family/friends/challenge).

---

## 42. Home Widgets

Android / iOS home screen: Steps progress · Water intake · Today's calories · Current streak · Karma level.

```dart
class HomeWidgetService {
  static Future<void> updateStepsWidget(int steps, int goal) async {
    await HomeWidget.saveWidgetData<int>('steps_today', steps);
    await HomeWidget.saveWidgetData<int>('steps_goal', goal);
    await HomeWidget.updateWidget(
      androidName: 'StepsWidgetProvider', iOSName: 'StepsWidget');
  }
}
```

---

## 43. Error Handling & Observability

Standard provider pattern — always handle all three states:

```dart
ref.watch(provider).when(
  loading: () => const ShimmerLoader(height: 120),
  error:   (e, _) => ErrorRetryWidget(message: 'Could not load', onRetry: () => ref.invalidate(provider)),
  data:    (v) => v == null ? EmptyState(contextKey: 'bp', message: 'No readings yet.') : HeroCard(data: v),
);
```

---

## 44. Complete `appwrite.json` Reference

```json
{
  "projectId": "your_project_id",
  "projectName": "FitKarma",
  "collections": [
    { "$id": "users", "name": "Users", "databaseId": "fitkarma-db" },
    { "$id": "food_logs", "name": "Food Logs", "databaseId": "fitkarma-db" },
    {
      "$id": "food_database",
      "name": "Food Database",
      "databaseId": "fitkarma-db"
    },
    {
      "$id": "bp_readings",
      "name": "Blood Pressure",
      "databaseId": "fitkarma-db"
    },
    {
      "$id": "glucose_readings",
      "name": "Glucose",
      "databaseId": "fitkarma-db"
    },
    { "$id": "sleep_logs", "name": "Sleep Logs", "databaseId": "fitkarma-db" },
    { "$id": "workouts", "name": "Workouts", "databaseId": "fitkarma-db" },
    { "$id": "habits", "name": "Habits", "databaseId": "fitkarma-db" },
    { "$id": "journal", "name": "Journal", "databaseId": "fitkarma-db" },
    {
      "$id": "lab_reports",
      "name": "Lab Reports",
      "databaseId": "fitkarma-db"
    },
    {
      "$id": "karma_events",
      "name": "Karma Events",
      "databaseId": "fitkarma-db"
    },
    { "$id": "festivals", "name": "Festivals", "databaseId": "fitkarma-db" },
    {
      "$id": "medications",
      "name": "Medications",
      "databaseId": "fitkarma-db"
    },
    { "$id": "water_logs", "name": "Water Logs", "databaseId": "fitkarma-db" },
    {
      "$id": "social_posts",
      "name": "Social Posts",
      "databaseId": "fitkarma-db"
    },
    { "$id": "groups", "name": "Groups", "databaseId": "fitkarma-db" },
    {
      "$id": "share_tokens",
      "name": "Share Tokens",
      "databaseId": "fitkarma-db"
    }
  ],
  "functions": [
    {
      "$id": "xp-calculator",
      "name": "XP Calculator",
      "runtime": "node-20.0",
      "timeout": 15
    },
    {
      "$id": "report-share",
      "name": "Report Share Link",
      "runtime": "node-20.0",
      "timeout": 15
    },
    {
      "$id": "food-search",
      "name": "Food Search",
      "runtime": "node-20.0",
      "timeout": 10
    },
    {
      "$id": "ai-coach",
      "name": "AI Coach",
      "runtime": "node-20.0",
      "timeout": 30
    },
    {
      "$id": "feature-flags",
      "name": "Feature Flags",
      "runtime": "node-20.0",
      "timeout": 5
    }
  ],
  "buckets": [
    {
      "$id": "lab-reports",
      "name": "Lab Reports",
      "encryption": true,
      "antivirus": true
    },
    { "$id": "avatars", "name": "User Avatars", "compression": "gzip" }
  ]
}
```

---

## 45. Glossary & Architecture Decisions

| Term                 | Definition                                                                                              |
| -------------------- | ------------------------------------------------------------------------------------------------------- |
| **DLQ**              | Dead Letter Queue — records that failed to sync 3+ times. User must resolve via Settings → Data & Sync. |
| **Optimistic UI**    | UI updates immediately from Drift write; remote sync is background.                                     |
| **Calm Zone**        | Settings, Journal, Emergency Card, Lab Reports — zero glow/blur/animation on all device tiers.          |
| **syncStatus**       | `pending` → `synced` → `dlq`. Drives all sync worker decisions.                                         |
| **localId**          | UUID generated on device before any network access. Never null.                                         |
| **UX Stage**         | `firstWeek / familiar / expert` — controls onboarding density.                                          |
| **Single Hero Rule** | Exactly one `metricXL` or `heroDisplay` per visible scroll area.                                        |
| **Rule of Two**      | No surface > 2 visual effects simultaneously.                                                           |
| **Soft Delete**      | `isDeleted = true` instead of hard delete — enables undo, sync recovery, audit trails.                  |

### Architecture Decision Records

**ADR-001: Drift over Hive** — SQL joins needed for date-range queries and relational linking (glucose → food logs).

**ADR-002: Riverpod over Bloc** — simpler async composition, better `AsyncValue`, code generation via `riverpod_annotation`.

**ADR-003: Appwrite over Firebase** — self-hostable (India data residency path), open-source, no per-read billing, CLI-first workflow.

**ADR-004: SQLCipher** — AES-256 at the SQLite page level. Key in platform keychain. Raw `.db` file unreadable without key.

**ADR-005: Soft Delete** — health data is irreplaceable; undo and cross-device conflict recovery require it.

**ADR-006: Pure Dart Animations** — consistent token styling, zero-latency start, no third-party versioning risk.

**ADR-007: `--dart-define`** — secrets never in source; separate build targets for dev/staging/prod.

**ADR-008: Sentry over Crashlytics** — self-hostable, no Google telemetry, avoids GCP lock-in.

**ADR-009: lastWriteWins + manualReview conflicts** — clinical records (BP, glucose, medications) require `manualReview`; food/habits use `lastWriteWins`.

**ADR-010: Open Food Facts + Custom Indian DB** — Open Food Facts provides 3M+ global items (free, open-source); custom Appwrite collection provides 50,000+ Indian-specific items with Hindi names and regional variants. [§F1]

**ADR-011: LLM AI Coach via Appwrite Function** — keeps API key server-side; enables rate limiting, logging, and model swapping without app release. [§F2]

**ADR-012: RevenueCat for Subscriptions** — handles App Store + Play Store receipts, entitlement management, and webhooks in one SDK; avoids custom backend billing logic. [§F4]
