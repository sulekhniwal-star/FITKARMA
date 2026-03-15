// lib/core/network/sync_queue_item.dart
import 'package:hive/hive.dart';

/// Represents a pending sync operation to be flushed to Appwrite.
///
/// Copied from Section 8 of the documentation:
/// - Used for offline-first writes
/// - Stored in sync_queue_box
/// - Flushed in batches of 20 when online
/// - Uses exponential backoff: 1s → 2s → 4s → 8s → 16s, max 5 retries
class SyncQueueItem extends HiveObject {
  String id;
  String collection; // Appwrite collection ID
  String operation; // 'create' | 'update' | 'delete'
  String localId; // Hive object key
  String? appwriteDocId; // Populated after first successful create
  Map<String, dynamic> payload;
  DateTime createdAt;
  int retryCount; // Max 5 attempts
  String? error;

  SyncQueueItem({
    required this.id,
    required this.collection,
    required this.operation,
    required this.localId,
    this.appwriteDocId,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.error,
  });

  /// Creates a new sync queue item with a generated ID.
  factory SyncQueueItem.create({
    required String collection,
    required String operation,
    required String localId,
    required Map<String, dynamic> payload,
  }) {
    return SyncQueueItem(
      id: '${DateTime.now().millisecondsSinceEpoch}_$localId',
      collection: collection,
      operation: operation,
      localId: localId,
      payload: payload,
      createdAt: DateTime.now(),
    );
  }

  /// Increments retry count and stores error message.
  void markFailed(String errorMessage) {
    retryCount++;
    error = errorMessage;
  }

  /// Marks the item as successfully synced with the Appwrite document ID.
  void markSuccess(String docId) {
    appwriteDocId = docId;
    error = null;
  }

  /// Checks if max retries exceeded.
  bool get canRetry => retryCount < 5;

  /// Calculates the next retry delay using exponential backoff.
  /// Returns delay in milliseconds: 1000 → 2000 → 4000 → 8000 → 16000
  int get nextRetryDelay {
    return 1000 * (1 << retryCount); // 2^retryCount * 1000ms
  }

  /// Converts to Map for storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'collection': collection,
      'operation': operation,
      'localId': localId,
      'appwriteDocId': appwriteDocId,
      'payload': payload,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'error': error,
    };
  }

  /// Creates from Map.
  factory SyncQueueItem.fromMap(Map<dynamic, dynamic> map) {
    return SyncQueueItem(
      id: map['id'] as String,
      collection: map['collection'] as String,
      operation: map['operation'] as String,
      localId: map['localId'] as String,
      appwriteDocId: map['appwriteDocId'] as String?,
      payload: Map<String, dynamic>.from(map['payload'] as Map),
      createdAt: DateTime.parse(map['createdAt'] as String),
      retryCount: map['retryCount'] as int? ?? 0,
      error: map['error'] as String?,
    );
  }
}

/// Operation types for sync queue items.
enum SyncOperation { create, update, delete }

extension SyncOperationExtension on SyncOperation {
  String get value {
    switch (this) {
      case SyncOperation.create:
        return 'create';
      case SyncOperation.update:
        return 'update';
      case SyncOperation.delete:
        return 'delete';
    }
  }

  static SyncOperation fromString(String value) {
    switch (value) {
      case 'create':
        return SyncOperation.create;
      case 'update':
        return SyncOperation.update;
      case 'delete':
        return SyncOperation.delete;
      default:
        throw ArgumentError('Unknown sync operation: $value');
    }
  }
}
