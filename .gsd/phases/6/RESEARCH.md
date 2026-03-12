# Phase 6 Research: Sync Engine & Medical Encryption

## Security Architecture (ADR-14, 15)
- **Encryption**: AES-256-CBC using the `encrypt` package.
- **Key Storage**: Use `flutter_secure_storage` to persist a randomly generated 256-bit master key.
- **Hive Integration**: Use `Hive.openBox(..., encryptionCipher: HiveAesCipher(key))`.
- **Scope**: All local boxes (Activity, Water, Food, Ayurveda, Progress) will transition to encrypted boxes.

## Sync Engine (ADR-16)
- **Database**: Appwrite (Cloud).
- **Conflict Resolution**:
  - Each record will store a `lastModified` timestamp.
  - Sync logic compares local vs remote timestamps.
  - If `local.timestamp == remote.timestamp`, use "Last Write Wins" (highest ID or sequence).
- **Queue**: Background Task (using `workmanager` if needed) to flush the `sync_queue` even when the app is closed.

## Localization (ADR-17)
- **Migration**: Move from `BilingualLabel` (hardcoded) to `intl` package + `.arb` files.
- **Structure**:
  - `lib/l10n/app_en.arb`
  - `lib/l10n/app_hi.arb`
- **UI Impact**: Update `BilingualLabel` to consume from `AppLocalizations`, or keep its "double language" design by fetching both English and Hindi keys simultaneously where branding requires it.
