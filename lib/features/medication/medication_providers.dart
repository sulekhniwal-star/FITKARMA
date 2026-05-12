import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/core_providers.dart';
import '../karma/karma_providers.dart';

class MedicationTakenNotifier extends Notifier<Set<String>> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _cachePrefix = 'med_taken_ids_';

  @override
  Set<String> build() {
    Future.microtask(() => _loadTakenToday());
    return <String>{};
  }

  String get _todayKey {
    final now = DateTime.now();
    return '$_cachePrefix${now.year}_${now.month}_${now.day}';
  }

  Future<void> _loadTakenToday() async {
    try {
      final str = await _storage.read(key: _todayKey);
      if (str != null) {
        final list = jsonDecode(str) as List<dynamic>;
        state = list.map((e) => e.toString()).toSet();
      }
    } catch (_) {}
  }

  Future<void> markTaken(Medication med) async {
    if (state.contains(med.id)) return;

    final updated = {...state, med.id};
    state = updated;

    try {
      await _storage.write(key: _todayKey, value: jsonEncode(updated.toList()));
    } catch (_) {}

    // Mark as taken → logs to Drift → awards karma XP
    // Award compliance points
    ref.read(karmaStateProvider.notifier).addKarmaEvent(
          'Medication Taken: ${med.name}',
          'streak',
          20,
        );
  }

  bool isTakenToday(String medId) => state.contains(medId);
}

final medicationTakenProvider = NotifierProvider<MedicationTakenNotifier, Set<String>>(MedicationTakenNotifier.new);

final medicationsStreamProvider = StreamProvider<List<Medication>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchAllMedications();
});
