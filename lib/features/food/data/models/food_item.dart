class FoodItem {
  final String id;
  final String name;
  final String source;
  final int priority;
  final double caloriesPer100g;
  final String? group;
  final String? category;
  final String? barcode;
  final bool isBundled;

  FoodItem({
    required this.id,
    required this.name,
    required this.source,
    required this.priority,
    required this.caloriesPer100g,
    this.group,
    this.category,
    this.barcode,
    this.isBundled = true,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? 'unknown',
      name: json['name'] ?? 'Unknown',
      source: json['source'] ?? 'unknown',
      priority: json['priority'] ?? 99,
      caloriesPer100g: (json['caloriesPer100g'] ?? 0).toDouble(),
      group: json['group'],
      category: json['category'],
      barcode: json['barcode'],
      isBundled: json['bundled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'priority': priority,
      'caloriesPer100g': caloriesPer100g,
      'group': group,
      'category': category,
      'barcode': barcode,
      'bundled': isBundled,
    };
  }
}