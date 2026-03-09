# FitKarma

## What This Is

FitKarma is India's most affordable and culturally-rich fitness application. It combines offline-first reliability, gamification through "Karma" points, and privacy-centric design to help users track steps, log food, and perform workouts while remaining culturally relevant to the Indian lifestyle.

## Core Value

Empower users to improve their health through culturally-relevant fitness tracking and gamified rewards with zero recurring API costs and absolute privacy.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] **Offline-First Sync**: Seamless data synchronization between Hive (local) and PocketBase (remote).
- [ ] **Cultural Fitness Experience**: Integration of Indian food database, Yoga, Bollywood workouts, and Ayurveda.
- [ ] **Gamified Rewards (Karma)**: Earning and redeeming "Karma" points for daily activities and streaks.
- [ ] **Privacy-Centric Health Logs**: Encrypted storage of medical reports and sensitive health data.
- [ ] **Zero-Cost Infrastructure**: Self-hosted PocketBase on Railway with no recurring API costs (using free tiers).
- [ ] **Multi-Modal Logging**: Food logging via AI OCR, Voice assistant, and Barcode scanning.
- [ ] **Community & Challenges**: Real-time group challenges, leaderboards, and social posting.
- [ ] **Wearable Integration**: Health Connect (Android) and HealthKit (iOS) support.

### Out of Scope

- [ ] **Paid External APIs** — To maintain the "affordable" goal, any API with recurring monthly costs is excluded in favor of free tiers or on-device processing.
- [ ] **Centralized Data Sharing** — In line with privacy-first principles, medical data is never shared with third parties.

## Context

FitKarma aims to disrupt the fitness app market in India by removing the friction of high subscription costs and generic Westernized content. By using a modern tech stack (Flutter, Riverpod, PocketBase) and prioritizing offline capabilities, it caters to users with varying internet connectivity and budget constraints.

## Constraints

- **Tech Stack**: Flutter 3.x, Riverpod 2.x, Hive, PocketBase (Self-hosted) — Ensures cross-platform performance and low infrastructure costs.
- **Performance**: App size < 50MB, Dashboard load < 1 second — Critical for user retention on mid-range devices.
- **Cost**: Zero recurring API costs — Use Google ML Kit (on-device), Open Food Facts, and OpenStreetMap.
- **Deployment**: PocketBase on Railway.app — Provides automated SSL and managed hosting at low cost.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| **PocketBase** | Self-hosted, open-source alternative to Firebase; handles Auth, DB, and Files with real-time SSE. | — Pending |
| **Hive** | High-performance NoSQL local storage for offline-first experience. | — Pending |
| **Riverpod** | Robust state management and dependency injection for reactive UI. | — Pending |
| **Google ML Kit** | On-device OCR for food labels and medical reports to ensure privacy and zero cost. | — Pending |

---
*Last updated: 2026-03-09 after initialization*
