// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodItem {

 String get id; String get name; String get source; int get priority; double get caloriesPer100g; String? get group; String? get category; String? get barcode; bool get isBundled;
/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodItemCopyWith<FoodItem> get copyWith => _$FoodItemCopyWithImpl<FoodItem>(this as FoodItem, _$identity);

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.caloriesPer100g, caloriesPer100g) || other.caloriesPer100g == caloriesPer100g)&&(identical(other.group, group) || other.group == group)&&(identical(other.category, category) || other.category == category)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.isBundled, isBundled) || other.isBundled == isBundled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,source,priority,caloriesPer100g,group,category,barcode,isBundled);

@override
String toString() {
  return 'FoodItem(id: $id, name: $name, source: $source, priority: $priority, caloriesPer100g: $caloriesPer100g, group: $group, category: $category, barcode: $barcode, isBundled: $isBundled)';
}


}

/// @nodoc
abstract mixin class $FoodItemCopyWith<$Res>  {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) _then) = _$FoodItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, String source, int priority, double caloriesPer100g, String? group, String? category, String? barcode, bool isBundled
});




}
/// @nodoc
class _$FoodItemCopyWithImpl<$Res>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._self, this._then);

  final FoodItem _self;
  final $Res Function(FoodItem) _then;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? source = null,Object? priority = null,Object? caloriesPer100g = null,Object? group = freezed,Object? category = freezed,Object? barcode = freezed,Object? isBundled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,caloriesPer100g: null == caloriesPer100g ? _self.caloriesPer100g : caloriesPer100g // ignore: cast_nullable_to_non_nullable
as double,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,isBundled: null == isBundled ? _self.isBundled : isBundled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodItem].
extension FoodItemPatterns on FoodItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodItem value)  $default,){
final _that = this;
switch (_that) {
case _FoodItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodItem value)?  $default,){
final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String source,  int priority,  double caloriesPer100g,  String? group,  String? category,  String? barcode,  bool isBundled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.name,_that.source,_that.priority,_that.caloriesPer100g,_that.group,_that.category,_that.barcode,_that.isBundled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String source,  int priority,  double caloriesPer100g,  String? group,  String? category,  String? barcode,  bool isBundled)  $default,) {final _that = this;
switch (_that) {
case _FoodItem():
return $default(_that.id,_that.name,_that.source,_that.priority,_that.caloriesPer100g,_that.group,_that.category,_that.barcode,_that.isBundled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String source,  int priority,  double caloriesPer100g,  String? group,  String? category,  String? barcode,  bool isBundled)?  $default,) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.name,_that.source,_that.priority,_that.caloriesPer100g,_that.group,_that.category,_that.barcode,_that.isBundled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodItem implements FoodItem {
  const _FoodItem({required this.id, required this.name, required this.source, required this.priority, required this.caloriesPer100g, this.group, this.category, this.barcode, this.isBundled = true});
  factory _FoodItem.fromJson(Map<String, dynamic> json) => _$FoodItemFromJson(json);

@override final  String id;
@override final  String name;
@override final  String source;
@override final  int priority;
@override final  double caloriesPer100g;
@override final  String? group;
@override final  String? category;
@override final  String? barcode;
@override@JsonKey() final  bool isBundled;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodItemCopyWith<_FoodItem> get copyWith => __$FoodItemCopyWithImpl<_FoodItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.caloriesPer100g, caloriesPer100g) || other.caloriesPer100g == caloriesPer100g)&&(identical(other.group, group) || other.group == group)&&(identical(other.category, category) || other.category == category)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.isBundled, isBundled) || other.isBundled == isBundled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,source,priority,caloriesPer100g,group,category,barcode,isBundled);

@override
String toString() {
  return 'FoodItem(id: $id, name: $name, source: $source, priority: $priority, caloriesPer100g: $caloriesPer100g, group: $group, category: $category, barcode: $barcode, isBundled: $isBundled)';
}


}

/// @nodoc
abstract mixin class _$FoodItemCopyWith<$Res> implements $FoodItemCopyWith<$Res> {
  factory _$FoodItemCopyWith(_FoodItem value, $Res Function(_FoodItem) _then) = __$FoodItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String source, int priority, double caloriesPer100g, String? group, String? category, String? barcode, bool isBundled
});




}
/// @nodoc
class __$FoodItemCopyWithImpl<$Res>
    implements _$FoodItemCopyWith<$Res> {
  __$FoodItemCopyWithImpl(this._self, this._then);

  final _FoodItem _self;
  final $Res Function(_FoodItem) _then;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? source = null,Object? priority = null,Object? caloriesPer100g = null,Object? group = freezed,Object? category = freezed,Object? barcode = freezed,Object? isBundled = null,}) {
  return _then(_FoodItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,caloriesPer100g: null == caloriesPer100g ? _self.caloriesPer100g : caloriesPer100g // ignore: cast_nullable_to_non_nullable
as double,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,isBundled: null == isBundled ? _self.isBundled : isBundled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
