import 'package:hive_flutter/hive_flutter.dart';
import '../network/sync_queue_item.dart';
import '../../features/tracking/domain/models/activity_log.dart';
import '../../features/tracking/domain/models/water_log.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(SyncQueueItemAdapter());
    Hive.registerAdapter(ActivityLogAdapter());
    Hive.registerAdapter(WaterLogAdapter());
  }

  // Helper method to open a box (example)
  static Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }
}
