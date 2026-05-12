import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/database/app_database.dart';
import '../onboarding/onboarding_providers.dart';

class FoodSearchSheet extends ConsumerStatefulWidget {
  const FoodSearchSheet({super.key});

  @override
  ConsumerState<FoodSearchSheet> createState() => _FoodSearchSheetState();
}

class _FoodSearchSheetState extends ConsumerState<FoodSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedMealType = 'breakfast';

  final List<Map<String, dynamic>> _quickAddItems = [
    {'name': 'Oatmeal', 'kcal': 150.0, 'p': 5.0, 'c': 27.0, 'f': 3.0},
    {'name': 'Chicken Breast', 'kcal': 165.0, 'p': 31.0, 'c': 0.0, 'f': 3.6},
    {'name': 'Avocado', 'kcal': 160.0, 'p': 2.0, 'c': 8.5, 'f': 14.7},
    {'name': 'Greek Yogurt', 'kcal': 100.0, 'p': 10.0, 'c': 3.6, 'f': 5.0},
    {'name': 'Apple', 'kcal': 95.0, 'p': 0.5, 'c': 25.0, 'f': 0.3},
    {'name': 'Eggs (2)', 'kcal': 140.0, 'p': 12.0, 'c': 1.0, 'f': 10.0},
  ];

  Future<void> _addFood(Map<String, dynamic> item) async {
    final db = ref.read(appDatabaseProvider);
    final user = ref.read(authProvider).value;
    if (user == null) return;

    await db.into(db.foodLogs).insert(
          FoodLogsCompanion.insert(
            id: const Uuid().v4(),
            userId: user.$id,
            name: item['name'],
            calories: item['kcal'],
            protein: item['p'],
            carbs: item['c'],
            fat: item['f'],
            logDate: DateTime.now(),
            mealType: _selectedMealType,
          ),
        );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${item['name']} to $_selectedMealType')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColorsDark.surface0,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColorsDark.surface2, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search food or scan barcode...',
                      hintStyle: AppTypography.bodyMd(color: AppColorsDark.textMuted),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColorsDark.primary),
                      filled: true,
                      fillColor: AppColorsDark.surface1,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColorsDark.primary),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildMealTypeSelector(),
          
          const SizedBox(height: 20),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Text('Quick Add', style: AppTypography.h3()),
                const SizedBox(height: 12),
                ..._quickAddItems.map((item) => _buildQuickAddItem(item)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeSelector() {
    final types = ['breakfast', 'lunch', 'dinner', 'snacks'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: types.map((type) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ChoiceChip(
            label: Text(type.toUpperCase()),
            selected: _selectedMealType == type,
            onSelected: (selected) {
              if (selected) setState(() => _selectedMealType = type);
            },
            selectedColor: AppColorsDark.primary,
            backgroundColor: AppColorsDark.surface1,
            labelStyle: AppTypography.labelSm(color: _selectedMealType == type ? Colors.white : AppColorsDark.textSecondary),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildQuickAddItem(Map<String, dynamic> item) {
    return ListTile(
      onTap: () => _addFood(item),
      contentPadding: EdgeInsets.zero,
      title: Text(item['name'], style: AppTypography.bodyLg(color: Colors.white)),
      subtitle: Text('${item['kcal'].toInt()} kcal • P: ${item['p']}g C: ${item['c']}g F: ${item['f']}g', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
      trailing: const Icon(Icons.add_circle_outline, color: AppColorsDark.primary),
    );
  }
}
