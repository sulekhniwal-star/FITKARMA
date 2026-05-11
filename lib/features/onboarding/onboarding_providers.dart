import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/providers/core_providers.dart';

part 'onboarding_providers.g.dart';

/// AuthNotifier — Manages user authentication state via Appwrite.
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<models.User?> build() async {
    final account = ref.watch(appwriteAccountProvider);
    try {
      return await account.get();
    } catch (_) {
      return null;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(appwriteAccountProvider);
      await account.createEmailPasswordSession(email: email, password: password);
      return await account.get();
    });
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(appwriteAccountProvider);
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      await account.createEmailPasswordSession(email: email, password: password);
      return await account.get();
    });
  }

  Future<void> loginAnonymous() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(appwriteAccountProvider);
      await account.createAnonymousSession();
      return await account.get();
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(appwriteAccountProvider);
      await account.deleteSession(sessionId: 'current');
      return null;
    });
  }
}
