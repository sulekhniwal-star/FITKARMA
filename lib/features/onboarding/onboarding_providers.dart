import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:drift/drift.dart' hide JsonKey;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/core_providers.dart';
import '../settings/settings_providers.dart';
import 'models/dosha_quiz.dart';
part 'onboarding_providers.freezed.dart';
part 'onboarding_providers.g.dart';

/// GoalsState — State container for the health goals selection screen.
/// Builds all goals from the constants in [health_goal.dart].
@freezed
abstract class GoalsState with _$GoalsState {
  const factory GoalsState({
    @Default({}) Set<String> selectedGoals,
    @Default(1800) int dailyCalorieTarget,
    @Default(120)  int dailyProteinG,
    @Default(8000) int dailyStepsGoal,
    @Default(8.0)  double sleepTargetHours,
  }) = _GoalsState;
}

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
          dominantDosha = data['dominantDosha'] ?? dominantDosha;
          age = data['age'] as int? ?? age;
          heightCm = (data['heightCm'] as num?)?.toDouble() ?? heightCm;
          weightKg = (data['weightKg'] as num?)?.toDouble() ?? weightKg;
          gender = data['gender'] ?? gender;
          
          debugPrint('AuthNotifier: Restored demographics from remote');
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
        uxStage = 'established';
        onboardingCompleted = true;
        dominantDosha = data['dominantDosha'];
        age = data['age'] as int?;
        heightCm = (data['heightCm'] as num?)?.toDouble();
        weightKg = (data['weightKg'] as num?)?.toDouble();
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
              uxStage: Value(UXStage.welcomeDone.name),
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
        uxStage: Value(UXStage.doshaDone.name),
      ),
    );

    final databases = ref.read(appwriteDatabasesProvider);
    final rowData = {
      'userId': user.$id,
      'dominantDosha': result.dominant.name,
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

  Future<void> saveGoals({
    required Set<String> goals,
    required int dailyCalorieTarget,
    required int dailyProteinG,
    required int dailyStepsGoal,
    required double sleepTargetHours,
  }) async {
    final user = state.value;
    if (user == null) return;

    final db = ref.read(appDatabaseProvider);
    await (db.update(db.users)..where((t) => t.id.equals(user.$id))).write(
      UsersCompanion(
        goals: Value(goals.join(',')),
        uxStage: Value(UXStage.goalsDone.name),
      ),
    );

    if (goals.contains('heart_health') || goals.contains('manage_bp_glucose')) {
      try {
        ref.read(systemSettingsProvider.notifier).updateStepGoal(dailyStepsGoal);
      } catch (e) {
        debugPrint('Error updating system settings step goal: $e');
      }
    }

    final databases = ref.read(appwriteDatabasesProvider);
    final rowData = {
      'userId': user.$id,
      'fitnessGoals': goals.join(','),
      'dailyCalorieTarget': dailyCalorieTarget,
      'dailyProteinG': dailyProteinG,
      'dailyStepsGoal': dailyStepsGoal,
      'sleepTargetHours': sleepTargetHours,
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

    // Calculate BMI and update physical targets dynamically
    if (height > 0 && weight > 0) {
      final double bmi = weight / ((height / 100.0) * (height / 100.0));
      debugPrint('AuthNotifier: Calculated BMI: ${bmi.toStringAsFixed(1)}');
      
      int stepsGoal = 10000;
      int waterGoal = 3000;
      int workoutGoal = 30;

      if (bmi < 18.5) {
        stepsGoal = 6000;     // Moderate active to conserve energy
        waterGoal = 2500;     // Adequate hydration
        workoutGoal = 20;     // Focus on light conditioning
      } else if (bmi < 25.0) {
        stepsGoal = 10000;    // Standard optimal active baseline
        waterGoal = 3000;     // Standard hydration
        workoutGoal = 30;     // Well-balanced standard workout
      } else if (bmi < 30.0) {
        stepsGoal = 12000;    // High activity to boost calorie burn
        waterGoal = 3500;     // Increased hydration
        workoutGoal = 45;     // Extra metabolic burn duration
      } else {
        stepsGoal = 8000;     // Safe progressive active goal to protect joints
        waterGoal = 4000;     // High hydration to flush metabolic byproduct
        workoutGoal = 40;     // Progressive conditioning cardio/strength
      }

      try {
        final settingsNotifier = ref.read(systemSettingsProvider.notifier);
        settingsNotifier.updateStepGoal(stepsGoal);
        settingsNotifier.updateWaterGoal(waterGoal);
        settingsNotifier.updateWorkoutGoal(workoutGoal);
        debugPrint('AuthNotifier: Targets updated - Steps: $stepsGoal, Water: ${waterGoal}mL, Workout: ${workoutGoal}m');
      } catch (e) {
        debugPrint('AuthNotifier: Error updating system targets: $e');
      }
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
          uxStage: Value(UXStage.demographicsDone.name),
        ),
      );
      debugPrint('AuthNotifier: Local save successful');
    } catch (e) {
      debugPrint('AuthNotifier: Local save failed: $e');
      rethrow;
    }

    debugPrint('AuthNotifier: Syncing demographics to Appwrite...');
    final databases = ref.read(appwriteDatabasesProvider);
    final rowData = {
      'userId': user.$id,
      'name': name,
      'age': age,
      'heightCm': height,
      'weightKg': weight,
      'gender': gender,
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
        uxStage: Value('complete'),
      ),
    );

    // Sync to Appwrite
    final databases = ref.read(appwriteDatabasesProvider);
    final rowData = {
      'userId': user.$id,
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
      
      try {
        await account.deleteSession(sessionId: 'current');
      } catch (_) {
        // Ignore
      }

      await account.createAnonymousSession();
      final user = await account.get();

      final db = ref.read(appDatabaseProvider);
      await db
          .into(db.users)
          .insert(
            UsersCompanion.insert(
              id: user.$id,
              userId: user.$id,
              email: 'anonymous@fitkarma.in',
              name: 'Anonymous User',
              uxStage: Value(UXStage.welcomeDone.name),
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

/// Goals — Multi-selection provider for health goals and target metrics.
/// Generates a `goalsProvider` that reads/writes `GoalsState`.
@riverpod
class Goals extends _$Goals {
  @override
  GoalsState build() => const GoalsState();

  bool toggleGoal(String goalId) {
    final current = state.selectedGoals;
    if (current.contains(goalId)) {
      state = state.copyWith(selectedGoals: current.where((id) => id != goalId).toSet());
      return true;
    }
    if (current.length >= 3) return false;
    state = state.copyWith(selectedGoals: {...current, goalId});
    return true;
  }

  void updateCalorieTarget(int kcal) => state = state.copyWith(dailyCalorieTarget: kcal);
  void updateProteinTarget(int g)     => state = state.copyWith(dailyProteinG: g);
  void updateStepsGoal(int steps)     => state = state.copyWith(dailyStepsGoal: steps);
  void updateSleepTarget(double h)    => state = state.copyWith(sleepTargetHours: h);
}

