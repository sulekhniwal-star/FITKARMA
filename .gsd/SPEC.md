# SPEC.md — Project Specification

> **Status**: `FINALIZED`

## Vision
To build India's most affordable, culturally-rich, and privacy-centric fitness app. FitKarma provides a holistic health experience—from Ayurvedic dosha tracking and regional food logging to chronic disease management—delivered via a stunning, offline-first Flutter application.

## Goals
1. **Offline-First Excellence**: Ensure 100% functionality for core health tracking (food, steps, workouts) without an active internet connection using Hive.
2. **Indian Cultural Integration**: Deliver a deeply localized experience with 8+ regional languages, a comprehensive Indian food database, and Ayurvedic principles (Dinacharya/Ritucharya).
3. **Privacy & Security**: Implement client-side AES-256 encryption for sensitive medical and reproductive health data before any sync to Appwrite.
4. **Universal Premium Design**: Implement a consistent visual language across all 30+ modules based on the reference mockups (concentric activity rings, karma XP systems, bilingual navigation, warm color palette, and premium card layouts). Every screen must feel like a natural extension of the dashboard UI.

## Non-Goals (Out of Scope)
- **External API Dependency**: Core logic will not rely on paid external APIs (e.g., GPT-4 for logging) to keep user costs zero.
- **Social Media Integration**: In version 1.0, we will not prioritize Facebook/Instagram sharing; the focus is on personal health logs.
- **Hardware Manufacturing**: Integration with third-party wearables (Fitbit/Garmin) is in scope, but proprietary hardware is not.

## Users
- **Primary**: Health-conscious Indian users across all connectivity tiers (2G to 5G).
- **Secondary**: Individuals managing chronic conditions (diabetes, hypertension) needing regular metric logging.
- **Experience**: Users looking for a "gamified" but culturally relevant path to fitness (Karma coins/XP).

## Constraints
- **Technical**: Flutter 3.x, Riverpod 2.x (with code gen), Hive Flutter, Appwrite.
- **Efficiency**: App size target < 50MB; Dashboard load < 1 second.
- **Geography**: Must support English + 8 Indian regional languages.
- **Security**: Server must never hold plaintext for sensitive medical records.

## Success Criteria
- [ ] Sub-1s cold start to dashboard on mid-range Android devices.
- [ ] 100% accuracy in offline-to-online sync for food and activity logs.
- [ ] Successful client-side encryption of period and medical logs.
- [ ] Full bilingual support (English/Hindi) across 100% of the UI.
- [ ] UI consistency: All screens conform to the design system established in the reference mockup.
