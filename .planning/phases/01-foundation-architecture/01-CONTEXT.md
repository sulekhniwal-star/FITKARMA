# Phase 01: Foundation & Architecture - Context

**Gathered:** 2026-03-09
**Status:** Ready for planning

<domain>
## Phase Boundary

Establishing the core Flutter 3.x project structure, dependency injection roots, and architectural standards that will support the entire FitKarma ecosystem (Offline-sync, AI, and Cultural Premium UI).

</domain>

<decisions>
## Implementation Decisions

### Clean Architecture & Project Structure
- **Organization**: Feature-First folder structure (e.g., `features/steps/` containing `data/`, `domain/`, `presentation/`).
- **Data Flow**: Use **Explicit Mappers** to convert between database Models (Hive/JSON) and Pure Dart Entities.
- **Domain Privacy**: Domain layer must be **Pure Dart** (zero Flutter dependencies).
- **Scaffolding**: Use **Mason (Bricks)** to automate feature folder creation and maintain consistency.
- **Modularization**: Single-Package project for MVP speed, but with strict boundary enforcement within feature layers.
- **UI Architecture**: A standalone **Design System Package** will house all "Cultural Premium" Glassmorphic widgets.
- **Resilience**: Implement the **Adapter Pattern** for all third-party integrations (Storage, Sensors, APIs).

### Environment & Configuration
- **Secrets Management**: Use **`dart-define`** compile-time flags for API keys and sensitive settings.
- **Flavors**: Full **Dev/Prod Flavor** separation (different Bundle IDs/App IDs).
- **Initialization**: Centralized Dependency Injection loaded at app startup.
- **CI/CD**: Credentials managed via **GitHub Secrets**.

### State Management (Riverpod)
- **Code Generation**: Use **Riverpod Generator** (`@riverpod`) for all providers.
- **Logic Handling**: Business logic resides in **Notifier/Controller** classes.
- **State Pattern**: **Functional/Immutable** states using **Freezed** and the **AsyncValue** pattern for loading/error/data transitions.

### Claude's Discretion
- File naming conventions (standard Flutter/Dart package norms).
- Selection of specific linting rules (`flutter_lints` or `very_good_analysis`).
- Folder naming for the design system package (e.g., `packages/fitkarma_ui`).

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- None (New project initialization).

### Established Patterns
- New patterns established in this phase will serve as the reference for all future development.

### Integration Points
- This phase creates the root `main_development.dart` and `main_production.dart` entry points.

</code_context>

<specifics>
## Specific Ideas
- The design system should prioritize "Glassmorphism" as the base aesthetic for cards and overlays.
- Standardized error handling wrapper for the Adapter layer.

</specifics>

<deferred>
## Deferred Ideas
- Implementation of the actual Step Tracking logic (Phase 4).
- Implementation of the AI Chatbot backend sync (Phase 10).

</deferred>

---

*Phase: 01-foundation-architecture*
*Context gathered: 2026-03-09*
