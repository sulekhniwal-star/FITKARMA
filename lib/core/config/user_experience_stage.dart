import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import '../providers/core_providers.dart';

part 'user_experience_stage.g.dart';

/// UXStage — Represents the user's progress within the onboarding flow.
/// Each value represents a completed step in the onboarding journey.
enum UXStage {
  /// Initial state - user is at the welcome screen
  welcomeDone,

  /// User completed goals selection
  goalsDone,

  /// User completed dosha quiz
  doshaDone,

  /// User completed demographics entry
  demographicsDone,

  /// User viewed/accepted diet plan
  dietPlanDone,

  /// User selected their program
  programSelectDone,

  /// User completed all onboarding steps
  complete,
}

@riverpod
class UxStage extends _$UxStage {
  @override
  Future<UXStage> build() async {
    final db = ref.watch(appDatabaseProvider);

    final user = await (db.select(db.users)..limit(1)).getSingleOrNull();

    if (user == null) return UXStage.welcomeDone;

    switch (user.uxStage) {
      case 'welcomeDone':
        return UXStage.welcomeDone;
      case 'goalsDone':
        return UXStage.goalsDone;
      case 'doshaDone':
        return UXStage.doshaDone;
      case 'demographicsDone':
        return UXStage.demographicsDone;
      case 'dietPlanDone':
        return UXStage.dietPlanDone;
      case 'programSelectDone':
        return UXStage.programSelectDone;
      case 'complete':
        return UXStage.complete;
      default:
        return UXStage.welcomeDone;
    }
  }

  Future<void> updateStage(UXStage newStage) async {
    final db = ref.read(appDatabaseProvider);
    final stageString = newStage.name;
    
    // Update the local user record
    await (db.update(db.users)).write(
      UsersCompanion(uxStage: Value(stageString)),
    );
    
    ref.invalidateSelf();
  }
}
