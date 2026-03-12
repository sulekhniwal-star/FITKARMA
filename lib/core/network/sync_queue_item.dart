import 'package:uuid/uuid.dart';

class SyncQueueItem {
  final String id;
  final String collectionId;
  final String operation; // 'create' | 'update' | 'delete'
  final String localId; // Hive object key
  final String? appwriteDocId;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  int retryCount;
  String? error;

  SyncQueueItem({
    required this.id,
    required this.collectionId,
    required this.operation,
    required this.localId,
    this.appwriteDocId,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.error,
  });

  factory SyncQueueItem.create({
    required String collectionId,
    required String operation,
    required String localId,
    String? appwriteDocId,
    required Map<String, dynamic> payload,
  }) {
    return SyncQueueItem(
      id: const Uuid().v4(),
      collectionId: collectionId,
      operation: operation,
      localId: localId,
      appwriteDocId: appwriteDocId,
      payload: payload,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'collectionId': collectionId,
      'operation': operation,
      'localId': localId,
      'appwriteDocId': appwriteDocId,
      'payload': payload,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'error': error,
    };
  }

  factory SyncQueueItem.fromMap(Map<dynamic, dynamic> map) {
    return SyncQueueItem(
      id: map['id'] as String,
      collectionId: map['collectionId'] as String,
      operation: map['operation'] as String,
      localId: map['localId'] as String,
      appwriteDocId: map['appwriteDocId'] as String?,
      payload: Map<String, dynamic>.from(map['payload'] as Map),
      createdAt: DateTime.parse(map['createdAt'] as String),
      retryCount: map['retryCount'] as int,
      error: map['error'] as String?,
    );
  }
}
