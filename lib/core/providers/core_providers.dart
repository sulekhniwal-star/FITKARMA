import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';

/// appwriteClientProvider — Configures the core Appwrite client.
/// 
/// Reads configuration from --dart-define environment variables.
@riverpod
Client appwriteClient(AppwriteClientRef ref) {
  const endpoint = String.fromEnvironment('APPWRITE_ENDPOINT', defaultValue: 'https://cloud.appwrite.io/v1');
  const projectId = String.fromEnvironment('APPWRITE_PROJECT_ID');

  if (projectId.isEmpty) {
    throw Exception('APPWRITE_PROJECT_ID is not defined. Please run with --dart-define=APPWRITE_PROJECT_ID=your_id');
  }

  return Client()
    ..setEndpoint(endpoint)
    ..setProject(projectId)
    ..setSelfSigned(status: true); // Allow self-signed for dev
}

@riverpod
Databases appwriteDatabases(AppwriteDatabasesRef ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
}

@riverpod
Storage appwriteStorage(AppwriteStorageRef ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
}

@riverpod
Functions appwriteFunctions(AppwriteFunctionsRef ref) {
  final client = ref.watch(appwriteClientProvider);
  return Functions(client);
}

@riverpod
Account appwriteAccount(AppwriteAccountRef ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
}
