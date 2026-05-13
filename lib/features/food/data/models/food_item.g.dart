// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServingSize _$ServingSizeFromJson(Map<String, dynamic> json) => _ServingSize(
  label: json['label'] as String,
  weightG: (json['weightG'] as num).toDouble(),
);

Map<String, dynamic> _$ServingSizeToJson(_ServingSize instance) =>
    <String, dynamic>{'label': instance.label, 'weightG': instance.weightG};

_FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => _FoodItem(
  id: json['id'] as String,
  name: json['name'] as String,
  nameHindi: json['nameHindi'] as String?,
  category: json['category'] as String?,
  caloriesPer100g: (json['caloriesPer100g'] as num).toDouble(),
  proteinPer100g: (json['proteinPer100g'] as num?)?.toDouble() ?? 0.0,
  carbsPer100g: (json['carbsPer100g'] as num?)?.toDouble() ?? 0.0,
  fatPer100g: (json['fatPer100g'] as num?)?.toDouble() ?? 0.0,
  fiberPer100g: (json['fiberPer100g'] as num?)?.toDouble() ?? 0.0,
  emoji: json['emoji'] as String? ?? '🍛',
  source: json['source'] as String? ?? 'unknown',
  barcode: json['barcode'] as String?,
  servingSizes:
      (json['servingSizes'] as List<dynamic>?)
          ?.map((e) => ServingSize.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  priority: (json['priority'] as num?)?.toInt() ?? 99,
  group: json['group'] as String?,
  isBundled: json['isBundled'] as bool? ?? true,
);

Map<String, dynamic> _$FoodItemToJson(_FoodItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'nameHindi': instance.nameHindi,
  'category': instance.category,
  'caloriesPer100g': instance.caloriesPer100g,
  'proteinPer100g': instance.proteinPer100g,
  'carbsPer100g': instance.carbsPer100g,
  'fatPer100g': instance.fatPer100g,
  'fiberPer100g': instance.fiberPer100g,
  'emoji': instance.emoji,
  'source': instance.source,
  'barcode': instance.barcode,
  'servingSizes': instance.servingSizes,
  'priority': instance.priority,
  'group': instance.group,
  'isBundled': instance.isBundled,
};
