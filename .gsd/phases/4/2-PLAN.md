---
phase: 4
plan: 2
wave: 1
---

# Plan 4.2: Food Search UI & Functional Scanning

## Objective
Build the high-fidelity food logging interface with functional camera/gallery integration and bilingual search.

## Context
- lib/features/food/presentation/food_logging_screen.dart
- lib/features/food/presentation/widgets/portion_picker.dart

## Tasks

<task type="auto">
  <name>Implement Food Logging Screen</name>
  <files>lib/features/food/presentation/food_logging_screen.dart</files>
  <action>
    - Build search bar with "Search food / भोजन खोजें" bilingual hint.
    - Add Microphone and Camera icons inside search bar.
    - Implement the "Scan Label" and "Upload Photo" Chips using `image_picker`.
  </action>
  <verify>Visual check: Tapping chips opens camera/gallery.</verify>
  <done>Food logging screen matches reference image precisely.</done>
</task>

<task type="auto">
  <name>Build FoodItemCard & Portion Picker</name>
  <files>
    - lib/features/food/presentation/widgets/food_item_card.dart
    - lib/features/food/presentation/widgets/portion_picker.dart
  </files>
  <action>
    - Create `FoodItemCard` with image, English/Hindi name, and calorie summary.
    - Create `PortionPicker` dialog with units: Katori, Piece, Ladle, Grams.
  </action>
  <verify>Visual check of dialog and card styling.</verify>
  <done>Users can select Indian portions for logged food.</done>
</task>

## Success Criteria
- [ ] UI matches the high-fidelity reference image (Section 2 of doc).
- [ ] Search filtering works against the local seed database.
- [ ] Image picking returns a (mocked) successful feedback snackbar for "Scanning".
