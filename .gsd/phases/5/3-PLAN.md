---
phase: 5
plan: 3
wave: 1
---

# Plan 5.3: Challenges Carousel & Join Logic

## Objective
Implement an interactive "Challenges" section to drive engagement through community-style health goals.

## Context
- lib/features/challenges/domain/models/challenge.dart
- lib/features/challenges/presentation/widgets/challenge_carousel.dart

## Tasks

<task type="auto">
  <name>Create Challenge Models</name>
  <files>lib/features/challenges/domain/models/challenge.dart</files>
  <action>
    - Define `Challenge` Hive model (TypeId: 7).
    - Fields: `titleEn`, `titleHi`, `xpReward`, `isJoined`.
  </action>
  <verify>flutter pub run build_runner build</verify>
  <done>Model supports "Joinable" state.</done>
</task>

<task type="auto">
  <name>Build Challenges Carousel</name>
  <files>lib/features/challenges/presentation/widgets/challenge_carousel.dart</files>
  <action>
    - Create a horizontal ListView of vibrant cards.
    - Implement "Join" button that updates the local state.
  </action>
  <verify>Tap Join -> Button text changes to "Joined".</verify>
  <done>Interactive challenges are live.</done>
</task>

## Success Criteria
- [ ] Challenges are horizontally scrollable.
- [ ] "Joined" status persists across app restarts.
- [ ] Dashboard shows a "Challenge active" nudge if any challenge is joined.
