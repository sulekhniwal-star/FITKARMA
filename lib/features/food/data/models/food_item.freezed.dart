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
mixin _$ServingSize {

 String get label; double get weightG;
/// Create a copy of ServingSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServingSizeCopyWith<ServingSize> get copyWith => _$ServingSizeCopyWithImpl<ServingSize>(this as ServingSize, _$identity);

  /// Serializes this ServingSize to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServingSize&&(identical(other.label, label) || other.label == label)&&(identical(other.weightG, weightG) || other.weightG == weightG));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,weightG);

@override
String toString() {
  return 'ServingSize(label: $label, weightG: $weightG)';
}


}

/// @nodoc
abstract mixin class $ServingSizeCopyWith<$Res>  {
  factory $ServingSizeCopyWith(ServingSize value, $Res Function(ServingSize) _then) = _$ServingSizeCopyWithImpl;
@useResult
$Res call({
 String label, double weightG
});




}
/// @nodoc
class _$ServingSizeCopyWithImpl<$Res>
    implements $ServingSizeCopyWith<$Res> {
  _$ServingSizeCopyWithImpl(this._self, this._then);

  final ServingSize _self;
  final $Res Function(ServingSize) _then;

/// Create a copy of ServingSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? weightG = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,weightG: null == weightG ? _self.weightG : weightG // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ServingSize].
extension ServingSizePatterns on ServingSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServingSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServingSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServingSize value)  $default,){
final _that = this;
switch (_that) {
case _ServingSize():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServingSize value)?  $default,){
final _that = this;
switch (_that) {
case _ServingSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  double weightG)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServingSize() when $default != null:
return $default(_that.label,_that.weightG);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  double weightG)  $default,) {final _that = this;
switch (_that) {
case _ServingSize():
return $default(_that.label,_that.weightG);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  double weightG)?  $default,) {final _that = this;
switch (_that) {
case _ServingSize() when $default != null:
return $default(_that.label,_that.weightG);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServingSize extends ServingSize {
  const _ServingSize({required this.label, required this.weightG}): super._();
  factory _ServingSize.fromJson(Map<String, dynamic> json) => _$ServingSizeFromJson(json);

@override final  String label;
@override final  double weightG;

/// Create a copy of ServingSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServingSizeCopyWith<_ServingSize> get copyWith => __$ServingSizeCopyWithImpl<_ServingSize>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServingSizeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServingSize&&(identical(other.label, label) || other.label == label)&&(identical(other.weightG, weightG) || other.weightG == weightG));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,weightG);

@override
String toString() {
  return 'ServingSize(label: $label, weightG: $weightG)';
}


}

/// @nodoc
abstract mixin class _$ServingSizeCopyWith<$Res> implements $ServingSizeCopyWith<$Res> {
  factory _$ServingSizeCopyWith(_ServingSize value, $Res Function(_ServingSize) _then) = __$ServingSizeCopyWithImpl;
@override @useResult
$Res call({
 String label, double weightG
});




}
/// @nodoc
class __$ServingSizeCopyWithImpl<$Res>
    implements _$ServingSizeCopyWith<$Res> {
  __$ServingSizeCopyWithImpl(this._self, this._then);

  final _ServingSize _self;
  final $Res Function(_ServingSize) _then;

/// Create a copy of ServingSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? weightG = null,}) {
  return _then(_ServingSize(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,weightG: null == weightG ? _self.weightG : weightG // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$FoodItem {

 String get id; String get name; String? get nameHindi; String? get category; double get caloriesPer100g; double get proteinPer100g; double get carbsPer100g; double get fatPer100g; double get fiberPer100g; String get emoji; String get source; String? get barcode; List<ServingSize> get servingSizes;// Legacy fields preserved for backward compatibility
 int get priority; String? get group; bool get isBundled;
/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodItemCopyWith<FoodItem> get copyWith => _$FoodItemCopyWithImpl<FoodItem>(this as FoodItem, _$identity);

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.category, category) || other.category == category)&&(identical(other.caloriesPer100g, caloriesPer100g) || other.caloriesPer100g == caloriesPer100g)&&(identical(other.proteinPer100g, proteinPer100g) || other.proteinPer100g == proteinPer100g)&&(identical(other.carbsPer100g, carbsPer100g) || other.carbsPer100g == carbsPer100g)&&(identical(other.fatPer100g, fatPer100g) || other.fatPer100g == fatPer100g)&&(identical(other.fiberPer100g, fiberPer100g) || other.fiberPer100g == fiberPer100g)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.source, source) || other.source == source)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&const DeepCollectionEquality().equals(other.servingSizes, servingSizes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.group, group) || other.group == group)&&(identical(other.isBundled, isBundled) || other.isBundled == isBundled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameHindi,category,caloriesPer100g,proteinPer100g,carbsPer100g,fatPer100g,fiberPer100g,emoji,source,barcode,const DeepCollectionEquality().hash(servingSizes),priority,group,isBundled);

@override
String toString() {
  return 'FoodItem(id: $id, name: $name, nameHindi: $nameHindi, category: $category, caloriesPer100g: $caloriesPer100g, proteinPer100g: $proteinPer100g, carbsPer100g: $carbsPer100g, fatPer100g: $fatPer100g, fiberPer100g: $fiberPer100g, emoji: $emoji, source: $source, barcode: $barcode, servingSizes: $servingSizes, priority: $priority, group: $group, isBundled: $isBundled)';
}


}

/// @nodoc
abstract mixin class $FoodItemCopyWith<$Res>  {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) _then) = _$FoodItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? nameHindi, String? category, double caloriesPer100g, double proteinPer100g, double carbsPer100g, double fatPer100g, double fiberPer100g, String emoji, String source, String? barcode, List<ServingSize> servingSizes, int priority, String? group, bool isBundled
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameHindi = freezed,Object? category = freezed,Object? caloriesPer100g = null,Object? proteinPer100g = null,Object? carbsPer100g = null,Object? fatPer100g = null,Object? fiberPer100g = null,Object? emoji = null,Object? source = null,Object? barcode = freezed,Object? servingSizes = null,Object? priority = null,Object? group = freezed,Object? isBundled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,caloriesPer100g: null == caloriesPer100g ? _self.caloriesPer100g : caloriesPer100g // ignore: cast_nullable_to_non_nullable
as double,proteinPer100g: null == proteinPer100g ? _self.proteinPer100g : proteinPer100g // ignore: cast_nullable_to_non_nullable
as double,carbsPer100g: null == carbsPer100g ? _self.carbsPer100g : carbsPer100g // ignore: cast_nullable_to_non_nullable
as double,fatPer100g: null == fatPer100g ? _self.fatPer100g : fatPer100g // ignore: cast_nullable_to_non_nullable
as double,fiberPer100g: null == fiberPer100g ? _self.fiberPer100g : fiberPer100g // ignore: cast_nullable_to_non_nullable
as double,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,servingSizes: null == servingSizes ? _self.servingSizes : servingSizes // ignore: cast_nullable_to_non_nullable
as List<ServingSize>,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? nameHindi,  String? category,  double caloriesPer100g,  double proteinPer100g,  double carbsPer100g,  double fatPer100g,  double fiberPer100g,  String emoji,  String source,  String? barcode,  List<ServingSize> servingSizes,  int priority,  String? group,  bool isBundled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.name,_that.nameHindi,_that.category,_that.caloriesPer100g,_that.proteinPer100g,_that.carbsPer100g,_that.fatPer100g,_that.fiberPer100g,_that.emoji,_that.source,_that.barcode,_that.servingSizes,_that.priority,_that.group,_that.isBundled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? nameHindi,  String? category,  double caloriesPer100g,  double proteinPer100g,  double carbsPer100g,  double fatPer100g,  double fiberPer100g,  String emoji,  String source,  String? barcode,  List<ServingSize> servingSizes,  int priority,  String? group,  bool isBundled)  $default,) {final _that = this;
switch (_that) {
case _FoodItem():
return $default(_that.id,_that.name,_that.nameHindi,_that.category,_that.caloriesPer100g,_that.proteinPer100g,_that.carbsPer100g,_that.fatPer100g,_that.fiberPer100g,_that.emoji,_that.source,_that.barcode,_that.servingSizes,_that.priority,_that.group,_that.isBundled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? nameHindi,  String? category,  double caloriesPer100g,  double proteinPer100g,  double carbsPer100g,  double fatPer100g,  double fiberPer100g,  String emoji,  String source,  String? barcode,  List<ServingSize> servingSizes,  int priority,  String? group,  bool isBundled)?  $default,) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.name,_that.nameHindi,_that.category,_that.caloriesPer100g,_that.proteinPer100g,_that.carbsPer100g,_that.fatPer100g,_that.fiberPer100g,_that.emoji,_that.source,_that.barcode,_that.servingSizes,_that.priority,_that.group,_that.isBundled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodItem extends FoodItem {
  const _FoodItem({required this.id, required this.name, this.nameHindi, this.category, required this.caloriesPer100g, this.proteinPer100g = 0.0, this.carbsPer100g = 0.0, this.fatPer100g = 0.0, this.fiberPer100g = 0.0, this.emoji = '🍛', this.source = 'unknown', this.barcode, final  List<ServingSize> servingSizes = const [], this.priority = 99, this.group, this.isBundled = true}): _servingSizes = servingSizes,super._();
  factory _FoodItem.fromJson(Map<String, dynamic> json) => _$FoodItemFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? nameHindi;
@override final  String? category;
@override final  double caloriesPer100g;
@override@JsonKey() final  double proteinPer100g;
@override@JsonKey() final  double carbsPer100g;
@override@JsonKey() final  double fatPer100g;
@override@JsonKey() final  double fiberPer100g;
@override@JsonKey() final  String emoji;
@override@JsonKey() final  String source;
@override final  String? barcode;
 final  List<ServingSize> _servingSizes;
@override@JsonKey() List<ServingSize> get servingSizes {
  if (_servingSizes is EqualUnmodifiableListView) return _servingSizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servingSizes);
}

// Legacy fields preserved for backward compatibility
@override@JsonKey() final  int priority;
@override final  String? group;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.category, category) || other.category == category)&&(identical(other.caloriesPer100g, caloriesPer100g) || other.caloriesPer100g == caloriesPer100g)&&(identical(other.proteinPer100g, proteinPer100g) || other.proteinPer100g == proteinPer100g)&&(identical(other.carbsPer100g, carbsPer100g) || other.carbsPer100g == carbsPer100g)&&(identical(other.fatPer100g, fatPer100g) || other.fatPer100g == fatPer100g)&&(identical(other.fiberPer100g, fiberPer100g) || other.fiberPer100g == fiberPer100g)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.source, source) || other.source == source)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&const DeepCollectionEquality().equals(other._servingSizes, _servingSizes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.group, group) || other.group == group)&&(identical(other.isBundled, isBundled) || other.isBundled == isBundled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameHindi,category,caloriesPer100g,proteinPer100g,carbsPer100g,fatPer100g,fiberPer100g,emoji,source,barcode,const DeepCollectionEquality().hash(_servingSizes),priority,group,isBundled);

@override
String toString() {
  return 'FoodItem(id: $id, name: $name, nameHindi: $nameHindi, category: $category, caloriesPer100g: $caloriesPer100g, proteinPer100g: $proteinPer100g, carbsPer100g: $carbsPer100g, fatPer100g: $fatPer100g, fiberPer100g: $fiberPer100g, emoji: $emoji, source: $source, barcode: $barcode, servingSizes: $servingSizes, priority: $priority, group: $group, isBundled: $isBundled)';
}


}

/// @nodoc
abstract mixin class _$FoodItemCopyWith<$Res> implements $FoodItemCopyWith<$Res> {
  factory _$FoodItemCopyWith(_FoodItem value, $Res Function(_FoodItem) _then) = __$FoodItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? nameHindi, String? category, double caloriesPer100g, double proteinPer100g, double carbsPer100g, double fatPer100g, double fiberPer100g, String emoji, String source, String? barcode, List<ServingSize> servingSizes, int priority, String? group, bool isBundled
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameHindi = freezed,Object? category = freezed,Object? caloriesPer100g = null,Object? proteinPer100g = null,Object? carbsPer100g = null,Object? fatPer100g = null,Object? fiberPer100g = null,Object? emoji = null,Object? source = null,Object? barcode = freezed,Object? servingSizes = null,Object? priority = null,Object? group = freezed,Object? isBundled = null,}) {
  return _then(_FoodItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,caloriesPer100g: null == caloriesPer100g ? _self.caloriesPer100g : caloriesPer100g // ignore: cast_nullable_to_non_nullable
as double,proteinPer100g: null == proteinPer100g ? _self.proteinPer100g : proteinPer100g // ignore: cast_nullable_to_non_nullable
as double,carbsPer100g: null == carbsPer100g ? _self.carbsPer100g : carbsPer100g // ignore: cast_nullable_to_non_nullable
as double,fatPer100g: null == fatPer100g ? _self.fatPer100g : fatPer100g // ignore: cast_nullable_to_non_nullable
as double,fiberPer100g: null == fiberPer100g ? _self.fiberPer100g : fiberPer100g // ignore: cast_nullable_to_non_nullable
as double,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,servingSizes: null == servingSizes ? _self._servingSizes : servingSizes // ignore: cast_nullable_to_non_nullable
as List<ServingSize>,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,isBundled: null == isBundled ? _self.isBundled : isBundled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
