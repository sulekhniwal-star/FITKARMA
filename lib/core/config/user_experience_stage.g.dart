// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_experience_stage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserExperienceStage)
final userExperienceStageProvider = UserExperienceStageProvider._();

final class UserExperienceStageProvider
    extends $NotifierProvider<UserExperienceStage, UXStage> {
  UserExperienceStageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userExperienceStageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userExperienceStageHash();

  @$internal
  @override
  UserExperienceStage create() => UserExperienceStage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UXStage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UXStage>(value),
    );
  }
}

String _$userExperienceStageHash() =>
    r'6037110213f2c081b9cf931bff135b09673bfeb6';

abstract class _$UserExperienceStage extends $Notifier<UXStage> {
  UXStage build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UXStage, UXStage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UXStage, UXStage>,
              UXStage,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
