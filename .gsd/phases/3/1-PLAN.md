---
phase: 3
plan: 1
wave: 1
---

# Plan 3.1: Activity Models & Hive Type Registration

## Objective
Define the data structures for local activity tracking and ensure they are compatible with Hive persistence.

## Context
- .gsd/SPEC.md
- lib/core/storage/hive_service.dart
- lib/features/tracking/domain/models/activity_log.dart
- lib/features/tracking/domain/models/water_log.dart

## Tasks

<task type="auto">
  <name>Create Activity & Water Models</name>
  <files>
    - lib/features/tracking/domain/models/activity_log.dart
    - lib/features/tracking/domain/models/water_log.dart
  </files>
  <action>
    - Create `ActivityLog` model with Hive annotations (typeId: 1).
    - Create `WaterLog` model with Hive annotations (typeId: 2).
    - Include `isSynced` flag in all models for future Phase 6 integration.
  </action>
  <verify>flutter pub run build_runner build</verify>
  <done>Models exist with .g.dart files generated.</done>
</task>

<task type="auto">
  <name>Register Hive Adapters</name>
  <files>lib/core/storage/hive_service.dart</files>
  <action>
    - Add `Hive.registerAdapter` calls for new activity models in the `init()` method.
  </action>
  <verify>File compilation.</verify>
  <done>Hive correctly registers activity adapters on startup.</done>
</task>

## Success Criteria
- [ ] Build runner completes without errors.
- [ ] Models follow the offline-first sync pattern (id, timestamp, isSynced).
