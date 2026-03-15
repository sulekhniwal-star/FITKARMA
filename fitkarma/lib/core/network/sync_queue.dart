// lib/core/network/sync_queue.dart
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_boxes.dart';
import '../constants/api_endpoints.dart';
import 'appwrite_client.dart';
import 'connectivity_service.dart';
import 'sync_queue_item.dart';

/// Service for managing the offline sync queue.
///
/// Implements:
/// - Write sync items to sync_queue_box on every local create/update/delete
/// - Background isolate watches connectivity; flushes queue in batches of 20 when online
/// - Exponential backoff: 1s → 2s → 4s → 8s → 16s, max 5 retries
class SyncQueue {
  static SyncQueue? _instance;
  static SyncQueue get instance => _instance ??= SyncQueue._internal();
  SyncQueue._internal();

  static const int _batchSize = 20;
  static const int _maxRetries = 5;

  final ConnectivityService _connectivity = ConnectivityService.instance;
  Box? _queueBox;

  // Stream subscription for connectivity changes
  StreamSubscription<bool>? _connectivitySubscription;

  // Flag to prevent concurrent sync operations
  bool _isSyncing = false;

  // Timer for retry with exponential backoff
  Timer? _retryTimer;

  /// Initializes the sync queue and starts listening for connectivity changes.
  Future<void> init() async {
    _queueBox = Hive.box(HiveBoxes.syncQueue);
    await _connectivity.init();

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.isOnlineStream.listen((isOnline) {
      if (isOnline) {
        _flushQueue();
      }
    });

    // Initial flush if online
    if (await _connectivity.checkConnectivity()) {
      _flushQueue();
    }
  }

  /// Adds a new item to the sync queue.
  ///
  /// Call this after every local create/update/delete operation.
  Future<void> enqueue({
    required String collection,
    required String operation,
    required String localId,
    required Map<String, dynamic> payload,
  }) async {
    final item = SyncQueueItem.create(
      collection: collection,
      operation: operation,
      localId: localId,
      payload: payload,
    );

    await _queueBox?.put(item.id, item.toMap());

    // Try to flush immediately if online
    if (_connectivity.isOnline) {
      _flushQueue();
    }
  }

  /// Flushes the sync queue to Appwrite.
  ///
  /// Processes up to 20 items per batch with exponential backoff retry.
  Future<void> _flushQueue() async {
    if (_isSyncing || !_connectivity.isOnline) return;

    _isSyncing = true;

    try {
      final items = _getPendingItems();

      for (final item in items) {
        if (!_connectivity.isOnline) break;
        if (item.retryCount >= _maxRetries) {
          // Remove items that have exceeded max retries
          await _queueBox?.delete(item.id);
          continue;
        }

        try {
          await _syncItem(item);
          // Remove successfully synced item
          await _queueBox?.delete(item.id);
        } catch (e) {
          // Mark as failed and schedule retry with exponential backoff
          item.markFailed(e.toString());
          await _queueBox?.put(item.id, item.toMap());

          // Schedule retry with exponential backoff
          _scheduleRetry(item.nextRetryDelay);
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Gets all pending items from the queue, sorted by creation time.
  List<SyncQueueItem> _getPendingItems() {
    if (_queueBox == null) return [];

    final items = <SyncQueueItem>[];
    for (final key in _queueBox!.keys) {
      final map = _queueBox!.get(key);
      if (map != null) {
        items.add(SyncQueueItem.fromMap(map));
      }
    }

    // Sort by creation time (oldest first)
    items.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Return only the first batch
    return items.take(_batchSize).toList();
  }

  /// Syncs a single item to Appwrite.
  Future<void> _syncItem(SyncQueueItem item) async {
    final db = AppwriteClient.databases;
    final dbId = AW.dbId;

    switch (item.operation) {
      case 'create':
        final result = await db.createDocument(
          databaseId: dbId,
          collectionId: item.collection,
          documentId: 'unique()',
          data: item.payload,
        );
        // Update local item with Appwrite document ID
        item.markSuccess(result.$id);
        break;

      case 'update':
        if (item.appwriteDocId == null) {
          throw Exception('Cannot update without appwriteDocId');
        }
        await db.updateDocument(
          databaseId: dbId,
          collectionId: item.collection,
          documentId: item.appwriteDocId!,
          data: item.payload,
        );
        break;

      case 'delete':
        if (item.appwriteDocId == null) {
          throw Exception('Cannot delete without appwriteDocId');
        }
        await db.deleteDocument(
          databaseId: dbId,
          collectionId: item.collection,
          documentId: item.appwriteDocId!,
        );
        break;

      default:
        throw Exception('Unknown operation: ${item.operation}');
    }
  }

  /// Schedules a retry with exponential backoff.
  void _scheduleRetry(int delayMs) {
    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(milliseconds: delayMs), () {
      if (_connectivity.isOnline) {
        _flushQueue();
      }
    });
  }

  /// Gets the current queue size.
  int get queueSize => _queueBox?.length ?? 0;

  /// Checks if there are pending items.
  bool get hasPendingItems => queueSize > 0;

  /// Forces a manual sync attempt.
  Future<void> forceSync() async {
    if (_connectivity.isOnline) {
      await _flushQueue();
    }
  }

  /// Clears all pending items from the queue.
  Future<void> clearQueue() async {
    await _queueBox?.clear();
  }

  /// Disposes of resources.
  void dispose() {
    _connectivitySubscription?.cancel();
    _retryTimer?.cancel();
  }
}
