---
phase: 4
plan: 1
wave: 1
---

# Plan 4.1: Food Models & Seed Data

## Objective
Define the data structures for food tracking and pre-populate the local database with common Indian staples.

## Context
- lib/features/food/domain/models/food_item.dart
- lib/features/food/domain/models/meal_log.dart
- lib/core/storage/hive_service.dart

## Tasks

<task type="auto">
  <name>Create Food Models</name>
  <files>
    - lib/features/food/domain/models/food_item.dart
    - lib/features/food/domain/models/meal_log.dart
  </files>
  <action>
    - Create `FoodItem` model (TypeId: 3) with English/Hindi names and nutritional values.
    - Create `MealLog` model (TypeId: 4) to record user consumption.
  </action>
  <verify>flutter pub run build_runner build</verify>
  <done>Food models exist with logic for calorie calculation based on portion.</done>
</task>

<task type="auto">
  <name>Initialize Seed Food Database</name>
  <files>lib/core/storage/hive_service.dart</files>
  <action>
    - Register new food adapters.
    - Implement a method `_seedFoodData()` that populates a "food_items" box with staples (Dal, Roti, etc.) if it's empty.
  </action>
  <verify>Check Hive box contents on startup.</verify>
  <done>Local database has pre-filled Indian food items.</done>
</task>

<task type="auto">
  <name>Setup Image Picker Dependency</name>
  <files>pubspec.yaml</files>
  <action>
    - Ensure `image_picker` is added to pubspec.
    - Add necessary permissions to `AndroidManifest.xml` (Cam/Gallery).
  </action>
  <verify>flutter pub get</verify>
  <done>Project is ready for camera/gallery interaction.</done>
</task>

## Success Criteria
- [ ] Build runner succeeds.
- [ ] 10+ Indian food items are available in the local database.
