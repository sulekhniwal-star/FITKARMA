// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'correlation_engine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthInsight {

 String get id; String get title; String get description; String get category;// sleep_bp, hydration_steps, glucose, bp_anomaly, step_deficit
 double get confidence;// 0.0 to 1.0 confidence score
 bool get isActionable;
/// Create a copy of HealthInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthInsightCopyWith<HealthInsight> get copyWith => _$HealthInsightCopyWithImpl<HealthInsight>(this as HealthInsight, _$identity);

  /// Serializes this HealthInsight to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthInsight&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.isActionable, isActionable) || other.isActionable == isActionable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,confidence,isActionable);

@override
String toString() {
  return 'HealthInsight(id: $id, title: $title, description: $description, category: $category, confidence: $confidence, isActionable: $isActionable)';
}


}

/// @nodoc
abstract mixin class $HealthInsightCopyWith<$Res>  {
  factory $HealthInsightCopyWith(HealthInsight value, $Res Function(HealthInsight) _then) = _$HealthInsightCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String category, double confidence, bool isActionable
});




}
/// @nodoc
class _$HealthInsightCopyWithImpl<$Res>
    implements $HealthInsightCopyWith<$Res> {
  _$HealthInsightCopyWithImpl(this._self, this._then);

  final HealthInsight _self;
  final $Res Function(HealthInsight) _then;

/// Create a copy of HealthInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = null,Object? confidence = null,Object? isActionable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,isActionable: null == isActionable ? _self.isActionable : isActionable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthInsight].
extension HealthInsightPatterns on HealthInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthInsight value)  $default,){
final _that = this;
switch (_that) {
case _HealthInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthInsight value)?  $default,){
final _that = this;
switch (_that) {
case _HealthInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String category,  double confidence,  bool isActionable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthInsight() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.confidence,_that.isActionable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String category,  double confidence,  bool isActionable)  $default,) {final _that = this;
switch (_that) {
case _HealthInsight():
return $default(_that.id,_that.title,_that.description,_that.category,_that.confidence,_that.isActionable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String category,  double confidence,  bool isActionable)?  $default,) {final _that = this;
switch (_that) {
case _HealthInsight() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.confidence,_that.isActionable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthInsight implements HealthInsight {
  const _HealthInsight({required this.id, required this.title, required this.description, required this.category, required this.confidence, required this.isActionable});
  factory _HealthInsight.fromJson(Map<String, dynamic> json) => _$HealthInsightFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String category;
// sleep_bp, hydration_steps, glucose, bp_anomaly, step_deficit
@override final  double confidence;
// 0.0 to 1.0 confidence score
@override final  bool isActionable;

/// Create a copy of HealthInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthInsightCopyWith<_HealthInsight> get copyWith => __$HealthInsightCopyWithImpl<_HealthInsight>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthInsightToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthInsight&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.isActionable, isActionable) || other.isActionable == isActionable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,confidence,isActionable);

@override
String toString() {
  return 'HealthInsight(id: $id, title: $title, description: $description, category: $category, confidence: $confidence, isActionable: $isActionable)';
}


}

/// @nodoc
abstract mixin class _$HealthInsightCopyWith<$Res> implements $HealthInsightCopyWith<$Res> {
  factory _$HealthInsightCopyWith(_HealthInsight value, $Res Function(_HealthInsight) _then) = __$HealthInsightCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String category, double confidence, bool isActionable
});




}
/// @nodoc
class __$HealthInsightCopyWithImpl<$Res>
    implements _$HealthInsightCopyWith<$Res> {
  __$HealthInsightCopyWithImpl(this._self, this._then);

  final _HealthInsight _self;
  final $Res Function(_HealthInsight) _then;

/// Create a copy of HealthInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = null,Object? confidence = null,Object? isActionable = null,}) {
  return _then(_HealthInsight(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,isActionable: null == isActionable ? _self.isActionable : isActionable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
