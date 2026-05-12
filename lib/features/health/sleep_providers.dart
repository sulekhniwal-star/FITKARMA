import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/core_providers.dart';
import '../onboarding/onboarding_providers.dart';

class SleepMetadataService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _prefix = 'slp_meta_';

  Future<void> saveMetadata(
    String logId, {
    int? spO2,
    int? heartRate,
    String? notes,
    Map<String, int>? stagesMinutes,
  }) async {
    final data = jsonEncode({
      'spO2': spO2,
      'heartRate': heartRate,
      'notes': notes,
      'stagesMinutes': stagesMinutes,
    });
    await _storage.write(key: '$_prefix$logId', value: data);
  }

  Future<Map<String, dynamic>> getMetadata(String logId) async {
    final data = await _storage.read(key: '$_prefix$logId');
    if (data == null) {
      return {
        'spO2': 97,
        'heartRate': 58,
        'notes': null,
        'stagesMinutes': {'rem': 95, 'deep': 85, 'light': 240, 'awake': 24},
      };
    }
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return {
        'spO2': map['spO2'] as int? ?? 97,
        'heartRate': map['heartRate'] as int? ?? 58,
        'notes': map['notes'] as String?,
        'stagesMinutes': (map['stagesMinutes'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v as int),
            ) ??
            {'rem': 95, 'deep': 85, 'light': 240, 'awake': 24},
      };
    } catch (_) {
      return {
        'spO2': 97,
        'heartRate': 58,
        'notes': null,
        'stagesMinutes': {'rem': 95, 'deep': 85, 'light': 240, 'awake': 24},
      };
    }
  }
}

final sleepMetadataServiceProvider = Provider<SleepMetadataService>((ref) {
  return SleepMetadataService();
});

final sleepLogsStreamProvider = StreamProvider<List<SleepLog>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchRecentSleepLogs(limit: 30);
});

class SleepMetadataCacheNotifier extends Notifier<Map<String, Map<String, dynamic>>> {
  @override
  Map<String, Map<String, dynamic>> build() => {};

  Future<void> loadForLogs(List<SleepLog> logs) async {
    final service = ref.read(sleepMetadataServiceProvider);
    final updated = {...state};
    bool changed = false;
    for (final l in logs) {
      if (!updated.containsKey(l.id)) {
        updated[l.id] = await service.getMetadata(l.id);
        changed = true;
      }
    }
    if (changed) {
      state = updated;
    }
  }

  Future<void> save(
    String logId, {
    int? spO2,
    int? heartRate,
    String? notes,
    Map<String, int>? stagesMinutes,
  }) async {
    final service = ref.read(sleepMetadataServiceProvider);
    await service.saveMetadata(
      logId,
      spO2: spO2,
      heartRate: heartRate,
      notes: notes,
      stagesMinutes: stagesMinutes,
    );
    state = {
      ...state,
      logId: {
        'spO2': spO2 ?? 97,
        'heartRate': heartRate ?? 58,
        'notes': notes,
        'stagesMinutes': stagesMinutes ?? {'rem': 95, 'deep': 85, 'light': 240, 'awake': 24},
      },
    };
  }
}

final sleepMetadataCacheProvider = NotifierProvider<SleepMetadataCacheNotifier, Map<String, Map<String, dynamic>>>(SleepMetadataCacheNotifier.new);

Future<void> logSleepSession(
  WidgetRef ref, {
  required DateTime startTime,
  required DateTime endTime,
  required int quality,
  int? spO2,
  int? heartRate,
  String? notes,
  Map<String, int>? stagesMinutes,
}) async {
  final db = ref.read(appDatabaseProvider);
  final user = ref.read(authProvider).value;
  final userId = user?.$id ?? 'anonymous';
  final id = const Uuid().v4();

  DateTime actualStart = startTime;
  if (actualStart.isAfter(endTime)) {
    actualStart = actualStart.subtract(const Duration(days: 1));
  }

  await db.into(db.sleepLogs).insert(
        SleepLogsCompanion.insert(
          id: id,
          userId: userId,
          startTime: actualStart,
          endTime: endTime,
          quality: quality,
        ),
      );

  Map<String, int> finalStages = stagesMinutes ?? {};
  if (finalStages.isEmpty) {
    final totalMins = endTime.difference(actualStart).inMinutes;
    finalStages = {
      'rem': (totalMins * 0.22).toInt(),
      'deep': (totalMins * 0.18).toInt(),
      'light': (totalMins * 0.55).toInt(),
      'awake': (totalMins * 0.05).toInt(),
    };
  }

  await ref.read(sleepMetadataCacheProvider.notifier).save(
        id,
        spO2: spO2,
        heartRate: heartRate,
        notes: notes,
        stagesMinutes: finalStages,
      );
}
