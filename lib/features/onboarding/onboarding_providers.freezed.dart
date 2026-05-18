// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalsState implements DiagnosticableTreeMixin {

 Set<String> get selectedGoals; int get dailyCalorieTarget; int get dailyProteinG; int get dailyStepsGoal; double get sleepTargetHours;
/// Create a copy of GoalsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalsStateCopyWith<GoalsState> get copyWith => _$GoalsStateCopyWithImpl<GoalsState>(this as GoalsState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GoalsState'))
    ..add(DiagnosticsProperty('selectedGoals', selectedGoals))..add(DiagnosticsProperty('dailyCalorieTarget', dailyCalorieTarget))..add(DiagnosticsProperty('dailyProteinG', dailyProteinG))..add(DiagnosticsProperty('dailyStepsGoal', dailyStepsGoal))..add(DiagnosticsProperty('sleepTargetHours', sleepTargetHours));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalsState&&const DeepCollectionEquality().equals(other.selectedGoals, selectedGoals)&&(identical(other.dailyCalorieTarget, dailyCalorieTarget) || other.dailyCalorieTarget == dailyCalorieTarget)&&(identical(other.dailyProteinG, dailyProteinG) || other.dailyProteinG == dailyProteinG)&&(identical(other.dailyStepsGoal, dailyStepsGoal) || other.dailyStepsGoal == dailyStepsGoal)&&(identical(other.sleepTargetHours, sleepTargetHours) || other.sleepTargetHours == sleepTargetHours));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(selectedGoals),dailyCalorieTarget,dailyProteinG,dailyStepsGoal,sleepTargetHours);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GoalsState(selectedGoals: $selectedGoals, dailyCalorieTarget: $dailyCalorieTarget, dailyProteinG: $dailyProteinG, dailyStepsGoal: $dailyStepsGoal, sleepTargetHours: $sleepTargetHours)';
}


}

/// @nodoc
abstract mixin class $GoalsStateCopyWith<$Res>  {
  factory $GoalsStateCopyWith(GoalsState value, $Res Function(GoalsState) _then) = _$GoalsStateCopyWithImpl;
@useResult
$Res call({
 Set<String> selectedGoals, int dailyCalorieTarget, int dailyProteinG, int dailyStepsGoal, double sleepTargetHours
});




}
/// @nodoc
class _$GoalsStateCopyWithImpl<$Res>
    implements $GoalsStateCopyWith<$Res> {
  _$GoalsStateCopyWithImpl(this._self, this._then);

  final GoalsState _self;
  final $Res Function(GoalsState) _then;

/// Create a copy of GoalsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedGoals = null,Object? dailyCalorieTarget = null,Object? dailyProteinG = null,Object? dailyStepsGoal = null,Object? sleepTargetHours = null,}) {
  return _then(_self.copyWith(
selectedGoals: null == selectedGoals ? _self.selectedGoals : selectedGoals // ignore: cast_nullable_to_non_nullable
as Set<String>,dailyCalorieTarget: null == dailyCalorieTarget ? _self.dailyCalorieTarget : dailyCalorieTarget // ignore: cast_nullable_to_non_nullable
as int,dailyProteinG: null == dailyProteinG ? _self.dailyProteinG : dailyProteinG // ignore: cast_nullable_to_non_nullable
as int,dailyStepsGoal: null == dailyStepsGoal ? _self.dailyStepsGoal : dailyStepsGoal // ignore: cast_nullable_to_non_nullable
as int,sleepTargetHours: null == sleepTargetHours ? _self.sleepTargetHours : sleepTargetHours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalsState].
extension GoalsStatePatterns on GoalsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalsState value)  $default,){
final _that = this;
switch (_that) {
case _GoalsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalsState value)?  $default,){
final _that = this;
switch (_that) {
case _GoalsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> selectedGoals,  int dailyCalorieTarget,  int dailyProteinG,  int dailyStepsGoal,  double sleepTargetHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalsState() when $default != null:
return $default(_that.selectedGoals,_that.dailyCalorieTarget,_that.dailyProteinG,_that.dailyStepsGoal,_that.sleepTargetHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> selectedGoals,  int dailyCalorieTarget,  int dailyProteinG,  int dailyStepsGoal,  double sleepTargetHours)  $default,) {final _that = this;
switch (_that) {
case _GoalsState():
return $default(_that.selectedGoals,_that.dailyCalorieTarget,_that.dailyProteinG,_that.dailyStepsGoal,_that.sleepTargetHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> selectedGoals,  int dailyCalorieTarget,  int dailyProteinG,  int dailyStepsGoal,  double sleepTargetHours)?  $default,) {final _that = this;
switch (_that) {
case _GoalsState() when $default != null:
return $default(_that.selectedGoals,_that.dailyCalorieTarget,_that.dailyProteinG,_that.dailyStepsGoal,_that.sleepTargetHours);case _:
  return null;

}
}

}

/// @nodoc


class _GoalsState with DiagnosticableTreeMixin implements GoalsState {
  const _GoalsState({final  Set<String> selectedGoals = const {}, this.dailyCalorieTarget = 1800, this.dailyProteinG = 120, this.dailyStepsGoal = 8000, this.sleepTargetHours = 8.0}): _selectedGoals = selectedGoals;
  

 final  Set<String> _selectedGoals;
@override@JsonKey() Set<String> get selectedGoals {
  if (_selectedGoals is EqualUnmodifiableSetView) return _selectedGoals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedGoals);
}

@override@JsonKey() final  int dailyCalorieTarget;
@override@JsonKey() final  int dailyProteinG;
@override@JsonKey() final  int dailyStepsGoal;
@override@JsonKey() final  double sleepTargetHours;

/// Create a copy of GoalsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalsStateCopyWith<_GoalsState> get copyWith => __$GoalsStateCopyWithImpl<_GoalsState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GoalsState'))
    ..add(DiagnosticsProperty('selectedGoals', selectedGoals))..add(DiagnosticsProperty('dailyCalorieTarget', dailyCalorieTarget))..add(DiagnosticsProperty('dailyProteinG', dailyProteinG))..add(DiagnosticsProperty('dailyStepsGoal', dailyStepsGoal))..add(DiagnosticsProperty('sleepTargetHours', sleepTargetHours));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalsState&&const DeepCollectionEquality().equals(other._selectedGoals, _selectedGoals)&&(identical(other.dailyCalorieTarget, dailyCalorieTarget) || other.dailyCalorieTarget == dailyCalorieTarget)&&(identical(other.dailyProteinG, dailyProteinG) || other.dailyProteinG == dailyProteinG)&&(identical(other.dailyStepsGoal, dailyStepsGoal) || other.dailyStepsGoal == dailyStepsGoal)&&(identical(other.sleepTargetHours, sleepTargetHours) || other.sleepTargetHours == sleepTargetHours));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_selectedGoals),dailyCalorieTarget,dailyProteinG,dailyStepsGoal,sleepTargetHours);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GoalsState(selectedGoals: $selectedGoals, dailyCalorieTarget: $dailyCalorieTarget, dailyProteinG: $dailyProteinG, dailyStepsGoal: $dailyStepsGoal, sleepTargetHours: $sleepTargetHours)';
}


}

/// @nodoc
abstract mixin class _$GoalsStateCopyWith<$Res> implements $GoalsStateCopyWith<$Res> {
  factory _$GoalsStateCopyWith(_GoalsState value, $Res Function(_GoalsState) _then) = __$GoalsStateCopyWithImpl;
@override @useResult
$Res call({
 Set<String> selectedGoals, int dailyCalorieTarget, int dailyProteinG, int dailyStepsGoal, double sleepTargetHours
});




}
/// @nodoc
class __$GoalsStateCopyWithImpl<$Res>
    implements _$GoalsStateCopyWith<$Res> {
  __$GoalsStateCopyWithImpl(this._self, this._then);

  final _GoalsState _self;
  final $Res Function(_GoalsState) _then;

/// Create a copy of GoalsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedGoals = null,Object? dailyCalorieTarget = null,Object? dailyProteinG = null,Object? dailyStepsGoal = null,Object? sleepTargetHours = null,}) {
  return _then(_GoalsState(
selectedGoals: null == selectedGoals ? _self._selectedGoals : selectedGoals // ignore: cast_nullable_to_non_nullable
as Set<String>,dailyCalorieTarget: null == dailyCalorieTarget ? _self.dailyCalorieTarget : dailyCalorieTarget // ignore: cast_nullable_to_non_nullable
as int,dailyProteinG: null == dailyProteinG ? _self.dailyProteinG : dailyProteinG // ignore: cast_nullable_to_non_nullable
as int,dailyStepsGoal: null == dailyStepsGoal ? _self.dailyStepsGoal : dailyStepsGoal // ignore: cast_nullable_to_non_nullable
as int,sleepTargetHours: null == sleepTargetHours ? _self.sleepTargetHours : sleepTargetHours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
