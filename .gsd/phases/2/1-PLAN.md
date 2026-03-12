---
phase: 2
plan: 1
wave: 1
---

# Plan 2.1: Custom Concentric Activity Rings & Bilingual Label

## Objective
Implement specialized UI components for the FitKarma design system: the custom 4-concentric-ring activity widget with integrated icons and a reusable bilingual text widget.

## Context
- .gsd/SPEC.md
- .gsd/DECISIONS.md (ADR-05)
- lib/shared/widgets/activity_rings.dart
- lib/shared/widgets/bilingual_label.dart

## Tasks

<task type="auto">
  <name>Implement Concentric Activity Rings Widget</name>
  <files>lib/shared/widgets/activity_rings.dart</files>
  <action>
    - Create a `CustomPainter` to draw 4 concentric rings (Orange, Green, Teal, Purple).
    - Stroke width should be ~10px.
    - Icons (Lightning, Feet, Water, Clock) must be drawn inside the ring paths (at the starting or ending cap).
    - Accepts 4 progress values (0.0 to 1.0).
  </action>
  <verify>flutter pub run build_runner build (then visual check in placeholders)</verify>
  <done>Custom ActivityRingsWidget draws 4 rings with respective icons inside the paths.</done>
</task>

<task type="auto">
  <name>Create Reusable Bilingual Label Widget</name>
  <files>lib/shared/widgets/bilingual_label.dart</files>
  <action>
    - Build a widget `BilingualLabel(english: ..., hindi: ...)` that stacks English and Hindi text with specialized styling (e.g., Hindi smaller and grey).
    - Use this for headers and labels throughout the app as per ADR-01 and ADR-04.
  </action>
  <verify>Visual check on dashboard placeholder header.</verify>
  <done>BilingualLabel widget correctly renders stacked English and Hindi texts.</done>
</task>

## Success Criteria
- [ ] Custom ring widget passes progress and icons correctly.
- [ ] BilingualLabel is versatile and used for headers.
- [ ] UI reflects premium card-based theme.
