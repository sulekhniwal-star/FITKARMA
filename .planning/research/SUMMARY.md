# Research Summary: FitKarma

## Executive Overview
The 2025 research confirms that an offline-first, Flutter-based architecture using Hive and self-hosted PocketBase is the most robust path for a privacy-centric, zero-cost Indian fitness app. Key success factors include leveraging on-device ML for privacy, deep Ayurvedic personalization, and a "Queue-First" sync engine.

## Key Findings by Dimension

### 🛠 Stack
- **Hive + PocketBase**: Use Hive as the local source of truth; sync to PB using a `PendingSyncBox`.
- **On-Device ML**: Use Google ML Kit (v2) for OCR. Note: 300 DPI images are required for reliable medical report extraction.
- **Connectivity**: `connectivity_plus` is mandatory for triggering sync clusters.

### ✨ Features
- **Nutrition**: Use Open Food Facts for barcodes (10k+ Indian items) but curate a local "Table Stakes" DB for regional dishes (Chapati, Dal, etc.).
- **Ayurveda**: Dosha logic should separate Prakriti (innate) and Vikriti (aggrovated state).
- **Gamification**: The "Karma" system should use real-time SSE subscriptions for community social features.

### 🏗 Architecture
- **Boundary**: Strict separation between Presentation (Riverpod/Hive) and Data (Repository/Network).
- **Flow**: User Action → Hive → UI Update → Sync Queue → Network → PocketBase.
- **Order**: Build Sync Infrastructure → Core Tracking → Nutrition → Ayurveda → Social.

### ⚠️ Critical Watchlist (Pitfalls)
- **The Western Trap**: Avoid generic health benchmarks; use Indian-specific body fat and metabolic standards.
- **Sync Reliability**: Don't rely solely on `Workmanager`; implement "App-Start Sync" to handle OEM background process killing.
- **Privacy**: PHI must be encrypted via Hive AES-256 before disk writes.

## Next Steps
1.  Define Requirements in `REQUIREMENTS.md` leveraging these findings.
2.  Design Phase 1 focused on Core Infrastructure and Step Tracking.
