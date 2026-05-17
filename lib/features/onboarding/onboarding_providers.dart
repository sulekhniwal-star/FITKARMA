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
    debugPrint('AuthNotifier: Building auth state...');
    try {
      // Add a timeout to prevent hanging on splash screen
      final user = await account.get().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('AuthNotifier: account.get() timed out');
          throw AppwriteException('Network timeout', 0);
        },
      );
      debugPrint('AuthNotifier: User found: ${user.$id}');
      
      // Ensure local user record exists
      final db = ref.read(appDatabaseProvider);
      debugPrint('AuthNotifier: Checking local record for ${user.$id}...');
      final localUser = await (db.select(
        db.users,
      )..where((t) => t.id.equals(user.$id))).getSingleOrNull();

      if (localUser == null || (localUser.age == null && localUser.heightCm == null)) {
        // Attempt to restore metrics from remote if local record is missing or incomplete
        String uxStage = localUser?.uxStage ?? 'onboarding';
        bool onboardingCompleted = localUser?.onboardingCompleted ?? false;
        String? dominantDosha = localUser?.dominantDosha;
        double? vataPercentage = localUser?.vataPercentage;
        double? pittaPercentage = localUser?.pittaPercentage;
        double? kaphaPercentage = localUser?.kaphaPercentage;
        String? goals = localUser?.goals;
        String? gender = localUser?.gender;
        int? age = localUser?.age;
        double? heightCm = localUser?.heightCm;
        double? weightKg = localUser?.weightKg;

        try {
          final databases = ref.read(appwriteDatabasesProvider);
          debugPrint('AuthNotifier: Fetching remote record for ${user.$id}...');
          final row = await databases.getRow(
            databaseId: 'fitkarma-db',
            tableId: 'users',
            rowId: user.$id,
          );
          final data = row.data;
          debugPrint('AuthNotifier: Remote data found: $data');
          
          // Only overwrite if remote has data
          uxStage = data['uxStage'] ?? uxStage;
          onboardingCompleted = data['onboardingCompleted'] ?? onboardingCompleted;
          dominantDosha = data['dominantDosha'] ?? dominantDosha;
          vataPercentage = (data['vataPercentage'] as num?)?.toDouble() ?? vataPercentage;
          pittaPercentage = (data['pittaPercentage'] as num?)?.toDouble() ?? pittaPercentage;
          kaphaPercentage = (data['kaphaPercentage'] as num?)?.toDouble() ?? kaphaPercentage;
          goals = data['goals'] ?? goals;
          age = data['age'] as int? ?? age;
          heightCm = (data['height'] as num?)?.toDouble() ?? heightCm;
          weightKg = (data['weight'] as num?)?.toDouble() ?? weightKg;
          gender = data['gender'] ?? gender;
          
          debugPrint('AuthNotifier: Restored uxStage: $uxStage, completed: $onboardingCompleted');
        } catch (e) {
          debugPrint('AuthNotifier: Failed to restore remote record: $e');
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
                age: Value(age),
                heightCm: Value(heightCm),
                weightKg: Value(weightKg),
                gender: Value(gender),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      return user;
    } catch (e) {
      if (e is AppwriteException && e.code == 401) {
        debugPrint('AuthNotifier: No active session (401)');
      } else {
        debugPrint('AuthNotifier: Error during build (falling back to null): $e');
      }
      return null;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(appwriteAccountProvider);
      
      // Clear any existing session to avoid 401 "session already exists"
      try {
        await account.deleteSession(sessionId: 'current');
      } catch (_) {
        // Ignore if no session exists
      }

      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
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
      int? age;
      double? heightCm;
      double? weightKg;
      String? gender;

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
        age = data['age'] as int?;
        heightCm = (data['height'] as num?)?.toDouble();
        weightKg = (data['weight'] as num?)?.toDouble();
        gender = data['gender'];
      } catch (_) {
        final existingLocal = await (db.select(
          db.users,
        )..where((t) => t.id.equals(user.$id))).getSingleOrNull();
        if (existingLocal != null) {
          uxStage = existingLocal.uxStage;
          onboardingCompleted = existingLocal.onboardingCompleted;
          dominantDosha = existingLocal.dominantDosha;
          vataPercentage = existingLocal.vataPercentage;
          pittaPercentage = existingLocal.pittaPercentage;
          kaphaPercentage = existingLocal.kaphaPercentage;
          goals = existingLocal.goals;
          age = existingLocal.age;
          heightCm = existingLocal.heightCm;
          weightKg = existingLocal.weightKg;
          gender = existingLocal.gender;
        }
      }

      await db
          .into(db.users)
          .insert(
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
              age: Value(age),
              heightCm: Value(heightCm),
              weightKg: Value(weightKg),
              gender: Value(gender),
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
      
      // Clear any existing session to avoid 401 "session already exists"
      try {
        await account.deleteSession(sessionId: 'current');
      } catch (_) {
        // Ignore if no session exists
      }

      final userId = ID.unique();
      await account.create(
        userId: userId,
        email: email,
        password: password,
        name: name,
      );
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final user = await account.get();

      // Initialize user in local DB
      final db = ref.read(appDatabaseProvider);
      await db
          .into(db.users)
          .insert(
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
            'userId': user.$id,
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
      'userId': user.$id,
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
      'userId': user.$id,
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

  Future<void> saveDemographics({
    required String name,
    required int age,
    required double height,
    required double weight,
    required String gender,
  }) async {
    final user = state.value;
    if (user == null) {
      debugPrint('AuthNotifier: Cannot save demographics, user is null');
      return;
    }

    debugPrint('AuthNotifier: Saving demographics locally for ${user.$id}...');
    final db = ref.read(appDatabaseProvider);
    try {
      await (db.update(db.users)..where((t) => t.id.equals(user.$id))).write(
        UsersCompanion(
          name: Value(name),
          age: Value(age),
          heightCm: Value(height),
          weightKg: Value(weight),
          gender: Value(gender),
          uxStage: const Value('demographics_completed'),
        ),
      );
      debugPrint('AuthNotifier: Local save successful');
    } catch (e) {
      debugPrint('AuthNotifier: Local save failed: $e');
      rethrow;
    }

    // Update Appwrite
    debugPrint('AuthNotifier: Syncing demographics to Appwrite...');
    final databases = ref.read(appwriteDatabasesProvider);
    final rowData = {
      'userId': user.$id,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'uxStage': 'demographics_completed',
    };

    try {
      await databases.updateRow(
        databaseId: 'fitkarma-db',
        tableId: 'users',
        rowId: user.$id,
        data: rowData,
      );
      debugPrint('AuthNotifier: Appwrite sync successful (updated)');
    } catch (_) {
      try {
        await databases.createRow(
          databaseId: 'fitkarma-db',
          tableId: 'users',
          rowId: user.$id,
          data: rowData,
        );
        debugPrint('AuthNotifier: Appwrite sync successful (created)');
      } catch (e) {
        debugPrint('AuthNotifier: Appwrite sync failed (non-fatal): $e');
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
      'userId': user.$id,
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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(appwriteAccountProvider);
      
      // Clear any existing session to avoid 401 "session already exists"
      try {
        await account.deleteSession(sessionId: 'current');
      } catch (_) {
        // Ignore
      }

      await account.createAnonymousSession();
      final user = await account.get();

      // Initialize user in local DB
      final db = ref.read(appDatabaseProvider);
      await db
          .into(db.users)
          .insert(
            UsersCompanion.insert(
              id: user.$id,
              userId: user.$id,
              email: 'anonymous@fitkarma.in',
              name: 'Anonymous User',
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
            'userId': user.$id,
            'email': 'anonymous@fitkarma.in',
            'name': 'Anonymous User',
            'uxStage': 'onboarding',
            'onboardingCompleted': false,
          },
        );
      } catch (e) {
        debugPrint('Error creating remote anonymous user row: $e');
      }

      return user;
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

