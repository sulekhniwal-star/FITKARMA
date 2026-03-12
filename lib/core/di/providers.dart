import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../network/appwrite_client.dart';
import '../network/connectivity_service.dart';
import '../network/sync_queue.dart';

// Connectivity & Sync Providers
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final syncQueueProvider = Provider<SyncQueue>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return SyncQueue(connectivity);
});

// Appwrite Providers
final appwriteClientProvider = Provider<Client>((ref) {
  return AppwriteClient.client;
});

final appwriteAccountProvider = Provider<Account>((ref) {
  return AppwriteClient.account;
});

final appwriteDatabaseProvider = Provider<Databases>((ref) {
  return AppwriteClient.databases;
});

final appwriteStorageProvider = Provider<Storage>((ref) {
  return AppwriteClient.storage;
});

final appwriteRealtimeProvider = Provider<Realtime>((ref) {
  return AppwriteClient.realtime;
});

final appwriteFunctionsProvider = Provider<Functions>((ref) {
  return AppwriteClient.functions;
});
