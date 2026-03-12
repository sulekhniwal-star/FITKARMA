import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/widgets/section_header.dart';
import 'widgets/food_item_card.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Log Breakfast / नाश्ता लॉग करें'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search food, or tap the mic... / खाना खोजें',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic, color: AppColors.primary),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
                      onPressed: () {},
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
              ),
            ),
          ),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildActionPill(icon: Icons.camera_alt, label: 'Scan Label'),
                const SizedBox(width: 8),
                _buildActionPill(icon: Icons.restaurant, label: 'Upload Plate Photo'),
                const SizedBox(width: 8),
                _buildActionPill(icon: Icons.edit, label: 'Manual Entry'),
              ],
            ),
          ),
          
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SectionHeader(
                    englishTitle: 'Frequent Indian Portions',
                    hindiSubtitle: 'अक्सर खाया जाने वाला',
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final items = [
                          {'title': 'Roti', 'hi': 'रोटी', 'kcal': '120', 'portion': '1 piece'},
                          {'title': 'Dal Tadka', 'hi': 'दाल तड़का', 'kcal': '150', 'portion': '1 katori'},
                          {'title': 'Paneer Makhani', 'hi': 'पनीर मखनी', 'kcal': '350', 'portion': '1 katori'},
                          {'title': 'Rice', 'hi': 'चावल', 'kcal': '130', 'portion': '1 katori'},
                        ];
                        final item = items[index];
                        return FoodItemCard(
                          isGrid: true,
                          title: item['title']!,
                          hindiTitle: item['hi']!,
                          kalCount: item['kcal']!,
                          portion: item['portion']!,
                          onTap: () {},
                          onAdd: () {},
                        );
                      },
                      childCount: 4,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SectionHeader(
                    englishTitle: 'Recent Logs',
                    hindiSubtitle: 'हाल के लॉग',
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return FoodItemCard(
                        isGrid: false,
                        title: 'Boiled Egg',
                        hindiTitle: 'उबला हुआ अंडा',
                        kalCount: '78',
                        portion: '1 piece',
                        onTap: () {},
                        onAdd: () {},
                      );
                    },
                    childCount: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
