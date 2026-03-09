# Roadmap: FitKarma

## Overview

FitKarma will be built using a **Local-First** approach, prioritizing the development of core fitness and wellness features within the Flutter application before establishing the centralized backend. This ensures that the user experience is robust offline and that the PocketBase schema perfectly reflects the app's final requirements.

## Phases

- [x] **Phase 1: Foundation & Architecture** - Initialize project with Clean Architecture and Riverpod.
- [x] **Phase 2: Theming & Brand Identity** - Implement Dosha-adaptive themes and Glassmorphic design.
- [ ] **Phase 3: Secure Local Storage** - Setup Hive with AES-256 encryption.
- [ ] **Phase 4: Core Loop - Step Tracking** - Native pedometer integration and real-time dashboard UI.
- [ ] **Phase 5: Nutrition Engine (Ingestion)** - Multi-source search and barcode scanning.
- [ ] **Phase 6: Nutrition Engine (Logging)** - Manual entries, macros, and on-device label OCR.
- [ ] **Phase 7: Ayurvedic Brain** - Dosha quiz engine and daily personalization logic.
- [ ] **Phase 8: AI Chatbot (Karma Buddy)** - Offline NLP logging and internal intent classification.
- [ ] **Phase 9: Gamification Mechanics** - Karma point earning logic and streak visualizations.
- [ ] **Phase 10: Backend Infrastructure** - PocketBase setup on Railway and collection configuration.
- [ ] **Phase 11: Sync & Real-time** - Offline-first sync engine and live leaderboards.
- [ ] **Phase 12: Support & Polish** - WhatsApp escalation bridge and final MVP validation.

## Phase Details

### Phase 1: Foundation & Architecture
**Goal**: Establish a scalable folder structure and state management base.
**Depends on**: Nothing
**Requirements**: CORE-01
**Success Criteria**:
  1. Flutter project compiles with no errors.
  2. Clean Architecture folders (core, data, domain, presentation) exist.
  3. Riverpod providers are initialized and accessible.
**Plans**: 1 plan

### Phase 2: Theming & Brand Identity
**Goal**: Implement the "Cultural Premium" look and feel.
**Depends on**: Phase 1
**Requirements**: CORE-05
**Success Criteria**:
  1. App can switch between Vata, Pitta, and Kapha color palettes.
  2. Glassmorphic card components are available for UI building.
  3. Custom Indian-heritage typography (Noto Sans Indic) is configured.
**Plans**: 1 plan

### Phase 3: Secure Local Storage
**Goal**: Enable high-performance, encrypted offline data storage.
**Depends on**: Phase 2
**Requirements**: CORE-02
**Success Criteria**:
  1. Hive boxes are initialized with AES-256 keys from secure storage.
  2. Basic CRUD operations on local boxes are verified.
**Plans**: 1 plan

### Phase 4: Core Loop - Step Tracking
**Goal**: Deliver the primary value proposition of movement tracking.
**Depends on**: Phase 3
**Requirements**: STEP-01, STEP-03
**Success Criteria**:
  1. Steps are tracked in the background on Android/iOS.
  2. Dashboard shows a Glassmorphic progress ring updating in real-time.
**Plans**: 2 plans

### Phase 5: Nutrition Engine (Ingestion)
**Goal**: Build the search and discovery layer for food logging.
**Depends on**: Phase 4
**Requirements**: FOOD-01, FOOD-02
**Success Criteria**:
  1. Users can search for Indian food items locally and via OFF API.
  2. Scanning a barcode returns accurate nutritional data.
**Plans**: 2 plans

### Phase 6: Nutrition Engine (Logging)
**Goal**: Complete the food logging experience with OCR and detailed macros.
**Depends on**: Phase 5
**Requirements**: FOOD-03, FOOD-04
**Success Criteria**:
  1. Users can log meals with custom portion sizes.
  2. On-device OCR extracts info from packaged food labels.
**Plans**: 2 plans

### Phase 7: Ayurvedic Brain
**Goal**: Integrate the Dosha quiz and recommendation logic.
**Depends on**: Phase 6
**Requirements**: AYUR-01, AYUR-03
**Success Criteria**:
  1. 20-question quiz determines user's Prakriti/Vikriti.
  2. App suggests daily tips based on weather and Dosha.
**Plans**: 1 plan

### Phase 8: AI Chatbot (Karma Buddy)
**Goal**: Implement natural language interaction and logging.
**Depends on**: Phase 7
**Requirements**: CHAT-01, CHAT-04
**Success Criteria**:
  1. Users can log "2 rotis" via text chat.
  2. Chat history is viewable offline.
**Plans**: 2 plans

### Phase 9: Gamification Mechanics
**Goal**: Drive retention through rewards and streaks.
**Depends on**: Phase 8
**Requirements**: KARM-01, KARM-02
**Success Criteria**:
  1. Karma points are added for logging activities.
  2. Streaks are visualized with blooming "Karma Seeds."
**Plans**: 1 plan

### Phase 10: Backend Infrastructure
**Goal**: Establish the centralized persistence layer.
**Depends on**: Phase 9
**Requirements**: CORE-03, AUTH-01, AUTH-02
**Success Criteria**:
  1. PocketBase is live on Railway with SSL.
  2. Collections (users, food_logs, etc.) match app data structures.
  3. User can sign up/in via PocketBase.
**Plans**: 2 plans

### Phase 11: Sync & Real-time
**Goal**: Connect local data to the cloud and enable community features.
**Depends on**: Phase 10
**Requirements**: CORE-04, STEP-02, KARM-03
**Success Criteria**:
  1. Data syncs between Hive and PocketBase automatically.
  2. Leaderboards update via server-sent events (SSE).
**Plans**: 2 plans

### Phase 12: Support & Polish
**Goal**: Final safety net and MVP-ready verification.
**Depends on**: Phase 11
**Requirements**: CHAT-02, CHAT-03
**Success Criteria**:
  1. Chatbot escalates to WhatsApp support on frustration detection.
  2. Deep links pass conversation context to support team.
**Plans**: 1 plan

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation & Architecture | 1/1 | Complete | 2026-03-09 |
| 2. Theming & Brand Identity | 1/1 | Complete | 2026-03-09 |
| 3. Secure Local Storage | 0/1 | Not started | - |
| 4. Core Loop - Step Tracking | 0/2 | Not started | - |
| 5. Nutrition Engine (Ingestion) | 0/2 | Not started | - |
| 6. Nutrition Engine (Logging) | 0/2 | Not started | - |
| 7. Ayurvedic Brain | 0/1 | Not started | - |
| 8. AI Chatbot (Karma Buddy) | 0/2 | Not started | - |
| 9. Gamification Mechanics | 0/1 | Not started | - |
| 10. Backend Infrastructure | 0/2 | Not started | - |
| 11. Sync & Real-time | 0/2 | Not started | - |
| 12. Support & Polish | 0/1 | Not started | - |

---
*Roadmap defined: 2026-03-09*
