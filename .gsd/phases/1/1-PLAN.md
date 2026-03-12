---
phase: 1
plan: 1
wave: 1
---

# Plan 1.1: Flutter Project Initialization & Core Data Layer

## Objective
Initialize the Flutter project structure, configure dependencies, and establish the core folder hierarchy with Hive storage readiness.

## Context
- .gsd/SPEC.md
- .gsd/ROADMAP.md
- .gsd/phases/1/RESEARCH.md
- FitKarma_Documentation.md

## Tasks

<task type="auto">
  <name>Initialize Flutter Project & Dependencies</name>
  <files>pubspec.yaml, lib/main.dart</files>
  <action>
    - Create a new Flutter project in the current directory if it doesn't exist.
    - Add dependencies: `flutter_riverpod`, `riverpod_annotation`, `go_router`, `hive_flutter`, `connectivity_plus`, `appwrite`.
    - Add dev_dependencies: `riverpod_generator`, `build_runner`, `hive_generator`.
    - Run `flutter pub get`.
  </action>
  <verify>flutter pub get</verify>
  <done>pubspec.yaml contains all required dependencies and builds successfully.</done>
</task>

<task type="auto">
  <name>Establish Core Folder Structure & Hive Initialization</name>
  <files>lib/core/storage/hive_service.dart, lib/main.dart</files>
  <action>
    - Create the standard folder structure: `lib/core/`, `lib/shared/`, `lib/features/auth/`, `lib/features/dashboard/`.
    - Implement a `HiveService` in `lib/core/storage/hive_service.dart` that initializes Hive for Flutter.
    - Update `lib/main.dart` to initialize Hive before running the app using a Riverpod `ProviderContainer`.
  </action>
  <verify>flutter run (check for initialization errors in logs)</verify>
  <done>Hive initializes without errors on startup; basic folder structure exists.</done>
</task>

## Success Criteria
- [ ] Flutter project initialized with all specified dependencies.
- [ ] `lib` directory contains the core modular structure.
- [ ] Hive is initialized correctly on app startup.
