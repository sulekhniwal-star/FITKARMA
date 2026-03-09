# Phase 01: Foundation & Architecture - Research (2025 Update)

## 1. Project Initialization & Architecture

### Dart 3.6+ Workspaces (The 2025 Standard)
The biggest shift in 2025 is the move from manual path dependencies to **Dart Workspaces**. This simplifies monorepo management significantly.

- **Root `pubspec.yaml`**: Defines the workspace members.
- **Benefits**: Single `pubspec.lock` for the whole project, automatic resolution of internal packages, and better IDE performance.
- **FitKarma Setup**:
  ```yaml
  workspace:
    - .
    - packages/fitkarma_ui
  ```

### Clean Architecture (Feature-First)
Matches the previous research, but with stricter enforcement of **Domain Layer Purity** (Pure Dart).

## 2. State Management (Riverpod 3.0)

Riverpod 3.0 is the baseline for 2025.
- **AsyncNotifier**: The standard for anything hitting a database or API.
- **Mutations (Experimental)**: Use for side-effects (logging food, tracking steps) to prevent UI glitches during async transitions.
- **autoRetry**: Built-in exponential backoff for initialization failures.
- **ref.mounted**: Essential check before triggering UI changes from Notifiers.

## 3. Environment & Configuration

### dart-define-from-file
Using `--dart-define-from-file` with JSON files (e.g., `config/dev.json`) is the preferred way to manage large sets of compile-time variables without polluting the terminal history.

### Security Note
For high-security secrets (though out of scope for Phase 1), **Envied** with `obfuscate: true` is recommended over plain `dart-define` to prevent easy reverse-engineering of the binary.

## 4. Design System Architecture ( fitkarma_ui )

- **Approach**: Internal Workspace Package.
- **Structure**:
  ```text
  packages/fitkarma_ui/
  ├── lib/
  │   ├── src/            # Private widgets/logic
  │   └── fitkarma_ui.dart # Public API exports
  ```
- **Rationale**: Strict boundary between the "Style" and "Logic" layers.

## 5. Summary Implementation Path (Updated)
1.  Initialize Flutter project with **Dart Workspace** support.
2.  Setup `packages/fitkarma_ui` as a workspace member.
3.  Configure `launch.json` and `config/*.json` for `dart-define-from-file`.
4.  Setup Riverpod 3.0 with `custom_lint` and `riverpod_lint`.
5.  Initialize `mason` for FFCA scaffolding.
