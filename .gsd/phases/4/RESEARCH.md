# Phase 4 Research: Food Tracking & Indian Database

## Food Models
- **FoodItem**: 
  - Fields: `id`, `nameEn`, `nameHi`, `caloriesPer100g`, `protein`, `carbs`, `fat`, `imageUrl`.
  - Stored in a read-only "Global Food" Hive box.
- **MealLog**:
  - Fields: `id`, `foodId`, `mealType` (Breakfast/Lunch...), `portionAmount`, `portionUnit` (Katori, Piece, Grams), `timestamp`, `isSynced`.

## Portion Units (ADR-09)
Need a map for calorie multipliers:
- 1 Katori (Medium) â‰ˆ 150ml
- 1 Piece (Roti) â‰ˆ 30-40g
- 1 Ladle (Palla) â‰ˆ 50ml

## Seed Data List
1.  Dal Tadka (दाल तड़का) - 150 kcal/katori
2.  Paneer Butter Masala (पनीर बटर मसाला) - 250 kcal/katori
3.  Whole Wheat Roti (रोटी) - 70 kcal/piece
4.  Masala Dosa (मसाला डोसा) - 200 kcal/piece
5.  Idli (इडली) - 50 kcal/piece
6.  Chana Masala (चना मसाला) - 180 kcal/katori
7.  Curd (दही) - 60 kcal/katori

## Image Picking (ADR-08)
- Dependency: `image_picker`.
- Setup for Android (Permissions in Manifest).
- Logic: `_picker.pickImage(source: ImageSource.camera)` for the "Scan Label" chip.

## Premium Imagery (ADR-10)
- Use standard high-quality food URLs or a local asset map for the seed items.
