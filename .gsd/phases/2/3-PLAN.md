---
phase: 2
plan: 3
wave: 1
---

# Plan 2.3: Dashboard UI Assembly & Insight Card

## Objective
Assemble the final Dashboard UI according to the design mockup, including the Amber Insight Card with functional feedback buttons.

## Context
- .gsd/SPEC.md
- .gsd/DECISIONS.md (ADR-07)
- lib/features/dashboard/presentation/dashboard_screen.dart
- lib/shared/widgets/insight_card.dart

## Tasks

<task type="auto">
  <name>Implement Amber Insight Card Widget</name>
  <files>lib/shared/widgets/insight_card.dart</files>
  <action>
    - Create a card with an amber/bright yellow background.
    - Style: Lightbulb icon, body text ("You're short on protein..."), and Thumbs up/down icons at the bottom right.
    - Make the thumbs buttons "functional": trigger a snackbar or log (log simulation) for feedback.
  </action>
  <verify>Visual check on dashboard.</verify>
  <done>InsightCard is visually rich and has interactable feedback buttons.</done>
</task>

<task type="auto">
  <name>Assemble Dashboard Layout</name>
  <files>lib/features/dashboard/presentation/dashboard_screen.dart</files>
  <action>
    - Header: Avatar + Greeting (using `greetingProvider`) + Karma coins label.
    - Center Card: White surface containing the `ActivityRingsWidget` and the numeric legend for the 4 metrics below it.
    - Body: Insert the `InsightCard`.
    - Meal Section: Add horizontally scrollable tabs for "Breakfast, Lunch, Dinner, Snacks".
  </action>
  <verify>flutter run (check alignment and premium feel)</verify>
  <done>Dashboard screen matches reference image layout and branding.</done>
</task>

## Success Criteria
- [ ] Dashboard assembly matches the provided UI image perfectly.
- [ ] Insight card buttons respond to taps.
- [ ] Layout is responsive (works on standard screen sizes).
