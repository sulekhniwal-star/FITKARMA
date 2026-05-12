import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/core_providers.dart';
import '../onboarding/onboarding_providers.dart';

part 'bp_providers.g.dart';

// ─── Classification Logic ───────────────────────────────────────────────────

enum BpClassification {
  normal('Normal', Color(0xFF4ADE80), Color(0x334ADE80)),
  elevated('Elevated', Color(0xFFFBBF24), Color(0x33FFB547)),
  stage1('Stage 1', Color(0xFFFBBF24), Color(0x33FFB547)),
  stage2('Stage 2', Color(0xFFF87171), Color(0x40FF6B35)),
  crisis('Hypertensive Crisis', Color(0xFFF87171), Color(0x40FF6B35));

  final String label;
  final Color color;
  final Color glowColor;

  const BpClassification(this.label, this.color, this.glowColor);

  static BpClassification classify(int systolic, int diastolic) {
    if (systolic > 180 || diastolic > 120) {
      return BpClassification.crisis;
    } else if (systolic >= 140 || diastolic >= 90) {
      return BpClassification.stage2;
    } else if ((systolic >= 130 && systolic <= 139) || (diastolic >= 80 && diastolic <= 89)) {
      return BpClassification.stage1;
    } else if (systolic >= 120 && systolic <= 129 && diastolic < 80) {
      return BpClassification.elevated;
    } else {
      return BpClassification.normal;
    }
  }
}

// ─── Metadata Storage Service ───────────────────────────────────────────────

class BpMetadataService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _prefix = 'bp_meta_';

  Future<void> saveMetadata(String readingId, String? notes, String arm) async {
    final data = jsonEncode({'notes': notes, 'arm': arm});
    await _storage.write(key: '$_prefix$readingId', value: data);
  }

  Future<Map<String, String?>> getMetadata(String readingId) async {
    final data = await _storage.read(key: '$_prefix$readingId');
    if (data == null) return {'notes': null, 'arm': 'Left'};
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return {
        'notes': map['notes'] as String?,
        'arm': (map['arm'] as String?) ?? 'Left',
      };
    } catch (_) {
      return {'notes': null, 'arm': 'Left'};
    }
  }
}

@riverpod
BpMetadataService bpMetadataService(Ref ref) {
  return BpMetadataService();
}

// ─── Stream & Cache Providers ───────────────────────────────────────────────

final bpReadingsStreamProvider = StreamProvider<List<BpReading>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchRecentBpReadings(limit: 30);
});

@riverpod
class BpMetadataCache extends _$BpMetadataCache {
  @override
  Map<String, Map<String, String?>> build() => {};

  Future<void> loadForReadings(List<BpReading> readings) async {
    final service = ref.read(bpMetadataServiceProvider);
    final updated = {...state};
    bool changed = false;
    for (final r in readings) {
      if (!updated.containsKey(r.id)) {
        updated[r.id] = await service.getMetadata(r.id);
        changed = true;
      }
    }
    if (changed) {
      state = updated;
    }
  }

  Future<void> save(String readingId, String? notes, String arm) async {
    final service = ref.read(bpMetadataServiceProvider);
    await service.saveMetadata(readingId, notes, arm);
    state = {
      ...state,
      readingId: {'notes': notes, 'arm': arm},
    };
  }
}

// Helper function to insert reading
Future<void> logBpReading(
  WidgetRef ref, {
  required int systolic,
  required int diastolic,
  required int pulse,
  required String? notes,
  required String arm,
}) async {
  final db = ref.read(appDatabaseProvider);
  final user = ref.read(authProvider).value;
  final userId = user?.$id ?? 'anonymous';
  final id = const Uuid().v4();

  await db.into(db.bpReadings).insert(
        BpReadingsCompanion.insert(
          id: id,
          userId: userId,
          systolic: systolic,
          diastolic: diastolic,
          pulse: pulse,
          measuredAt: DateTime.now(),
        ),
      );

  await ref.read(bpMetadataCacheProvider.notifier).save(id, notes, arm);
}
