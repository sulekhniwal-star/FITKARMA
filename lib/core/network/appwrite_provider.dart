import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appwrite_provider.g.dart';

// These should be in a .env or config file in real projects
const String appwriteEndpoint = 'https://cloud.appwrite.io/v1';
const String appwriteProjectId = 'fitkarma_project';

@Riverpod(keepAlive: true)
Client appwriteClient(Ref ref) {
  return Client()
    ..setEndpoint(appwriteEndpoint)
    ..setProject(appwriteProjectId);
}

@Riverpod(keepAlive: true)
Account appwriteAccount(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
}

@Riverpod(keepAlive: true)
Databases appwriteDatabases(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
}
