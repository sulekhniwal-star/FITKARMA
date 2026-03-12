---
phase: 6
plan: 2
wave: 1
---

# Plan 6.2: Encrypted Storage Layer

## Objective
Update all Hive boxes to use AES-256 encryption using the secure key from Plan 6.1.

## Context
- `lib/core/storage/hive_service.dart`

## Tasks

<task type="auto">
  <name>Transition Hive to Encrypted Boxes</name>
  <files>lib/core/storage/hive_service.dart</files>
  <action>
    - Retrieve encryption key from `EncryptionService`.
    - Open all boxes (Activity, Water, Food, etc.) with `encryptionCipher`.
  </action>
  <verify>Box content is unreadable without key (logical check).</verify>
  <done>All user data is encrypted at rest.</done>
</task>

<task type="auto">
  <name>Update Repositories for L10n</name>
  <files>
    - lib/features/dashboard/presentation/greeting_provider.dart
    - lib/shared/widgets/bilingual_label.dart
  </files>
  <action>
    - Refactor `BilingualLabel` to use ARB keys.
    - Update hardcoded strings in providers to use localized values.
  </action>
  <verify>UI displays correct translations from ARB.</verify>
  <done>UI logic is clean of hardcoded bilingual strings.</done>
</task>

## Success Criteria
- [ ] No plaintext health data is stored in Hive.
- [ ] `BilingualLabel` continues to show both languages but via ARB lookups.
