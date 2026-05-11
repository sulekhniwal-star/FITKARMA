import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/providers/core_providers.dart';
import '../../core/database/app_database.dart';
import 'models/dosha_quiz.dart';

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
      final userId = ID.unique();
      await account.create(
        userId: userId,
        email: email,
        password: password,
        name: name,
      );
      await account.createEmailPasswordSession(email: email, password: password);
      
      // Initialize user in local DB
      final db = ref.read(appDatabaseProvider);
      await db.into(db.users).insert(
            UsersCompanion.insert(
              id: userId,
              userId: userId,
              email: email,
              name: name,
            ),
          );

      return await account.get();
    });
  }

  Future<void> saveDoshaResult(DoshaResult result) async {
    final user = state.value;
    if (user == null) return;

    final db = ref.read(appDatabaseProvider);
    await (db.update(db.users)..where((t) => t.id.equals(user.$id))).write(
      UsersCompanion(
        dominantDosha: Value(result.dominant.name),
        vataPercentage: Value(result.vataPercentage),
        pittaPercentage: Value(result.pittaPercentage),
        kaphaPercentage: Value(result.kaphaPercentage),
        uxStage: const Value('dosha_completed'),
      ),
    );

    // Sync to Appwrite (Optional: could be handled by a sync worker)
    final databases = ref.read(appwriteDatabasesProvider);
    try {
      await databases.updateDocument(
        databaseId: 'fitkarma-db',
        collectionId: 'users',
        documentId: user.$id,
        data: {
          'dominantDosha': result.dominant.name,
          'vataPercentage': result.vataPercentage,
          'pittaPercentage': result.pittaPercentage,
          'kaphaPercentage': result.kaphaPercentage,
          'uxStage': 'dosha_completed',
        },
      );
    } catch (e) {
      // Log error but continue
      print('Error syncing dosha to Appwrite: $e');
    }
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

/// DoshaQuizNotifier — Manages the state of the 10-question quiz.
@riverpod
class DoshaQuiz extends _$DoshaQuiz {
  @override
  Map<int, DoshaType> build() => {};

  void answerQuestion(int questionIndex, DoshaType answer) {
    state = {...state, questionIndex: answer};
  }

  DoshaResult? calculateResult() {
    if (state.length < 10) return null;

    int vata = 0, pitta = 0, kapha = 0;
    for (final answer in state.values) {
      if (answer == DoshaType.vata) vata++;
      if (answer == DoshaType.pitta) pitta++;
      if (answer == DoshaType.kapha) kapha++;
    }

    final total = state.length.toDouble();
    
    // Find dominant
    DoshaType dominant = DoshaType.vata;
    if (pitta >= vata && pitta >= kapha) dominant = DoshaType.pitta;
    if (kapha >= vata && kapha >= pitta) dominant = DoshaType.kapha;

    return DoshaResult(
      dominant: dominant,
      vataPercentage: (vata / total) * 100,
      pittaPercentage: (pitta / total) * 100,
      kaphaPercentage: (kapha / total) * 100,
    );
  }
}
