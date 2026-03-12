---
phase: 1
plan: 3
wave: 1
---

# Plan 1.3: Bilingual Navigation & Shell Architecture

## Objective
Establish the primary application shell using GoRouter, implementing the 5-tab bottom navigation with hardcoded bilingual labels (English/Hindi) as per the design reference.

## Context
- .gsd/SPEC.md
- .gsd/DECISIONS.md (ADR-04)
- lib/app.dart
- lib/features/dashboard/presentation/dashboard_screen.dart

## Tasks

<task type="auto">
  <name>Configure AppTheme & Standard Colors</name>
  <files>lib/shared/theme/app_theme.dart, lib/shared/theme/app_colors.dart</files>
  <action>
    - Define primary (Orange #FF5722), secondary (Purple #3F3D8F), accent (Amber), and background (Off-white #FDF6EC) colors.
    - Create a basic `MaterialApp` theme using these colors to ensure visual consistency from Phase 1.
  </action>
  <verify>Visual check on dashboard background.</verify>
  <done>AppTheme is applied with the specified Indian cultural color palette.</done>
</task>

<task type="auto">
  <name>Implement GoRouter with Bilingual Shell Navigation</name>
  <files>lib/app.dart, lib/features/dashboard/presentation/dashboard_screen.dart</files>
  <action>
    - Setup `GoRouter` with a `ShellRoute` containing a BottomNavigationBar.
    - Implement 5 routes: Home (नमस्ते / Home), Food, Workout, Steps, Me.
    - Labels: Use two-line format for BottomNavigationBar Items (e.g., Home / नमस्ते, मुख्यपृष्ठ).
    - Create basic placeholder screens for each tab.
  </action>
  <verify>Navigation works; tabs switch between placeholder screens; labels are bilingual.</verify>
  <done>GoRouter manages 5 tabs with bilingual labels; app has a functional bottom nav shell.</done>
</task>

## Success Criteria
- [ ] Theme with orange/purple palette applied.
- [ ] GoRouter shell implemented with functional 5-tab navigation.
- [ ] Bilingual labels (English/Hindi) visible on the Bottom Navigation Bar.
