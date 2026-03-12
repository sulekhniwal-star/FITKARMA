import 'package:hive/hive.dart';

part 'sync_queue_item.g.dart';

@HiveType(typeId: 0)
class SyncQueueItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String action; // e.g., 'CREATE', 'UPDATE', 'DELETE'

  @HiveField(2)
  final String collectionId;

  @HiveField(3)
  final Map<String, dynamic> data;

  @HiveField(4)
  final DateTime createdAt;

  SyncQueueItem({
    required this.id,
    required this.action,
    required this.collectionId,
    required this.data,
    required this.createdAt,
  });
}
