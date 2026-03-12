---
phase: 3
plan: 3
wave: 1
---

# Plan 3.3: UI Integration & Live Dashboard

## Objective
Connect the Dashboard UI to the newly created local repositories, replacing mock data with actual stored values and enabling user interaction via the Floating Action Button.

## Context
- lib/features/dashboard/presentation/dashboard_controller.dart
- lib/features/dashboard/presentation/dashboard_screen.dart

## Tasks

<task type="auto">
  <name>Link DashboardController to Repositories</name>
  <files>lib/features/dashboard/presentation/dashboard_controller.dart</files>
  <action>
    - Inject `ActivityRepository` and `WaterRepository` into the controller.
    - Update `build()` to fetch initial values from the database.
    - Update `addWater()` and other setters to call repository methods.
  </action>
  <verify>Tap 'Add' button and see the Teal ring progress.</verify>
  <done>Dashboard reflects live Hive data.</done>
</task>

<task type="auto">
  <name>Implement Add-Metric Dialog</name>
  <files>lib/features/dashboard/presentation/widgets/add_metric_dialog.dart</files>
  <action>
    - Create a dialog triggered by the Dashboard FAB.
    - Options: "Log Steps", "Add Water", "Add Workout".
    - Connect these to the DashboardController.
  </action>
  <verify>End-to-end flow: Dialog -> Add -> UI Update.</verify>
  <done>Users can manually log activity data.</done>
</task>

## Success Criteria
- [ ] Ring progress updates immediately after data entry.
- [ ] Data is retrieved correctly on app restart.
- [ ] UI remains high-fidelity with premium dialogs.
