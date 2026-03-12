import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_endpoints.dart';
import '../domain/user_model.dart';
import '../../../core/di/providers.dart';

class AuthRepository {
  final Account _account;
  final Databases _databases;

  AuthRepository(this._account, this._databases);

  // Auth methods
  Future<models.Session> login(String email, String password) {
    return _account.createEmailPasswordSession(email: email, password: password);
  }

  Future<models.User> register(String name, String email, String password) {
    return _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }

  Future<void> logout() {
    return _account.deleteSession(sessionId: 'current');
  }

  // Profile methods
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await _account.get();
      final doc = await _databases.getDocument(
        databaseId: AW.dbId,
        collectionId: AW.users,
        documentId: user.$id,
      );
      return UserModel.fromAppwrite(doc);
    } catch (e) {
      return null;
    }
  }

  Future<void> createUserProfile(UserModel user) async {
    await _databases.createDocument(
      databaseId: AW.dbId,
      collectionId: AW.users,
      documentId: user.id,
      data: user.toAppwrite(),
      permissions: [
        Permission.read(Role.user(user.id)),
        Permission.write(Role.user(user.id)),
      ],
    );
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _databases.updateDocument(
      databaseId: AW.dbId,
      collectionId: AW.users,
      documentId: user.id,
      data: user.toAppwrite(),
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final databases = ref.watch(appwriteDatabaseProvider);
  return AuthRepository(account, databases);
});
