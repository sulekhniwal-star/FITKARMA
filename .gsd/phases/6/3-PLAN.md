---
phase: 6
plan: 3
wave: 1
---

# Plan 6.3: Advanced Sync Engine

## Objective
Implement multi-device synchronization with timestamp-based conflict resolution via Appwrite.

## Context
- `lib/core/network/sync_service.dart`
- `lib/core/network/sync_queue_item.dart`

## Tasks

<task type="auto">
  <name>Implement Timestamp Logic</name>
  <files>lib/core/network/sync_queue_item.dart</files>
  <action>
    - Ensure every sync item has a high-precision `updatedAt` timestamp.
  </action>
  <verify>Timestamp is generated on every local write.</verify>
  <done>Conflict markers are available for sync.</done>
</task>

<task type="auto">
  <name>Build Conflict Resolution Handler</name>
  <files>lib/core/network/sync_service.dart</files>
  <action>
    - Logic: `if (remote.timestamp > local.timestamp) updateLocal() else pushLocal()`.
    - Handle identical timestamps with "Last Write Wins".
  </action>
  <verify>Mock sync with newer remote data -> Local updates correctly.</verify>
  <done>Multi-device data integrity is secured.</done>
</task>

<task type="auto">
  <name>Appwrite Provider Configuration</name>
  <files>lib/core/network/appwrite_provider.dart</files>
  <action>
    - Set up `Client`, `Account`, and `Databases` for Appwrite interaction.
  </action>
  <verify>App connects to Appwrite endpoint.</verify>
  <done>Backend infrastructure is linked.</done>
</task>

## Success Criteria
- [ ] Data successfully merges between local Hive and remote Appwrite.
- [ ] Sync queue flushes automatically on connectivity restore.
