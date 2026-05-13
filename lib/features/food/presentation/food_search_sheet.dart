import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/database/app_database.dart';
import '../../onboarding/onboarding_providers.dart';
import '../data/food_database_service.dart';
import '../../karma/karma_service.dart';
import '../../streak/streak_providers.dart';

class FoodSearchSheet extends ConsumerStatefulWidget {
  final String? initialMealType;
  const FoodSearchSheet({super.key, this.initialMealType});

  @override
  ConsumerState<FoodSearchSheet> createState() => _FoodSearchSheetState();
}

class _FoodSearchSheetState extends ConsumerState<FoodSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedMealType;
  Timer? _debounce;
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  final List<Map<String, dynamic>> _quickAddItems = [
    {'name': 'Oatmeal', 'kcal': 150.0, 'p': 5.0, 'c': 27.0, 'f': 3.0},
    {'name': 'Chicken Breast', 'kcal': 165.0, 'p': 31.0, 'c': 0.0, 'f': 3.6},
    {'name': 'Avocado', 'kcal': 160.0, 'p': 2.0, 'c': 8.5, 'f': 14.7},
    {'name': 'Greek Yogurt', 'kcal': 100.0, 'p': 10.0, 'c': 3.6, 'f': 5.0},
    {'name': 'Apple', 'kcal': 95.0, 'p': 0.5, 'c': 25.0, 'f': 0.3},
    {'name': 'Eggs (2)', 'kcal': 140.0, 'p': 12.0, 'c': 1.0, 'f': 10.0},
  ];

  @override
  void initState() {
    super.initState();
    _selectedMealType = widget.initialMealType ?? 'breakfast';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (query.trim().length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final service = ref.read(foodDatabaseServiceProvider.notifier);
      final results = await service.searchByName(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  void _openBarcodeScanner() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColorsDark.surface0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: 300,
            height: 400,
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: (capture) async {
                    final barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                      final code = barcodes.first.rawValue!;
                      Navigator.pop(context);
                      _performBarcodeLookup(code);
                    }
                  },
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Align barcode within frame',
                      style: AppTypography.labelMd(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performBarcodeLookup(String barcode) async {
    setState(() => _isSearching = true);
    final service = ref.read(foodDatabaseServiceProvider.notifier);
    final res = await service.searchByBarcode(barcode);
    if (mounted) {
      setState(() => _isSearching = false);
      if (res != null) {
        _showPortionSelector(res);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found. Please add manually.')),
        );
      }
    }
  }

  void _showPortionSelector(Map<String, dynamic> item) {
    double portionQty = 1.0;
    final double kcalBase = (item['caloriesPer100g'] as num? ?? item['kcal'] as num? ?? 0.0).toDouble();
    final double pBase = (item['proteinPer100g'] as num? ?? item['p'] as num? ?? 0.0).toDouble();
    final double cBase = (item['carbsPer100g'] as num? ?? item['c'] as num? ?? 0.0).toDouble();
    final double fBase = (item['fatPer100g'] as num? ?? item['f'] as num? ?? 0.0).toDouble();
    final String emoji = item['emoji']?.toString() ?? '🍛';
    final String name = item['name']?.toString() ?? 'Unknown';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColorsDark.surface0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final double currentKcal = kcalBase * portionQty;
            final double currentP = pBase * portionQty;
            final double currentC = cBase * portionQty;
            final double currentF = fBase * portionQty;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: AppTypography.h2()),
                            Text('${kcalBase.toInt()} kcal per 100g/serving', style: AppTypography.labelMd(color: AppColorsDark.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Portion Multiplier', style: AppTypography.bodyLg(color: Colors.white)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: portionQty > 0.25 ? () => setModalState(() => portionQty -= 0.25) : null,
                            icon: const Icon(Icons.remove_circle_outline, color: AppColorsDark.primary),
                          ),
                          Text('${portionQty.toStringAsFixed(2)}x', style: AppTypography.h3(color: Colors.white)),
                          IconButton(
                            onPressed: () => setModalState(() => portionQty += 0.25),
                            icon: const Icon(Icons.add_circle_outline, color: AppColorsDark.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColorsDark.surface1, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MacroBadge(label: 'KCAL', value: '${currentKcal.toInt()}'),
                        _MacroBadge(label: 'PRO', value: '${currentP.toInt()}g'),
                        _MacroBadge(label: 'CARBS', value: '${currentC.toInt()}g'),
                        _MacroBadge(label: 'FAT', value: '${currentF.toInt()}g'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsDark.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _logFoodFinal({
                          'name': name,
                          'kcal': currentKcal,
                          'p': currentP,
                          'c': currentC,
                          'f': currentF,
                        });
                      },
                      child: Text('Log Food', style: AppTypography.h3(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showManualEntrySheet() {
    final nameCtrl = TextEditingController(text: _searchController.text);
    final kcalCtrl = TextEditingController();
    final pCtrl = TextEditingController();
    final cCtrl = TextEditingController();
    final fCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColorsDark.surface0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Custom Food', style: AppTypography.h2()),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  labelStyle: AppTypography.labelMd(color: AppColorsDark.textMuted),
                  filled: true,
                  fillColor: AppColorsDark.surface1,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: kcalCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Calories (kcal)',
                        labelStyle: AppTypography.labelMd(color: AppColorsDark.textMuted),
                        filled: true,
                        fillColor: AppColorsDark.surface1,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: pCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Protein (g)',
                        labelStyle: AppTypography.labelMd(color: AppColorsDark.textMuted),
                        filled: true,
                        fillColor: AppColorsDark.surface1,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Carbs (g)',
                        labelStyle: AppTypography.labelMd(color: AppColorsDark.textMuted),
                        filled: true,
                        fillColor: AppColorsDark.surface1,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: fCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Fat (g)',
                        labelStyle: AppTypography.labelMd(color: AppColorsDark.textMuted),
                        filled: true,
                        fillColor: AppColorsDark.surface1,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsDark.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;
                    final kcal = double.tryParse(kcalCtrl.text) ?? 0.0;
                    final p = double.tryParse(pCtrl.text) ?? 0.0;
                    final c = double.tryParse(cCtrl.text) ?? 0.0;
                    final f = double.tryParse(fCtrl.text) ?? 0.0;

                    Navigator.pop(context);
                    _logFoodFinal({
                      'name': name,
                      'kcal': kcal,
                      'p': p,
                      'c': c,
                      'f': f,
                    });
                  },
                  child: Text('Add & Log', style: AppTypography.h3(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logFoodFinal(Map<String, dynamic> item) async {
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

    await ref.read(karmaServiceProvider).awardXP('food_log');
    await ref.read(streakStateProvider.notifier).logActivity();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged ${item['name']}! +5 XP ⚡'),
          backgroundColor: AppColorsDark.surface1,
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
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
                        onChanged: _onSearchChanged,
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
                      onPressed: _openBarcodeScanner,
                      icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColorsDark.primary),
                    ),
                  ],
                ),
              ),
              
              if (_isSearching)
                const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: LinearProgressIndicator(color: AppColorsDark.primary, backgroundColor: AppColorsDark.surface1),
                )
              else
                const SizedBox(height: 16),
              
              _buildMealTypeSelector(),
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    if (_searchResults.isNotEmpty) ...[
                      Text('Search Results', style: AppTypography.h3()),
                      const SizedBox(height: 12),
                      ..._searchResults.map((item) => _FoodResultTile(
                            emoji: item['emoji']?.toString() ?? '🍛',
                            name: item['name']?.toString() ?? 'Unknown',
                            kcal: (item['caloriesPer100g'] as num? ?? item['kcal'] as num? ?? 0.0).toDouble(),
                            onTap: () => _showPortionSelector(item),
                          )),
                    ] else if (_searchController.text.trim().length >= 2 && !_isSearching) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text('No matching foods found', style: AppTypography.bodyMd(color: AppColorsDark.textMuted)),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: _showManualEntrySheet,
                                icon: const Icon(Icons.add, color: AppColorsDark.primary),
                                label: Text('Add manually', style: AppTypography.h4(color: AppColorsDark.primary)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Text('Quick Add', style: AppTypography.h3()),
                      const SizedBox(height: 12),
                      ..._quickAddItems.map((item) => _FoodResultTile(
                            emoji: '🍛',
                            name: item['name'],
                            kcal: item['kcal'],
                            onTap: () => _showPortionSelector({
                              ...item,
                              'caloriesPer100g': item['kcal'],
                              'proteinPer100g': item['p'],
                              'carbsPer100g': item['c'],
                              'fatPer100g': item['f'],
                            }),
                          )),
                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: _showManualEntrySheet,
                          child: Text('Add custom food manually', style: AppTypography.labelMd(color: AppColorsDark.primary)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FoodResultTile extends StatelessWidget {
  final String emoji;
  final String name;
  final double kcal;
  final VoidCallback onTap;

  const _FoodResultTile({
    required this.emoji,
    required this.name,
    required this.kcal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: AppColorsDark.surface1, borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
      ),
      title: Text(name, style: AppTypography.bodyLg(color: Colors.white)),
      subtitle: Text('${kcal.toInt()} kcal / 100g', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
      trailing: const Icon(Icons.add_circle_outline, color: AppColorsDark.primary),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String label;
  final String value;

  const _MacroBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.h3(color: Colors.white)),
      ],
    );
  }
}
