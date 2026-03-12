import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:appwrite/appwrite.dart';
import '../constants/hive_boxes.dart';
import '../constants/api_endpoints.dart';
import 'appwrite_client.dart';
import 'sync_queue_item.dart';
import 'connectivity_service.dart';

class SyncQueue {
  final Box _box = Hive.box(HiveBoxes.syncQueue);
  final ConnectivityService _connectivity;
  final Databases _databases = AppwriteClient.databases;
  
  bool _isProcessing = false;
  Timer? _timer;

  SyncQueue(this._connectivity) {
    // Check connectivity and start processing if online
    _connectivity.onConnectivityChanged.listen((isOnline) {
      if (isOnline) {
        processQueue();
      }
    });
    
    // Periodic check every 15 minutes as per doc
    _timer = Timer.periodic(const Duration(minutes: 15), (_) {
      processQueue();
    });
  }

  Future<void> addItem(SyncQueueItem item) async {
    await _box.add(item.toMap());
    processQueue();
  }

  Future<void> processQueue() async {
    if (_isProcessing) return;
    if (!(await _connectivity.isConnected)) return;

    _isProcessing = true;
    
    try {
      final items = _box.values.toList();
      if (items.isEmpty) return;

      // Process in batches of 20 as per doc
      final batch = items.take(20).toList();
      
      for (var map in batch) {
        final item = SyncQueueItem.fromMap(map as Map);
        final success = await _processItem(item);
        
        if (success) {
          // Find the key for this item in the box and delete it
          final key = _box.keys.firstWhere((k) => _box.get(k)['id'] == item.id);
          await _box.delete(key);
        } else {
          // Increment retry count or handle failure
          item.retryCount++;
          if (item.retryCount >= 5) {
             // Max retries reached, maybe log or move to a dead letter box
             final key = _box.keys.firstWhere((k) => _box.get(k)['id'] == item.id);
             await _box.delete(key);
             debugPrint('Sync failed for item ${item.id} after 5 retries');
          } else {
             // Update the item in the box
             final key = _box.keys.firstWhere((k) => _box.get(k)['id'] == item.id);
             await _box.put(key, item.toMap());
          }
        }
      }
    } catch (e) {
      debugPrint('Error processing sync queue: $e');
    } finally {
      _isProcessing = false;
      
      // If there are still items, check if we should continue immediately
      if (_box.isNotEmpty && await _connectivity.isConnected) {
        processQueue();
      }
    }
  }

  Future<bool> _processItem(SyncQueueItem item) async {
    try {
      switch (item.operation) {
        case 'create':
          await _databases.createDocument(
            databaseId: AW.dbId,
            collectionId: item.collectionId,
            documentId: item.appwriteDocId ?? ID.unique(),
            data: item.payload,
          );
          break;
        case 'update':
          if (item.appwriteDocId == null) return false;
          await _databases.updateDocument(
            databaseId: AW.dbId,
            collectionId: item.collectionId,
            documentId: item.appwriteDocId!,
            data: item.payload,
          );
          break;
        case 'delete':
          if (item.appwriteDocId == null) return true; // Already gone or never existed
          await _databases.deleteDocument(
            databaseId: AW.dbId,
            collectionId: item.collectionId,
            documentId: item.appwriteDocId!,
          );
          break;
      }
      return true;
    } on AppwriteException catch (e) {
      debugPrint('Appwrite sync error: ${e.message}');
      // Check for specific errors that might mean we shouldn't retry (e.g. 404 on update)
      if (e.code == 404 && item.operation == 'update') return true; 
      return false;
    } catch (e) {
      debugPrint('General sync error: $e');
      return false;
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
