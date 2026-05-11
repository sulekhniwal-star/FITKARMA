import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_experience_stage.g.dart';

enum UXStage {
  onboarding,
  firstWeek,
  established,
}

@riverpod
class UserExperienceStage extends _$UserExperienceStage {
  @override
  UXStage build() {
    // TODO: Connect to Drift database to determine actual stage
    return UXStage.onboarding;
  }

  void setStage(UXStage stage) {
    state = stage;
  }
}
