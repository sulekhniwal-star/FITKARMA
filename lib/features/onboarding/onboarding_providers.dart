import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/core_providers.dart';
import 'models/dosha_quiz.dart';

part 'onboarding_providers.g.dart';

/// AuthNotifier — Manages user authentication state via Appwrite.
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<models.User?> build() async {
    final account = ref.watch(appwriteAccountProvider);
    try {
      final user = await account.get();
      // Ensure local user record exists
      final db = ref.read(appDatabaseProvider);
      final localUser = await (db.select(db.users)..where((t) => t.id.equals(user.$id))).getSingleOrNull();
      if (localUser == null) {
        await db.into(db.users).insert(
          UsersCompanion.insert(
            id: user.$id,
            userId: user.$id,
            email: user.email,
            name: user.name,
            uxStage: const Value('established'),
            onboardingCompleted: const Value(true),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(appwriteAccountProvider);
      await account.createEmailPasswordSession(email: email, password: password);
      final user = await account.get();

      // Setup local user record and attempt restore from remote
      final db = ref.read(appDatabaseProvider);
      final databases = ref.read(appwriteDatabasesProvider);
      
      String uxStage = 'established';
      bool onboardingCompleted = true;
      String? dominantDosha;
      double? vataPercentage;
      double? pittaPercentage;
      double? kaphaPercentage;
      String? goals;

      try {
        final row = await databases.getRow(
          databaseId: 'fitkarma-db',
          tableId: 'users',
          rowId: user.$id,
        );
        final data = row.data;
        uxStage = data['uxStage'] ?? 'established';
        onboardingCompleted = data['onboardingCompleted'] ?? true;
        dominantDosha = data['dominantDosha'];
        vataPercentage = (data['vataPercentage'] as num?)?.toDouble();
        pittaPercentage = (data['pittaPercentage'] as num?)?.toDouble();
        kaphaPercentage = (data['kaphaPercentage'] as num?)?.toDouble();
        goals = data['goals'];
      } catch (_) {
        final existingLocal = await (db.select(db.users)..where((t) => t.id.equals(user!.$id))).getSingleOrNull();
        if (existingLocal != null) {
          uxStage = existingLocal.uxStage;
          onboardingCompleted = existingLocal.onboardingCompleted;
          dominantDosha = existingLocal.dominantDosha;
          vataPercentage = existingLocal.vataPercentage;
          pittaPercentage = existingLocal.pittaPercentage;
          kaphaPercentage = existingLocal.kaphaPercentage;
          goals = existingLocal.goals;
        }
      }

      await db.into(db.users).insert(
        UsersCompanion.insert(
          id: user.$id,
          userId: user.$id,
          email: user.email,
          name: user.name,
          uxStage: Value(uxStage),
          onboardingCompleted: Value(onboardingCompleted),
          dominantDosha: Value(dominantDosha),
          vataPercentage: Value(vataPercentage),
          pittaPercentage: Value(pittaPercentage),
          kaphaPercentage: Value(kaphaPercentage),
          goals: Value(goals),
        ),
        mode: InsertMode.insertOrReplace,
      );

      return user;
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
      final user = await account.get();
      
      // Initialize user in local DB
      final db = ref.read(appDatabaseProvider);
      await db.into(db.users).insert(
            UsersCompanion.insert(
              id: user.$id,
              userId: user.$id,
              email: email,
              name: name,
              uxStage: const Value('onboarding'),
              onboardingCompleted: const Value(false),
            ),
            mode: InsertMode.insertOrReplace,
          );

      // Create remote row proactively
      try {
        final databases = ref.read(appwriteDatabasesProvider);
        await databases.createRow(
          databaseId: 'fitkarma-db',
          tableId: 'users',
          rowId: user.$id,
          data: {
            'email': email,
            'name': name,
            'uxStage': 'onboarding',
            'onboardingCompleted': false,
          },
        );
      } catch (e) {
        debugPrint('Error creating remote user row: $e');
      }

      return user;
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

    // Sync to Appwrite with fallback creation
    final databases = ref.read(appwriteDatabasesProvider);
    final rowData = {
      'dominantDosha': result.dominant.name,
      'vataPercentage': result.vataPercentage,
      'pittaPercentage': result.pittaPercentage,
      'kaphaPercentage': result.kaphaPercentage,
      'uxStage': 'dosha_completed',
      'email': user.email,
      'name': user.name,
    };

    try {
      await databases.updateRow(
        databaseId: 'fitkarma-db',
        tableId: 'users',
        rowId: user.$id,
        data: rowData,
      );
    } catch (_) {
      try {
        await databases.createRow(
          databaseId: 'fitkarma-db',
          tableId: 'users',
          rowId: user.$id,
          data: rowData,
        );
      } catch (e) {
        debugPrint('Error syncing dosha to Appwrite: $e');
      }
    }
  }

  Future<void> saveGoals(List<String> goals) async {
    final user = state.value;
    if (user == null) return;

    final db = ref.read(appDatabaseProvider);
    await (db.update(db.users)..where((t) => t.id.equals(user.$id))).write(
      UsersCompanion(
        goals: Value(goals.join(',')),
        uxStage: const Value('goals_completed'),
      ),
    );

    // Sync to Appwrite
    final databases = ref.read(appwriteDatabasesProvider);
    final rowData = {
      'goals': goals.join(','),
      'uxStage': 'goals_completed',
      'email': user.email,
      'name': user.name,
    };

    try {
      await databases.updateRow(
        databaseId: 'fitkarma-db',
        tableId: 'users',
        rowId: user.$id,
        data: rowData,
      );
    } catch (_) {
      try {
        await databases.createRow(
          databaseId: 'fitkarma-db',
          tableId: 'users',
          rowId: user.$id,
          data: rowData,
        );
      } catch (e) {
        debugPrint('Error syncing goals to Appwrite: $e');
      }
    }
  }

  Future<void> completeOnboarding() async {
    final user = state.value;
    if (user == null) return;

    final db = ref.read(appDatabaseProvider);
    await (db.update(db.users)..where((t) => t.id.equals(user.$id))).write(
      const UsersCompanion(
        onboardingCompleted: Value(true),
        uxStage: Value('established'),
      ),
    );

    // Sync to Appwrite
    final databases = ref.read(appwriteDatabasesProvider);
    final rowData = {
      'onboardingCompleted': true,
      'uxStage': 'established',
      'email': user.email,
      'name': user.name,
    };

    try {
      await databases.updateRow(
        databaseId: 'fitkarma-db',
        tableId: 'users',
        rowId: user.$id,
        data: rowData,
      );
    } catch (_) {
      try {
        await databases.createRow(
          databaseId: 'fitkarma-db',
          tableId: 'users',
          rowId: user.$id,
          data: rowData,
        );
      } catch (e) {
        debugPrint('Error syncing onboarding status to Appwrite: $e');
      }
    }
  }

  Future<void> loginAnonymous() async {
    // ... existing loginAnonymous ...
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
  // ... existing DoshaQuiz ...
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

/// GoalsNotifier — Manages the multi-selection of health goals.
@riverpod
class Goals extends _$Goals {
  @override
  List<String> build() => [];

  void toggleGoal(String goalId) {
    if (state.contains(goalId)) {
      state = state.where((id) => id != goalId).toList();
    } else {
      state = [...state, goalId];
    }
  }
}
