---
phase: 1
plan: 2
wave: 1
---

# Plan 1.2: Prototype Sync Service & Connectivity Management

## Objective
Implement a robust prototype and skeleton for the sync engine that handles offline-to-online transitions using a Hive-backed queue.

## Context
- .gsd/SPEC.md
- .gsd/DECISIONS.md (ADR-03)
- lib/core/network/sync_service.dart
- lib/core/network/connectivity_service.dart

## Tasks

<task type="auto">
  <name>Implement Connectivity Service</name>
  <files>lib/core/network/connectivity_service.dart</files>
  <action>
    - Create a `ConnectivityService` using a Riverpod `StreamProvider` that wraps `connectivity_plus`.
    - Provide an easy way for other services to react to network transitions (e.g., from offline to wifi/mobile).
  </action>
  <verify>flutter pub run build_runner build (if using riverpod_generator)</verify>
  <done>Riverpod provider for connectivity state exists and updates correctly.</done>
</task>

<task type="auto">
  <name>Create Prototype Sync Queue Service</name>
  <files>lib/core/network/sync_service.dart</files>
  <action>
    - Define a `SyncQueueItem` model for storage in a Hive box.
    - Implement a `SyncService` that monitors the `ConnectivityService`.
    - Provide a "flush" function that log-simulates talks to Appwrite; if online, it should iterate through the pending Hive queue.
    - Placeholder for future Appwrite project/collection IDs.
  </action>
  <verify>Unit test or console log check for queue flush trigger on network reconnection.</verify>
  <done>SyncService monitors connectivity and "flushes" the Hive queue when internet is available.</done>
</task>

## Success Criteria
- [ ] Connectivity monitoring is integrated via Riverpod.
- [ ] A Hive box for `sync_queue` is established.
- [ ] Sync logic reacts to connectivity changes to process the pending queue.
