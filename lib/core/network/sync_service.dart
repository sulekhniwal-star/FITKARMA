import 'dart:developer' as dev;
import 'package:appwrite/appwrite.dart';
import 'package:fitkarma/core/network/appwrite_provider.dart';
import 'package:fitkarma/core/network/connectivity_service.dart';
import 'package:fitkarma/core/network/sync_queue_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_service.g.dart';

@Riverpod(keepAlive: true)
class SyncService extends _$SyncService {
  late Box<SyncQueueItem> _queueBox;

  @override
  FutureOr<void> build() async {
    _queueBox = await Hive.openBox<SyncQueueItem>('sync_queue');
    
    // Listen for connectivity changes
    ref.listen(networkNotifierProvider, (previous, next) {
      if (next == true) {
        dev.log('Internet connected! Flushing sync queue...');
        flushQueue();
      }
    });
  }

  Future<void> addToQueue(SyncQueueItem item) async {
    await _queueBox.put(item.id, item);
    if (ref.read(networkNotifierProvider)) {
      flushQueue();
    }
  }

  Future<void> flushQueue() async {
    if (_queueBox.isEmpty) return;
    if (!ref.read(networkNotifierProvider)) return;

    final databases = ref.read(appwriteDatabasesProvider);
    final items = _queueBox.values.toList();
    
    // Sort by createdAt to maintain some order, though we also check updatedAt
    items.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    for (var item in items) {
      try {
        await _processSyncItem(databases, item);
        await _queueBox.delete(item.id);
      } catch (e) {
        dev.log('Failed to sync item ${item.id}: $e');
      }
    }
  }

  Future<void> _processSyncItem(Databases databases, SyncQueueItem item) async {
    const databaseId = 'main';
    
    try {
      // Check for remote record
      final remoteDoc = await databases.getDocument(
        databaseId: databaseId,
        collectionId: item.collectionId,
        documentId: item.id,
      );

      final remoteUpdatedAt = DateTime.parse(remoteDoc.data['updatedAt']);
      
      // Conflict Resolution Logic (ADR-16)
      if (item.updatedAt.isAfter(remoteUpdatedAt)) {
        // Local is newer: Update remote
        await databases.updateDocument(
          databaseId: databaseId,
          collectionId: item.collectionId,
          documentId: item.id,
          data: {
            ...item.data,
            'updatedAt': item.updatedAt.toIso8601String(),
          },
        );
      } else if (item.updatedAt.isAtSameMomentAs(remoteUpdatedAt)) {
        // Same timestamp: Last Write Wins (using document ID or just re-pushed)
        // For simplicity, we just push if they are the same
         await databases.updateDocument(
          databaseId: databaseId,
          collectionId: item.collectionId,
          documentId: item.id,
          data: item.data,
        );
      } else {
        // Remote is newer: Need to update local record
        // In a real app, this would trigger a broadcast to the repository
        dev.log('Remote data is newer for ${item.id}. Remote sync required.');
      }
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        // Document doesn't exist remotely: Create it
        await databases.createDocument(
          databaseId: databaseId,
          collectionId: item.collectionId,
          documentId: item.id,
          data: {
            ...item.data,
            'updatedAt': item.updatedAt.toIso8601String(),
          },
        );
      } else {
        rethrow;
      }
    }
  }
}
