import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/onboarding/onboarding_providers.dart';
import '../database/app_database.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}

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

@riverpod
Future<bool> isPro(IsProRef ref) async {
  final auth = ref.watch(authProvider);
  final user = auth.value;
  if (user == null) return false;

  final databases = ref.watch(appwriteDatabasesProvider);
  try {
    final doc = await databases.getDocument(
      databaseId: 'fitkarma-db',
      collectionId: 'users',
      documentId: user.$id,
    );
    return doc.data['isPro'] ?? false;
  } catch (e) {
    // If user document doesn't exist yet, they are not pro
    return false;
  }
}
