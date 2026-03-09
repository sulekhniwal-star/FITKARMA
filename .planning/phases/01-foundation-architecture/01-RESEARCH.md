# Phase 01: Foundation & Architecture - Research

## 1. Project Initialization & Architecture

### Feature-First Clean Architecture (FFCA)
In 2025, the industry standard for scalable Flutter apps has settled on **Feature-First Clean Architecture**. This approach optimizes for "Cognitive Locality"—keeping everything related to a feature in one place.

**Recommended Folder Structure:**
```text
lib/
├── core/                  # Global shared code (theme, extensions, use_cases)
├── features/
│   └── feature_name/
│       ├── data/         # Models, Data Sources, Repository Impl
│       ├── domain/       # Entities, Use Cases, Repository Interfaces
│       └── presentation/ # Widgets, Providers/Controllers
├── packages/              # Internal local packages
│   └── design_system/    # Branding, themes, Glassmorphic widgets
└── main_development.dart
└── main_production.dart
```

### Mason (Bricks) for Scaffolding
Using `mason_cli` is the best practice for enforcing this structure.
- **Goal**: Create a `feat` brick that generates the `data/domain/presentation` subfolders automatically.
- **Reference Bricks**: `clean_architecture_feature` or `feature_brick`.

## 2. State Management (Riverpod 3.0)

With the release of **Riverpod 3.0** (late 2025), several patterns are now mandatory for modern projects:

### Code Generation
- **Notifier/AsyncNotifier**: Replacing `StateNotifier`. Use `riverpod_generator` for type safety and automatic `autoDispose`.
- **AsyncValue Pattern**: Mandatory for frontend. Use `.when()` or `.maybeWhen()` for handling Loading/Error/Data states in the UI.

### Functional State & Freezed
- **Immutability**: All State objects must be `freezed` classes.
- **Side Effects**: All mutations happen via `Notifier` methods that emit a new state instance.

## 3. Environment & Configuration

### Secrets & dart-define
- **Security**: Move away from hardcoded strings. Use `String.fromEnvironment('KEY')` to inject secrets at compile time via `--dart-define`.
- **from-file**: Use `launch.json` or `config.json` with `--dart-define-from-file` for local development to avoid long CLI commands.

### Flavors (Dev/Prod)
- **Identity**: Android `productFlavors` and iOS `Schemes` are used to differentiate `com.fitkarma.dev` from `com.fitkarma.app`.
- **Entry points**: `main_development.dart` initializes with Dev logging/API URLs, while `main_production.dart` uses production credentials.

## 4. Design System Architecture

### Package vs Folder
For FitKarma's "Cultural Premium" look:
- **Approach**: Internal local package (`packages/fitkarma_ui`).
- **Rationale**: 
  - **Decoupling**: Prevents UI components from accidentally importing business logic providers.
  - **Reusability**: Makes it easier to spin up a separate "Pro" or "Admin" app sharing the same brand identity.
  - **Visual Testing**: Easier to run `golden tests` or a manual "Gallery" app just for the UI package.

## 5. Summary Implementation Path
1.  Initialize standard Flutter project.
2.  Setup `mason` and define a custom `feature` brick.
3.  Configure `dart-define` secrets and `flutter_flavor` for Dev/Prod.
4.  Scaffold the `packages/fitkarma_ui` local package.
5.  Establish the Clean Architecture base classes in `lib/core`.
