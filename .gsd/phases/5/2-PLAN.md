---
phase: 5
plan: 2
wave: 1
---

# Plan 5.2: Karma XP & Leveling System

## Objective
Introduce a gamified progression system that rewards users for healthy habits using cultural terminology (Sadhaka, Warrior, etc.).

## Context
- lib/features/gamification/domain/models/user_progress.dart
- lib/features/gamification/data/repositories/progress_repository.dart
- lib/features/dashboard/presentation/widgets/karma_level_card.dart

## Tasks

<task type="auto">
  <name>Implement Progress Repository</name>
  <files>
    - lib/features/gamification/domain/models/user_progress.dart
    - lib/features/gamification/data/repositories/progress_repository.dart
  </files>
  <action>
    - Create `UserProgress` Hive model (TypeId: 6).
    - Methods to add XP and calculate level titles (Sadhaka, Yoddha, Rishi).
  </action>
  <verify>Log food -> Check if XP increases in Hive.</verify>
  <done>User progress is persisted locally.</done>
</task>

<task type="auto">
  <name>Connect XP Triggers</name>
  <files>
    - lib/features/dashboard/presentation/dashboard_controller.dart
    - lib/features/food/data/repositories/food_repository.dart
  </files>
  <action>
    - Hook into meal logging and water adding to trigger `addXp()` calls.
  </action>
  <verify>Perform dashboard actions and see XP UI update.</verify>
  <done>Holistic gamification loop is active.</done>
</task>

<task type="auto">
  <name>Build Karma Level Card</name>
  <files>lib/features/dashboard/presentation/widgets/karma_level_card.dart</files>
  <action>
    - Create a premium card for the header displaying Current Level, Title, and XP progress bar.
  </action>
  <verify>Visual check on dashboard header.</verify>
  <done>Gamification is visible and rewarding.</done>
</task>

## Success Criteria
- [ ] Levels increment correctly (e.g., Level 2 at 500 XP).
- [ ] Titles update automatically as users level up.
