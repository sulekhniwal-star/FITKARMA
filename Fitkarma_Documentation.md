# FitKarma — Developer Documentation

> **Offline-First · Privacy-Centric · Built for India**
> Flutter 3.x · Riverpod 2.x · Hive · Appwrite

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [UI Design Reference](#2-ui-design-reference)
3. [Application Architecture](#3-application-architecture)
4. [Folder Structure](#4-folder-structure)
5. [Appwrite Setup](#5-appwrite-setup)
6. [Database Schema](#6-database-schema)
7. [Hive Local Storage](#7-hive-local-storage)
8. [Offline Sync Architecture](#8-offline-sync-architecture)
9. [Authentication & Onboarding](#9-authentication--onboarding)
10. [Core Feature Modules](#10-core-feature-modules)
11. [Advanced Feature Modules](#11-advanced-feature-modules)
12. [Health Monitoring Modules](#12-health-monitoring-modules)
13. [Lifestyle & Wellness Modules](#13-lifestyle--wellness-modules)
14. [Social & Community Modules](#14-social--community-modules)
15. [Platform & Infrastructure Modules](#15-platform--infrastructure-modules)
16. [Security & Privacy](#16-security--privacy)
17. [External API Integrations](#17-external-api-integrations)
18. [Performance Contracts](#18-performance-contracts)
19. [State Management](#19-state-management)
20. [Monetization & Subscriptions](#20-monetization--subscriptions)
21. [Testing Strategy](#21-testing-strategy)
22. [Coding Standards](#22-coding-standards)
23. [Environment Configuration](#23-environment-configuration)
24. [CI/CD Pipeline](#24-cicd-pipeline)

---

## 1. Project Overview

| Property             | Value                                                     |
|----------------------|-----------------------------------------------------------|
| App Name             | FitKarma                                                  |
| Tagline              | India's Most Affordable, Culturally-Rich Fitness App      |
| Bundle ID            | `com.fitkarma.app`                                        |
| Architecture         | Offline-first, server-synced via Appwrite                 |
| Tech Stack           | Flutter 3.x · Riverpod 2.x · Hive · Appwrite             |
| Target Market        | Indian users across all connectivity tiers (2G–5G)        |
| Languages            | English + 8 Indian regional languages                     |
| App Size Target      | < 50 MB                                                   |
| Dashboard Load       | < 1 second                                                |
| Total Feature Modules| 30+                                                       |

### Design Principles

- **Offline-first** — All writes go to Hive instantly; Appwrite is only touched during sync. Zero loading states for core actions.
- **Zero recurring API costs** — Critical data paths never depend on external APIs at runtime.
- **Privacy-first** — AES-256 encrypted medical and reproductive health data. No advertising SDKs. No data sold to third parties.
- **Culturally rich** — Indian food database, Ayurveda engine, festival calendar, and regional language support baked in.
- **Performance** — Sub-50 MB install size, < 2s cold start, < 1s dashboard render, < 3% battery drain per hour during background tracking.
- **Single backend** — Appwrite replaces all Firebase dependencies. No Firebase SDK except `firebase_messaging` for push tokens.
- **Comprehensive health coverage** — Blood pressure, glucose, mental health, wearable sync, meal planning, and chronic disease management modules.
- **Accessible** — Screen reader, font scaling, and high-contrast mode support built in.

---

## 2. UI Design Reference

> The following describes the UI design language established by the reference mockups. All screens and components must conform to these specifications.

### 2.1 Screen Inventory from Reference Mockups

#### Dashboard Screen
- **Header** — Avatar, greeting text ("Namaste, [Name] 🙏"), karma coin indicator (e.g. `1,250 XP`) and level badge (`Level 12 Warrior`) overlaid on the avatar.
- **Activity Rings** — Four concentric ring widgets arranged in a compact circle:
  - Ring 1 (outermost, orange): Calories — e.g. `1200 / 2000 kcal`
  - Ring 2 (green): Steps — e.g. `8,500 / 10,000`
  - Ring 3 (teal): Water — e.g. `4 / 8 glasses`
  - Ring 4 (purple): Active minutes — e.g. `35 / 60 mins`
- **Insight Card** — Amber/yellow card with a lightbulb icon and actionable nudge text (e.g. *"You're 18g protein short today. Adding a katori of dal to dinner will help!"*). Thumbs-up / thumbs-down rating buttons at the bottom right.
- **Today's Meals Section** — Horizontal row of meal-type tabs (Breakfast · Lunch · Dinner · Snacks). Each tab shows a food category icon and label.
- **Quick-Log FAB** — Orange circular floating action button with `+` icon, positioned at the bottom-right above the nav bar.
- **Bottom Navigation Bar** — 5 tabs with icons and bilingual labels (English + Hindi): Home (जैसे, मुख्यपृष्ठ) · Food · Workout · Steps · Me.

#### Food Logging Screen (`Log Breakfast`)
- **App bar** — Back arrow + screen title (e.g. `Log Breakfast`).
- **Search bar** — Bilingual placeholder (`Search food, or tap the mic... / खाना खोजें / स्कैन करें`), microphone icon on the right, barcode icon on the far right.
- **Quick-action chips** — Three pill-shaped buttons below the search bar: `📷 Scan Label` · `🍽 Upload Plate Photo` · `✏ Manual Entry`.
- **Frequent Indian Portions section** — `2 × N` grid of food cards. Each card shows:
  - Food photo (rounded corners)
  - Food name (bold, e.g. `Dal Tadka`)
  - Portion in Indian units (e.g. `1 Katori (150g)`)
  - Calorie count (e.g. `118 kcal`)
  - `+` circular button on the bottom-right of the card.
- **Recent Logs section** — List of past entries with thumbnail, name, portion, and a `+` button to re-log.

#### Karma & Ayurveda Screen (Me / Profile tab)
- **Karma Level card** — Dark purple/indigo gradient card showing:
  - `Karma Level` label
  - Linear progress bar
  - `XP needed for Level 13 (Warrior)` subtitle
  - Karma coin icon + XP count
  - Large level title (e.g. `Warrior`)
- **Dosha Profile card** — White card with:
  - Title: `Your Dosha Profile: 🌿 Vata-Pitta`
  - Donut chart with three colour segments (Vata / Pitta / Kapha)
  - Percentage legend (e.g. 45% Vata · 35% Pitta · 20% Kapha)
  - `View Seasonal Guidelines (Ritucharya)` outlined button
- **Daily Rituals (Dinacharya) section** — Checklist with checkbox + ritual name + completion indicator (green tick / empty circle).
- **Challenges Carousel** — Horizontally scrollable cards showing active challenges (e.g. `7-Day No Sugar Navratri Challenge`, progress bar, `Day 3/7`, reward `+200 XP`).

### 2.2 Visual Design System

| Token             | Value / Specification                                              |
|-------------------|--------------------------------------------------------------------|
| Primary colour    | Deep orange `#FF5722`                                              |
| Secondary colour  | Indigo / deep purple `#3F3D8F`                                     |
| Accent            | Amber `#FFC107` (insight cards, karma coins)                       |
| Background        | Warm off-white `#FDF6EC`                                           |
| Surface           | Pure white `#FFFFFF` cards with `8px` border radius and soft shadow|
| Typography        | System default (Roboto on Android, SF Pro on iOS); Hindi text rendered with Devanagari support |
| Ring stroke width | `10px` with `lineCap: round`                                       |
| Card elevation    | `2dp` shadow, `borderRadius: 12px`                                 |
| FAB colour        | Orange `#FF5722`, white `+` icon                                   |
| Bottom nav        | White background, active icon in primary orange, bilingual labels  |
| Chip / pill style | Outlined, `borderRadius: 20px`, icon prefix                        |
| Food card images  | `72 × 72px` rounded thumbnails                                     |

### 2.3 Bilingual UI Requirements

- All primary navigation labels, screen titles, and section headers must include the Hindi translation rendered beneath the English text.
- Food names in the Indian food database must include `name` (English) and `name_hi` (Devanagari script).
- Search bars on food-related screens display bilingual placeholder text.
- The bottom navigation bar renders bilingual labels using a two-line `Text` widget styled at `10sp` for the Hindi sub-label.

### 2.4 Component Library

All widgets below are part of the shared design system in `lib/shared/widgets/` and must not be re-implemented per screen.

| Component               | Location                            | Notes                                           |
|-------------------------|-------------------------------------|-------------------------------------------------|
| `ActivityRingsWidget`   | `shared/widgets/activity_rings.dart`| Four concentric rings, accepts progress 0.0–1.0 per ring |
| `InsightCard`           | `shared/widgets/insight_card.dart`  | Amber background, lightbulb icon, thumbs rating |
| `FoodItemCard`          | `shared/widgets/food_item_card.dart`| Photo, name, portion, kcal, `+` tap handler    |
| `KarmaLevelCard`        | `shared/widgets/karma_level_card.dart` | Dark gradient, progress bar, level title     |
| `DoshaDonutChart`       | `shared/widgets/dosha_chart.dart`   | Three-segment donut using `fl_chart`            |
| `ChallengeCarouselCard` | `shared/widgets/challenge_card.dart`| Horizontally scrollable, progress + XP reward  |
| `QuickLogFAB`           | `shared/widgets/quick_log_fab.dart` | Speed-dial FAB with sub-actions                |
| `MealTypeTabBar`        | `shared/widgets/meal_tab_bar.dart`  | Icon + label tabs; Breakfast / Lunch / Dinner / Snacks |
| `ShimmerLoader`         | `shared/widgets/shimmer_loader.dart`| Used in all async loading states               |
| `BilingualLabel`        | `shared/widgets/bilingual_label.dart` | English + Hindi stacked `Text` widgets       |

---

## 3. Application Architecture

### 3.1 Frontend

| Concern          | Choice                                                              |
|------------------|----------------------------------------------------------------------|
| Framework        | Flutter 3.x — single codebase for Android and iOS                  |
| Architecture     | Modular, feature-based Clean Architecture                           |
| State Management | Riverpod 2.x                                                        |
| Local Storage    | Hive — encrypted boxes, offline-first writes                        |
| Navigation       | GoRouter with deep-link support                                     |
| UI               | Custom design system with Indian cultural theming (see Section 2)   |
| Accessibility    | Screen reader, font scaling, high-contrast mode support             |

### 3.2 Backend (Appwrite)

| Concern          | Detail                                                              |
|------------------|----------------------------------------------------------------------|
| Auth             | Email/password, OAuth2, JWT sessions                                |
| Database         | Appwrite Databases — document-level permissions per user            |
| File Storage     | Appwrite Storage — avatars, post media                              |
| Real-time        | Appwrite Realtime (WebSocket) — live karma and social updates       |
| Server Functions | Appwrite Functions (Node.js) — FCM hooks, Razorpay webhooks, Fitbit token exchange |
| Hosting Options  | Appwrite Cloud (free tier) or self-hosted via Docker / Railway      |
| Admin Dashboard  | Internal content management — workouts, challenges, food DB seeding |

### 3.3 Data Flow

```
User Action
    │
    ▼
Write to Hive (local)          ← UI updates immediately, no loading state
    │
    ▼
Add to sync_queue_box
    │
    ▼  (background, when online)
Flush queue → Appwrite Databases  (batches of 20, exponential backoff)
    │
    ▼  (foreground, Appwrite Realtime)
Receive remote changes → Conflict resolution → Update Hive
```

> **Sensitive data rule**: Period, medical, BP, glucose, journal, and appointment records are AES-256 encrypted client-side before any Hive write or Appwrite sync. The server never holds plaintext.

---

## 4. Folder Structure

```
lib/
├── main.dart
├── app.dart                               # App root, GoRouter, theme
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_endpoints.dart             # Appwrite project/database/collection IDs
│   │   └── hive_boxes.dart
│   ├── di/
│   │   └── providers.dart                 # Root Riverpod providers
│   ├── errors/
│   │   ├── app_exception.dart
│   │   └── error_handler.dart
│   ├── network/
│   │   ├── appwrite_client.dart           # Appwrite singleton
│   │   ├── connectivity_service.dart
│   │   └── sync_queue.dart
│   ├── security/
│   │   ├── encryption_service.dart        # AES-256-GCM + PBKDF2
│   │   └── key_manager.dart
│   ├── storage/
│   │   ├── hive_service.dart
│   │   └── secure_storage.dart
│   └── utils/
│       ├── date_utils.dart
│       ├── indian_food_utils.dart
│       └── validators.dart
│
├── features/
│   ├── auth/                   # data/ domain/ presentation/
│   ├── dashboard/              # data/ domain/ presentation/
│   ├── food/
│   │   ├── data/
│   │   │   ├── food_repository.dart
│   │   │   ├── food_aw_service.dart
│   │   │   ├── food_hive_service.dart
│   │   │   ├── barcode_service.dart
│   │   │   ├── ocr_service.dart           # Google ML Kit
│   │   │   └── voice_food_service.dart
│   │   ├── domain/
│   │   │   ├── food_item_model.dart
│   │   │   └── food_log_model.dart
│   │   └── presentation/
│   ├── workout/                # data/ domain/ presentation/
│   ├── steps/                  # data/ domain/ presentation/
│   ├── sleep/                  # data/ domain/ presentation/
│   ├── mood/                   # data/ domain/ presentation/
│   ├── period/                 # data/ (AES-encrypted) domain/ presentation/
│   ├── medications/            # data/ domain/ presentation/
│   ├── body_metrics/           # data/ domain/ presentation/
│   ├── habits/                 # data/ domain/ presentation/
│   ├── nutrition/              # data/ domain/ presentation/
│   ├── ayurveda/               # data/ domain/ presentation/
│   ├── family/                 # data/ domain/ presentation/
│   ├── emergency/              # data/ domain/ presentation/
│   ├── festival/               # data/ domain/ presentation/
│   ├── karma/                  # data/ domain/ presentation/
│   ├── social/                 # data/ domain/ presentation/
│   ├── insight_engine/
│   │   └── rule_engine.dart    # On-device only, zero server calls
│   ├── blood_pressure/         # data/ domain/ presentation/
│   ├── glucose/                # data/ domain/ presentation/
│   ├── spo2/                   # data/ domain/ presentation/
│   ├── doctor_appointments/    # data/ domain/ presentation/
│   ├── chronic_disease/        # data/ domain/ presentation/
│   ├── meal_planner/           # data/ domain/ presentation/
│   ├── recipe_builder/         # data/ domain/ presentation/
│   ├── fasting_tracker/        # data/ domain/ presentation/
│   ├── mental_health/          # data/ domain/ presentation/
│   ├── meditation/             # data/ domain/ presentation/
│   ├── journal/                # data/ domain/ presentation/
│   ├── community/              # data/ domain/ presentation/
│   ├── wearables/              # data/ domain/ presentation/
│   ├── reports/                # data/ domain/ presentation/
│   ├── personal_records/       # data/ domain/ presentation/
│   └── settings/               # data/ domain/ presentation/
│
├── shared/
│   ├── widgets/
│   │   ├── activity_rings.dart
│   │   ├── insight_card.dart
│   │   ├── food_item_card.dart
│   │   ├── karma_level_card.dart
│   │   ├── dosha_chart.dart
│   │   ├── challenge_card.dart
│   │   ├── quick_log_fab.dart
│   │   ├── meal_tab_bar.dart
│   │   ├── shimmer_loader.dart
│   │   └── bilingual_label.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── app_colors.dart
│       └── app_text_styles.dart
│
└── l10n/                       # 8 Indian regional languages
    ├── app_en.arb
    ├── app_hi.arb
    ├── app_ta.arb
    ├── app_te.arb
    ├── app_kn.arb
    ├── app_mr.arb
    ├── app_bn.arb
    └── app_gu.arb
```

> **Naming convention**: Backend service files use `_aw_service.dart` suffix. Local storage files use `_hive_service.dart` suffix.

---

## 5. Appwrite Setup

### 5.1 Deployment Options

| Option               | Command / URL                                            | Notes                          |
|----------------------|----------------------------------------------------------|--------------------------------|
| Appwrite Cloud       | [cloud.appwrite.io](https://cloud.appwrite.io)           | Free tier, zero ops overhead   |
| Self-hosted (Docker) | `docker run appwrite/appwrite`                           | Any VPS, single command        |
| Railway              | Deploy via Railway Appwrite template                     | Managed hosting alternative    |

### 5.2 Appwrite Client Singleton

```dart
// lib/core/network/appwrite_client.dart
import 'package:appwrite/appwrite.dart';

class AppwriteClient {
  static final Client _client = Client()
    ..setEndpoint(AppConfig.appwriteEndpoint)
    ..setProject(AppConfig.appwriteProjectId);

  static Client    get client    => _client;
  static Account   get account   => Account(_client);
  static Databases get databases => Databases(_client);
  static Storage   get storage   => Storage(_client);
  static Realtime  get realtime  => Realtime(_client);
  static Functions get functions => Functions(_client);
}
```

### 5.3 Collection ID Constants

```dart
// lib/core/constants/api_endpoints.dart
class AW {
  // Project
  static const projectId  = String.fromEnvironment('APPWRITE_PROJECT_ID');
  static const endpoint   = String.fromEnvironment('APPWRITE_ENDPOINT');
  static const dbId       = String.fromEnvironment('APPWRITE_DATABASE_ID');

  // Core collections
  static const users            = 'users';
  static const foodLogs         = 'food_logs';
  static const foodItems        = 'food_items';
  static const workoutLogs      = 'workout_logs';
  static const stepLogs         = 'step_logs';
  static const sleepLogs        = 'sleep_logs';
  static const moodLogs         = 'mood_logs';
  static const periodLogs       = 'period_logs';
  static const medications      = 'medications';
  static const habits           = 'habits';
  static const bodyMeasurements = 'body_measurements';
  static const karmaTx          = 'karma_transactions';
  static const nutritionGoals   = 'nutrition_goals';
  static const posts            = 'posts';
  static const challenges       = 'challenges';
  static const subscriptions    = 'subscriptions';
  static const familyGroups     = 'family_groups';
  static const workouts         = 'workouts';

  // Extended collections
  static const bloodPressureLogs  = 'blood_pressure_logs';
  static const glucoseLogs        = 'glucose_logs';
  static const spo2Logs           = 'spo2_logs';
  static const doctorAppointments = 'doctor_appointments';
  static const fastingLogs        = 'fasting_logs';
  static const mealPlans          = 'meal_plans';
  static const recipes            = 'recipes';
  static const journalEntries     = 'journal_entries';
  static const personalRecords    = 'personal_records';
  static const communityGroups    = 'community_groups';
  static const healthReports      = 'health_reports';
  static const communityDms       = 'community_dms';

  // Storage Buckets
  static const avatarsBucket   = 'avatars';
  static const postsBucket     = 'posts_media';
}
```

### 5.4 Console Configuration Checklist

- [ ] Create database and note the `DATABASE_ID`
- [ ] Create all core collections listed in `AW` constants above
- [ ] Create all 12 extended collections
- [ ] Set document-level permissions on every collection: `Role.user({userId})` for read/write
- [ ] Enable Google OAuth2 under Auth → OAuth2 Providers
- [ ] Enable SMTP under Settings → SMTP (password reset emails)
- [ ] Create Storage buckets: `avatars`, `posts_media`
- [ ] Deploy Appwrite Functions: FCM hooks, Razorpay webhook, Fitbit token exchange, Garmin token exchange
- [ ] Configure API rate limiting
- [ ] Set up daily database export cron for disaster recovery

---

## 6. Database Schema

> All collections live in a single Appwrite Database. Document IDs are auto-generated via `ID.unique()`. Every collection enforces document-level permissions — users can only access their own records.

### `users`

| Field               | Type     | Notes                                                           |
|---------------------|----------|-----------------------------------------------------------------|
| `$id`               | string   | Appwrite auto ID — matches Auth `userId`                        |
| `name`              | string   | Display name                                                    |
| `email`             | email    | Unique, synced from Auth                                        |
| `dob`               | datetime |                                                                 |
| `gender`            | enum     | `male` / `female` / `other` / `prefer_not`                      |
| `height_cm`         | double   |                                                                 |
| `weight_kg`         | double   |                                                                 |
| `goal`              | enum     | `lose_weight` / `gain_muscle` / `maintain` / `endurance`        |
| `activity_level`    | enum     | `sedentary` / `light` / `moderate` / `active` / `very_active`  |
| `dosha_type`        | enum     | `vata` / `pitta` / `kapha` / compound types                     |
| `blood_group`       | enum     | `A+` / `A-` / `B+` / `B-` / `O+` / `O-` / `AB+` / `AB-`      |
| `language`          | enum     | `en` / `hi` / `ta` / `te` / `kn` / `mr` / `bn` / `gu`         |
| `subscription_tier` | enum     | `free` / `premium` / `family`                                   |
| `karma_total`       | integer  | Total XP accumulated                                            |
| `karma_level`       | integer  | Level 1–50                                                      |
| `is_low_data_mode`  | boolean  | Enables 2G/3G optimisations                                     |
| `chronic_conditions`| string   | JSON: `["diabetes","hypertension"]`                             |
| `wearable_source`   | enum     | `fitbit` / `garmin` / `mi_band` / `boat` / `none`              |
| `referral_code`     | string   | Unique code for referral program                                |
| `referred_by`       | string   | Referrer `user_id` (nullable)                                   |
| `$createdAt`        | datetime | Auto                                                            |
| `$updatedAt`        | datetime | Auto                                                            |

### `food_logs`

| Field          | Type     | Notes                                                           |
|----------------|----------|-----------------------------------------------------------------|
| `$id`          | string   | Auto                                                            |
| `user_id`      | string   | Relation → `users.$id`                                          |
| `food_item_id` | string   | Relation → `food_items` (nullable)                              |
| `recipe_id`    | string   | Relation → `recipes` (nullable)                                 |
| `food_name`    | string   | Denormalised for offline reads                                  |
| `meal_type`    | enum     | `breakfast` / `lunch` / `dinner` / `snack`                     |
| `quantity_g`   | double   | Grams consumed                                                  |
| `calories`     | double   |                                                                 |
| `protein_g`    | double   |                                                                 |
| `carbs_g`      | double   |                                                                 |
| `fat_g`        | double   |                                                                 |
| `fiber_g`      | double   | Optional                                                        |
| `logged_at`    | datetime |                                                                 |
| `log_method`   | enum     | `search` / `barcode` / `ocr` / `voice` / `photo` / `recipe` / `planner` |
| `sync_status`  | enum     | `synced` / `pending` / `conflict`                               |

### `food_items`

| Field               | Type    | Notes                                              |
|---------------------|---------|----------------------------------------------------|
| `$id`               | string  | Auto                                               |
| `name`              | string  |                                                    |
| `name_hi`           | string  | Hindi / Devanagari name                            |
| `barcode`           | string  | EAN-13 (nullable)                                  |
| `calories_per_100g` | double  |                                                    |
| `protein_per_100g`  | double  |                                                    |
| `carbs_per_100g`    | double  |                                                    |
| `fat_per_100g`      | double  |                                                    |
| `is_indian`         | boolean | Flag for Indian food items                         |
| `serving_sizes`     | string  | JSON: `[{"name":"katori","grams":150}]`            |
| `source`            | enum    | `openfoodfacts` / `manual` / `community` / `restaurant` |
| `restaurant_name`   | string  | e.g. `"Swiggy — McDonald's"` (nullable)            |

### `workout_logs`

| Field            | Type     | Notes                                                        |
|------------------|----------|--------------------------------------------------------------|
| `user_id`        | string   | Relation → `users`                                           |
| `workout_id`     | string   | Relation → `workouts` (nullable)                             |
| `workout_name`   | string   | Denormalised                                                 |
| `duration_min`   | integer  |                                                              |
| `calories_burned`| double   |                                                              |
| `workout_type`   | enum     | `youtube` / `gps_outdoor` / `structured` / `custom`          |
| `gps_route`      | string   | JSON array of `{lat, lng}` points                            |
| `distance_km`    | double   | GPS workouts only                                            |
| `sets_data`      | string   | JSON: `[{"exercise","sets","reps","kg"}]`                    |
| `avg_heart_rate` | integer  | bpm — from wearable if available                             |
| `hr_zone`        | enum     | `zone1` / `zone2` / `zone3` / `zone4` / `zone5`             |
| `logged_at`      | datetime |                                                              |
| `sync_status`    | enum     | `synced` / `pending` / `conflict`                            |

### `step_logs`

| Field            | Type     | Notes                                              |
|------------------|----------|----------------------------------------------------|
| `user_id`        | string   | Relation → `users`                                 |
| `date`           | datetime | One record per day                                 |
| `steps`          | integer  |                                                    |
| `distance_km`    | double   |                                                    |
| `calories_burned`| double   |                                                    |
| `goal_steps`     | integer  | Daily target                                       |
| `source`         | enum     | `pedometer` / `health_connect` / `healthkit` / `wearable` |
| `sync_status`    | enum     |                                                    |

### `sleep_logs`

| Field           | Type     | Notes                                              |
|-----------------|----------|----------------------------------------------------|
| `user_id`       | string   | Relation → `users`                                 |
| `date`          | datetime |                                                    |
| `bedtime`       | string   | `HH:MM`                                            |
| `wake_time`     | string   | `HH:MM`                                            |
| `duration_min`  | integer  |                                                    |
| `quality_score` | integer  | 1–5 emoji scale                                    |
| `deep_sleep_min`| integer  | From HealthKit / Health Connect                    |
| `notes`         | string   |                                                    |
| `source`        | enum     | `manual` / `health_connect` / `healthkit` / `wearable` |

### `mood_logs`

| Field            | Type     | Notes                                              |
|------------------|----------|----------------------------------------------------|
| `user_id`        | string   | Relation → `users`                                 |
| `logged_at`      | datetime |                                                    |
| `mood_score`     | integer  | 1–5                                                |
| `energy_level`   | integer  | 1–10                                               |
| `stress_level`   | integer  | 1–10                                               |
| `tags`           | string   | JSON: `["anxious","focused","tired"]`              |
| `voice_note_path`| string   | Local device path only — **never uploaded**        |
| `screen_time_min`| integer  | From Digital Wellbeing / Screen Time (optional)    |

### `period_logs`

> ⚠️ **All fields are AES-256 encrypted client-side before any storage or sync. Sync to Appwrite is opt-in only — default is local-only.**

| Field            | Type     | Notes                          |
|------------------|----------|--------------------------------|
| `user_id`        | string   | Relation → `users`             |
| `cycle_start`    | datetime | Encrypted before write         |
| `cycle_end`      | datetime | Encrypted before write         |
| `flow_intensity` | string   | Encrypted enum                 |
| `symptoms`       | string   | Encrypted JSON array           |
| `notes`          | string   | Encrypted                      |
| `sync_enabled`   | boolean  | User opt-in only, default false|

### `medications`

| Field        | Type     | Notes                                                      |
|--------------|----------|------------------------------------------------------------|
| `user_id`    | string   | Relation → `users`                                         |
| `name`       | string   |                                                            |
| `dosage`     | string   | e.g. `500mg`                                               |
| `frequency`  | string   | JSON: `{"times":["08:00","20:00"],"days":"daily"}`         |
| `start_date` | datetime |                                                            |
| `end_date`   | datetime | Nullable                                                   |
| `refill_date`| datetime | Alert triggered 3 days before                              |
| `is_active`  | boolean  |                                                            |
| `category`   | enum     | `prescription` / `otc` / `supplement` / `ayurvedic`        |

### `habits`

| Field            | Type    | Notes                                              |
|------------------|---------|----------------------------------------------------|
| `user_id`        | string  | Relation → `users`                                 |
| `name`           | string  |                                                    |
| `icon`           | string  | Emoji or icon name                                 |
| `target_count`   | integer | e.g. `8` for glasses of water                      |
| `unit`           | string  | `glasses` / `minutes` / `pages`                    |
| `frequency`      | enum    | `daily` / `weekdays` / `custom`                    |
| `current_streak` | integer |                                                    |
| `longest_streak` | integer |                                                    |
| `reminder_time`  | string  | `HH:MM` (nullable)                                 |
| `is_preset`      | boolean | Preset habit vs user-defined                       |

### `body_measurements`

| Field         | Type     | Notes              |
|---------------|----------|--------------------|
| `user_id`     | string   | Relation → `users` |
| `date`        | datetime |                    |
| `weight_kg`   | double   |                    |
| `chest_cm`    | double   |                    |
| `waist_cm`    | double   |                    |
| `hips_cm`     | double   |                    |
| `arms_cm`     | double   |                    |
| `thighs_cm`   | double   |                    |
| `body_fat_pct`| double   | Optional           |
| `bmi`         | double   | Auto-calculated    |

### `blood_pressure_logs`

| Field            | Type     | Notes                                                    |
|------------------|----------|----------------------------------------------------------|
| `user_id`        | string   | Relation → `users`                                       |
| `systolic`       | integer  | mmHg                                                     |
| `diastolic`      | integer  | mmHg                                                     |
| `pulse`          | integer  | bpm (optional)                                           |
| `logged_at`      | datetime |                                                          |
| `classification` | enum     | `normal` / `elevated` / `stage1` / `stage2` / `crisis`  |
| `notes`          | string   | Optional                                                 |
| `source`         | enum     | `manual` / `wearable` / `health_connect`                 |
| `sync_status`    | enum     | `synced` / `pending` / `conflict`                        |

### `glucose_logs`

| Field            | Type     | Notes                                                         |
|------------------|----------|---------------------------------------------------------------|
| `user_id`        | string   | Relation → `users`                                            |
| `glucose_mgdl`   | double   | mg/dL                                                         |
| `reading_type`   | enum     | `fasting` / `post_meal` / `random` / `bedtime`                |
| `food_log_id`    | string   | Relation → `food_logs` (nullable — for post-meal correlation) |
| `logged_at`      | datetime |                                                               |
| `classification` | enum     | `normal` / `prediabetic` / `diabetic`                         |
| `notes`          | string   | Optional                                                      |
| `sync_status`    | enum     |                                                               |

### `spo2_logs`

| Field        | Type     | Notes                                    |
|--------------|----------|------------------------------------------|
| `user_id`    | string   | Relation → `users`                       |
| `spo2_pct`   | double   | SpO2 percentage                          |
| `pulse`      | integer  | bpm                                      |
| `logged_at`  | datetime |                                          |
| `source`     | enum     | `manual` / `wearable` / `health_connect` |
| `sync_status`| enum     |                                          |

### `doctor_appointments`

> ⚠️ **Notes field is AES-256 encrypted. Prescription photos stored locally only — never uploaded.**

| Field               | Type     | Notes                                    |
|---------------------|----------|------------------------------------------|
| `user_id`           | string   | Relation → `users`                       |
| `doctor_name`       | string   |                                          |
| `specialty`         | string   | e.g. Cardiologist                        |
| `appointment_at`    | datetime |                                          |
| `notes`             | string   | Symptoms / questions (AES-256 encrypted) |
| `prescription_path` | string   | Local device path — **never uploaded**   |
| `is_completed`      | boolean  |                                          |
| `reminder_sent`     | boolean  |                                          |
| `sync_status`       | enum     |                                          |

### `fasting_logs`

| Field                | Type     | Notes                                                   |
|----------------------|----------|---------------------------------------------------------|
| `user_id`            | string   | Relation → `users`                                      |
| `protocol`           | enum     | `16:8` / `18:6` / `5:2` / `omad` / `custom`            |
| `fast_start`         | datetime |                                                         |
| `fast_end`           | datetime | Nullable if in progress                                 |
| `eating_window_start`| string   | `HH:MM`                                                 |
| `eating_window_end`  | string   | `HH:MM`                                                 |
| `completed`          | boolean  |                                                         |
| `notes`              | string   |                                                         |
| `sync_status`        | enum     |                                                         |

### `meal_plans`

| Field           | Type     | Notes                                                      |
|-----------------|----------|------------------------------------------------------------|
| `user_id`       | string   | Relation → `users`                                         |
| `week_start`    | datetime | Monday of the planned week                                 |
| `plan_data`     | string   | JSON: 7-day meal schedule with `food_item_ids`, `recipe_ids`|
| `calorie_target`| double   |                                                            |
| `generated_by`  | enum     | `ai_suggested` / `manual`                                  |
| `sync_status`   | enum     |                                                            |

### `recipes`

| Field           | Type    | Notes                                              |
|-----------------|---------|----------------------------------------------------|
| `user_id`       | string  | Relation → `users` (nullable for community recipes)|
| `name`          | string  |                                                    |
| `ingredients`   | string  | JSON: `[{"food_item_id","quantity_g"}]`            |
| `total_calories`| double  | Auto-calculated                                    |
| `total_protein_g`| double |                                                    |
| `total_carbs_g` | double  |                                                    |
| `total_fat_g`   | double  |                                                    |
| `servings`      | integer |                                                    |
| `prep_time_min` | integer |                                                    |
| `is_public`     | boolean | Share with community                               |
| `cuisine_type`  | enum    | `north_indian` / `south_indian` / `bengali` / `gujarati` / `other` |
| `sync_status`   | enum    |                                                    |

### `journal_entries`

> ⚠️ **AES-256 encrypted client-side. Sync to Appwrite is opt-in only — default is local-only.**

| Field         | Type     | Notes                               |
|---------------|----------|-------------------------------------|
| `user_id`     | string   | Relation → `users`                  |
| `date`        | datetime |                                     |
| `content`     | string   | AES-256 encrypted before write      |
| `mood_score`  | integer  | 1–5 (optional)                      |
| `tags`        | string   | Encrypted JSON array                |
| `sync_enabled`| boolean  | Default false — local only          |

### `personal_records`

| Field           | Type     | Notes                                                         |
|-----------------|----------|---------------------------------------------------------------|
| `user_id`       | string   | Relation → `users`                                            |
| `record_type`   | enum     | `max_lift` / `fastest_5k` / `longest_run` / `best_streak` / `most_steps` |
| `exercise_name` | string   | e.g. Bench Press                                              |
| `value`         | double   |                                                               |
| `unit`          | string   | `kg` / `km` / `min` / `steps`                                 |
| `achieved_at`   | datetime |                                                               |
| `workout_log_id`| string   | Relation → `workout_logs` (nullable)                          |

### `community_groups`

| Field          | Type    | Notes                                                   |
|----------------|---------|---------------------------------------------------------|
| `name`         | string  | e.g. Keto Indians, Mumbai Runners                       |
| `description`  | string  |                                                         |
| `admin_id`     | string  | Relation → `users`                                      |
| `members`      | string  | JSON array of `user_ids`                                |
| `member_count` | integer |                                                         |
| `group_type`   | enum    | `diet` / `location` / `sport` / `challenge` / `support` |
| `is_public`    | boolean |                                                         |
| `avatar_file_id`| string | Appwrite Storage                                        |

### `health_reports`

| Field            | Type     | Notes                                       |
|------------------|----------|---------------------------------------------|
| `user_id`        | string   | Relation → `users`                          |
| `period`         | enum     | `weekly` / `monthly`                        |
| `report_start`   | datetime |                                             |
| `report_end`     | datetime |                                             |
| `summary_data`   | string   | JSON snapshot of all metrics                |
| `pdf_local_path` | string   | Generated locally — not uploaded            |
| `generated_at`   | datetime |                                             |

### Other Collections (Summary)

| Collection           | Key Fields                                                                         |
|----------------------|------------------------------------------------------------------------------------|
| `karma_transactions` | `user_id`, `amount`, `action`, `description`, `balance_after`                     |
| `nutrition_goals`    | `user_id`, `tdee`, `calorie_goal`, `protein_g`, `carbs_g`, `fat_g`, `goal_type`   |
| `posts`              | `user_id`, `content`, `media_file_id`, `post_type`, `likes_count`                 |
| `challenges`         | `title`, `challenge_type`, `target_value`, `start_date`, `end_date`, `karma_reward`|
| `subscriptions`      | `user_id`, `plan`, `status`, `razorpay_sub_id`, `start_date`, `end_date`, `amount_paid` |
| `family_groups`      | `admin_id`, `name`, `members` (JSON), `leaderboard_type`                          |
| `workouts`           | `title`, `youtube_id`, `duration_min`, `difficulty`, `category`, `language`, `is_premium` |
| `community_dms`      | `sender_id`, `receiver_id`, `content`, `sent_at`, `is_read`                       |

---

## 7. Hive Local Storage

### Box Registry

| Box Name                   | Contents                                                     |
|----------------------------|--------------------------------------------------------------|
| `food_logs_box`            | `FoodLog` objects — written locally, synced async            |
| `step_logs_box`            | `DailyStepLog` — one record per calendar day                 |
| `workout_logs_box`         | `WorkoutLog` including GPS route data                        |
| `sleep_logs_box`           | `SleepLog` entries                                           |
| `mood_logs_box`            | `MoodLog` entries                                            |
| `period_logs_box`          | **AES-256 encrypted** `PeriodLog` entries                    |
| `medications_box`          | Medication schedules and reminder configs                    |
| `habits_box`               | `HabitDef` + daily completion records                        |
| `body_metrics_box`         | `BodyMeasurement` snapshots                                  |
| `food_items_box`           | Cached food items from Appwrite + OpenFoodFacts              |
| `sync_queue_box`           | `SyncQueueItem` — pending Appwrite operations                |
| `user_prefs_box`           | `UserPreferences` — theme, language, goals                   |
| `karma_box`                | Local XP snapshot for immediate UI updates                   |
| `nutrition_goals_box`      | TDEE and macro targets                                       |
| `blood_pressure_box`       | **AES-256 encrypted** `BPLog` entries                        |
| `glucose_box`              | **AES-256 encrypted** `GlucoseLog` entries                   |
| `spo2_box`                 | `SpO2Log` entries                                            |
| `fasting_box`              | `FastingSession` — current and past fasting logs             |
| `meal_plans_box`           | `MealPlan` — weekly plans                                    |
| `recipes_box`              | `Recipe` — user and community recipes                        |
| `journal_box`              | **AES-256 encrypted** `JournalEntry` entries                 |
| `personal_records_box`     | `PersonalRecord` per exercise/activity                       |
| `doctor_appointments_box`  | **AES-256 encrypted** appointment and prescription notes     |
| `health_reports_box`       | Generated report metadata (PDF stored at `pdf_local_path`)   |
| `wearable_sync_box`        | Last sync timestamps per wearable source                     |

### Sample Hive Model — `FoodLog`

```dart
// lib/features/food/domain/food_log_model.dart
@HiveType(typeId: 1)
class FoodLog extends HiveObject {
  @HiveField(0)  String id;
  @HiveField(1)  String userId;
  @HiveField(2)  String foodName;
  @HiveField(3)  String mealType;
  @HiveField(4)  double quantityG;
  @HiveField(5)  double calories;
  @HiveField(6)  double proteinG;
  @HiveField(7)  double carbsG;
  @HiveField(8)  double fatG;
  @HiveField(9)  DateTime loggedAt;
  @HiveField(10) String syncStatus;   // 'pending' | 'synced' | 'conflict'
  @HiveField(11) String? recipeId;    // nullable — set when logged from recipe

  /// Construct from an Appwrite Document after sync/fetch
  FoodLog.fromAppwrite(Document doc) {
    id         = doc.$id;
    userId     = doc.data['user_id'];
    foodName   = doc.data['food_name'];
    mealType   = doc.data['meal_type'];
    quantityG  = doc.data['quantity_g'];
    calories   = doc.data['calories'];
    proteinG   = doc.data['protein_g'];
    carbsG     = doc.data['carbs_g'];
    fatG       = doc.data['fat_g'];
    loggedAt   = DateTime.parse(doc.data['logged_at']);
    syncStatus = 'synced';
    recipeId   = doc.data['recipe_id'];
  }

  /// Serialise for Appwrite document creation
  Map<String, dynamic> toAppwrite() => {
    'user_id':     userId,
    'food_name':   foodName,
    'meal_type':   mealType,
    'quantity_g':  quantityG,
    'calories':    calories,
    'protein_g':   proteinG,
    'carbs_g':     carbsG,
    'fat_g':       fatG,
    'logged_at':   loggedAt.toIso8601String(),
    'sync_status': syncStatus,
    if (recipeId != null) 'recipe_id': recipeId,
  };
}
```

---

## 8. Offline Sync Architecture

### Strategy

1. **Write locally first** — all user actions write to Hive immediately; no loading state shown to the user.
2. **Enqueue** — a `SyncQueueItem` is appended to `sync_queue_box` for every create / update / delete operation.
3. **Background flush** — a background isolate monitors connectivity via `connectivity_plus`. When online, the queue is flushed in batches of 20 using Appwrite Databases.
4. **Delta sync** — on app resume, only documents changed since `$updatedAt > lastSyncTimestamp` are fetched.
5. **Real-time updates** — while the app is foregrounded, Appwrite Realtime pushes changes via WebSocket; these are merged into Hive using the conflict rules below.

### Conflict Resolution Matrix

| Data Type                          | Winner                        | Rationale                                          |
|------------------------------------|-------------------------------|----------------------------------------------------|
| Food / Workout / Sleep / Mood      | Client                        | Logs are user events — trust the device            |
| Step counts                        | `max(client, server)`         | Take higher value; never lose steps                |
| Karma / XP balance                 | Server                        | Prevent client-side score manipulation             |
| Social posts / likes               | Server                        | Server is the canonical social state               |
| User profile fields                | Merge (last-write-wins per field) | Avoids full overwrites                         |
| Subscription status                | Server                        | Razorpay is the source of truth                    |
| Period / Journal / Medical logs    | Client                        | Only the user holds the decryption key             |
| BP / Glucose logs                  | Client                        | AES-encrypted medical data — client is authoritative|
| Wearable data                      | `max(client, server)`         | Health data should never be reduced                |

### Sync Queue Item

```dart
class SyncQueueItem {
  final String  id;
  final String  collection;      // Appwrite collection ID
  final String  operation;       // 'create' | 'update' | 'delete'
  final String  localId;         // Hive object key
  final String? appwriteDocId;   // Populated after first successful create
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  int    retryCount;             // Max 5 attempts
  String? error;
}

// Retry schedule: 1s → 2s → 4s → 8s → 16s (exponential backoff)
```

### Appwrite Realtime Subscription

```dart
// Subscribe to real-time karma transaction events
final subscription = AppwriteClient.realtime.subscribe([
  'databases.${AW.dbId}.collections.${AW.karmaTx}.documents',
]);

subscription.stream.listen((RealtimeMessage event) {
  if (event.events.contains(
      'databases.*.collections.*.documents.*.create')) {
    final doc = Document.fromMap(event.payload);
    ref.read(karmaProvider.notifier).applyRemoteUpdate(doc);
  }
});
```

---

## 9. Authentication & Onboarding

### Auth Configuration

| Property          | Detail                                                              |
|-------------------|----------------------------------------------------------------------|
| Methods           | Email/password, Google OAuth2, Apple Sign-In (iOS)                  |
| Session storage   | `flutter_secure_storage` — Appwrite JWT stored encrypted            |
| Session renewal   | `account.updateSession(sessionId: 'current')` before expiry         |
| Biometric lock    | `local_auth` — guards app re-open                                   |
| Permissions model | `Permission.read(Role.user(uid))` + `Permission.write(Role.user(uid))` on every document |
| Account merge     | Email + Google OAuth with same email → automatic merge via Appwrite identity linking |

### Onboarding Flow

```
Name → Gender / DOB → Height / Weight → Fitness Goal
    → Activity Level → Chronic Conditions (optional, activates management mode)
    → Dosha Quiz (12 questions)
    → Language Selection → Health Permissions (contextual)
    → Wearable Connection (optional, skippable — can be done later in Settings)
```

- Dosha quiz calculates vata / pitta / kapha percentage automatically.
- Health permissions are requested contextually — never at first launch.
- Chronic condition selection activates the relevant management mode.
- **Karma reward**: +50 XP for completing onboarding.

### Email Auth

```dart
// lib/features/auth/data/auth_aw_service.dart
class AuthAwService {
  final Account _account = AppwriteClient.account;

  Future<Session> login(String email, String password) =>
    _account.createEmailPasswordSession(email: email, password: password);

  Future<User> register(String name, String email, String password) =>
    _account.create(
      userId: ID.unique(),
      name: name,
      email: email,
      password: password,
    );

  Future<void> logout() =>
    _account.deleteSession(sessionId: 'current');

  Future<User> getCurrentUser() => _account.get();
}
```

### Google OAuth2

```dart
// No Firebase SDK required — Appwrite handles the OAuth2 flow
await AppwriteClient.account.createOAuth2Session(
  provider: OAuthProvider.google,
  success: 'appwrite-callback-{projectId}://auth',
  failure: 'appwrite-callback-{projectId}://auth/failure',
);
```

---

## 10. Core Feature Modules

### 10.1 Dashboard

- **Data source**: Hive only on launch — renders in < 1 second with no network dependency.
- **Activity rings**: Calories · Steps · Water · Active minutes · Blood pressure status (see Section 2.1 for ring layout spec).
- **Insight card**: Amber card with lightbulb icon and actionable nudge from the on-device Rule Engine; max 2 per day; dismissable and rateable (👍 / 👎).
- **Karma bar**: Current XP, level badge (`Level 12 Warrior`), and progress to next level — as shown in the reference mockup.
- **Quick-log FAB**: Orange speed-dial FAB for one-tap logging of food, water, mood, workout, BP, and glucose.
- **Today's Meals section**: Horizontal tab bar (Breakfast · Lunch · Dinner · Snacks) with meal summary cards below.
- **Summary cards**: Latest workout, sleep recovery score.
- **Morning briefing notification**: Today's calorie goal, weather-adjusted plan, fasting window open/close times.
- **Android home screen widgets**: Steps ring, calorie ring, water ring.
- **Screens**: `DashboardHome`, `KarmaProgressCard`, `DailyRingWidget`

### 10.2 Food Logging

| Method      | Implementation                                                              | Appwrite Action                           |
|-------------|-----------------------------------------------------------------------------|-------------------------------------------|
| Search      | Hive first (< 200ms) → Appwrite query → OpenFoodFacts fallback              | `databases.listDocuments(filters)`        |
| Barcode     | `flutter_barcode_scanner` → OpenFoodFacts API                               | Cache result to `food_items` collection   |
| OCR         | Google ML Kit TextRecognitionV2 — nutrition label scan (`Scan Label` button)| On-device only                            |
| Photo AI    | Google ML Kit ObjectDetection — identify food from photo (`Upload Plate Photo` button) | On-device only               |
| Voice       | `speech_to_text` — *"dal chawal"* → search → confirm                        | Hive write + sync queue                   |
| Indian DB   | Pre-seeded Indian food database with katori / piece / glass portions        | Seeded via Appwrite import                |
| Restaurant  | Community-seeded Swiggy/Zomato menu calorie lookup                          | Cache to `food_items`                     |
| Recipe log  | Log an entire saved recipe as one entry                                     | Hive write + sync queue                   |

> **UI note**: The food log screen shows bilingual search placeholder, three quick-action chips (`Scan Label` · `Upload Plate Photo` · `Manual Entry`), a `Frequent Indian Portions` 2×N grid with katori-based portions, and a `Recent Logs` section — all as shown in the reference mockup.

**Karma**: +10 XP per food log; +30 XP for the first log of the day.

```dart
// lib/features/food/data/food_aw_service.dart
class FoodAwService {
  final Databases _db = AppwriteClient.databases;

  Future<List<Document>> searchFoodItems(String query) async {
    final result = await _db.listDocuments(
      databaseId: AW.dbId,
      collectionId: AW.foodItems,
      queries: [
        Query.search('name', query),
        Query.limit(20),
      ],
    );
    return result.documents;
  }

  Future<Document> logFood(String uid, Map<String, dynamic> data) =>
    _db.createDocument(
      databaseId: AW.dbId,
      collectionId: AW.foodLogs,
      documentId: ID.unique(),
      data: data,
      permissions: [
        Permission.read(Role.user(uid)),
        Permission.write(Role.user(uid)),
      ],
    );
}
```

### 10.3 Workout System

| Property          | Detail                                                                              |
|-------------------|-------------------------------------------------------------------------------------|
| YouTube           | `youtube_player_flutter` plays by video ID — no ads for premium users               |
| GPS Outdoor       | `geolocator` + `flutter_map` (OpenStreetMap) — background location tracking         |
| Structured        | 30-day and 12-week programs with day-by-day plans                                   |
| Categories        | Yoga, HIIT, Strength, Cardio, Dance, Bollywood Fitness, Cricket Drills, Kabaddi, Pranayama |
| HR Zones          | Heart rate zone training (Zone 1–5) integrated with wearable data                   |
| Workout Calendar  | Schedule future workouts; rest day recommendations based on recovery score           |
| Custom Builder    | Build exercise-level custom workouts: exercise, sets, reps, rest time               |
| Warm-up/Cool-down | Pre/post workout guidance triggered automatically                                   |
| PRs               | Personal records tracked per exercise — max lift, fastest pace, longest distance    |
| Offline           | Workout metadata cached in Hive; downloaded content plays without connectivity      |

**Karma**: +20 XP per workout; +50 XP for completing a program day; +100 XP for a new personal record.

### 10.4 Step Tracking

- **Primary sensor**: Health Connect (Android 14+) / HealthKit (iOS).
- **Fallback**: `pedometer` package via device accelerometer.
- **Background**: WorkManager (Android) / `BGAppRefreshTask` (iOS).
- **Adaptive goal**: Daily target adjusts based on 7-day rolling average.
- **Sync**: Step count batch-synced to Appwrite at midnight local time.
- **Inactivity nudge**: Detects prolonged phone inactivity (> 60 min) and pushes a gentle movement reminder.
- **Karma**: +5 XP per 1,000 steps (maximum 50 XP/day).

### 10.5 Karma System

| Action                      | XP                      |
|-----------------------------|-------------------------|
| Log food                    | +10 (+30 first/day)     |
| Log workout                 | +20                     |
| Complete program day        | +50                     |
| Log sleep                   | +5                      |
| Log mood                    | +3                      |
| Complete challenge          | +50 to +200             |
| Complete onboarding         | +50                     |
| Log BP or glucose           | +5                      |
| Complete a fast             | +15                     |
| New personal record         | +100                    |
| Successful referral         | +500 (referrer) / +100 (referee) |
| 7-day streak multiplier     | ×1.5 earn rate          |
| 30-day streak multiplier    | ×2.0 earn rate          |

**Levels**: 50 tiers — Seedling → Warrior → Yogi → Guru → Legend
**Karma Store**: Redeem XP for premium workout packs, digital badges, profile themes.
**Leaderboards**: Friends · City · National — weekly reset.

> **UI note**: The Karma screen (Me tab) shows the dark purple gradient `KarmaLevelCard`, the `DoshaDonutChart`, the `Daily Rituals` checklist, and the `Challenges Carousel` — all per the reference mockup.

**Screens**: `KarmaHub`, `KarmaStore`, `KarmaHistory`, `Leaderboard`

---

## 11. Advanced Feature Modules

### 11.1 Sleep Tracker

| Property         | Detail                                                                       |
|------------------|------------------------------------------------------------------------------|
| Manual log       | Time pickers for bedtime / wake time, emoji quality scale (1–5), notes       |
| Auto-detect      | Syncs from HealthKit / Health Connect / wearable when permission is granted  |
| Insights         | Weekly average vs recommended (7–9h), sleep debt chart, workout correlation  |
| Tips             | Ayurvedic sleep tips triggered when avg < 6h, personalised by dosha type     |
| Burnout detection| Sustained low mood + poor sleep + low energy over 7 days triggers a recovery flow |
| Karma            | +5 XP per sleep log                                                          |

### 11.2 Mood Tracker

| Property      | Detail                                                                     |
|---------------|----------------------------------------------------------------------------|
| Logging       | 5-emoji selector, energy slider (1–10), stress slider (1–10) — < 30 sec   |
| Tags          | `anxious` · `calm` · `focused` · `tired` · `motivated` · `irritable`      |
| Voice note    | Optional 1-minute note — stored locally only, **never uploaded**           |
| Insights      | Mood heatmap calendar, energy/stress trend, mood–workout correlation        |
| Screen time   | Correlates Digital Wellbeing / Screen Time data with mood                  |
| Karma         | +3 XP per log                                                              |

### 11.3 Period Tracker

- All data AES-256 encrypted client-side before any Hive write or Appwrite sync.
- Sync to Appwrite is opt-in only — default behaviour is local-only.
- Cycle prediction based on the average of the last 3 cycles; ovulation window estimation included.
- Tracked symptoms: cramps, bloating, mood swings, headache, fatigue, spotting.
- Workout suggestions adapt to cycle phase: menstrual / follicular / ovulatory / luteal.
- **PCOD/PCOS management mode**: Irregular cycle support, specialist referral prompts, symptom tracking, hormone-friendly workout suggestions.
- **Privacy guarantee**: Period data is never used for ads or shared with any third party.

### 11.4 Medication Reminder

| Property          | Detail                                                              |
|-------------------|----------------------------------------------------------------------|
| Reminders         | `flutter_local_notifications` — per-medication schedules, fully offline |
| Refill alert      | Push notification 3 days before estimated refill date               |
| Categories        | Prescription · OTC · Supplement · Ayurvedic                          |
| Interactions      | Basic warnings for common drug pairs (hardcoded)                    |
| Emergency card    | Active medications auto-populate the Emergency Health Card          |
| Doctor appointments | Track upcoming appointments; 24h reminder; prescription photo stored locally only |

### 11.5 Body Measurements Tracker

- Tracked metrics: weight, height, chest, waist, hips, arms, thighs, body fat %.
- Auto-calculated ratios: BMI, waist-to-hip, waist-to-height.
- BMI history chart with trend lines and goal markers.
- Progress photos stored locally only — never uploaded to Appwrite Storage.
- Before/after comparison slider widget.
- Trend charts for 30 / 90 / 180-day windows per measurement.

### 11.6 Smart Habit Tracker

- **Preset habits**: 8 glasses water · 10-min meditation · 30-min walk · read 10 pages · no sugar.
- **Custom habits**: user-defined name, emoji icon, target count, unit, frequency.
- Individual streak tracking per habit with visual flame indicator.
- **Streak analytics**: Breakdown of which habits were broken and when, with pattern insights.
- Weekly completion heatmap (GitHub contribution graph style).
- **Karma**: +2 XP per habit completion; +10 XP for a 7-day streak.

### 11.7 Nutrition Goal Engine

```dart
// TDEE — Mifflin-St Jeor equation
// Male:   BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) + 5
// Female: BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) − 161
// TDEE = BMR × activity_factor

const activityFactors = {
  'sedentary':   1.2,
  'light':       1.375,
  'moderate':    1.55,
  'active':      1.725,
  'very_active': 1.9,
};

// Calorie goal adjustments
// lose_weight:  TDEE − 300 to 500 kcal
// gain_muscle:  TDEE + 300 to 500 kcal
// maintain:     TDEE

// Default macro split (Indian diet profile)
// Carbohydrates: 55% of calories
// Protein:       20% of calories
// Fat:           25% of calories
```

- Daily nutrition ring charts with traffic-light status: 🟢 on track · 🟡 slightly over · 🔴 exceeded.
- Contextual smart nudges: *"You're 18g protein short today. Add a glass of lassi!"* (as shown in reference mockup insight card).
- Micronutrient tracking: Iron · B12 · Vitamin D · Calcium.
- Supplement & micronutrient gap analysis: weekly actionable report of deficiencies.
- Grocery list generator: auto-generates from nutrition goals or weekly meal plan.
- Intermittent fasting integration: eating window logged against daily calorie budget.

### 11.8 Ayurveda Personalisation Engine

- 12-question dosha quiz produces a vata / pitta / kapha percentage breakdown (visualised as `DoshaDonutChart` on the Me tab).
- Daily rituals (Dinacharya) recommended based on dosha type and current season — rendered as a checklist on the Me tab.
- Seasonal plans (Ritucharya) — food and activity adjustments per Indian season; accessible via `View Seasonal Guidelines (Ritucharya)` button.
- Herbal remedies library: ashwagandha, triphala, brahmi, turmeric — with evidence-based notes.
- **Dosha re-quiz**: User can retake the quiz at any time from Settings without data loss.
- **Screens**: `AyurvedaHome`, `DoshaProfile`, `DailyRituals`, `SeasonalPlan`, `HerbalRemedies`

### 11.9 Family Health Profiles

- One family admin, up to 6 members (Family plan).
- Each member is an independent Appwrite account — admin has view-only access.
- Weekly step leaderboard with fun nudges.
- Group push notifications via Appwrite Functions: *"Papa hasn't logged any meal today 🙁"*
- Family challenges: 7-day step goal, water challenge, screen-free morning.

### 11.10 Emergency Health Card

- Stored **locally only** — no Appwrite sync, accessible without network.
- Fields: blood group · allergies · chronic conditions · current medications (auto-pulled from med module) · emergency contact · doctor name + number · insurance policy number.
- Accessible via Android lock screen widget and iOS Home Screen widget.
- Export: PDF for printing, QR code for quick scan by medical staff.

### 11.11 Festival Fitness Calendar

- Indian festival database hardcoded — zero API dependency.
- **Navratri**: 9-day fasting guide, Garba calorie burn tracker.
- **Ramadan**: Sehri/Iftar nutrition planner, fasting workout modifications.
- **Diwali**: Sweet calorie tracker + healthy mithai alternatives.
- **Karwa Chauth**: Hydration alerts, light workout suggestions.
- Auto-triggers: contextual push notification 3 days before each festival.
- Meal planner adjusts automatically during active festival periods.

### 11.12 Low Data Mode (2G / 3G Support)

- Toggle in Settings — can also be auto-detected by connection speed measurement.
- When active: image loading disabled, sync frequency reduced to every 6 hours (default: 15 minutes), images compressed to ≤ 200 KB before upload, social feed switches to text-only, wearable sync reduced to 6-hour intervals.
- All core features (food log, workout log, step count) remain fully functional offline.

### 11.13 On-Device AI Health Insight Engine

All rules run in Dart on the device. Zero server calls. No ML model dependency.

```dart
// lib/features/insight_engine/rule_engine.dart
// Evaluated daily — max 2 cards surfaced on dashboard
final rules = [
  if (avgSleepHours < 6 && moodAvg < 3)
      → "Poor sleep may be affecting your mood",

  if (stepsLast3Days < 3000)
      → "You've been less active. A 10-min walk can help!",

  if (waterToday < 1500 && ambientTemp > 35)
      → "It's hot today. Drink more water!",

  if (workoutDaysLast7 == 0)
      → "No workouts this week. Your Karma is waiting!",

  if (proteinAvg7d < goalProtein * 0.7)
      → "Add dal or paneer to boost your protein intake",

  if (cycleDay == 1 || cycleDay == 2)
      → "Rest and light yoga are recommended today",

  if (streakDays % 7 == 0)
      → "7-day streak! You're building a real habit. 🔥",

  if (bpLastReading.classification == 'elevated')
      → "Your recent BP is elevated. Consider logging daily and consulting a doctor.",

  if (fastingWindowOpen && waterToday < 1000)
      → "Stay hydrated during your fasting window!",

  if (glucosePostMealHigh3DaysRunning)
      → "Post-meal glucose has been high. Try reducing refined carbs at lunch.",

  if (moodAvg7d < 2 && sleepAvg7d < 6 && energyAvg7d < 4)
      → "You may be experiencing burnout. Open the Mental Health module for support.",

  if (bmi > 25 && workoutDaysLast7 < 3)
      → "3 workouts/week can help you reach your goal",
];
```

- Each card is dismissable. User rates each card (👍 / 👎) — preference stored locally to suppress unhelpful rules.
- Rules are updated only through app updates.

---

## 12. Health Monitoring Modules

### 12.1 Blood Pressure & Heart Rate Tracker

- **Manual logging**: systolic, diastolic, pulse — takes < 20 seconds.
- **Wearable auto-sync**: pulls from Health Connect / HealthKit / Fitbit / Garmin.
- **AHA classification**: Normal / Elevated / Stage 1 Hypertension / Stage 2 Hypertension / Hypertensive Crisis.
- **Trend chart**: 7 / 30 / 90-day history with coloured reference bands per AHA category.
- **Morning and evening reminders** to log BP (configurable).
- **Hypertension management mode**: Daily BP streak, sodium intake tracking integration with nutrition module.
- **Emergency alert**: Reading exceeds 180/120 mmHg → immediate care prompt.
- **Karma**: +5 XP per BP log. AES-256 encrypted.

```dart
// lib/features/blood_pressure/domain/bp_classifier.dart
enum BPClassification { normal, elevated, stage1, stage2, crisis }

BPClassification classify(int systolic, int diastolic) {
  if (systolic >= 180 || diastolic >= 120) return BPClassification.crisis;
  if (systolic >= 140 || diastolic >= 90)  return BPClassification.stage2;
  if (systolic >= 130 || diastolic >= 80)  return BPClassification.stage1;
  if (systolic >= 120 && diastolic < 80)   return BPClassification.elevated;
  return BPClassification.normal;
}
```

### 12.2 Blood Glucose Tracker

- **Reading types**: Fasting / Post-meal (1h, 2h) / Random / Bedtime.
- **Reference ranges**: Normal / Pre-diabetic / Diabetic per WHO/IDF standards.
- **HbA1c estimator**: 90-day average glucose → estimated A1c percentage.
- **Meal correlation**: Links post-meal glucose to the corresponding food log entry.
- **Trend chart**: Glucose across reading types with configurable target bands.
- **Diabetic management mode**: Medication reminders synced to glucose schedule, carb-aware nutrition nudges.
- **Karma**: +5 XP per glucose log. AES-256 encrypted.

```dart
// lib/features/glucose/domain/glucose_classifier.dart
enum GlucoseClassification { normal, prediabetic, diabetic }

GlucoseClassification classifyFasting(double mgdl) {
  if (mgdl >= 126) return GlucoseClassification.diabetic;
  if (mgdl >= 100) return GlucoseClassification.prediabetic;
  return GlucoseClassification.normal;
}

GlucoseClassification classifyPostMeal2h(double mgdl) {
  if (mgdl >= 200) return GlucoseClassification.diabetic;
  if (mgdl >= 140) return GlucoseClassification.prediabetic;
  return GlucoseClassification.normal;
}
```

### 12.3 SpO2 / Oxygen Saturation Tracker

- **Manual logging**: SpO2 percentage + pulse rate.
- **Wearable sync**: Health Connect / HealthKit / supported wearables.
- **Alert**: SpO2 < 95% triggers a consult-your-doctor nudge (high post-COVID relevance).
- **Trend chart**: 30-day SpO2 history with 95% lower reference band.

### 12.4 Chronic Disease Management

Supported conditions: Diabetes Type 1 & 2 · Hypertension · PCOD/PCOS · Hypothyroidism · Asthma.

| Mode             | Modules Surfaced                                                          |
|------------------|---------------------------------------------------------------------------|
| Diabetes         | Glucose tracker + Carb-aware nutrition + Medication + BP dashboard        |
| PCOD/PCOS        | Irregular cycle support + Hormone-friendly workouts + Weight management   |
| Hypertension     | BP tracker + Sodium tracking + Stress management + Medication compliance  |
| Hypothyroidism   | Weight trend + Fatigue tracking + Medication reminders                    |
| Asthma           | SpO2 tracker + Activity intensity limits + Medication reminders           |

- Condition-specific insight rules in the Rule Engine.
- Specialist referral prompts when metrics fall outside safe ranges.

### 12.5 Doctor Appointments

- Track upcoming doctor appointments with 24h reminder.
- Prescription photos stored locally only — never uploaded under any circumstance.
- Doctor notes AES-256 encrypted before Hive write.
- Active medications auto-populate the appointment summary for easy reference.

---

## 13. Lifestyle & Wellness Modules

### 13.1 Meal Planner

- **Weekly meal planner**: Plan breakfast, lunch, dinner, and snacks for 7 days.
- **AI-suggested plans**: Rule Engine generates a plan based on TDEE, dosha type, and current nutrition gaps — zero server calls.
- **One-tap log**: Log a planned meal directly from the planner — no re-entry.
- **Indian meal templates**: Pre-built weekly plans for North Indian, South Indian, Bengali, and Gujarati diets.
- **Festival-aware**: Planner adjusts automatically during Navratri, Ramadan, and other festivals.
- **Grocery list**: Auto-generates a shopping list from the week's meal plan.

### 13.2 Recipe Builder

- **Create custom recipes**: Add ingredients from `food_items`, set quantities and servings.
- **Auto-calculates**: Total calories, protein, carbs, fat per serving.
- **Save → log**: Log the entire recipe as one food entry in one tap.
- **Community sharing**: Mark recipe as public — other users can save and log it.
- **Indian cuisine classifier**: Tag by regional cuisine for discoverability.
- **Recipe import**: Paste a recipe URL; OCR extracts ingredient list (best-effort via ML Kit).

### 13.3 Intermittent Fasting Tracker

- **Supported protocols**: 16:8 · 18:6 · 5:2 · OMAD · Custom window.
- **Fasting timer**: Countdown to eating window; progress ring with stages — fed, early fast, ketosis, deep fast.
- **Eating window validation**: All food logs checked against the active fasting window.
- **Ramadan mode**: Sehri/Iftar as the fasting boundary; integrates with Festival Calendar.
- **Hydration alerts** during fasting windows.
- **Streak tracking**: Consecutive successful fasting days.
- **Karma**: +15 XP per completed fast.

```dart
// lib/features/fasting_tracker/domain/fasting_stage.dart
enum FastingStage { fed, earlyFast, fatBurning, ketosis, deepFast }

FastingStage getStage(Duration elapsed) {
  final hours = elapsed.inHours;
  if (hours < 4)  return FastingStage.fed;
  if (hours < 8)  return FastingStage.earlyFast;
  if (hours < 12) return FastingStage.fatBurning;
  if (hours < 16) return FastingStage.ketosis;
  return FastingStage.deepFast;
}
```

### 13.4 Guided Meditation & Pranayama

- **Guided sessions**: 5 / 10 / 15 / 20-minute sessions with bundled offline audio.
- **Pranayama library**: Anulom Vilom · Bhramari · Kapalbhati · Bhastrika — timer-based with inhale/hold/exhale cues.
- **Dosha-specific sessions**: Calming for vata, cooling for pitta, energising for kapha.
- **Stress mode**: Quick 3-minute breathing exercise triggered when `stress_level > 7` in mood log.
- **Session history and streak tracking**.
- **Karma**: +5 XP per meditation session; +10 XP for a 7-day meditation streak.

### 13.5 Journaling

- **Daily journal entries** with rich text (bold, italic, lists) via `flutter_quill`.
- **Optional mood score and tags** per entry.
- **AES-256 encrypted** before any Hive write — local only by default.
- **Sync to Appwrite is opt-in only** (same model as period tracker).
- **Weekly prompt suggestions**: *"What made you feel strong this week?"*
- **Monthly journal summary**: Word cloud of frequent tags, mood trend overlay.

### 13.6 Mental Health & Stress Management

- **Stress management programs**: 7-day CBT-lite techniques, progressive muscle relaxation.
- **Burnout detection**: Sustained low mood + poor sleep + low energy over 7 days triggers a dedicated recovery flow.
- **Screen time awareness**: Surfaces Digital Wellbeing / Screen Time data and correlates with mood.
- **Professional help prompts**: Triggered gently after 14 days of consistently low mood scores.
- **Mental health resources**: Curated list of Indian helplines — iCall, Vandrevala Foundation, NIMHANS.

### 13.7 Personal Records Tracker

- **Auto-detection**: Detects new PRs from workout logs — max lift per exercise, fastest 5K, longest run.
- **Manual PR entry** for sports: cricket runs, kabaddi raid points, etc.
- **PR celebration notification**: *"New PR! You lifted 80kg on Bench Press!"*
- **PR history chart** per exercise with trend over time.
- **Karma**: +100 XP for any new personal record.

---

## 14. Social & Community Modules

### 14.1 Social Feed

- Post workouts, meals, and milestones with optional media.
- Like, comment, and share within the FitKarma community.
- Verified nutritionist / trainer badge on professional accounts.
- Follow system: follow users; see their public activity in the main feed.
- User discovery: search and follow by username or interest tag.

### 14.2 Community Groups

- **Create or join** topic-based groups: Keto Indians · Mumbai Runners · Diabetics Support.
- **Group types**: diet / location / sport / challenge / support.
- **Group feed**: Posts, challenges, and leaderboard scoped to the group.
- **Group challenges**: Admin-created challenges with a shared group leaderboard.
- **Direct messaging (DMs)**: One-to-one messaging within community connections.

### 14.3 Referral & Invite Program

- Each user receives a unique referral code generated at registration.
- **Referrer earns** +500 Karma XP when the referred user completes onboarding.
- **Referred user earns** +100 Karma XP on signup.
- Tracked via the `referred_by` field in the `users` collection.
- **Referral leaderboard** in Karma Hub — top referrers earn exclusive badge rewards.

---

## 15. Platform & Infrastructure Modules

### 15.1 Automated Health Reports

- **Weekly and monthly reports** auto-generated every Sunday night / month end.
- **Report contents**: Steps trend · Calorie balance · Sleep quality · Mood trend · BP/Glucose (if tracked) · Workout frequency · Karma earned.
- **PDF generated locally** using the `pdf` package — never uploaded to Appwrite.
- **Shareable**: User can share or print the PDF (e.g. for a doctor visit).
- **Doctor-friendly format**: Separate section for medical metrics with reference ranges clearly labelled.

### 15.2 Wearable Device Integration

| Device / Platform          | Data Pulled                       | Method                        |
|----------------------------|-----------------------------------|-------------------------------|
| Health Connect (Android 14+)| Steps, sleep, HR, SpO2, BP       | `health` package              |
| HealthKit (iOS)            | Steps, sleep, HR, SpO2, BP        | `health` package              |
| Fitbit                     | Steps, sleep, HR, SpO2            | Fitbit Web API via OAuth2     |
| Garmin                     | Steps, sleep, HR, GPS workouts    | Garmin Connect IQ API         |
| Mi Band / Xiaomi           | Steps, sleep, HR                  | Health Connect bridge         |
| boAt (Wear OS)             | Steps, HR                         | Health Connect bridge         |

- All wearable data is supplementary; device sensor data takes priority when the wearable is disconnected.
- Wearable sync runs on app resume and every 15 minutes in background (6 hours in Low Data Mode).

---

## 16. Security & Privacy

### 16.1 Session Management

| Property         | Detail                                                              |
|------------------|----------------------------------------------------------------------|
| Sessions         | Appwrite JWT — stored in `flutter_secure_storage`                   |
| Renewal          | `account.updateSession(sessionId: 'current')` before expiry         |
| OAuth2           | Handled by Appwrite — no Firebase Auth SDK in app                   |
| Biometric lock   | `local_auth` guards app re-open                                     |
| Doc permissions  | `Permission.read(Role.user(uid))` + `Permission.write(Role.user(uid))` on every document |
| Account merge    | Email + Google OAuth with same email → automatic merge via Appwrite identity linking |

### 16.2 Data Encryption

AES-256-GCM with PBKDF2 key derivation (100,000 iterations) applied to all sensitive data.

```dart
// Key derivation — same pattern for all sensitive boxes
final key = await deriveKey(
  password: userPassword,
  deviceId: await DeviceInfo.getDeviceId(),
  salt: storedSalt,       // Persisted in flutter_secure_storage
  iterations: 100_000,
  keyLength: 32,          // 256-bit key
);

// Encrypted Hive boxes
final periodBox      = await Hive.openBox<PeriodLog>('period_logs',
    encryptionCipher: HiveAesCipher(key));
final journalBox     = await Hive.openBox<JournalEntry>('journal',
    encryptionCipher: HiveAesCipher(key));
final bpBox          = await Hive.openBox<BPLog>('blood_pressure',
    encryptionCipher: HiveAesCipher(key));
final glucoseBox     = await Hive.openBox<GlucoseLog>('glucose',
    encryptionCipher: HiveAesCipher(key));
final appointmentBox = await Hive.openBox<Appointment>('appointments',
    encryptionCipher: HiveAesCipher(key));
```

### 16.3 Appwrite Collection Permissions Template

```
// Apply to every collection in the Appwrite Console:
//
// Create:  role:users               — any authenticated user may create
// Read:    role:user:{userId}        — owner only
// Update:  role:user:{userId}        — owner only
// Delete:  role:user:{userId}        — owner only
//
// period_logs, journal_entries, blood_pressure_logs,
// glucose_logs, doctor_appointments:
//   → no server-side admin read access — ever
```

### 16.4 Network Security

- All API traffic over HTTPS — plain HTTP requests are rejected at the client level.
- API rate limiting configured in the Appwrite Console.
- No third-party analytics SDKs. Sentry used for anonymised crash reporting only.
- Fitbit/Garmin `client_secret` values are **never** embedded in the Flutter app — all token exchanges happen via Appwrite Functions server-side.

### 16.5 Privacy Commitments

| Data Type            | Behaviour                                                          |
|----------------------|--------------------------------------------------------------------|
| Period / medical     | AES-256 encrypted before leaving device; sync is opt-in only       |
| Progress photos      | Stored locally only — never uploaded to Appwrite Storage           |
| Voice notes          | Stored locally only — auto-deleted after 30 days                   |
| Journal entries      | AES-256 encrypted; local-only by default; sync is opt-in           |
| BP / Glucose logs    | AES-256 encrypted; user controls sync                              |
| Prescription photos  | Local only — never uploaded under any circumstance                 |
| Doctor notes         | AES-256 encrypted; local only by default                           |
| User data (GDPR)     | Full JSON export + account deletion via `account.delete()`          |
| Advertising          | No advertising SDKs — zero ad revenue from user data               |
| Third parties        | No data sold or shared with any third party                        |
| Self-hosted option   | Data stays on your own server when using Docker deployment          |

---

## 17. External API Integrations

### 17.1 Appwrite SDK — Common Operations

```dart
// --- Authentication ---
await AppwriteClient.account.createEmailPasswordSession(
  email: email, password: password,
);

// --- Create document ---
await AppwriteClient.databases.createDocument(
  databaseId: AW.dbId,
  collectionId: AW.foodLogs,
  documentId: ID.unique(),
  data: foodLog.toAppwrite(),
  permissions: [
    Permission.read(Role.user(uid)),
    Permission.write(Role.user(uid)),
  ],
);

// --- Query documents (delta sync) ---
await AppwriteClient.databases.listDocuments(
  databaseId: AW.dbId,
  collectionId: AW.stepLogs,
  queries: [
    Query.equal('user_id', uid),
    Query.greaterThan('\$updatedAt', lastSyncTimestamp),
  ],
);

// --- Upload file ---
await AppwriteClient.storage.createFile(
  bucketId: AW.postsBucket,
  fileId: ID.unique(),
  file: InputFile.fromBytes(bytes: imageBytes, filename: 'post.jpg'),
  permissions: [Permission.read(Role.users())],
);

// --- Realtime subscription ---
AppwriteClient.realtime
  .subscribe(['databases.${AW.dbId}.collections.${AW.karmaTx}.documents'])
  .stream
  .listen((event) { /* handle karma update */ });
```

### 17.2 Open Food Facts

| Property    | Value                                                              |
|-------------|---------------------------------------------------------------------|
| Endpoint    | `https://world.openfoodfacts.org/api/v2/product/{barcode}.json`   |
| Method      | `GET`                                                              |
| User-Agent  | `FitKarma/1.0 (contact@fitkarma.app)`                             |
| Parse target| `product.nutriments` — calories, protein, carbohydrates, fat      |
| Fallback    | Prompt manual entry if barcode not found                           |
| Caching     | Save to `food_items_box` in Hive and create document in Appwrite  |

### 17.3 Fitbit Web API

```dart
// lib/features/wearables/data/fitbit_service.dart

// Step 1: Launch Fitbit OAuth2 consent screen
await launchUrl(Uri.parse(
  'https://www.fitbit.com/oauth2/authorize'
  '?response_type=code'
  '&client_id=${AppConfig.fitbitClientId}'
  '&scope=activity+sleep+heartrate+oxygen_saturation'
  '&redirect_uri=fitkarma://wearable/fitbit/callback',
));

// Step 2: Exchange auth code via Appwrite Function (keeps client_secret server-side)
// Step 3: Store access_token + refresh_token in flutter_secure_storage
// Step 4: Delta-sync on app resume — only data since last_sync_at
```

### 17.4 Appwrite Function — Fitbit Token Exchange

```javascript
// Appwrite Function (Node.js)
// Keeps Fitbit client_secret server-side — never exposed to the Flutter app
export default async ({ req, res }) => {
  const { code } = JSON.parse(req.body);
  const tokenRes = await fetch('https://api.fitbit.com/oauth2/token', {
    method: 'POST',
    headers: {
      'Authorization': 'Basic ' + btoa(CLIENT_ID + ':' + CLIENT_SECRET),
      'Content-Type':  'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      grant_type:   'authorization_code',
      code,
      redirect_uri: REDIRECT_URI,
    }),
  });
  const tokens = await tokenRes.json();
  return res.json({
    access_token:  tokens.access_token,
    refresh_token: tokens.refresh_token,
  });
};
```

### 17.5 Appwrite Functions — FCM Push Notifications

```javascript
// Trigger: databases.fitkarma.collections.challenges.documents.create
export default async ({ req, res, log }) => {
  const challenge = JSON.parse(req.body);
  const sdk = new Appwrite.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT)
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);
  const tokens = await fetchParticipantFcmTokens(sdk, challenge);
  await sendFCMNotification(tokens, {
    title: 'New Challenge!',
    body:  challenge.title,
  });
  return res.json({ success: true });
};
```

### 17.6 Razorpay — Subscription & One-time Purchase Flow

```
Subscriptions:
1. Flutter calls Appwrite Function → creates Razorpay subscription order
2. Flutter opens razorpay_flutter checkout
3. Payment success → Razorpay webhook fires
4. Appwrite Function verifies HMAC signature
5. Appwrite Function updates subscriptions collection
6. Appwrite Realtime pushes updated status to Flutter client

One-time purchases (à la carte workout packs):
1. Flutter calls Appwrite Function → creates Razorpay order (not subscription)
2. Flutter opens razorpay_flutter checkout
3. Payment success → webhook → Appwrite Function unlocks the purchased pack
4. Pack availability flag written to user document
```

### 17.7 Other Integrations

| Integration                    | Detail                                                              |
|--------------------------------|----------------------------------------------------------------------|
| Google ML Kit                  | TextRecognitionV2 (OCR), ObjectDetection (food photo), BarcodeScanning — no API key needed |
| `youtube_player_flutter`       | Plays workout videos by YouTube ID — no YouTube iOS/Android SDK    |
| OpenStreetMap + `flutter_map`  | GPS workout route display — no Google Maps API key needed           |
| Nominatim                      | Reverse geocoding for GPS workouts — free, no API key               |
| Health Connect / HealthKit     | `health` package — reads steps, sleep, heart rate, SpO2, BP        |
| Garmin Connect IQ              | OAuth1 — steps, sleep, HR, GPS workouts                            |
| `just_audio`                   | Bundled meditation audio playback — fully offline                   |
| Sentry                         | Anonymised crash reporting — Flutter app + Appwrite Functions       |

### 17.8 YouTube Data API v3 (Admin Use Only)

| Property  | Detail                                                              |
|-----------|----------------------------------------------------------------------|
| Endpoint  | `https://www.googleapis.com/youtube/v3/search`                      |
| Usage     | Admin-only task: populate workout YouTube IDs in Appwrite Console   |
| Cost note | 100 units per query — cache all results; never re-query the same workout |
| API Key   | Store in `.env` only — **never hardcode in source**                 |

---

## 18. Performance Contracts

| Metric                      | Target          | Strategy                                                         |
|-----------------------------|-----------------|------------------------------------------------------------------|
| Cold start                  | < 2 seconds     | Hive pre-warmed; deferred Riverpod providers                     |
| Dashboard render            | < 1 second      | Load from Hive first; lazy-load Appwrite data in background      |
| Local food search           | < 200 ms        | Hive full-text search on indexed `name` field                    |
| Offline write latency       | < 50 ms         | Direct Hive write — zero network calls                           |
| Sync batch flush            | < 5 seconds     | Max 20 documents per batch via Appwrite                          |
| Installed app size          | < 50 MB         | Tree-shaking, deferred fonts, compressed assets                  |
| Background battery drain    | < 3% / hour     | Efficient background isolate; batched sensor reads               |
| GPS workout accuracy        | ± 10 m          | High-accuracy mode; smooth polyline rendering                    |
| Image load time             | < 500 ms        | `cached_network_image` + Appwrite CDN URLs                       |
| PDF report generation       | < 3 seconds     | Dart isolate for PDF rendering — never blocks UI thread          |
| Wearable sync               | < 10 seconds on resume | Delta sync — only data since `last_sync_at`              |
| Glucose/BP chart render     | < 300 ms        | Pre-computed chart data in Hive; recalculated only on new log    |
| Fasting timer update        | < 16 ms         | `Timer.periodic(1s)` in isolate; UI driven by `StreamProvider`  |

### Flutter-Specific Optimisations

- `const` constructors on every widget possible — reduces unnecessary rebuilds.
- `RepaintBoundary` around animated widgets (dashboard rings, charts, fasting timer).
- `ListView.builder` for all scrolling lists — never `Column` with `map`.
- Dart isolates for CPU-heavy operations: AES encryption, PDF generation, barcode decoding, chart data processing.
- Images compressed to max 1080px, WebP format before upload.
- Deferred loading for infrequently accessed modules: Ayurveda, Emergency, Festival, Reports.

---

## 19. State Management

### Provider Types

| Provider                  | Use Case                                                          |
|---------------------------|-------------------------------------------------------------------|
| `Provider`                | Synchronous, immutable values — config, constants, services        |
| `FutureProvider`          | One-time async fetch — user profile, initial food search          |
| `StateNotifierProvider`   | Mutable state with business logic — auth, food log form, sync queue |
| `StreamProvider`          | Real-time data — Appwrite Realtime, step counter, wearable data, fasting timer |
| `AsyncNotifierProvider`   | Async state with mutations — preferred for complex screens in Riverpod 2.x |

### Code Standards

```dart
// ✅ Correct — async provider with proper state handling
final foodLogsProvider = FutureProvider.family<List<FoodLog>, DateTime>(
  (ref, date) async {
    final repo = ref.watch(foodRepositoryProvider);
    return repo.getLogsForDate(date);
  },
);

// ✅ Correct — handle all async states in the widget
@override
Widget build(BuildContext context, WidgetRef ref) {
  final data = ref.watch(foodLogsProvider(today));
  return data.when(
    loading: () => const ShimmerLoader(),
    error:   (e, s) => ErrorWidget(e),
    data:    (logs) => FoodLogList(logs: logs),
  );
}

// ❌ Wrong — business logic inside setState
setState(() {
  _foodLogs = await fetchLogs(); // Never do this
});

// ✅ ref.watch() in build(); ref.read() in callbacks only
// ✅ Named constructors: FoodLog.fromAppwrite(), FoodLog.fromHive()
// ✅ const constructors everywhere possible
// ✅ Always handle loading and error states — never assume success
```

### Navigation — GoRouter Route Map

```
/                               → Splash
/onboarding                     → Onboarding (5 steps)
/login                          → Login
/register                       → Register
/home                           → Shell (bottom nav)
  /home/dashboard               → Dashboard
  /home/food                    → Food Home
    /home/food/search           → Search
    /home/food/scan             → Barcode Scanner
    /home/food/photo            → Photo Scanner
    /home/food/detail/:id       → Food Detail
    /home/food/recipes          → Recipe Browser
    /home/food/recipes/new      → Recipe Builder
    /home/food/planner          → Meal Planner
  /home/workout                 → Workout Home
    /home/workout/:id           → Workout Detail
    /home/workout/:id/play      → Video Player
    /home/workout/custom        → Custom Workout Builder
    /home/workout/calendar      → Workout Calendar
  /home/steps                   → Steps Home
  /home/social                  → Social Feed
    /home/social/groups         → Community Groups
    /home/social/groups/:id     → Group Detail
    /home/social/dm/:userId     → Direct Messages
/karma                          → Karma Hub
/profile                        → Profile
/sleep                          → Sleep Tracker
/mood                           → Mood Tracker
/habits                         → Habit Tracker
/period                         → Period Tracker
/medications                    → Medications
/body-metrics                   → Body Measurements
/ayurveda                       → Ayurveda Hub
/family                         → Family Profiles
/emergency                      → Emergency Card
/blood-pressure                 → BP Tracker
/glucose                        → Glucose Tracker
/spo2                           → SpO2 Tracker
/chronic-disease                → Chronic Disease Hub
/fasting                        → Fasting Tracker
/meditation                     → Meditation & Pranayama
/journal                        → Journal
/mental-health                  → Mental Health Hub
/wearables                      → Wearable Connections
/reports                        → Health Reports
/personal-records               → Personal Records
/doctor-appointments            → Doctor Appointments
/referral                       → Referral Program
/settings                       → Settings
/subscription                   → Subscription Plans
```

**Bottom navigation (5 tabs)**: 🏠 Home · 🥗 Food · 💪 Workout · 👟 Steps · 👤 Me

---

## 20. Monetization & Subscriptions

### Plans (Razorpay)

| Plan               | Price (INR)      | Key Features                                                    |
|--------------------|------------------|-----------------------------------------------------------------|
| Free               | ₹0               | Core tracking, limited food DB, community access, 7-day history |
| Monthly Premium    | ₹99 / month      | Full food DB, unlimited history, premium workouts, all modules  |
| Quarterly Premium  | ₹249 / 3 months  | Same as Monthly — 16% saving                                    |
| Yearly Premium     | ₹899 / year      | Same as Monthly — 25% saving + priority support                 |
| Family Plan        | ₹1,499 / year    | Up to 6 members, shared leaderboard, family challenges          |

### Additional Revenue Streams

- **Karma Store** — premium workout packs, badge unlocks, profile themes redeemable with earned XP.
- **À la carte purchases** — buy a single premium workout pack without a full subscription.
- **Corporate wellness** — org-level dashboard, bulk subscriptions, HR integration.
- **Expert marketplace** — certified nutritionists and trainers (planned v3.0).
- **Affiliate** — transparent Ayurveda product recommendations via tracked links.
- **Referral program** — viral growth mechanic: +500 XP referrer, +100 XP referee.

### Free Tier Data Archival Strategy

- 7-day history visible in the free tier; older data **archived** (not deleted) in Appwrite.
- Upgrade prompt shown when user tries to access data older than 7 days.
- Archived data is restored immediately on upgrade — zero data loss.
- Free users can always export a full JSON archive of all their data (GDPR compliance).

---

## 21. Testing Strategy

### Unit Tests

Target ≥ 60% coverage for all files under `/features/*/data/` and `/features/*/domain/`.

- Business logic in all `StateNotifier` and `AsyncNotifier` classes.
- TDEE engine — BMR formulas, goal adjustments, macro splits.
- Dosha quiz scoring algorithm.
- Sync conflict resolution for all data types.
- AES-256 encryption / decryption round-trip for all encrypted types (period, journal, BP, glucose, appointments).
- Karma XP accumulation with streak multipliers.
- Blood pressure AHA classification logic — all threshold boundaries.
- Glucose WHO classification — fasting and post-meal thresholds.
- Fasting stage machine — in-progress, completed, broken states.
- Recipe calorie auto-calculation from ingredient list.
- Referral code generation uniqueness (collision probability test).
- BP/Glucose conflict resolution — client always wins for medical data.

### Widget Tests

- `ActivityRingsWidget` — correct percentage rendering for various data states (from dashboard mockup).
- `FoodSearchBar` — debounce, local search, loading state, bilingual placeholder.
- `KarmaProgressBar` — level boundary and overflow handling.
- `ErrorWidget` and `ShimmerLoader` — render correctly in all async states.
- `MoodEmojiSelector` — tap selection and slider interactions.
- `BPTrendChart` — correct colour banding for Normal / Elevated / Hypertension.
- `FastingProgressRing` — correct phase labelling and countdown display.
- `GlucoseHistoryChart` — correct target band rendering per reading type.
- `DoshaDonutChart` — correct segment proportions for all dosha combinations.
- `ChallengeCarouselCard` — progress bar, XP reward, scrollable layout.

### Integration Tests

- **Full food log flow**: search → select → confirm portion → verify Hive write → verify sync queue entry.
- **Offline → online sync**: log items offline, restore connectivity, verify Appwrite document created.
- **Auth flow**: register → complete onboarding → verify dashboard loads from Hive.
- **GPS workout**: start → track route → pause/resume → stop → verify `WorkoutLog` saved.
- **Period encryption**: log entry → read back → verify decryption succeeds → verify raw Hive bytes are not plaintext.
- **BP log flow**: log → verify AES encryption → verify correct AHA classification displayed.
- **Fasting flow**: start fast → advance time → eat → verify completion and XP awarded.
- **Wearable sync**: mock Fitbit API response → verify data maps to correct Hive boxes.
- **Referral flow**: generate code → sign up with code → verify XP awarded to both parties.
- **Recipe builder**: add ingredients → calculate → save → log recipe → verify calorie total in food log.
- **Meal planner → food log**: plan a meal → tap log → verify food log created with `log_method: planner`.

### Performance Tests

- Dashboard cold start benchmark < 2s on a mid-range device (3 GB RAM).
- Food search Hive query < 200ms against a 10,000-item database.
- Sync queue flush — 20 records uploaded in < 5 seconds on a 3G connection.
- Memory profiling — no leaks in the food log screen after 50 entries.
- PDF report generation < 3 seconds for a 30-day report.
- BP chart render < 300ms with 90 data points.

---

## 22. Coding Standards

### Dart / Flutter Rules

- **Riverpod only** for state management — `setState` is never used for business logic.
- **Immutable models** — all fields are `final`; use `copyWith` for updates.
- **Named constructors mandatory**: `MyModel.fromAppwrite()`, `MyModel.fromHive()`.
- **`AsyncValue` handling mandatory** for all `FutureProvider` / `StreamProvider` widgets.
- **`const` constructors** on every widget and model where possible.
- **Build method limit**: max 80 lines — extract sub-widgets if exceeded.
- **No `var`** for non-obvious types — always declare the type explicitly.
- **Private helpers** prefixed with underscore: `_buildHeader()`, `_onTap()`.

### Widget File Template

```dart
class FoodLogCard extends ConsumerWidget {
  const FoodLogCard({required this.log, super.key});

  // 1. Final fields
  final FoodLog log;

  // 2. build() — max 80 lines
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(children: [
        _buildTitle(),
        _buildMacroRow(),
      ]),
    );
  }

  // 3. Private helper widgets / methods
  Widget _buildTitle()    => Text(log.foodName);
  Widget _buildMacroRow() => Row(/* ... */);
  void _onDeleteTap(WidgetRef ref) { /* ... */ }

  // 4. Static utility methods (if any)
  static double gramsToOunces(double g) => g * 0.03527;
}
```

### Commit Message Format (Conventional Commits)

```
feat(food):        add voice logging in Hindi
feat(bp):          add blood pressure tracker module
feat(fasting):     add intermittent fasting timer
fix(steps):        background tracking crash on Android 13
perf(dash):        reduce cold start by 200ms
chore(deps):       upgrade riverpod to 2.4.9
test(sync):        add Appwrite conflict resolution unit tests
docs(readme):      update Appwrite setup instructions
refactor(auth):    extract token refresh into AuthService
```

### File Naming Conventions

| Type          | Convention                         | Example                   |
|---------------|------------------------------------|---------------------------|
| Screens       | `snake_case_screen.dart`           | `food_log_screen.dart`    |
| Widgets       | `snake_case_card.dart` / `_widget` | `food_log_card.dart`      |
| Providers     | Grouped by feature                 | `food_providers.dart`     |
| Models        | `snake_case_model.dart`            | `food_log_model.dart`     |
| Appwrite svc  | `feature_aw_service.dart`          | `food_aw_service.dart`    |
| Local svc     | `feature_hive_service.dart`        | `food_hive_service.dart`  |
| Repositories  | `feature_repository.dart`          | `food_repository.dart`    |

---

## 23. Environment Configuration

> ⚠️ **Never commit `.env` files to version control. Add `.env` to `.gitignore` immediately.**

### `.env` File

```env
# ── Appwrite ─────────────────────────────────────────────────────
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your_project_id
APPWRITE_DATABASE_ID=your_database_id
APPWRITE_API_KEY=your_server_api_key       # Server-side / Appwrite Functions only

# ── External APIs ─────────────────────────────────────────────────
YOUTUBE_API_KEY=your_youtube_data_api_v3_key
RAZORPAY_KEY_ID=rzp_test_xxxxxxxxxxxx
RAZORPAY_KEY_SECRET=your_secret_key
OPEN_FOOD_FACTS_USER_AGENT=FitKarma/1.0 (contact@fitkarma.app)
FCM_SERVER_KEY=your_fcm_server_key
SENTRY_DSN=https://xxx@sentry.io/xxx

# ── Wearable APIs ─────────────────────────────────────────────────
FITBIT_CLIENT_ID=your_fitbit_client_id
FITBIT_CLIENT_SECRET=your_fitbit_client_secret   # SERVER SIDE ONLY — Appwrite Function env var
GARMIN_CONSUMER_KEY=your_garmin_consumer_key
GARMIN_CONSUMER_SECRET=your_garmin_consumer_secret

# ── Production overrides ──────────────────────────────────────────
# APPWRITE_ENDPOINT=https://appwrite.fitkarma.app/v1
# RAZORPAY_KEY_ID=rzp_live_xxxxxxxxxxxx
```

> ⚠️ `FITBIT_CLIENT_SECRET` and `GARMIN_CONSUMER_SECRET` must **only** be stored as Appwrite Function environment variables — never in the Flutter app's build environment.

### `AppConfig` Dart Class

```dart
// lib/core/constants/app_config.dart
class AppConfig {
  static String get appwriteEndpoint => const String.fromEnvironment(
    'APPWRITE_ENDPOINT',
    defaultValue: 'https://cloud.appwrite.io/v1',
  );

  static String get appwriteProjectId =>
    const String.fromEnvironment('APPWRITE_PROJECT_ID');

  static String get appwriteDatabaseId =>
    const String.fromEnvironment('APPWRITE_DATABASE_ID');

  static String get razorpayKeyId =>
    const String.fromEnvironment('RAZORPAY_KEY_ID');

  // Public ID only; secret stays server-side in Appwrite Functions
  static String get fitbitClientId =>
    const String.fromEnvironment('FITBIT_CLIENT_ID');
}

// Build command:
// flutter run --dart-define-from-file=.env
```

### `pubspec.yaml` — Key Dependencies

```yaml
dependencies:
  flutter_riverpod:              ^2.4.9
  riverpod_annotation:           ^2.3.3
  hive_flutter:                  ^1.1.0
  appwrite:                      ^13.0.0
  go_router:                     ^11.0.0
  dio:                           ^5.4.0
  http:                          ^1.1.0
  flutter_secure_storage:        ^9.0.0
  local_auth:                    ^2.1.7
  connectivity_plus:             ^5.0.2
  geolocator:                    ^10.1.0
  flutter_map:                   ^6.1.0
  youtube_player_flutter:        ^8.1.2
  google_mlkit_text_recognition: ^0.11.0
  google_mlkit_object_detection: ^0.11.0
  flutter_barcode_scanner:       ^1.0.0
  speech_to_text:                ^6.3.0
  health:                        ^9.0.0
  fl_chart:                      ^0.66.0
  shimmer:                       ^3.0.0
  flutter_local_notifications:   ^16.1.0
  razorpay_flutter:              ^1.3.7
  firebase_messaging:            ^14.7.9   # FCM token only — no other Firebase packages
  sentry_flutter:                ^7.14.0
  cached_network_image:          ^3.3.1
  image_picker:                  ^1.0.4
  path_provider:                 ^2.1.1
  flutter_dotenv:                ^5.1.0
  pdf:                           ^3.10.0
  flutter_quill:                 ^9.0.0
  just_audio:                    ^0.9.0
  workmanager:                   ^0.5.0

dev_dependencies:
  riverpod_generator: ^2.3.9
  hive_generator:     ^1.0.1
  build_runner:       ^2.4.7
  flutter_test:
    sdk: flutter
  mockito:            ^5.4.4
  integration_test:
    sdk: flutter
```

---

## 24. CI/CD Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: FitKarma CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: stable
      - run: flutter pub get
      - run: flutter analyze --fatal-infos
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
        with:
          files: coverage/lcov.info

  build_android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter build appbundle --dart-define-from-file=.env.prod
      - uses: actions/upload-artifact@v3
        with:
          name: android-release
          path: build/app/outputs/bundle/release/app-release.aab

  build_ios:
    needs: test
    runs-on: macos-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter build ipa --dart-define-from-file=.env.prod
```

### Appwrite Deployment

```bash
# Install Appwrite CLI
npm install -g appwrite-cli

# Login
appwrite login

# Deploy all functions
appwrite deploy function --functionId fcm_push_hook
appwrite deploy function --functionId razorpay_webhook
appwrite deploy function --functionId fitbit_token_exchange
appwrite deploy function --functionId garmin_token_exchange
```

> Set all server-side secrets (Fitbit, Garmin, Razorpay) as Appwrite Function environment variables — never in version control.

### Disaster Recovery & Backup

```bash
# Daily backup cron job — runs at 02:00 IST every day
0 20 * * * appwrite databases export \
  --databaseId $DATABASE_ID \
  --output /backups/fitkarma-$(date +%Y%m%d).json \
  && rclone copy /backups/ b2:fitkarma-backups/
```

- **Retention policy**: 30 daily backups retained; 12 monthly backups retained.
- **Storage**: Backblaze B2 (cost-effective for Indian teams).
- **Recovery test**: Restore procedure tested monthly in a staging environment.

### Admin Dashboard

- **Internal web app** built with Appwrite Console + custom Appwrite Functions.
- **Content management**: Add/edit workout videos, seed food items, create and manage challenges.
- **User management**: Aggregate engagement stats, subscription management, Razorpay refund processing.
- **Monitoring**: Appwrite Console metrics + Sentry dashboard for Flutter crash rates + Appwrite Function error rates.
- **Feature flags**: Simple key-value document in Appwrite to toggle features without an app update.

---

*FitKarma Developer Documentation*
*Flutter · Riverpod · Hive · Appwrite · Built for India*
*Offline-first · Privacy-centric · 30+ modules · Full bilingual UI*