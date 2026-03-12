import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../data/repositories/food_repository.dart';
import '../domain/models/food_item.dart';
import 'widgets/food_item_card.dart';
import 'widgets/portion_picker.dart';

class FoodLoggingScreen extends ConsumerStatefulWidget {
  const FoodLoggingScreen({super.key});

  @override
  ConsumerState<FoodLoggingScreen> createState() => _FoodLoggingScreenState();
}

class _FoodLoggingScreenState extends ConsumerState<FoodLoggingScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  final _picker = ImagePicker();

  Future<void> _handleImageAction(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing image... (Mocked Vision API)')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodRepo = ref.watch(foodRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const BilingualLabel(
          english: 'Log Food',
          hindi: 'भोजन दर्ज करें',
          englishSize: 18,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _query = val),
              decoration: InputDecoration(
                hintText: 'Search food / भोजन खोजें',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryOrange),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.mic_none), onPressed: () {}),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () => _handleImageAction(ImageSource.camera),
                    ),
                  ],
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Action Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ActionChip(
                  avatar: const Icon(Icons.qr_code_scanner, size: 16),
                  label: const Text('Scan Label / लेबल स्कैन'),
                  onPressed: () => _handleImageAction(ImageSource.camera),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.borderGrey),
                ),
                const SizedBox(width: 8),
                ActionChip(
                  avatar: const Icon(Icons.photo_library_outlined, size: 16),
                  label: const Text('Upload Photo / फोटो अपलोड'),
                  onPressed: () => _handleImageAction(ImageSource.gallery),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.borderGrey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: foodRepo.when(
              data: (_) {
                return FutureBuilder<List<FoodItem>>(
                  future: ref.read(foodRepositoryProvider.notifier).searchFood(_query),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final items = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final food = items[index];
                        return FoodItemCard(
                          food: food,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => PortionPicker(
                                food: food,
                                onConfirm: (amount, unit, calories) async {
                                  await ref.read(foodRepositoryProvider.notifier).logMeal(
                                    foodId: food.id,
                                    mealType: 'Lunch', // Mocked currently
                                    amount: amount,
                                    unit: unit,
                                    totalCalories: calories,
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Meal logged successfully!')),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
