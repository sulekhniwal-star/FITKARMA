# Requirements: FitKarma

**Defined:** 2026-03-09
**Core Value:** Empower users to improve their health through culturally-relevant fitness tracking, gamified rewards, and absolute privacy, all with zero recurring API costs.

## v1 Requirements (MVP)

### Infrastructure & Core (Local First)
> [!NOTE]
> PocketBase and backend setup (CORE-03) will be handled after frontend features are solidified to ensure all collection requirements are captured.

- [ ] **CORE-01**: Initialize Flutter 3.x project with Clean Architecture and Riverpod 2.x.
- [ ] **CORE-02**: Setup Hive local storage with AES-256 encryption for sensitive boxes.
- [ ] **CORE-03**: Self-host PocketBase on Railway with automated SSL and SQLite volume persistence.
- [ ] **CORE-04**: Implement Offline-First Sync Engine with a `PendingSyncBox` and "Last-Write-Wins" conflict resolution.
- [ ] **CORE-05**: Implement a Dynamic Color Theme factory supporting Vata, Pitta, and Kapha palettes.

### Authentication
- [ ] **AUTH-01**: User can sign up/in with Email and Password via PocketBase.
- [ ] **AUTH-02**: User can sign in using Google OAuth2.
- [ ] **AUTH-03**: Auth tokens are securely stored in `flutter_secure_storage`.
- [ ] **AUTH-04**: Automated session restoration on app launch.

### Step Tracking (Core Loop)
- [ ] **STEP-01**: Foreground and background step tracking via `pedometer` (Android/iOS).
- [ ] **STEP-02**: Daily step logs stored in Hive and synced weekly to PocketBase.
- [ ] **STEP-03**: Dashboard displays real-time step count with a Glassmorphic progress ring.

### Nutrition (Food Log)
- [ ] **FOOD-01**: Search local Hive database (Table Stakes) and Open Food Facts API for food items.
- [ ] **FOOD-02**: Barcode scanning via `barcode_scan2` to fetch nutritional data from Open Food Facts.
- [ ] **FOOD-03**: Manual food entry with calories, macros, and Indian portion sizes.
- [ ] **FOOD-04**: On-device OCR (ML Kit) to extract nutritional info from packaged food labels.

### Ayurvedic Integration
- [ ] **AYUR-01**: Interactive Dosha Quiz (20 questions) to determine Prakriti and Vikriti.
- [ ] **AYUR-02**: Dashboard theme and greetings adapt based on current user Dosha.
- [ ] **AYUR-03**: Daily "Dosha Tip" generated based on weather, time, and user constitution.

### AI Chatbot & Support
- [ ] **CHAT-01**: "Karma Buddy" AI chatbot for health queries and NLP food logging ("Ate 2 chapatis").
- [ ] **CHAT-02**: Detection of frustration or "human" keywords to trigger escalation.
- [ ] **CHAT-03**: One-tap escalation to WhatsApp Support with context summary in deep link.
- [ ] **CHAT-04**: Offline chat history viewing from local Hive box.

### Karma System (Gamification)
- [ ] **KARM-01**: Earn Karma points for daily goals (Steps, Food Log, Water).
- [ ] **KARM-02**: Daily Streaks (visualized with blooming "Karma Seeds").
- [ ] **KARM-03**: Real-time Global and Regional Leaderboards (via PocketBase SSE).

## v2 Requirements (Post-MVP)

### Advanced Health
- **HEAL-01**: Medical Report OCR to extract Hb, Sugar, and Blood Pressure trends.
- **HEAL-02**: AI-driven "Readiness" score synthesizing wearable data and Ayurvedic state.
- **HEAL-03**: Integration with Health Connect (Android) and HealthKit (iOS).

### Advanced Workouts
- **WORK-01**: YouTube-based workout player with metadata caching.
- **WORK-02**: Offline workout video caching (Downloads).
- **WORK-03**: On-device Pose Detection for real-time Yoga posture correction.

### Subscriptions
- **SUBS-01**: Premium plans (Monthly/Yearly) integration via Razorpay.
- **SUBS-02**: Karma Store for redeeming digital rewards and partner discounts.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Paid Health APIs | Violates "Zero recurring API costs" principle. |
| Third-party Data Sales | Violates "Absolute Privacy" principle. |
| Non-Indian Food DBs | To maintain "Culturally Rich" focus and minimize app size. |
| Real-time Video Streaming | High infrastructure cost for a free-tier backend. |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| CORE-01 | Phase 1 | Pending |
| CORE-05 | Phase 2 | Pending |
| CORE-02 | Phase 3 | Pending |
| STEP-01 | Phase 4 | Pending |
| STEP-03 | Phase 4 | Pending |
| FOOD-01 | Phase 5 | Pending |
| FOOD-02 | Phase 5 | Pending |
| FOOD-03 | Phase 6 | Pending |
| FOOD-04 | Phase 6 | Pending |
| AYUR-01 | Phase 7 | Pending |
| AYUR-03 | Phase 7 | Pending |
| CHAT-01 | Phase 8 | Pending |
| CHAT-04 | Phase 8 | Pending |
| KARM-01 | Phase 9 | Pending |
| KARM-02 | Phase 9 | Pending |
| CORE-03 | Phase 10 | Pending |
| AUTH-01 | Phase 10 | Pending |
| AUTH-02 | Phase 10 | Pending |
| CORE-04 | Phase 11 | Pending |
| STEP-02 | Phase 11 | Pending |
| KARM-03 | Phase 11 | Pending |
| CHAT-02 | Phase 12 | Pending |
| CHAT-03 | Phase 12 | Pending |

**Coverage:**
- v1 requirements: 23 total
- Mapped to phases: 23
- Unmapped: 0 ✓
