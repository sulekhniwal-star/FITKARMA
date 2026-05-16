import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/onboarding/onboarding_providers.dart';
import '../database/app_database.dart';
import '../../features/subscription/subscription_service.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

/// appwriteClientProvider — Configures the core Appwrite client.
/// 
/// Reads configuration from --dart-define environment variables.
@riverpod
Client appwriteClient(Ref ref) {
  const endpoint = String.fromEnvironment('APPWRITE_ENDPOINT', defaultValue: 'https://sgp.cloud.appwrite.io/v1');
  const projectId = String.fromEnvironment('APPWRITE_PROJECT_ID', defaultValue: 'fitkarma');

  if (projectId.isEmpty) {
    throw Exception('APPWRITE_PROJECT_ID is not defined. Please run with --dart-define=APPWRITE_PROJECT_ID=your_id');
  }

  return Client()
    ..setEndpoint(endpoint)
    ..setProject(projectId)
    ..setSelfSigned(status: true); // Allow self-signed for dev
}

@riverpod
TablesDB appwriteDatabases(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return TablesDB(client);
}

@riverpod
Storage appwriteStorage(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
}

@riverpod
Functions appwriteFunctions(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Functions(client);
}

@riverpod
Account appwriteAccount(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
}

@riverpod
Future<bool> isPro(Ref ref) async {
  final auth = ref.watch(authProvider);
  final user = auth.value;
  if (user == null) return false;

  // 1. Evaluate primary native store capability entitlement layer
  final subService = ref.read(subscriptionServiceProvider);
  final hasNativeEntitlement = await subService.isPro();
  if (hasNativeEntitlement) return true;

  // 2. Fallback checking remote user row role cache values
  final client = ref.watch(appwriteClientProvider);
  final tablesDb = TablesDB(client);
  try {
    final row = await tablesDb.getRow(
      databaseId: 'fitkarma-db',
      tableId: 'users',
      rowId: user.$id,
    );
    return row.data['isPro'] ?? false;
  } catch (e) {
    return false;
  }
}
@riverpod
Stream<dynamic> currentUserLocalRecord(Ref ref) {
  final authAsync = ref.watch(authProvider);
  final user = authAsync.value;
  if (user == null) return Stream.value(null);

  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.users)..where((t) => t.id.equals(user.$id))).watchSingleOrNull();
}
