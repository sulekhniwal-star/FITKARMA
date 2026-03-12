# Phase 1 Research: Foundation & Architecture

## Core Tech Stack
- **Framework**: Flutter 3.x
- **State Management**: Riverpod 2.x with `riverpod_generator` and `riverpod_annotation`.
- **Local Storage**: `hive_flutter` 2.0 with `hive_generator` for type adapters.
- **Navigation**: `go_router` 13.x+ (using hardcoded bilingual labels).
- **Backend**: Appwrite (Prototype Sync Service).

## Architecture: Modular Clean Architecture
Following the documentation's directory structure:
- `lib/core/`: Constants, DI, Errors, Network (Sync Queue), Security, Storage, Utils.
- `lib/shared/`: Shared widgets, Theme.
- `lib/features/`: Feature-based folders (Auth, Dashboard to start).

## Sync Service Prototype
The documented sync flow uses a `sync_queue_box`.
- **Mechanism**: Use a Riverpod `Notifier` or `Provider` to manage the queue.
- **Trigger**: Listen to connectivity changes via `connectivity_plus`.
- **Persistence**: Store pending operations in Hive to survive app restarts.
- **Batched Processing**: Implement a rudimentary "flush" mechanism that pretends to talk to Appwrite for now (mock).

## Task Breakdown for Phase 1
1. **Initial Setup**: Project structure, dependencies (Riverpod, Hive, GoRouter).
2. **Theme & Navigation**: Configure AppTheme (Orange/Purple) and GoRouter with ShellRoute.
3. **Data Layer Foundation**: Initialize Hive and create the initial Sync Service skeleton.

## Dependencies to Add
```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^13.2.0
  hive_flutter: ^1.1.0
  connectivity_plus: ^6.0.3
  # Appwrite will be added but not fully configured in Phase 1 prototype
  appwrite: ^12.0.3 

dev_dependencies:
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.9
  hive_generator: ^2.0.1
```
