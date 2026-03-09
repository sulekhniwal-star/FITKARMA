# Research Dimension: Stack (2025)

## Recommended Tech Stack

| Layer | Recommendation | Rationale | Confidence |
|-------|----------------|-----------|------------|
| **Frontend** | Flutter 3.22+ | Excellent cross-platform performance, active maintenance, and strong community support for health apps. | High |
| **State Management** | Riverpod 2.x | Reactive, testable, and handles dependency injection elegantly for complex data flows. | High |
| **Local Database** | Hive | Extremely fast for simple key-value/object storage, offline-first by default, and supports encryption. | High |
| **Sync Strategy** | Queue-First (PendingSyncBox) | Ensures zero data loss by logging all offline actions to a Hive-backed queue before syncing with PocketBase. | Medium |
| **Local-First Sync** | `pocketbase_drift` | (Alternative) Uses Drift/SQLite for more complex relational data and provides built-in sync strategies. | Medium |

## Key Insights

- **Local-First Source of Truth**: Design for Hive as the primary DB. PocketBase serves as the synchronization hub.
- **Connectivity Monitoring**: Use `connectivity_plus` to trigger sync batches immediately when the device reconnects.
- **Lazy Loading**: For food databases (thousands of records), use Hive "Lazy Boxes" to maintain <1s dashboard load times.
- **OEM Optimization**: Android manufacturers (Xiaomi, Oppo, etc.) aggressively kill background tasks. `Workmanager` is reliable but requires careful battery exclusion instructions for users.

## What NOT to Use (and Why)

- **Pure Cloud Firestore**: Violated "Zero recurring API costs" goal. PocketBase on Railway offers a predictable, self-hosted alternative.
- **Direct UI-to-API Calls**: Do NOT call PocketBase directly from widgets. Always route through the Hive-backed repository to ensure offline reliability.
