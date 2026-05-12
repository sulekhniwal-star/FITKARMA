// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => _FoodItem(
  id: json['id'] as String,
  name: json['name'] as String,
  source: json['source'] as String,
  priority: (json['priority'] as num).toInt(),
  caloriesPer100g: (json['caloriesPer100g'] as num).toDouble(),
  group: json['group'] as String?,
  category: json['category'] as String?,
  barcode: json['barcode'] as String?,
  isBundled: json['isBundled'] as bool? ?? true,
);

Map<String, dynamic> _$FoodItemToJson(_FoodItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'source': instance.source,
  'priority': instance.priority,
  'caloriesPer100g': instance.caloriesPer100g,
  'group': instance.group,
  'category': instance.category,
  'barcode': instance.barcode,
  'isBundled': instance.isBundled,
};
