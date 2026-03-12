---
phase: 6
plan: 1
wave: 1
---

# Plan 6.1: Security Foundation & L10n Setup

## Objective
Establish the encryption service and migration of localizations to the standard ARB format.

## Context
- `lib/core/security/encryption_service.dart`
- `l10n/app_en.arb`, `l10n/app_hi.arb`

## Tasks

<task type="auto">
  <name>Setup Security Dependencies</name>
  <files>pubspec.yaml</files>
  <action>
    - Add `encrypt`, `flutter_secure_storage`.
  </action>
  <verify>flutter pub get</verify>
  <done>Security packages are available.</done>
</task>

<task type="auto">
  <name>Implement Encryption Service</name>
  <files>lib/core/security/encryption_service.dart</files>
  <action>
    - Service to generate/retrieve master key from Secure Storage.
    - Provision `HiveAesCipher` for encrypted boxes.
  </action>
  <verify>Check if key persists across app restarts.</verify>
  <done>Encryption keys are securely managed.</done>
</task>

<task type="auto">
  <name>Migrate to ARB Localization</name>
  <files>
    - lib/l10n/app_en.arb
    - lib/l10n/app_hi.arb
    - lib/app.dart
  </files>
  <action>
    - Configure `l10n.yaml`.
    - Extract core strings (Dashboard, Food, Ayurveda) into ARB files.
    - Initialize `AppLocalizations` in `MaterialApp`.
  </action>
  <verify>flutter gen-l10n</verify>
  <done>Localization is now handled via standard intl framework.</done>
</task>

## Success Criteria
- [ ] Master key generated and stored in Keychain/Keystore.
- [ ] App starts with `AppLocalizations` support.
