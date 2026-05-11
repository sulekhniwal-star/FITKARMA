# Part III — Enterprise Hardening

## 46. Clean Architecture — Layer Separation

```text
features/food/
├── data/
├── datasources/
│   ├── food_local_datasource.dart   # Drift only
│   └── food_remote_datasource.dart  # Appwrite only
├── models/
│   └── food_log_model.dart
├── repositories/
│   └── food_repository_impl.dart
├── domain/
├── entities/meal.dart
├── repositories/food_repository.dart  # abstract
├── usecases/
│   ├── log_meal.dart
│   └── get_today_meals.dart
└── presentation/
    ├── providers/food_providers.dart
    └── screens/food_home_screen.dart
```

---

## 47. Dependency Injection Strategy

```dart
@riverpod
FoodRepository foodRepository(FoodRepositoryRef ref) => FoodRepositoryImpl(
  ref.watch(foodLocalDatasourceProvider),
  ref.watch(foodRemoteDatasourceProvider),
  ref.watch(syncWorkerProvider),
);

// Test override:
ProviderScope(
  overrides: [foodRepositoryProvider.overrideWith((_) => InMemoryFoodRepository())],
  child: const FitKarmaApp(),
)
```

---

## 48. Database Migration Strategy

```dart
@override
int get schemaVersion => 4;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) => m.createAll(),
  onUpgrade: (m, from, to) async {
    if (from < 2) await m.addColumn(foodLogs, foodLogs.failedAttempts);
    if (from < 3) {
      await m.addColumn(foodLogs, foodLogs.remoteId);
      await m.addColumn(bpReadings, bpReadings.remoteId);
    }
  },
);
```

Rules: never drop columns · new columns must be nullable or have DEFAULT · test with `verifyAll()` in CI.

---

## 49. Soft Delete System

```dart
// Every user-deletable table gets:
BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
IntColumn  get deletedAt => integer().nullable()();

// Every query must filter:
..where((t) => t.isDeleted.equals(false))

// Deletion = soft mark + SnackBar with [Undo] for 4s
```

---

## 50. Sync Conflict Resolution

```dart
enum ConflictStrategy { lastWriteWins, manualReview }
```

| Collection                                       | Strategy                                        |
| ------------------------------------------------ | ----------------------------------------------- |
| `bp_readings`, `glucose_readings`, `medications` | `manualReview` — clinical, never auto-overwrite |
| `food_logs`, `workouts`, `habits`, `journal`     | `lastWriteWins`                                 |
| `users` (profile)                                | `lastWriteWins`                                 |

Every syncable table needs `updatedAt: IntColumn`.

---

## 51. Sync Queue Priorities

```dart
extension SyncPriorityTable on String {
  SyncPriority get syncPriority => const {
    'bp_readings':      SyncPriority.critical,
    'glucose_readings': SyncPriority.critical,
    'medications':      SyncPriority.critical,
    'workouts':         SyncPriority.high,
    'sleep_logs':       SyncPriority.high,
    'food_logs':        SyncPriority.medium,
    'habits':           SyncPriority.medium,
    'water_logs':       SyncPriority.low,
    'social_posts':     SyncPriority.low,
  }[this] ?? SyncPriority.low;
}
```

---

## 52. Security Threat Model

| Threat            | Mitigation                                           |
| ----------------- | ---------------------------------------------------- |
| Rooted device     | SQLCipher AES-256 + platform keychain key            |
| MITM              | Certificate pinning + TLS 1.3 only                   |
| Token theft       | Appwrite HTTP-only session cookies                   |
| Screenshot leak   | `FLAG_SECURE` on sensitive screens                   |
| Backup exposure   | `android:allowBackup="false"`                        |
| Decompiled binary | All secrets via `--dart-define` + Appwrite Functions |

---

## 53. Certificate Pinning & Screen Security

```dart
// Certificate pinning via IOHttpClientAdapter
client.badCertificateCallback = (cert, host, port) =>
    cert.sha256.toUpperCase() == pinnedFingerprint;

// FLAG_SECURE on sensitive screens (Journal, Lab Reports, etc.)
class SecureScreen extends StatefulWidget { ... }
```

---

## 54. Audit Logging

```dart
enum AuditAction {
  viewLabReport, exportHealthData, editProfile,
  loginSuccess, loginFailed, biometricSuccess, biometricFailed,
}

// Log every sensitive action:
await auditLogger.log(userId: uid, action: AuditAction.viewLabReport, resourceId: reportId);
```

---

## 55. Accessibility — Advanced

- Dynamic font scaling: clamp scaled font sizes `(12.0, 20.0)` to prevent layout breaks
- Reduced Motion: check `accessibilitySettingsProvider` before any `AnimatedBuilder`
- Color-blind indicators: always pair color with shape/icon (never color alone for health status)
- OpenDyslexic toggle in Settings → Accessibility → `ThemeData` rebuild

---

## 56. Performance — Render Budget & Widget Optimization

```dart
// select() — narrow provider subscription
final calories = ref.watch(foodStateProvider.select((s) => s.totalCalories));

// const constructors — Flutter skips rebuild entirely
const ShimmerLoader(height: 120)

// RepaintBoundary — isolates expensive CustomPaint
RepaintBoundary(child: ActivityRings(...))

// Background isolates for large JSON
Future<List<FoodLog>> parseLogs(String json) => compute(_parseFoodLogs, json);
```

---

## 57. Crash Reporting & Observability

```dart
await SentryFlutter.init((options) {
  options.dsn = const String.fromEnvironment('SENTRY_DSN');
  options.tracesSampleRate = 0.2;
  options.environment = const String.fromEnvironment('APP_ENV', defaultValue: 'production');
  // Strip PII — never send health values in error reports
  options.beforeSend = (event, hint) => event.copyWith(user: null);
}, appRunner: () => runApp(const ProviderScope(child: FitKarmaApp())));
```

---

## 58. Feature Flags

```dart
class FeatureFlags {
  final bool aiInsights;       // §F2 — default: true (now implemented)
  final bool socialFeed;       // default: true
  final bool weddingPlanner;   // default: true
  final bool fhirExport;       // default: false (future)
  final bool voiceLogging;     // default: false (future)
  final bool proSubscription;  // §F4 — default: true (RevenueCat)
}
```

---

## 59. AI Insight Engine (Rule-Based)

```dart
class InsightEngine {
  Future<HealthAnomaly?> detectBPAnomaly(String userId) async {
    final readings = await _fetchBpReadings(userId, days: 30);
    if (readings.length < 7) return null;
    final avgSystolic = readings.map((r) => r.systolic).average;
    final stdDev = _standardDeviation(readings.map((r) => r.systolic.toDouble()));
    if (readings.last.systolic > avgSystolic + 2 * stdDev) {
      return HealthAnomaly(type: AnomalyType.bpElevated, message: '...');
    }
    return null;
  }
}
```

---

## 60. Wearable Abstraction Layer

```dart
abstract class HealthDataProvider {
  String get providerName;
  Future<bool> requestPermissions();
  Future<int> getTodaySteps();
  Future<double?> getLatestHeartRate();
  Future<List<SleepSession>> getSleepData(DateTime date);
  Future<List<BpReading>> getBloodPressureData({int days = 7});
}

class HealthConnectProvider implements HealthDataProvider { /* Android */ }
class HealthKitProvider      implements HealthDataProvider { /* iOS — full impl §F3 */ }
class ManualEntryProvider    implements HealthDataProvider { /* fallback */ }

@riverpod
HealthDataProvider healthDataProvider(HealthDataProviderRef ref) {
  if (Platform.isAndroid) return HealthConnectProvider();
  if (Platform.isIOS)     return HealthKitProvider();   // ← fixed [§F3]
  return ManualEntryProvider();
}
```

---

## 61. Testing — Comprehensive Strategy

```dart
// Widget test: GlassCard tier enforcement
testWidgets('GlassCard — low tier uses solid surface1, no blur', (tester) async {
  await tester.pumpWidget(ProviderScope(
    overrides: [deviceTierProvider.overrideWith((_) => Future.value(DeviceTier.low))],
    child: MaterialApp(theme: AppTheme.dark(), home: const GlassCard(child: Text('test'))),
  ));
  await tester.pump();
  expect(find.byType(BackdropFilter), findsNothing);
});

// Integration test: offline sync recovery
testWidgets('Meal logged offline syncs on connectivity restore', (tester) async {
  // Override connectivity → none → log food → expect pending
  // Override connectivity → wifi → expect synced
});
```

---

## 62. Account Management & Data Rights

```dart
// Export all health data as JSON
Future<File> exportHealthData(String userId) async { ... }

// Full account deletion
Future<void> deleteAccount(String userId) async {
  await Account(ref.read(appwriteClientProvider)).delete();
  await ref.read(appDatabaseProvider).close();
  await File(await _getDbPath()).delete();
  await const FlutterSecureStorage().deleteAll();
  ref.invalidate(authNotifierProvider);
}
```
