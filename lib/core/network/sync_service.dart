import 'dart:developer' as dev;
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
    // If online, try to flush immediately
    if (ref.read(networkNotifierProvider)) {
      flushQueue();
    }
  }

  Future<void> flushQueue() async {
    if (_queueBox.isEmpty) return;
    
    dev.log('Processing ${_queueBox.length} items in sync queue');
    
    final items = _queueBox.values.toList();
    for (var item in items) {
      try {
        // Prototype: Mock Appwrite interaction
        dev.log('Syncing item ${item.id} to collection ${item.collectionId}');
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network latency
        
        // Remove from local queue once successfully "synced"
        await _queueBox.delete(item.id);
      } catch (e) {
        dev.log('Failed to sync item ${item.id}: $e');
        // Exponential backoff or retry logic would go here in future phases
      }
    }
  }
}
