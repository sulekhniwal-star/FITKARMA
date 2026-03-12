---
phase: 5
plan: 1
wave: 1
---

# Plan 5.1: Dosha Quiz & Ayurvedic Profile

## Objective
Implement a core Ayurvedic feature that determines and displays the user's constitution (Dosha) using a localized quiz and custom donut chart.

## Context
- lib/features/ayurveda/domain/models/dosha_profile.dart
- lib/features/ayurveda/presentation/widgets/dosha_donut_chart.dart
- lib/features/ayurveda/presentation/ayurveda_section.dart

## Tasks

<task type="auto">
  <name>Create Dosha Profile Model</name>
  <files>lib/features/ayurveda/domain/models/dosha_profile.dart</files>
  <action>
    - Define `DoshaProfile` Hive model (TypeId: 5).
    - Fields for Vata, Pitta, Kapha percentages.
  </action>
  <verify>flutter pub run build_runner build</verify>
  <done>Model persists user dosha state.</done>
</task>

<task type="auto">
  <name>Build Dosha Quiz UI</name>
  <files>lib/features/ayurveda/presentation/quiz/dosha_quiz_screen.dart</files>
  <action>
    - Implement a 4-question stepper quiz with bilingual labels.
    - Logic to calculate percentages based on answers.
  </action>
  <verify>Manual quiz run through.</verify>
  <done>Users can determine their Dosha through the app.</done>
</task>

<task type="auto">
  <name>Implement Dosha Donut Chart</name>
  <files>lib/features/ayurveda/presentation/widgets/dosha_donut_chart.dart</files>
  <action>
    - Use `CustomPainter` to draw a segmented donut chart (Vata: Indigo, Pitta: Red, Kapha: Green).
  </action>
  <verify>Visual match with reference design.</verify>
  <done>Vibrant Chart visualization for the profile.</done>
</task>

## Success Criteria
- [ ] Quiz successfully calculates a Dosha distribution.
- [ ] "Ayurveda" section appears on the dashboard once the quiz is complete.
