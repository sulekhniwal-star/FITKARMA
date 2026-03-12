---
phase: 3
plan: 2
wave: 1
---

# Plan 3.2: Local Activity Repositories

## Objective
Implement a repository layer to encapsulate Hive operations, providing a clean API for the UI to save and retrieve activity data.

## Context
- lib/features/tracking/data/repositories/activity_repository.dart
- lib/features/tracking/data/repositories/water_repository.dart

## Tasks

<task type="auto">
  <name>Implement Activity Repository</name>
  <files>lib/features/tracking/data/repositories/activity_repository.dart</files>
  <action>
    - Build `ActivityRepository` using Hive boxes.
    - Methods: `saveSteps(int)`, `saveActiveMinutes(int)`, `getDailyActivity(DateTime)`.
    - Logic should aggregate or update record for the specific date.
  </action>
  <verify>Riverpod provider test or manual use in Controller.</verify>
  <done>Activity repository handles daily step/minute persistence.</done>
</task>

<task type="auto">
  <name>Implement Water Repository</name>
  <files>lib/features/tracking/data/repositories/water_repository.dart</files>
  <action>
    - Build `WaterRepository` for tracking glass intake.
    - Methods: `addGlass()`, `getDailyWater(DateTime)`.
  </action>
  <done>Water persistence is functional.</done>
</task>

## Success Criteria
- [ ] Data persists across app restarts.
- [ ] Repositories use the `SyncService` (Phase 1) to queue items if they were being synced (future-proofing).
