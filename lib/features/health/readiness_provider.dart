import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import '../../core/providers/core_providers.dart';
import '../../core/database/app_database.dart';
import '../../core/services/karma_service.dart';
import 'readiness_engine.dart';

part 'readiness_provider.g.dart';

@riverpod
class ReadinessState extends _$ReadinessState {
  @override
  FutureOr<ReadinessLog?> build() async {
    final db = ref.watch(appDatabaseProvider);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    // Fetch latest log logged today
    final log = await (db.select(db.readinessLogs)
      ..where((t) => t.loggedAt.greaterOrEqualValue(startOfDay))
      ..orderBy([(t) => OrderingTerm(expression: t.loggedAt, mode: OrderingMode.desc)])
      ..limit(1))
      .getSingleOrNull();
      
    return log;
  }

  Future<void> logMorningCheckIn({
    required int sleepMinutes,
    required int sleepQuality,
    required int sorenessLevel,
    required int stressLevel,
    required int energyLevel,
    int? restingHr,
  }) async {
    state = const AsyncValue.loading();
    final db = ref.read(appDatabaseProvider);
    
    final result = ReadinessEngine.calculate(
      sleepMinutes: sleepMinutes,
      sleepQuality: sleepQuality,
      sorenessLevel: sorenessLevel,
      stressLevel: stressLevel,
      energyLevel: energyLevel,
      restingHr: restingHr,
    );

    final now = DateTime.now();
    final companion = ReadinessLogsCompanion.insert(
      id: Value(DateTime.now().toIso8601String()),
      userId: ref.read(authProvider).value?.$id ?? 'local',
      score: result.score,
      zone: result.zone.name,
      sleepMinutes: Value(sleepMinutes),
      sleepQuality: Value(sleepQuality),
      sorenessLevel: Value(sorenessLevel),
      stressLevel: Value(stressLevel),
      energyLevel: Value(energyLevel),
      restingHr: Value(restingHr),
      recommendation: Value(result.recommendation),
      loggedAt: Value(now),
      syncStatus: const Value('pending'),
    );

    await db.into(db.readinessLogs).insert(companion);
    
    // Also create matching daily mission for the user!
    final missionCompanion = DailyMissionsCompanion.insert(
      id: Value(DateTime.now().toIso8601String()),
      userId: ref.read(authProvider).value?.$id ?? 'local',
      title: 'Daily Mission · ${result.zoneLabel}',
      description: result.recommendation,
      workoutIntensity: result.workoutIntensity,
      waterTargetMl: result.waterTargetMl,
      stepTarget: result.stepTarget,
      calorieTarget: 2200, // baseline
      missionDate: now,
      syncStatus: const Value('pending'),
    );
    
    await db.into(db.dailyMissions).insert(missionCompanion);

    // Award XP for logging recovery state (health engagement)
    try {
      await ref.read(karmaServiceProvider.notifier).awardXP('log_recovery');
    } catch (_) {}

    // Reload state
    ref.invalidateSelf();
  }
}

@riverpod
FutureOr<List<ReadinessLog>> readinessHistory(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.readinessLogs)
    ..orderBy([(t) => OrderingTerm(expression: t.loggedAt, mode: OrderingMode.desc)])
    ..limit(7))
    .get();
}

@riverpod
FutureOr<DailyMission?> currentDailyMission(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  
  return (db.select(db.dailyMissions)
    ..where((t) => t.missionDate.greaterOrEqualValue(startOfDay))
    ..orderBy([(t) => OrderingTerm(expression: t.missionDate, mode: OrderingMode.desc)])
    ..limit(1))
    .getSingleOrNull();
}
