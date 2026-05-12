import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/core_providers.dart';
import '../onboarding/onboarding_providers.dart';

class JournalMetadataService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _prefix = 'jrn_meta_';

  Future<void> saveTags(String entryId, List<String> tags) async {
    final data = jsonEncode({'tags': tags});
    await _storage.write(key: '$_prefix$entryId', value: data);
  }

  Future<List<String>> getTags(String entryId) async {
    final data = await _storage.read(key: '$_prefix$entryId');
    if (data == null) return [];
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      final list = map['tags'] as List<dynamic>? ?? [];
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }
}

final journalMetadataServiceProvider = Provider<JournalMetadataService>((ref) {
  return JournalMetadataService();
});

final journalEntriesStreamProvider = StreamProvider<List<JournalEntry>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchJournalEntries();
});

class JournalMetadataCacheNotifier extends StateNotifier<Map<String, List<String>>> {
  final JournalMetadataService _service;

  JournalMetadataCacheNotifier(this._service) : super({});

  Future<void> loadForEntries(List<JournalEntry> entries) async {
    final updated = {...state};
    bool changed = false;
    for (final e in entries) {
      if (!updated.containsKey(e.id)) {
        updated[e.id] = await _service.getTags(e.id);
        changed = true;
      }
    }
    if (changed) {
      state = updated;
    }
  }

  Future<void> saveTags(String entryId, List<String> tags) async {
    await _service.saveTags(entryId, tags);
    state = {
      ...state,
      entryId: tags,
    };
  }
}

final journalMetadataCacheProvider = StateNotifierProvider<JournalMetadataCacheNotifier, Map<String, List<String>>>((ref) {
  final service = ref.watch(journalMetadataServiceProvider);
  return JournalMetadataCacheNotifier(service);
});

Future<void> saveJournalEntry(
  WidgetRef ref, {
  required String content,
  required String moodEmoji,
  required List<String> tags,
}) async {
  final db = ref.read(appDatabaseProvider);
  final user = ref.read(authProvider).value;
  final userId = user?.$id ?? 'anonymous';
  final id = const Uuid().v4();

  await db.into(db.journalEntries).insert(
        JournalEntriesCompanion.insert(
          id: id,
          userId: userId,
          content: content,
          mood: moodEmoji,
          createdAt: DateTime.now(),
        ),
      );

  if (tags.isNotEmpty) {
    await ref.read(journalMetadataCacheProvider.notifier).saveTags(id, tags);
  }
}
