---
phase: 4
plan: 3
wave: 1
---

# Plan 4.3: Integration & Dashboard Totals

## Objective
Finalize the connection between food logging and the main dashboard, ensuring calorie totals update accurately.

## Context
- lib/features/food/data/repositories/food_repository.dart
- lib/features/dashboard/presentation/dashboard_controller.dart

## Tasks

<task type="auto">
  <name>Implement Food Repository</name>
  <files>lib/features/food/data/repositories/food_repository.dart</files>
  <action>
    - Service to save `MealLog` entries to Hive.
    - Method to fetch today's logs and calculate total calories/macros.
  </action>
  <verify>Log a food item and verify it is stored in Hive.</verify>
  <done>Food repository persists meal logs.</done>
</task>

<task type="auto">
  <name>Link Dashboard to Food Totals</name>
  <files>lib/features/dashboard/presentation/dashboard_controller.dart</files>
  <action>
    - Update `DashboardController` to watch the `MealLog` box.
    - Sum today's calories and update the Orange "Calories" ring.
  </action>
  <verify>Log food -> Return to home -> Orange ring progress increases.</verify>
  <done>Dashboard reflects live calorie consumption.</done>
</task>

## Success Criteria
- [ ] End-to-end flow from search -> portion -> log -> dashboard update.
- [ ] Calorie counts are calculated based on the Indian portion multipliers (e.g., 2 rotis = 140 kcal).
