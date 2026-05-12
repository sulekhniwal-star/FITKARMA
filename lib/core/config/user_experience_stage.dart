import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import '../providers/core_providers.dart';

part 'user_experience_stage.g.dart';

/// UXStage — Represents the user's progress within the app lifecycle.
enum UXStage {
  /// User is still in the onboarding/registration flow.
  onboarding,
  
  /// User has finished onboarding and is in their first 7 days.
  firstWeek,
  
  /// User is a regular, established user.
  established,
}

@riverpod
class UxStage extends _$UxStage {
  @override
  Future<UXStage> build() async {
    final db = ref.watch(appDatabaseProvider);
    
    // Fetch the single user record (assuming local-first one-user app for now)
    final user = await (db.select(db.users)..limit(1)).getSingleOrNull();
    
    if (user == null) return UXStage.onboarding;

    switch (user.uxStage) {
      case 'firstWeek':
        return UXStage.firstWeek;
      case 'established':
        return UXStage.established;
      default:
        return UXStage.onboarding;
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
