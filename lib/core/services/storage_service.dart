import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/core_providers.dart';

part 'storage_service.g.dart';

@riverpod
class StorageService extends _$StorageService {
  late final Storage _storage;
  static const String bucketId = 'fitkarma-vault';

  @override
  void build() {
    _storage = ref.watch(appwriteStorageProvider);
  }

  /// Uploads a lab report with the naming convention: labreport_{userId}_{uuid}.ext
  /// Enforces a max of 3 files for free tier users.
  Future<void> uploadLabReport(File file, String userId) async {
    final isProUser = await ref.read(isProProvider.future);

    if (!isProUser) {
      // Check free tier limit (max 3 lab reports)
      final existingFiles = await _storage.listFiles(
        bucketId: bucketId,
        queries: [
          Query.startsWith('name', 'labreport_${userId}_'),
        ],
      );

      if (existingFiles.total >= 3) {
        throw Exception('Free tier limit reached. Pro users get unlimited lab reports.');
      }
    }

    final extension = file.path.split('.').last.toLowerCase();
    final uuid = ID.unique();
    final fileName = 'labreport_${userId}_$uuid.$extension';

    await _storage.createFile(
      bucketId: bucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: file.path, filename: fileName),
      permissions: [
        Permission.read(Role.user(userId)),
        Permission.write(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );
  }

  /// Uploads a profile photo with the naming convention: avatar_{userId}.jpg
  Future<void> uploadProfilePhoto(File file, String userId) async {
    final fileName = 'avatar_$userId.jpg';

    // Check for existing avatar and delete to replace
    try {
      final existing = await _storage.listFiles(
        bucketId: bucketId,
        queries: [
          Query.equal('name', fileName),
        ],
      );
      for (var f in existing.files) {
        await _storage.deleteFile(
          bucketId: bucketId,
          fileId: f.$id,
        );
      }
    } catch (_) {
      // Ignore if file doesn't exist
    }

    await _storage.createFile(
      bucketId: bucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: file.path, filename: fileName),
      permissions: [
        Permission.read(Role.user(userId)),
        Permission.write(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );
  }
}
