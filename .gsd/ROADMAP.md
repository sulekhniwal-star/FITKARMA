# ROADMAP.md

> **Current Phase**: Not started
> **Milestone**: v1.0 (MVP)

## Must-Haves (from SPEC)
- [ ] **Offline-First Storage**: Core tracking data (food, steps, workouts) in Hive with sync.
- [ ] **Indian Food Database**: Local storage with English and Hindi names.
- [ ] **Bilingual UI**: Every core label/header/nav in English + Hindi.
- [ ] **AES-256 Encryption**: Client-side encryption for period, medical, and BP data.
- [ ] **Riverpod Architecture**: All logic and data fetch using code-gen.

## Phases

### Phase 1: Foundation & Architecture
**Status**: âœ… Complete
**Objective**: Establish the core folder structure, theme (orange/purple), navigation (GoRouter), and Hive initialization.
**Requirements**: REQ-01, REQ-09, REQ-12

### Phase 2: Shell & Dashboard UI
**Status**: âœ… Complete
**Objective**: Implement the Dashboard layout with custom Concentric Activity Rings, Bilingually-labelled Bottom Nav, and the Amber Insight Card.
**Requirements**: REQ-04, REQ-07, REQ-08

### Phase 3: Local Activity Tracking (Steps/Water/Workout)
**Status**: ✅ Complete
**Objective**: Build models and local Hive services for steps, water, and workouts. Update active rings in real-time.
**Requirements**: REQ-01, REQ-07

### Phase 4: Food Tracking & Indian Database
**Status**: Ã¢Â¬Å“ Not Started
**Objective**: Create the Food Logging screen, search bar (w/ microphone icon), and FoodItemCard. Store Indian food items locally.
**Requirements**: REQ-03, REQ-04

### Phase 5: Ayurveda & Gamification
**Status**: Ã¢Â¬Å“ Not Started
**Objective**: Implement the Karma Level card (XP system), Dosha Profile (Donut Chart), and the Challenges Carousel (Navratri Challenge).
**Requirements**: REQ-05, REQ-08

### Phase 6: Sync Engine & Medical Encryption
**Status**: Ã¢Â¬Å“ Not Started
**Objective**: Build the Appwrite sync engine and implement client-side AES-256 encryption for BP/Glucose/Medical/Period logs. Multi-language support (ARBs).
**Requirements**: REQ-02, REQ-06, REQ-11
