import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/core_providers.dart';
import '../onboarding/onboarding_providers.dart';

part 'glucose_providers.g.dart';

// ─── Classification Logic ───────────────────────────────────────────────────

enum GlucoseClassification {
  normal('Normal', Color(0xFF4ADE80), Color(0x334ADE80)),
  preDiabetic('Pre-diabetic', Color(0xFFFBBF24), Color(0x33FFB547)),
  diabetic('Diabetic', Color(0xFFF87171), Color(0x40FF6B35)),
  hypoglycemic('Hypoglycemic', Color(0xFFC084FC), Color(0x407B6FF0));

  final String label;
  final Color color;
  final Color glowColor;

  const GlucoseClassification(this.label, this.color, this.glowColor);

  static GlucoseClassification classify(double value, String timing) {
    if (value < 70) {
      return GlucoseClassification.hypoglycemic;
    }

    if (timing.toLowerCase() == 'fasting') {
      if (value <= 99) return GlucoseClassification.normal;
      if (value <= 125) return GlucoseClassification.preDiabetic;
      return GlucoseClassification.diabetic;
    } else {
      // post-meal, random, bedtime
      if (value <= 139) return GlucoseClassification.normal;
      if (value <= 199) return GlucoseClassification.preDiabetic;
      return GlucoseClassification.diabetic;
    }
  }

  static bool isCrisis(double value) {
    return value < 54 || value > 250;
  }
}

// ─── Metadata Storage Service ───────────────────────────────────────────────

class GlucoseMetadataService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _prefix = 'glu_meta_';

  Future<void> saveMetadata(String readingId, String? notes, String? linkedFood) async {
    final data = jsonEncode({'notes': notes, 'linkedFood': linkedFood});
    await _storage.write(key: '$_prefix$readingId', value: data);
  }

  Future<Map<String, String?>> getMetadata(String readingId) async {
    final data = await _storage.read(key: '$_prefix$readingId');
    if (data == null) return {'notes': null, 'linkedFood': null};
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return {
        'notes': map['notes'] as String?,
        'linkedFood': map['linkedFood'] as String?,
      };
    } catch (_) {
      return {'notes': null, 'linkedFood': null};
    }
  }
}

@riverpod
GlucoseMetadataService glucoseMetadataService(GlucoseMetadataServiceRef ref) {
  return GlucoseMetadataService();
}

// ─── Stream & Cache Providers ───────────────────────────────────────────────

@riverpod
Stream<List<GlucoseReading>> glucoseReadingsStream(GlucoseReadingsStreamRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchRecentGlucoseReadings(limit: 30);
}

@riverpod
Stream<List<FoodLog>> todayFoodLogs(TodayFoodLogsRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchTodayFoodLogs();
}

@riverpod
class GlucoseMetadataCache extends _$GlucoseMetadataCache {
  @override
  Map<String, Map<String, String?>> build() => {};

  Future<void> loadForReadings(List<GlucoseReading> readings) async {
    final service = ref.read(glucoseMetadataServiceProvider);
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

  Future<void> save(String readingId, String? notes, String? linkedFood) async {
    final service = ref.read(glucoseMetadataServiceProvider);
    await service.saveMetadata(readingId, notes, linkedFood);
    state = {
      ...state,
      readingId: {'notes': notes, 'linkedFood': linkedFood},
    };
  }
}

// Helper function to insert reading
Future<void> logGlucoseReading(
  WidgetRef ref, {
  required double value,
  required String timing,
  required String? notes,
  required String? linkedFood,
}) async {
  final db = ref.read(appDatabaseProvider);
  final user = ref.read(authProvider).value;
  final userId = user?.$id ?? 'anonymous';
  final id = const Uuid().v4();

  await db.into(db.glucoseReadings).insert(
        GlucoseReadingsCompanion.insert(
          id: id,
          userId: userId,
          value: value,
          timing: timing,
          measuredAt: DateTime.now(),
        ),
      );

  await ref.read(glucoseMetadataCacheProvider.notifier).save(id, notes, linkedFood);
}
