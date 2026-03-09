# Phase 03: Secure Local Storage - Research

## 1. Database Selection: Hive CE (2025)
For FitKarma's "Local-First" and "Privacy-First" mission, **`hive_ce`** (Community Edition) is selected as the primary persistence engine.

- **Why `hive_ce`**: It is the modern, maintained fork of Hive v2. It remains pure Dart, making it extremely fast and easy to encrypt compared to SQLite (which requires complex SQLCipher setups).
- **Encryption**: Natively supports **AES-256** (CBC mode with PKCS7 padding) out of the box.

## 2. Key Management: Double-Layer Security
To ensure "Absolute Privacy", the encryption key must never be hardcoded or stored in plain text.

1.  **Generation**: Use `Hive.generateSecureKey()` to create a high-entropy 256-bit key.
2.  **Storage**: Secure the key using **`flutter_secure_storage`**.
    - *Android*: Uses **EncryptedSharedPreferences** or KeyStore (Hardware-backed if available).
    - *iOS*: Uses **Keychain** (Secure Enclave).
3.  **Boot Flow**:
    - App starts → Checks `flutter_secure_storage` for key.
    - If missing → Generate and save.
    - If exists → Retrieve and initialize Hive boxes.

## 3. Architecture Integration (FFCA)
Following our **Feature-First Clean Architecture**:

- **Core Layer**: `lib/core/security/` will house the `EncryptionService`.
- **Data Layer Model**: Every Hive model (DTO) will live in `features/X/data/models/` with `@HiveType` annotations.
- **Pure Domain**: Domain entities remain pure Dart, decoupled from Hive annotations.

## 4. Dependencies
- `hive_ce`: Core engine.
- `hive_ce_flutter`: Flutter-specific extensions (path management).
- `flutter_secure_storage`: For hardware-backed key storage.
- `hive_ce_generator`: Proactive code generation for TypeAdapters.

## 5. Summary Implementation Path
1.  Initialize `EncryptionService` to handle key lifecycle.
2.  Setup Global Hive Initialization in `main.dart`.
3.  Implement a base `SecureBox` wrapper or helper to standardize encrypted box opening.
4.  Configure `build_runner` for Hive TypeAdapters.
