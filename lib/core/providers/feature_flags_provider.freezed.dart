// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_flags_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeatureFlags {

 bool get aiInsights; bool get wearableSync; bool get periodTracker; bool get socialFeed; bool get weddingPlanner; bool get doshaQuiz; bool get festivalCalendar; bool get proSubscription; bool get fhirExport; bool get voiceLogging; bool get cgmIntegration; bool get pharmacySearch;
/// Create a copy of FeatureFlags
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureFlagsCopyWith<FeatureFlags> get copyWith => _$FeatureFlagsCopyWithImpl<FeatureFlags>(this as FeatureFlags, _$identity);

  /// Serializes this FeatureFlags to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureFlags&&(identical(other.aiInsights, aiInsights) || other.aiInsights == aiInsights)&&(identical(other.wearableSync, wearableSync) || other.wearableSync == wearableSync)&&(identical(other.periodTracker, periodTracker) || other.periodTracker == periodTracker)&&(identical(other.socialFeed, socialFeed) || other.socialFeed == socialFeed)&&(identical(other.weddingPlanner, weddingPlanner) || other.weddingPlanner == weddingPlanner)&&(identical(other.doshaQuiz, doshaQuiz) || other.doshaQuiz == doshaQuiz)&&(identical(other.festivalCalendar, festivalCalendar) || other.festivalCalendar == festivalCalendar)&&(identical(other.proSubscription, proSubscription) || other.proSubscription == proSubscription)&&(identical(other.fhirExport, fhirExport) || other.fhirExport == fhirExport)&&(identical(other.voiceLogging, voiceLogging) || other.voiceLogging == voiceLogging)&&(identical(other.cgmIntegration, cgmIntegration) || other.cgmIntegration == cgmIntegration)&&(identical(other.pharmacySearch, pharmacySearch) || other.pharmacySearch == pharmacySearch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aiInsights,wearableSync,periodTracker,socialFeed,weddingPlanner,doshaQuiz,festivalCalendar,proSubscription,fhirExport,voiceLogging,cgmIntegration,pharmacySearch);

@override
String toString() {
  return 'FeatureFlags(aiInsights: $aiInsights, wearableSync: $wearableSync, periodTracker: $periodTracker, socialFeed: $socialFeed, weddingPlanner: $weddingPlanner, doshaQuiz: $doshaQuiz, festivalCalendar: $festivalCalendar, proSubscription: $proSubscription, fhirExport: $fhirExport, voiceLogging: $voiceLogging, cgmIntegration: $cgmIntegration, pharmacySearch: $pharmacySearch)';
}


}

/// @nodoc
abstract mixin class $FeatureFlagsCopyWith<$Res>  {
  factory $FeatureFlagsCopyWith(FeatureFlags value, $Res Function(FeatureFlags) _then) = _$FeatureFlagsCopyWithImpl;
@useResult
$Res call({
 bool aiInsights, bool wearableSync, bool periodTracker, bool socialFeed, bool weddingPlanner, bool doshaQuiz, bool festivalCalendar, bool proSubscription, bool fhirExport, bool voiceLogging, bool cgmIntegration, bool pharmacySearch
});




}
/// @nodoc
class _$FeatureFlagsCopyWithImpl<$Res>
    implements $FeatureFlagsCopyWith<$Res> {
  _$FeatureFlagsCopyWithImpl(this._self, this._then);

  final FeatureFlags _self;
  final $Res Function(FeatureFlags) _then;

/// Create a copy of FeatureFlags
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aiInsights = null,Object? wearableSync = null,Object? periodTracker = null,Object? socialFeed = null,Object? weddingPlanner = null,Object? doshaQuiz = null,Object? festivalCalendar = null,Object? proSubscription = null,Object? fhirExport = null,Object? voiceLogging = null,Object? cgmIntegration = null,Object? pharmacySearch = null,}) {
  return _then(_self.copyWith(
aiInsights: null == aiInsights ? _self.aiInsights : aiInsights // ignore: cast_nullable_to_non_nullable
as bool,wearableSync: null == wearableSync ? _self.wearableSync : wearableSync // ignore: cast_nullable_to_non_nullable
as bool,periodTracker: null == periodTracker ? _self.periodTracker : periodTracker // ignore: cast_nullable_to_non_nullable
as bool,socialFeed: null == socialFeed ? _self.socialFeed : socialFeed // ignore: cast_nullable_to_non_nullable
as bool,weddingPlanner: null == weddingPlanner ? _self.weddingPlanner : weddingPlanner // ignore: cast_nullable_to_non_nullable
as bool,doshaQuiz: null == doshaQuiz ? _self.doshaQuiz : doshaQuiz // ignore: cast_nullable_to_non_nullable
as bool,festivalCalendar: null == festivalCalendar ? _self.festivalCalendar : festivalCalendar // ignore: cast_nullable_to_non_nullable
as bool,proSubscription: null == proSubscription ? _self.proSubscription : proSubscription // ignore: cast_nullable_to_non_nullable
as bool,fhirExport: null == fhirExport ? _self.fhirExport : fhirExport // ignore: cast_nullable_to_non_nullable
as bool,voiceLogging: null == voiceLogging ? _self.voiceLogging : voiceLogging // ignore: cast_nullable_to_non_nullable
as bool,cgmIntegration: null == cgmIntegration ? _self.cgmIntegration : cgmIntegration // ignore: cast_nullable_to_non_nullable
as bool,pharmacySearch: null == pharmacySearch ? _self.pharmacySearch : pharmacySearch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatureFlags].
extension FeatureFlagsPatterns on FeatureFlags {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureFlags value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureFlags() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureFlags value)  $default,){
final _that = this;
switch (_that) {
case _FeatureFlags():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureFlags value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureFlags() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool aiInsights,  bool wearableSync,  bool periodTracker,  bool socialFeed,  bool weddingPlanner,  bool doshaQuiz,  bool festivalCalendar,  bool proSubscription,  bool fhirExport,  bool voiceLogging,  bool cgmIntegration,  bool pharmacySearch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureFlags() when $default != null:
return $default(_that.aiInsights,_that.wearableSync,_that.periodTracker,_that.socialFeed,_that.weddingPlanner,_that.doshaQuiz,_that.festivalCalendar,_that.proSubscription,_that.fhirExport,_that.voiceLogging,_that.cgmIntegration,_that.pharmacySearch);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool aiInsights,  bool wearableSync,  bool periodTracker,  bool socialFeed,  bool weddingPlanner,  bool doshaQuiz,  bool festivalCalendar,  bool proSubscription,  bool fhirExport,  bool voiceLogging,  bool cgmIntegration,  bool pharmacySearch)  $default,) {final _that = this;
switch (_that) {
case _FeatureFlags():
return $default(_that.aiInsights,_that.wearableSync,_that.periodTracker,_that.socialFeed,_that.weddingPlanner,_that.doshaQuiz,_that.festivalCalendar,_that.proSubscription,_that.fhirExport,_that.voiceLogging,_that.cgmIntegration,_that.pharmacySearch);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool aiInsights,  bool wearableSync,  bool periodTracker,  bool socialFeed,  bool weddingPlanner,  bool doshaQuiz,  bool festivalCalendar,  bool proSubscription,  bool fhirExport,  bool voiceLogging,  bool cgmIntegration,  bool pharmacySearch)?  $default,) {final _that = this;
switch (_that) {
case _FeatureFlags() when $default != null:
return $default(_that.aiInsights,_that.wearableSync,_that.periodTracker,_that.socialFeed,_that.weddingPlanner,_that.doshaQuiz,_that.festivalCalendar,_that.proSubscription,_that.fhirExport,_that.voiceLogging,_that.cgmIntegration,_that.pharmacySearch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureFlags implements FeatureFlags {
  const _FeatureFlags({this.aiInsights = true, this.wearableSync = false, this.periodTracker = true, this.socialFeed = false, this.weddingPlanner = false, this.doshaQuiz = true, this.festivalCalendar = false, this.proSubscription = false, this.fhirExport = false, this.voiceLogging = false, this.cgmIntegration = false, this.pharmacySearch = false});
  factory _FeatureFlags.fromJson(Map<String, dynamic> json) => _$FeatureFlagsFromJson(json);

@override@JsonKey() final  bool aiInsights;
@override@JsonKey() final  bool wearableSync;
@override@JsonKey() final  bool periodTracker;
@override@JsonKey() final  bool socialFeed;
@override@JsonKey() final  bool weddingPlanner;
@override@JsonKey() final  bool doshaQuiz;
@override@JsonKey() final  bool festivalCalendar;
@override@JsonKey() final  bool proSubscription;
@override@JsonKey() final  bool fhirExport;
@override@JsonKey() final  bool voiceLogging;
@override@JsonKey() final  bool cgmIntegration;
@override@JsonKey() final  bool pharmacySearch;

/// Create a copy of FeatureFlags
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureFlagsCopyWith<_FeatureFlags> get copyWith => __$FeatureFlagsCopyWithImpl<_FeatureFlags>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureFlagsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureFlags&&(identical(other.aiInsights, aiInsights) || other.aiInsights == aiInsights)&&(identical(other.wearableSync, wearableSync) || other.wearableSync == wearableSync)&&(identical(other.periodTracker, periodTracker) || other.periodTracker == periodTracker)&&(identical(other.socialFeed, socialFeed) || other.socialFeed == socialFeed)&&(identical(other.weddingPlanner, weddingPlanner) || other.weddingPlanner == weddingPlanner)&&(identical(other.doshaQuiz, doshaQuiz) || other.doshaQuiz == doshaQuiz)&&(identical(other.festivalCalendar, festivalCalendar) || other.festivalCalendar == festivalCalendar)&&(identical(other.proSubscription, proSubscription) || other.proSubscription == proSubscription)&&(identical(other.fhirExport, fhirExport) || other.fhirExport == fhirExport)&&(identical(other.voiceLogging, voiceLogging) || other.voiceLogging == voiceLogging)&&(identical(other.cgmIntegration, cgmIntegration) || other.cgmIntegration == cgmIntegration)&&(identical(other.pharmacySearch, pharmacySearch) || other.pharmacySearch == pharmacySearch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aiInsights,wearableSync,periodTracker,socialFeed,weddingPlanner,doshaQuiz,festivalCalendar,proSubscription,fhirExport,voiceLogging,cgmIntegration,pharmacySearch);

@override
String toString() {
  return 'FeatureFlags(aiInsights: $aiInsights, wearableSync: $wearableSync, periodTracker: $periodTracker, socialFeed: $socialFeed, weddingPlanner: $weddingPlanner, doshaQuiz: $doshaQuiz, festivalCalendar: $festivalCalendar, proSubscription: $proSubscription, fhirExport: $fhirExport, voiceLogging: $voiceLogging, cgmIntegration: $cgmIntegration, pharmacySearch: $pharmacySearch)';
}


}

/// @nodoc
abstract mixin class _$FeatureFlagsCopyWith<$Res> implements $FeatureFlagsCopyWith<$Res> {
  factory _$FeatureFlagsCopyWith(_FeatureFlags value, $Res Function(_FeatureFlags) _then) = __$FeatureFlagsCopyWithImpl;
@override @useResult
$Res call({
 bool aiInsights, bool wearableSync, bool periodTracker, bool socialFeed, bool weddingPlanner, bool doshaQuiz, bool festivalCalendar, bool proSubscription, bool fhirExport, bool voiceLogging, bool cgmIntegration, bool pharmacySearch
});




}
/// @nodoc
class __$FeatureFlagsCopyWithImpl<$Res>
    implements _$FeatureFlagsCopyWith<$Res> {
  __$FeatureFlagsCopyWithImpl(this._self, this._then);

  final _FeatureFlags _self;
  final $Res Function(_FeatureFlags) _then;

/// Create a copy of FeatureFlags
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aiInsights = null,Object? wearableSync = null,Object? periodTracker = null,Object? socialFeed = null,Object? weddingPlanner = null,Object? doshaQuiz = null,Object? festivalCalendar = null,Object? proSubscription = null,Object? fhirExport = null,Object? voiceLogging = null,Object? cgmIntegration = null,Object? pharmacySearch = null,}) {
  return _then(_FeatureFlags(
aiInsights: null == aiInsights ? _self.aiInsights : aiInsights // ignore: cast_nullable_to_non_nullable
as bool,wearableSync: null == wearableSync ? _self.wearableSync : wearableSync // ignore: cast_nullable_to_non_nullable
as bool,periodTracker: null == periodTracker ? _self.periodTracker : periodTracker // ignore: cast_nullable_to_non_nullable
as bool,socialFeed: null == socialFeed ? _self.socialFeed : socialFeed // ignore: cast_nullable_to_non_nullable
as bool,weddingPlanner: null == weddingPlanner ? _self.weddingPlanner : weddingPlanner // ignore: cast_nullable_to_non_nullable
as bool,doshaQuiz: null == doshaQuiz ? _self.doshaQuiz : doshaQuiz // ignore: cast_nullable_to_non_nullable
as bool,festivalCalendar: null == festivalCalendar ? _self.festivalCalendar : festivalCalendar // ignore: cast_nullable_to_non_nullable
as bool,proSubscription: null == proSubscription ? _self.proSubscription : proSubscription // ignore: cast_nullable_to_non_nullable
as bool,fhirExport: null == fhirExport ? _self.fhirExport : fhirExport // ignore: cast_nullable_to_non_nullable
as bool,voiceLogging: null == voiceLogging ? _self.voiceLogging : voiceLogging // ignore: cast_nullable_to_non_nullable
as bool,cgmIntegration: null == cgmIntegration ? _self.cgmIntegration : cgmIntegration // ignore: cast_nullable_to_non_nullable
as bool,pharmacySearch: null == pharmacySearch ? _self.pharmacySearch : pharmacySearch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
