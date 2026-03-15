import 'package:flutter/material.dart';
import 'app.dart';
import 'core/network/appwrite_client.dart';
import 'core/network/connectivity_service.dart';
import 'core/network/sync_queue.dart';
import 'core/storage/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local storage
  await HiveService.init();

  // Initialize connectivity monitoring and sync queue
  await SyncQueue.instance.init();

  // Test Appwrite connection
  try {
    final account = await AppwriteClient.account.get();
    debugPrint('Appwrite connection test - Account: $account');
  } catch (e) {
    debugPrint('Appwrite connection test failed: $e');
  }

  runApp(const FitKarmaApp());
}
