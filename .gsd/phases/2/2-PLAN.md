---
phase: 2
plan: 2
wave: 1
---

# Plan 2.2: Dashboard State & Random Greeting Provider

## Objective
Establish a robust Riverpod-based state for dashboard metrics and implement the "Greeting Generator" for bilingual user welcomes.

## Context
- .gsd/SPEC.md
- .gsd/DECISIONS.md (ADR-06)
- lib/features/dashboard/presentation/dashboard_controller.dart
- lib/features/dashboard/presentation/greeting_provider.dart

## Tasks

<task type="auto">
  <name>Implement Dashboard Activity State</name>
  <files>lib/features/dashboard/presentation/dashboard_controller.dart</files>
  <action>
    - Create a `DashboardState` data class (with `copyWith`) containing calories, steps, water, and active minutes.
    - Implement a `Notifier` to provide mock initial values for visualization in Phase 2.
  </action>
  <verify>flutter pub run build_runner build</verify>
  <done>Riverpod DashboardState exists with mock metrics.</done>
</task>

<task type="auto">
  <name>Create Random Bilingual Greeting Provider</name>
  <files>lib/features/dashboard/presentation/greeting_provider.dart</files>
  <action>
    - Create a provider `greetingProvider` that maps English to Hindi greetings:
        - "Good Morning" / "सुप्रभात, नमस्ते"
        - "Namaste" / "नमस्ते"
        - "Stay Hydrated" / "हाइड्रेटेड रहें"
    - Make the provider pick one entry randomly on initialization.
  </action>
  <verify>Visual check: Refresh app and see the greeting change.</verify>
  <done>Greeting provider returns a random bilingual greeting on each session start.</done>
</task>

## Success Criteria
- [ ] Dashboard controller provides mock data for the rings.
- [ ] Greeting provider yields a bilingual string (English/Hindi).
