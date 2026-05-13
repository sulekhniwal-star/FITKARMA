// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'festival_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FestivalsList)
final festivalsListProvider = FestivalsListProvider._();

final class FestivalsListProvider
    extends $AsyncNotifierProvider<FestivalsList, List<FestivalItem>> {
  FestivalsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'festivalsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$festivalsListHash();

  @$internal
  @override
  FestivalsList create() => FestivalsList();
}

String _$festivalsListHash() => r'aae160bbbc4db3ddd47e82a31a5832bf1b6b6d9f';

abstract class _$FestivalsList extends $AsyncNotifier<List<FestivalItem>> {
  FutureOr<List<FestivalItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<FestivalItem>>, List<FestivalItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FestivalItem>>, List<FestivalItem>>,
              AsyncValue<List<FestivalItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
