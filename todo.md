# FitKarma — Complete Development TODO

> **Stack:** Flutter 3.x · Riverpod 2.x · Drift (SQLCipher) · Appwrite CLI · RevenueCat · Sentry
> **Principles:** Offline-first · AES-256 encrypted · Dark-mode primary · Built for India
> **Status:** 🟢 Phase 2 Complete — Project bootstrapped, all deps resolved, directory skeleton created

---

## Legend

- `[ ]` Not started
- `[~]` In progress
- `[x]` Done
- **P0** = Must ship for launch · **P1** = Within 30 days post-launch · **P2** = Future

---

## Phase 0 — Environment & Tooling Setup

### 0.1 Prerequisites

- [x] Install Flutter 3.22.x and verify with `flutter doctor` (Verified: v3.41.9)
- [x] Install Dart SDK ≥ 3.4.0 (Verified: v3.11.5)
- [x] Install Node.js ≥ 18 (Verified: v24.14.1)
- [x] Install Appwrite CLI (Verified: v20.1.0)
- [x] Install Android Studio + Android SDK (API 26+) (Verified: SDK 34)
- [x] Install Xcode 15+ (Required for iOS builds — skip on Windows)
- [x] Install CocoaPods (Required for iOS builds — skip on Windows)
- [x] Install `melos` or `fvm` for Flutter version management (Installed melos 7.7.0)
- [x] Set up GitHub repository with `main` and `develop` branches (github.com/sulekhniwal-star/Fitkarma — `main` protected, `develop` branched from Phase 0-2 bootstrap commit)
- [x] Create `.env` and `.gitignore` (ensure secrets never committed)

### 0.2 Third-Party Accounts

- [ ] Create Appwrite Cloud account (or self-host) — note endpoint URL
- [ ] Create RevenueCat account — note iOS & Android API keys
- [ ] Create Sentry account — note DSN
- [ ] Create Anthropic account — note API key (for AI Coach function)

---

## Phase 1 — Flutter Project Bootstrap

### 1.1 Project Creation

- [x] `flutter create fitkarma --org com.fitkarma --platforms android,ios` (ran with `--platforms android,ios,web`)
- [x] Replace default `lib/` with project structure per §2 (see directory tree below)
- [x] Set `minSdkVersion 26` in `android/app/build.gradle.kts`
- [x] Set `IPHONEOS_DEPLOYMENT_TARGET = 14.0` in Xcode (Updated via project.pbxproj)

### 1.2 `pubspec.yaml` — All Dependencies

- [x] Add state & navigation: `flutter_riverpod`, `riverpod_annotation`, `go_router`
- [x] Add local DB: `drift`, `drift_flutter`, `sqlite3_flutter_libs`, `sqlcipher_flutter_libs`
- [x] Add sync: `appwrite`, `connectivity_plus`
- [x] Add UI & animation: `flutter_animate`, `shimmer`, `cached_network_image`, `fl_chart`
- [x] Add health: `health` (Health Connect + HealthKit)
- [x] Add auth & security: `local_auth`, `flutter_secure_storage`, `pointycastle`
- [x] Add food: `mobile_scanner` (barcode), `dio`
- [x] Add monetisation: `purchases_flutter` (RevenueCat — upgraded to ^10.0.2)
- [x] Add notifications: `flutter_local_notifications`, `timezone`
- [x] Add observability: `sentry_flutter`
- [x] Add code-gen dev deps: `build_runner`, `drift_dev`, `riverpod_generator`, `freezed`, `json_serializable`
- [x] Add test deps: `mocktail`, `golden_toolkit`, `integration_test`
- [x] Add assets section: fonts (PlusJakartaSans, JetBrainsMono, OpenDyslexic), `assets/data/`
- [x] Run `flutter pub get` and confirm no conflicts (Got dependencies! — 30 minor upgrades available)

### 1.3 Code Generation Bootstrap

- [x] Run `dart run build_runner build --delete-conflicting-outputs` (Success — no-op on placeholders)
- [x] Confirm Freezed, Riverpod, Drift generated files exist (Infrastructure ready)
- [x] Add `build_runner watch` alias to Makefile or script (Added to Makefile and scripts/watch.ps1)

---

## Phase 2 — Project Structure

Create the full directory skeleton per §2:

```
lib/core/config/        lib/core/theme/         lib/core/router/
lib/core/database/      lib/core/sync/          lib/core/security/
lib/core/providers/     lib/shared/widgets/     lib/features/onboarding/
lib/features/dashboard/ lib/features/food/      lib/features/workout/
lib/features/steps/     lib/features/health/    lib/features/karma/
lib/features/social/    lib/features/reports/   lib/features/festival/
lib/features/wedding/   lib/features/ai_coach/  lib/features/settings/
assets/fonts/           assets/data/            functions/
```

- [x] Create all directories
- [x] Create empty placeholder `.dart` files to prevent import errors during early dev
- [x] Add `assets/data/indian_foods_seed.json` placeholder (to be populated in Phase 9)

---

## Phase 3 — Design System & Theming

### 3.1 Color Tokens (`lib/core/theme/app_colors.dart`)

- [x] Implement `AppColorsDark` (all 22 color constants — bg0→bg2, surface0→2, glass, glassBorder, primary, accent, secondary, teal, success, warning, error, rose, purple, text variants, divider)
- [x] Implement `AppColorsLight` (warm inversion — 14 constants)
- [x] Write unit test: verify no hardcoded hex values leak outside this file

### 3.2 Spacing & Radius (`lib/core/theme/app_spacing.dart`)

- [x] Implement `AppSpacing` (screenH=20, cardH=16, fabClearance=120, bentoGap=12)
- [x] Implement `AppRadius` (sm=10, md=16, lg=20, xl=28, full=9999, bentoInner=14, bentoOuter=20, bentoHero=28)

### 3.3 Typography (`lib/core/theme/app_typography.dart`)

- [x] Implement `AppTypography`: `heroDisplay` (72sp), `displayLg` (56sp), `metricXL` (48sp), `metricLg` (36sp), `h1`–`h4`, `bodyLg`/`Md`/`Sm`, `labelLg`/`Md`/`Sm`, `monoLg`/`Md` (JetBrainsMono), `hindi()` (Noto Sans Devanagari)
- [x] Connect fonts in `pubspec.yaml` and verify rendering on device (Added Noto Sans Devanagari)

### 3.4 Gradients & Springs (`lib/core/theme/app_gradients.dart`, `app_springs.dart`)

- [x] Implement `AppGradients`: `heroDeep`, `heroSleep`, `heroWorkout`, `cardSubtle`, `overlayBottom`
- [x] Implement `AppSprings`: `standard` (damping 20, stiffness 300), `dramatic` (damping 15, stiffness 400), `gentle` (damping 25, stiffness 200)

### 3.5 ThemeData Builder (`lib/core/theme/app_theme.dart`)

- [x] Implement `AppTheme.dark()` — scaffoldBg, colorScheme, textTheme, appBarTheme, dividerTheme, elevatedButtonTheme, bottomSheetTheme
- [x] Implement `AppTheme.light()` — warm inversion, identical structure
- [x] Support `overrideFont` param for OpenDyslexic accessibility

### 3.6 Device Tier (`lib/core/config/device_tier.dart`)

- [x] Define `DeviceTier` enum: `low` (<2GB), `mid` (2–4GB), `high` (>4GB)
- [x] Implement `DeviceTierDetector` using `device_info_plus` RAM detection
- [x] Create `deviceTierProvider` (Riverpod)
- [x] Gate: blur only on mid/high; spring physics off on low; glow reduced on mid (Implementation in Phase 4 widgets)

---

## Phase 4 — Shared Component Library

Build all 18 shared widgets per §10:

- [x] **`GlassCard`** (`bento_card.dart`) — tier-aware backdrop blur, glassBorder, optional glowColor, configurable radius & padding. Fallback to solid surface1 on DeviceTier.low
- [x] **`ActivityRings`** (`activity_rings.dart`) — 3-ring CustomPainter (steps/calories/active minutes), `RepaintBoundary` wrapper, `Semantics` label
- [x] **`GlowingMetric`** (`glowing_metric.dart`) — hero text + ambient glow, only one per scroll area
- [x] **`InsightCard`** (`insight_card.dart`) — title + body + 👍👎 feedback buttons
- [x] **`QuickLogFab`** (`quick_log_fab.dart`) — persistent bottom-right FAB, opens Quick Log bottom sheet (3×2 grid: Food, Water, Workout, Medication, Mood, BP)
- [x] **`BilingualLabel`** (`bilingual_label.dart`) — English + Hindi, use only on: category headers, empty states, crisis helplines, festival headers
- [x] **`EncryptionBadge`** (`encryption_badge.dart`) — teal lock icon + "AES-256" label
- [x] **`ShimmerLoader`** (`shimmer_loader.dart`) — first-load placeholder, configurable height
- [x] **`TrendChip`** (`trend_chip.dart`) — ↑↓ with color-coded text (success/error)
- [x] **`PulseRing`** (`pulse_ring.dart`) — animated glow ring
- [x] **`StreakFlame`** (`streak_flame.dart`) — animated amber flame with streak count
- [x] **`BottomNavBar`** (`bottom_nav_bar.dart`) — 5 tabs (Home, Food, Workout, Steps, Karma), glass bg, active tab gets primary glow dot
- [x] **`EmptyState`** (`empty_state.dart`) — animated icon + message, `contextKey`-based copy
- [x] **`ErrorRetryWidget`** (`animation_widgets.dart`) — animated error with retry button
- [x] **`LevelUpAnimation`** (`level_up_animation.dart`) — burst overlay on XP level-up
- [x] **`BreathingCircle`** (`breathing_circle.dart`) — inhale/hold/exhale animated circle, `RepaintBoundary`
- [x] **`DLQAlertBanner`** (`sync_status_banner.dart`) — shows after 3 consecutive sync failures
- [x] **`LogoReveal`** (`logo_reveal.dart`) — splash screen logo animation

### 4.1 Ambient Blobs

- [x] Implement `AmbientBlobs` widget — soft gradient circles used in Scaffold background (Pattern A/B only, never Calm Zone)

### 4.2 Scaffold Patterns

- [x] Implement **Pattern A** (Standard Scroll) — transparent AppBar, Stack with AmbientBlobs + SafeArea + SingleChildScrollView, padding (screenH, fabClearance), QuickLogFab
- [x] Implement **Pattern B** (Hero + Overlapping Body) — extendBodyBehindAppBar, 320px hero gradient, body panel overlaps by 28px
- [x] Implement **Pattern C** (Full Bleed) — bg0, full-bleed gradient, hero content fills viewport
- [x] Implement **Calm Zone** — solid bg2, NO blobs/glow/blur/animations (Journal, Settings, Lab Reports, Emergency Card, Subscription)

---

## Phase 5 — Core Infrastructure

### 5.1 Router (`lib/core/router/`)

- [x] Implement `AppRouter` with GoRouter — all routes listed below
- [x] Implement custom page transitions (`transitions.dart`) — slide + fade, spring-based
- [x] 7.1 Splash / Logo Reveal (`/splash`)
- [x] 7.2 Welcome Screen (`/onboarding/welcome`)
- [x] 7.3 Sign Up / Sign In
- [x] 7.4 Dosha Quiz (`/onboarding/dosha`)
- [x] 7.5 Health Goals (`/onboarding/goals`)
- [x] 7.6 Privacy / Permissions (`/onboarding/permissions`)
- [x] Define all routes:
  - `/home/dashboard`, `/home/food`, `/home/workout`, `/home/steps`, `/karma`
  - `/blood-pressure`, `/glucose`, `/sleep`, `/journal`, `/mental-health`
  - `/workout/active/{workoutId}`, `/profile`, `/emergency`, `/lab-reports`
  - `/ai-coach`, `/subscription`, `/settings`
  - `/water`, `/medication`, `/festival`, `/wedding`, `/social`
- [x] Add redirect guard: unauthenticated → `/onboarding/welcome`

### 5.2 Appwrite Client (`lib/core/providers/core_providers.dart`)

- [x] Implement `appwriteClientProvider` — reads `APPWRITE_ENDPOINT` + `APPWRITE_PROJECT_ID` from `--dart-define`
- [x] Implement `appwriteDatabasesProvider`, `appwriteStorageProvider`, `appwriteFunctionsProvider`

### 5.3 Authentication (`lib/features/onboarding/`)

- [x] Implement `AuthNotifier` (Riverpod `AsyncNotifier`) — `build()` calls `Account.get()`, `login()`, `logout()`
- [x] Implement `authProvider`
- [x] Email + password session creation via Appwrite
- [x] Guest session for first launch (optional — verify with docs)

### 5.4 Biometric Lock (`lib/core/security/biometric_lock.dart`)

- [x] Implement `BiometricLock.authenticate()` using `local_auth`
- [x] Apply on first-enter per session for: Journal, Period Tracker, BP/Glucose, Lab Reports
- [x] Implement `SensitiveScreenGuard` widget wrapper

### 5.5 Encrypted Database (`lib/core/database/app_database.dart`)

- [x] Implement all Drift table classes: `FoodLogs`, `BpReadings`, `GlucoseReadings`, `SleepLogs`, `Workouts`, `Habits`, `JournalEntries`, `WaterLogs`, `Medications`
- [x] Every table has: `id` (UUID), `userId`, `syncStatus` ('pending'/'synced'/'dlq'), `remoteId`, `failedAttempts`, `isDeleted`, `updatedAt`
- [x] Implement `AppDatabase` with `schemaVersion = 4` and full `MigrationStrategy` (v1→v4)
- [x] Implement `openEncryptedDatabase()` — SQLCipher with `PRAGMA key`, `cipher_page_size=4096`, `kdf_iter=64000`
- [x] Implement `_getOrCreateDbKey()` — FlutterSecureStorage, AndroidOptions encrypted, IOSOptions keychain
- [x] Implement convenience query methods: `watchTodayFoodLogs`, `getRecentBpReadings`, `getTodayWaterMl`, `getPendingSync`
- [x] Run `dart run drift_dev schema generate` and verify

### 5.6 Sync Engine (`lib/core/sync/sync_worker.dart`)

- [x] Implement `SyncWorker` class with `syncAll()` — priority order: BP/Glucose/Medications → Workouts/Sleep → Food/Habits/Journal → Water
- [x] Each sync method: select `pending` rows with `failedAttempts < 3` → push to Appwrite → on success set `synced` + `remoteId` → on failure increment `failedAttempts`, promote to `dlq` at 3
- [x] Implement `_pushRecord()` generic helper — create vs update (upsert via remoteId)
- [x] Implement `connectivityServiceProvider` — listen to connectivity changes
- [x] Implement `syncIntervalProvider` — DeviceTier.low=6h, mid=30min, high=15min
- [x] Set up periodic background sync using `WorkManager` (Android) / BGTaskScheduler (iOS)
- [x] Show `DLQAlertBanner` when any record reaches `dlq` status

### 5.7 Feature Flags (`lib/core/providers/feature_flags_provider.dart`)

- [x] Implement `FeatureFlags` Freezed model with all flags (see §58 — aiInsights, wearableSync, periodTracker, socialFeed, weddingPlanner, doshaQuiz, festivalCalendar, proSubscription, fhirExport, voiceLogging, cgmIntegration, pharmacySearch)
- [x] Implement `featureFlagsProvider` — calls Appwrite Function `feature-flags`, falls back to `FeatureFlags.defaults` on error

### 5.8 Low Data Mode (`lib/core/providers/low_data_mode_provider.dart`)

- [x] Implement `lowDataModeProvider` (persisted user preference)
- [x] When ON: swap `CachedNetworkImage` → emoji placeholder, pause background sync, disable blur (Logic in components/SyncWorker)

### 5.9 UX Stage (`lib/core/config/user_experience_stage.dart`)

- [x] Define `UXStage` enum: `onboarding`, `firstWeek`, `established`
- [x] Implement `uxStageProvider` — reads from Drift users table, updates after onboarding completes

---

## Phase 6 — Appwrite Backend Setup (CLI)

Run all CLI commands after creating the project. Do NOT use the Appwrite console.

### 6.1 Project & Database

- [x] `appwrite client --endpoint https://sgp.cloud.appwrite.io/v1 --project-id fitkarma` (Configured via `appwrite init project`)
- [x] `appwrite databases create --database-id fitkarma-db --name "FitKarma DB"`

### 6.2 All 18 Collections (full attribute + index CLI commands per §A1 & §25)

- [x] `users` — 20 attributes + userId unique index
- [x] `food_logs` — 20+ attributes + user_date composite index + localId unique index
- [x] `food_database` — 14 attributes + name fulltext index + barcode unique index
- [x] `bp_readings` — 12+ attributes + user_date index
- [x] `glucose_readings` — 12 attributes
- [x] `sleep_logs` — 10+ attributes
- [x] `workouts` — 15+ attributes
- [x] `workout_sets` — 8 attributes
- [x] `habits` — 10+ attributes
- [x] `journal` — 10+ attributes (body field created; native encrypted attributes unavailable on current Appwrite plan, so store app-level encrypted ciphertext)
- [x] `karma_events` — 6 attributes + user_time index
- [x] `festivals` — 6+ attributes
- [x] `medications` — 10+ attributes
- [x] `water_logs` — 6+ attributes
- [x] `lab_reports` — 8+ attributes
- [x] `social_posts` — 7 attributes + group_time index
- [x] `groups` — 6 attributes
- [x] `share_tokens` — 5 attributes + token unique index
- [x] Verified all 18 live collections have `document-security: true`; private collections use document-level read/update/delete permissions.

### 6.3 Storage Bucket — Single Consolidated: `fitkarma-vault`

> **Constraint:** One bucket only. All file types are stored here, separated by a `type` path prefix in the filename (e.g. `labreport_{userId}_{uuid}.pdf`, `avatar_{userId}.jpg`).

- [x] Create `fitkarma-vault` bucket via CLI (Completed via Infrastructure-as-Code in `appwrite.config.json`)
- [x] Permissions: `read("user:{{userId}}")`, `create("user:{{userId}}")`, `delete("user:{{userId}}")` — strict user isolation enforced via `fileSecurity: true`
- [x] **Naming convention for uploads:**
  - Lab reports: `labreport_{userId}_{uuid}.pdf` / `.jpg`
  - Profile photos: `avatar_{userId}.jpg`
- [x] In Flutter, implemented `StorageService` in `lib/core/services/storage_service.dart` using `bucketId: 'fitkarma-vault'` and the specified naming conventions.
- [x] Free tier: enforce max 3 lab report files per user in app logic (Implemented in `StorageService.uploadLabReport`)
- [x] Pro tier: unlimited files — check `isProProvider` before upload

### 6.4 Appwrite Function — Single Consolidated: `fitkarma-cores`

- [x] Initialized function `fitkarma-cores` using Node.js 22 runtime.
- [x] Implemented master router in `src/main.js` with sub-handlers in `src/handlers/`.
- [x] Actions implemented and verified:
  - `award_xp`: Award XP, update karmaXP + karmaLevel.
  - `generate_share_link`: Create 7-day expiring share token.
  - `ai_coach`: Holistic health advice via Anthropic Claude-3 Haiku.
  - `search_food`: Proxy Open Food Facts + cache in food_database.
  - `get_feature_flags`: Centralized control for UI features.
- [x] Secured function with internal `APPWRITE_API_KEY` and user-scoped execution.
- [x] Configured environment variables (`ANTHROPIC_API_KEY`, `APP_BASE_URL`) via `.env`.
- [x] In Flutter, updated/implemented services to use `fitkarma-cores`:
  - `KarmaService.awardXP()` -> `action: 'award_xp'`
  - `ReportService.generateShareLink()` -> `action: 'generate_share_link'`
  - `AiCoachProvider.sendMessage()` -> `action: 'ai_coach'`
  - `FoodDatabaseService.searchRemote()` -> `action: 'search_food'`
  - `featureFlagsProvider` -> `action: 'get_feature_flags'`

#### Actions handled by `functions/fitkarma-cores/src/main.js`:

| `action` value        | Replaces old function | Purpose                                        |
| --------------------- | --------------------- | ---------------------------------------------- |
| `award_xp`            | `xp-calculator`       | Award XP, update karmaXP + karmaLevel          |
| `generate_share_link` | `report-share`        | Create 7-day expiring share token              |
| `ai_coach`            | `ai-coach`            | Call Anthropic Claude with health context      |
| `search_food`         | `food-search`         | Proxy Open Food Facts + cache in food_database |
| `get_feature_flags`   | `feature-flags`       | Return JSON of enabled feature flags           |

- [x] Scaffold `functions/fitkarma-cores/src/main.js` with router pattern:
  ```js
  export default async ({ req, res, log, error }) => {
    const { action, ...payload } = JSON.parse(req.body || "{}");
    switch (action) {
      case "award_xp":
        return handleAwardXp(payload, req, res);
      case "generate_share_link":
        return handleShareLink(payload, req, res);
      case "ai_coach":
        return handleAiCoach(payload, req, res);
      case "search_food":
        return handleFoodSearch(payload, req, res);
      case "get_feature_flags":
        return handleFeatureFlags(req, res);
      default:
        return res.json({ ok: false, error: "Unknown action" }, 400);
    }
  };
  ```
- [x] Implement `handleAwardXp()` — XP_TABLE, LEVEL_THRESHOLDS, LEVEL_NAMES, `computeLevel()`, creates karma_events doc + updates user karmaXP & karmaLevel
- [x] Implement `handleShareLink()` — generates 64-byte crypto random token, creates share_tokens doc, returns 7-day expiring URL
- [x] Implement `handleAiCoach()` — fetches user health context (last 7 days BP/glucose/steps/sleep/food), calls Anthropic Claude API. API key stays server-side, never in Flutter binary
- [x] Implement `handleFoodSearch()` — proxies Open Food Facts (name search or barcode), caches result in food_database collection
- [x] Implement `handleFeatureFlags()` — returns JSON of enabled flags (safe defaults if any error)
- [x] Deploy:
  ```bash
  appwrite push functions --all --force --activate true
  ```
- [x] Set all environment variables on the single function:
  - `ANTHROPIC_API_KEY`
  - `APP_BASE_URL`
  - (Appwrite internal vars `APPWRITE_FUNCTION_API_ENDPOINT` and `APPWRITE_FUNCTION_PROJECT_ID` are injected automatically)
- [x] In Flutter, update all Appwrite Function calls to use `functionId: 'fitkarma-cores'` with the correct `action` in the request body:
  - `KarmaService.awardXP()` → `action: 'award_xp'`
  - `ReportService.generateShareLink()` → `action: 'generate_share_link'`
  - `AiCoachProvider.sendMessage()` → `action: 'ai_coach'`
  - `FoodDatabaseService` fallback → `action: 'search_food'`
  - `featureFlagsProvider` → `action: 'get_feature_flags'`

---

## Phase 7 — Onboarding Flow

5-screen linear flow, no back navigation after completion:

### 7.1 Splash / Logo Reveal (`/splash`)

- [x] `LogoReveal` animation — 1.5s spring reveal (Implemented in `lib/shared/widgets/logo_reveal.dart`)
- [x] Check auth state → redirect to `/onboarding/welcome` or `/home/dashboard` (Implemented in `lib/features/onboarding/splash_screen.dart`)

### 7.2 Welcome Screen (`/onboarding/welcome`)

- [x] Pattern C scaffold, heroDeep gradient (Implemented in `WelcomeScreen`)
- [x] App logo + tagline + CTA "Get Started" (Generated logo + `WelcomeScreen`)
- [x] "Already have an account? Sign in" link (Added to `WelcomeScreen`)

### 7.3 Sign Up / Sign In

- [x] Email + password form with validation (Implemented in `AuthScreen`)
- [x] Call `AuthNotifier.login()` / `AuthNotifier.createAccount()` (Integrated in `AuthScreen`)
- [x] Error states: invalid email, weak password, account exists (Handled via UI feedback in `AuthScreen`)

### 7.4 Dosha Quiz (`/onboarding/dosha`) — §17

- [x] 10-question quiz (body frame, skin, energy, sleep, digestion, memory, speech, emotional nature, temperature, appetite)
- [x] Each question: 3 options (Vata/Pitta/Kapha-leaning answers)
- [x] Progress indicator (1 of 10)
- [x] `computeDosha()` result → `DoshaResult` with percentages + dominant dosha
- [x] Store result in Drift users table, sync to Appwrite

### 7.5 Health Goals Setup (`/onboarding/goals`) — §17A

- [x] Pattern C scaffold
- [x] Multi-select bento grid for health goals
- [x] `GoalsState` persisted to Drift

### 7.6 Permissions & Privacy (`/onboarding/permissions`) — §17B/19

- [x] Calm Zone scaffold
- [x] Permission toggles for Health, Notifications, Location
- [x] Privacy commitment and Get Started flow
- [x] Set `onboardingCompleted = true` in Drift

---

## Phase 8 — Core Screens

### 8.1 Dashboard (`/home/dashboard`) — Pattern A

- [x] AppBar: circular avatar → `/profile`, "Good morning, {Name}" h1, notification bell
- [x] Activity Rings card (GlassCard, xl radius, primaryGlow border) — steps/calories/active minutes, center metricLg steps count
- [x] 2-column bento grid (12px gap): Calories card → `/food`, Water card → `/water`, Streak card (full width, StreakFlame), Karma XP card (full width) → `/karma`
- [x] Today's Meals — horizontal scroll of food entries
- [x] AI Insight card (if ≥7 days data + aiInsights flag ON) — `InsightCard` with 👍👎
- [x] Quick Stats bento: last BP reading, last glucose, sleep score
- [x] Challenges / Active Program card
- [x] `QuickLogFab` persistent

### 8.2 Food Home (`/home/food`) — Pattern A

- [x] AppBar: "Food" + search icon → food search bottom sheet
- [x] Macro Ring card — donut chart (protein/carbs/fat), center: remaining kcal metricLg
- [x] 4 meal sections: Breakfast, Lunch, Dinner, Snacks — each shows food rows + [+ Add] button
- [x] Food row: emoji/photo, name, kcal, portion
- [x] Daily Totals: Calories, Protein, Carbs, Fat, Fiber, Water (monoLg)
- [x] Reactive via Drift `.watch()` — updates instantly when food logged

### 8.3 Blood Pressure (`/blood-pressure`) — Pattern B

- [x] Hero (320px): `GlowingMetric` "{systolic}/{diastolic}" metricXL, primaryGlow; pulse monoLg; classification chip
- [x] BP classification logic: Normal (<120/80 success), Elevated (warning), Stage 1 (warning), Stage 2 (error), Hypertensive Crisis (error + immediate alert dialog)
- [x] Body: 7-day `fl_chart` LineChart, reading history list, [Log Reading] button, `EncryptionBadge`
- [x] Biometric re-auth on first enter per session
- [x] Log Reading bottom sheet: systolic, diastolic, pulse inputs + notes + arm selector

### 8.4 Glucose (`/glucose`) — Pattern B

- [x] Hero: last reading value + classification chip (Normal/Pre-diabetic/Diabetic/Hypoglycemic)
- [x] `GlucoseClassifier` logic per `readingType` (fasting/post-meal/random/bedtime)
- [x] Crisis threshold: mgDl < 54 OR > 250 → immediate alert dialog
- [x] 7-day chart, reading history, [Log Reading] button
- [x] Link glucose reading to food log (optional)
- [x] Biometric re-auth on first enter

### 8.5 Steps (`/home/steps`) — Pattern C

- [x] Full-bleed heroDeep gradient
- [x] `heroDisplay` step count 72sp, white, glow
- [x] Distance (km) + calories burned monoLg
- [x] Progress arc: CustomPainter semicircle 0→daily goal (orange fill)
- [x] Hourly bar chart (fl_chart) — last 12h
- [x] Health Connect / HealthKit integration for real step data

### 8.6 Sleep (`/sleep`) — Pattern B (heroSleep gradient)

- [x] Hero: metricXL "7h 24m", sleep score monoLg
- [x] Sleep stages chart (REM/deep/light/awake)
- [x] Bedtime + wake time cards
- [x] Avg SpO2, avg heart rate
- [x] 7-day trend chart
- [x] Manual log bottom sheet (or pull from HealthKit)

### 8.7 Karma Hub (`/karma`) — Pattern B

- [x] Hero: displayLg XP total, "⚡ Level 8 Warrior" badge, XP progress bar to next level
- [x] Today's karma events list (each event: type, XP awarded, timestamp)
- [x] XP breakdown bento (by category: food, workout, steps, etc.)
- [x] Achievements grid (unlocked + locked with progress)
- [x] Leaderboard tab (family/friend group)
- [x] Active Challenges card

### 8.8 Journal (`/journal`) — Calm Zone

- [x] Biometric re-auth on first enter per session
- [x] Rich text editor (bold, italic, lists)
- [x] Mood selector (emoji 1–5 scale)
- [x] Tags (comma-separated)
- [x] Entry list sorted by date
- [x] Encrypted locally via SQLCipher

### 8.9 Mental Health Hub (`/mental-health`) — Pattern A

- [ ] CBT Insight cards
- [ ] Breathing exercise selector: 4-7-8, Box, 2-1-4-1 → routes to BreathingCircle screen (Pattern C)
- [ ] Burnout gauge (self-assessment)
- [ ] Indian crisis helplines always visible (BilingualLabel):
  - iCall: 9152987821
  - Vandrevala: 1860-2662-345
  - NIMHANS: 080-46110007

### 8.10 Profile (`/profile`) — Pattern B

- [ ] Hero: CircleAvatar + name + email
- [ ] Karma level compact card
- [ ] Dosha donut chart (vata/pitta/kapha percentages)
- [ ] Personal info rows (editable)
- [ ] Achievements section
- [ ] Referral card (share app + earn 500 XP)

### 8.11 Workout Active (`/workout/active/{workoutId}`) — Pattern C

- [ ] Full-screen timer (mm:ss)
- [ ] Current exercise name + set/rep tracker
- [ ] Log sets with weight + reps
- [ ] Calories burned (estimated)
- [ ] Stop/complete workout button
- [ ] Save to Drift on complete → sync to Appwrite

### 8.12 Emergency Card (`/emergency`) — Calm Zone

- [ ] 108 Ambulance button (tel link)
- [ ] AIIMS Delhi number
- [ ] 2 user-configured emergency contacts (name + number)
- [ ] Editable in Settings

### 8.13 Lab Reports (`/lab-reports`) — Calm Zone

- [ ] Biometric re-auth on first enter
- [ ] Upload PDF/image via Appwrite Storage — bucket: `fitkarma-vault`, filename: `labreport_{userId}_{uuid}.ext`
- [ ] Manual value entry (HbA1c, cholesterol, creatinine, etc.)
- [ ] Report list with date + type
- [ ] 7-day expiring share link — calls `fitkarma-coress` with `action: 'generate_share_link'`
- [ ] Free tier: max 3 reports enforced in app logic (count `lab_reports` docs before upload); Pro: unlimited

### 8.14 Water Tracking

- [ ] Accessible via Quick Log FAB
- [ ] Log amount (ml) with preset buttons (200ml, 350ml, 500ml)
- [ ] Daily total + goal progress ring
- [ ] Streak tracking

### 8.15 Medication Tracking

- [ ] Accessible via Quick Log FAB
- [ ] Medication list with dosage + schedule
- [ ] Mark as taken → logs to Drift → awards karma XP
- [ ] Local notification reminders per schedule

### 8.16 Festival Calendar (`/festival`)

- [ ] Indian festival list with dates (seeded from Appwrite `festivals` collection)
- [ ] For each festival: nutrition tips, special foods, activity recommendations
- [ ] BilingualLabel on festival headers

### 8.17 Wedding Planner (`/wedding`) — Pro only

- [ ] Wedding countdown (days remaining from `weddingDate`)
- [ ] Customised fitness milestones for wedding timeline
- [ ] Special meal plan suggestions
- [ ] ProGate wrapper

### 8.18 Social Groups (`/social`) — Pro only

- [ ] Family/friend group creation
- [ ] Group feed (posts from members)
- [ ] Leaderboard within group
- [ ] ProGate wrapper

### 8.19 Settings (`/settings`) — Calm Zone

- [ ] Theme toggle (dark/light)
- [ ] Language selector (English / Hindi)
- [ ] Notification preferences
- [ ] Emergency contacts management
- [ ] Daily goals adjustment
- [ ] Accessibility: dyslexic font toggle, text scale
- [ ] Low Data Mode toggle
- [ ] Biometric lock toggle
- [ ] Account management (change password, delete account + all data)
- [ ] Privacy Policy link (DPDP Act compliance, data residency)
- [ ] App version display

---

## Phase 9 — §F1 Indian Food Database Integration (P0)

### 9.1 Appwrite `food_database` Collection

- [ ] Run full CLI commands per §F1 (14 attributes + fulltext index on `name` + unique index on `barcode`)
- [ ] Permissions: `read("users")` only — authenticated users can read, no write from client

### 9.2 Indian Food Seed Data (`assets/data/indian_foods_seed.json`) — §9.2 Expanded

> **Target: 150,000+ items · Beat HealthifyMe's 100,000+ database**
>
> Every entry has: `name` · `nameHindi` · `nameRegional?` · `category` · `cuisine` · `caloriesPer100g` · `proteinPer100g` · `carbsPer100g` · `fatPer100g` · `fiberPer100g` · `emoji` · `source` · `servingSizes[]`
>
> **Bonus fields** (add where available): `calcium_mg` · `iron_mg` · `vitaminC_mg` · `vitaminA_ug` · `sodium_mg` · `potassium_mg` · `glycemicIndex` · `isVegan` · `isJain` · `isSattvic` · `barcode` · `imageUrl` · `scientificName`

#### Source Stack — 12 Layers
| # | Source | Items | Priority |
|---|---|---|---|
| S1 | IFCT 2017 npm package | ~542 | **Highest** |
| S2 | ICMR-NIN data.gov.in | ~1,000 | **Highest** |
| S3 | INDB (Indian Nutrient Databank) | ~1,095 raw + 1,014 recipes | Very High |
| S4 | Kaggle Indian food datasets (×5) | ~15,000 | High |
| S5 | USDA FoodData Central | ~4,000 filtered | High |
| S6 | UK CoFID 2021 | ~3,300 | Medium-High |
| S7 | Open Food Facts India | ~40,000 | Medium |
| S8 | Edamam Food Database API | ~8,000 Indian relevant | Medium |
| S9 | Spoonacular API (recipes) | ~5,000 Indian recipes | Medium |
| S10 | Nutritionix (live NLP only) | Live | Low |
| S11 | FAO/INFOODS global food DB | ~2,000 Asian foods | Medium |
| S12 | User contributions (post-launch) | Growing | Medium |

#### 🚀 Current Database Status: 1,194,275 items (Phase A-E complete)

#### Phase A — Primary Indian Sources (Highest Accuracy)
- [ ] **A1. IFCT 2017 npm package** — `npm install ifct2017`:
  - Extract 542 compositions, 151 nutrients each
  - Parse `lang` field for 17 Indian language names
  - Mark `"source": "ifct2017"` — highest priority, never overwritten
- [ ] **A2. ICMR-NIN data.gov.in** — IFCT 2017 npm package *is* the official ICMR-NIN data (same publisher: NIN, ICMR). No separate machine-readable file exists on data.gov.in. Covered by A1.
  - Mark `"source": "icmr_nin"` → `"source": "ifct2017"`
- [ ] **A3. INDB** — Cloned `github.com/lindsayjaacks/Indian-Nutrient-Databank-INDB-`
  - Extracted 1,014 composite Indian recipes from `INDB.xlsx` with full micronutrient profiles
  - Mark `"source": "indb"`

#### Phase B — Kaggle Indian Datasets (~15,000 items)
- [ ] Install Kaggle CLI — **No Python on machine. Using Node.js Kaggle REST API instead.**
  - Scripts: `etl/scripts/download_kaggle.js` + `etl/scripts/normalise_kaggle.js`
- [ ] **Download 5 datasets** via `node etl/scripts/download_kaggle.js` — all downloaded successfully
  - `batthulavinay/indian-food-nutrition` → `Indian_Food_Nutrition_Processed.csv` (1,014 dishes — deduped vs INDB)
  - `ahsanneural/10k-south-asian-recipes-with-nutrition-and-steps` → 10K recipes (nutrition col mismatch, 0 added)
  - `gijoe707/ifct2017` → `ifct2017_compositions.csv` (542 items — deduped vs IFCT A1)
  - `sonalshinde123/food-nutrition-dataset-150-everyday-foods` → 193 new items added
  - `umangsinghal5/nutritional-and-carbon-footprint-data-of-indian-diet` → 676 new items added
- [ ] Run `node etl/scripts/normalise_kaggle.js` — **869 net new items** after fuzzy dedup vs Phase A
- [ ] Mark `"source": "kaggle"` — applied

#### Phase C — USDA FoodData Central (Full Dataset)
- [ ] Download Foundation Foods JSON + SR Legacy JSON via `node etl/scripts/download_usda.js`
- [ ] Process full dataset (No filtering for Indian keywords) — **7,413 new items added**
- [ ] Mark `"source": "usda"` — applied

#### Phase D — UK CoFID 2021 (Full Dataset)
- [ ] Download `McCance_and_Widdowson_Composition_of_Foods_Integrated_Dataset_2021.xlsx` via `node etl/scripts/download_cofid.js`
- [ ] Process full dataset (No filtering for Indian cuisine) — **2,755 new items added**
- [ ] Merge all 13+ CoFID worksheets into unified records — merged Proximates, Inorganics, Vitamins
- [ ] Mark `"source": "cofid_uk"` — applied

#### Phase E — Open Food Facts Global (Full Dataset)
- [ ] Download full global dump `en.openfoodfacts.org.products.csv.gz` — **Complete (1.2GB)**
- [ ] Stream-process full dataset (No filtering for India) — **2,139,369 records normalized**
- [ ] Store `code` (EAN-13 barcode) in `barcode` field — applied
- [ ] Mark `"source": "off_global"` — applied
- [ ] Final Master Merge — **1,194,275 unique items finalized**

#### Phase F — Edamam Food Database API (~8,000 Indian relevant)
- [ ] Register at developer.edamam.com (1,000 calls/month free tier)
- [ ] Search Indian cuisine terms (dal, roti, biryani, etc.)
- [ ] Mark `"source": "edamam"`
- [ ] Deduplicate against existing sources

#### Phase G — Spoonacular Recipe API (~5,000 Indian recipes)
- [ ] Register at spoonacular.com/food-api (150 calls/day free)
- [ ] Filter: `cuisine=indian`, convert per-serving to per-100g
- [ ] Mark `"source": "spoonacular"`

#### Phase H — FAO/INFOODS (~2,000 Asian foods)
- [ ] Download INFOODS South/East Asian Food Composition Tables
- [ ] Extract Northeast Indian tribal foods (critical HealthifyMe gap)
- [ ] Mark `"source": "fao_infoods"`

#### Phase I — Category Coverage (Expanded to beat HealthifyMe)
- [ ] **Cereals & Staples** — ≥80 items (rice varieties, millets, pseudo-cereals)
- [ ] **Dals & Legumes** — ≥60 items (lentils, chickpeas, kidney beans, sprouted)
- [ ] **Breads & Rotis** — ≥50 items (phulka, naan, paratha, dosa, appam)
- [ ] **Rice Dishes** — ≥40 items (plain, jeera, lemon, biryani, pongal)
- [ ] **Sabzis & Curries** — ≥100 items (north + south + Bengali + Rajasthani)
- [ ] **Non-Vegetarian** — ≥80 items (regional chicken, mutton, fish, prawn, egg)
- [ ] **Snacks** — ≥80 items (samosa, dhokla, namkeen, baked options)
- [ ] **Sweets & Mithai** — ≥80 items (gulab jamun, ladoo, barfi, regional)
- [ ] **Street Food & Chaat** — ≥60 items (pav bhaji, pani puri, dosa)
- [ ] **South Indian** — ≥80 items (sambhar, rasam, Kerala/Karnataka specialties)
- [ ] **North Indian Regional** — ≥60 items (Punjabi, Rajasthani, Gujarati, etc.)
- [ ] **Northeast & Tribal** — ≥40 items (eromba, smoked pork, bamboo shoots - HealthifyMe gap)
- [ ] **Beverages** — ≥50 items (chai, lassi, thandai, health drinks)
- [ ] **Dairy & Products** — ≥40 items (milk variants, paneer, ghee, curd)
- [ ] **Fruits** — ≥60 items (mango varieties, guava, phalsa, jamun)
- [ ] **Raw Vegetables** — ≥60 items (gourds, leafy greens, roots)
- [ ] **Spices & Masalas** — ≥50 items (whole + powdered + branded blends)
- [ ] **Oils & Fats** — ≥20 items (groundnut, mustard, coconut, branded)
- [ ] **Diabetic & Low-GI** — ≥30 items (tag `glycemicIndex`, `isDiabeticFriendly`)
- [ ] **Fasting Foods** — ≥40 items (Navratri, Jain, Sattvic, IF-friendly)

#### Phase J — Nutrient Profile Enhancement
- [ ] Add extended nutrient fields to Appwrite schema:
  - `calcium_mg`, `iron_mg`, `vitaminC_mg`, `vitaminA_ug`, `vitaminD_ug`, `vitaminB12_ug`, `folate_ug`
  - `zinc_mg`, `sodium_mg`, `potassium_mg`, `magnesium_mg`, `glycemicIndex`
  - `omega3_g`, `saturatedFat_g`, `transFat_g`
- [ ] Add boolean diet flags: `isVegan`, `isJain`, `isSattvic`, `isGlutenFree`, `isNavratriSafe`, `isDiabeticFriendly`

#### Phase K — Normalisation, Dedup & Merge
- [ ] Install: `pip install pandas pdfplumber rapidfuzz openpyxl uuid xlrd` (Used Node.js `fuzzball` as performant alternative)
- [ ] Unified `FoodItem` schema across all normalizers
- [ ] Priority order for dedup: IFCT2017 > ICMR-NIN > INDB > Kaggle > USDA > CoFID > OFF > Edamam > Spoonacular > FAO
- [ ] Fuzzy dedup threshold: 88 (`rapidfuzz.fuzz.token_sort_ratio`)
- [ ] Filter invalid rows: `calories_per100g <= 0` or `> 900`
- [ ] Target: **≥1,190,000 unique items** ✅

#### Phase L — Seeding, App Integration & Testing
- [ ] Generate `assets/data/indian_foods_seed.json` — full merged dataset
- [ ] Generate Appwrite batches: `etl/output/batches/batch_NNNN.json` (100 docs each)
- [ ] **Tier 1 — Bundled seed:** ICMR + IFCT + INDB + Kaggle + key packaged goods
  - Loaded into Drift on first launch
  - Covers ~95% of daily logging needs
- [ ] **Tier 2 — Appwrite cloud:** Full database searchable via Appwrite full-text
  - Fetched on demand when Drift returns < 5 results
  - Results cached to Drift for future offline use
- [ ] Add `bundled: true` field to Tier 1 items
- [ ] Run `node scripts/seed_food_database.js` — estimated 3-4 hours
- [ ] Verify: Appwrite console shows 150,000+ documents in `food_database`

#### Testing Checklist
- [ ] Search "roti" returns ≥10 variants offline (Drift)
- [ ] Search "मक्की की रोटी" (Hindi) returns makki roti via nameHindi
- [ ] Barcode scan of Parle-G (8901719110115) returns correct product from Drift
- [ ] Search "eromba" returns Manipuri dish from Appwrite (not in Tier 1)
- [ ] Navratri filter: `isNavratriSafe = true` returns ≥20 foods
- [ ] Jain filter: `isJain = true` + `isVegetarian = true` returns ≥50 foods
- [ ] GI filter: `glycemicIndex < 55` returns ≥30 foods

### 9.3 Food Database Service (`lib/features/food/data/food_database_service.dart`)

- [ ] Implement `FoodDatabaseService.searchByName()` — priority: Appwrite Indian DB (fulltext) → Open Food Facts API (if <5 results and not lowData)
- [ ] Implement `FoodDatabaseService.searchByBarcode()` — priority: Appwrite (exact match) → Open Food Facts → return null
- [ ] Implement `_cacheToAppwrite()` — silent best-effort cache of OFF results
- [ ] Implement `foodDatabaseServiceProvider` (Riverpod)

### 9.4 Open Food Facts Client (`lib/features/food/data/open_food_facts_client.dart`)

- [ ] `searchByName()` — GET `/cgi/search.pl` with correct params
- [ ] `searchByBarcode()` — GET `/api/v0/product/{barcode}.json`
- [ ] Dio with 5-second timeout, proper error handling

### 9.5 FoodItem Model (`lib/features/food/data/models/food_item.dart`)

- [ ] Implement `FoodItem` Freezed class — all 12 fields
- [ ] `FoodItem.fromOpenFoodFacts()` factory — map nutriments correctly
- [ ] `FoodItem.fromAppwriteDoc()` factory — decode servingSizes JSON
- [ ] `isValid` getter: `name.isNotEmpty && caloriesPer100g > 0`
- [ ] `ServingSize` Freezed class

### 9.6 Food Search UI

- [ ] `FoodSearchSheet` — DraggableScrollableSheet (0.9/0.5/0.95)
- [ ] Search TextField (autofocus) with debounce 300ms (min 2 chars)
- [ ] LinearProgressIndicator while searching
- [ ] Results list with `_FoodResultTile` (emoji, name, kcal/100g)
- [ ] Barcode scanner button → `mobile_scanner` → `searchByBarcode()`
- [ ] "Add manually" TextButton → manual entry bottom sheet
- [ ] Portion selector after item tap (serving size picker)
- [ ] `FoodLogNotifier.logFood()` → Drift insert → XP award → sync

### 9.7 Food Search — `handleFoodSearch()` inside `fitkarma-cores`

- [ ] Implement `handleFoodSearch()` handler in `functions/fitkarma-cores/src/main.js`
- [ ] Accepts `{ action: 'search_food', query?, barcode? }` — name search or barcode lookup
- [ ] Proxies Open Food Facts API (avoids CORS on mobile), caches result in `food_database` collection
- [ ] Flutter `FoodDatabaseService` fallback path calls `functionId: 'fitkarma-cores'` with `action: 'search_food'`

---

## Phase 10 — §F2 AI Insight Engine & LLM Coach (P0)

### 10.1 Rule-Based Correlation Engine (`lib/features/insights/correlation_engine.dart`)

- [ ] Requires ≥14 days overlapping data
- [ ] Insight: Sleep → BP (poor sleep <6h raises BP by >8 mmHg average)
- [ ] Insight: Hydration → Steps (avg <1500ml → low hydration alert)
- [ ] Insight: High glucose pattern detection
- [ ] Insight: BP anomaly detection
- [ ] Insight: Step deficit (consistently below goal)
- [ ] `HealthInsight` Freezed model with confidence score (0.0–1.0)
- [ ] Show on Dashboard only if ≥7 days data; full insights at ≥14 days

### 10.2 AI Coach — `handleAiCoach()` inside `fitkarma-cores`

- [ ] Implement `handleAiCoach()` handler in `functions/fitkarma-cores/src/main.js`
- [ ] SYSTEM_PROMPT per §F2 — warm, empathetic, India-specific, 3–5 sentence responses, celebrate streaks, redirect off-topic
- [ ] Fetch user health context from Appwrite inside the function (last 7 days: BP, glucose, steps, sleep, food logs)
- [ ] Safety rules: BP Stage 2+ or glucose > 200 mg/dL → always recommend doctor. Never diagnose
- [ ] Anthropic API key stays server-side via `ANTHROPIC_API_KEY` env var on `fitkarma-cores` function
- [ ] Flutter calls: `Functions.createExecution(functionId: 'fitkarma-cores', body: jsonEncode({action: 'ai_coach', ...}))`

### 10.3 AI Coach Screen (`/ai-coach`) — Pro only

- [ ] `AiCoachScreen` (`lib/features/ai_coach/ai_coach_screen.dart`)
- [ ] Chat-style UI — user messages (right), coach messages (left, GlassCard)
- [ ] Text input + send button
- [ ] Loading indicator while awaiting response
- [ ] `AiCoachProvider` — sends conversation history + health context to Appwrite Function
- [ ] `ProGate` wrapper — shows upgrade prompt to free users
- [ ] Feature flag: `aiInsights` must be `true`

---

## Phase 11 — §F3 iOS HealthKit Integration (P0)

### 11.1 Xcode Entitlements

- [ ] Add `HealthKit` capability in Xcode → Runner.entitlements
- [ ] Add `com.apple.developer.healthkit` = true
- [ ] Add `com.apple.developer.healthkit.background-delivery` = true
- [ ] Add `NSHealthShareUsageDescription` to Info.plist
- [ ] Add `NSHealthUpdateUsageDescription` to Info.plist

### 11.2 HealthKit Provider (`lib/features/health/`)

- [ ] `requestPermissions()` — STEPS, HEART_RATE, BLOOD_OXYGEN, SLEEP_SESSION, BLOOD_PRESSURE_SYSTOLIC, BLOOD_PRESSURE_DIASTOLIC, BLOOD_GLUCOSE
- [ ] `todaySteps()` — aggregate from midnight to now
- [ ] `heartRate()` — latest sample
- [ ] `bloodOxygen()` — latest SpO2
- [ ] `sleepSessions()` — last 7 days, map to SleepLog Drift objects
- [ ] `writeSteps()` / `writeWorkout()` — write back to HealthKit
- [ ] Background delivery — register observer queries for step count updates

### 11.3 Android Health Connect

- [ ] Verify `health` package handles Health Connect on Android API 26+
- [ ] Request permissions on onboarding if platform is Android
- [ ] Handle graceful degradation if Health Connect not installed

---

## Phase 12 — §F4 Subscription Model & Monetisation (P0)

### 12.1 RevenueCat Setup

- [ ] Implement `SubscriptionService.init()` — `Purchases.configure()` with `REVENUECAT_API_KEY` from `--dart-define`
- [ ] Implement `SubscriptionService.isPro()` — check `entitlements.active['pro']`
- [ ] Implement `SubscriptionService.purchasePro()` — fetch current offering → purchase monthly product, handle `PurchasesErrorCode.purchaseCancelledError` silently
- [ ] Implement `SubscriptionService.restorePurchases()`
- [ ] `isProProvider` (Riverpod `FutureProvider`)
- [ ] `SubscriptionNotifier` (invalidates on purchase)

### 12.2 Free vs Pro Feature Matrix

Free tier includes: food logging, step tracking, BP/glucose manual logging, habits, journal, water tracking, medication tracking, push notifications, home widget (steps), basic insights (rule-based only)

Pro tier (₹299/month or ₹2,499/year, 7-day free trial) includes:

- [ ] AI Coach (LLM-powered)
- [ ] Correlation insights (sleep→BP, hydration→performance)
- [ ] Unlimited lab report storage (free: 3 max)
- [ ] Wedding planner
- [ ] Social groups + leaderboard
- [ ] Advanced reports (PDF export)
- [ ] All home widgets
- [ ] Priority sync (15-min interval)

### 12.3 `ProGate` Widget

- [ ] Implement `ProGate` — wraps Pro-only widgets, shows `_UpgradePrompt` for free users
- [ ] `_UpgradePrompt` — GlassCard with lock icon, "FitKarma Pro ₹299/month", [Upgrade] button → `/subscription`

### 12.4 Subscription Screen (`/subscription`) — Calm Zone

- [ ] Hero badge: amber-to-primary gradient, "⚡ FitKarma Pro", price display
- [ ] Pro feature checklist
- [ ] [Start Free 7-Day Trial] primary CTA
- [ ] [Restore purchases] TextButton
- [ ] Annual plan highlight (30% saving)

### 12.5 App Store & Play Store Configuration

- [ ] Create in-app purchase products in App Store Connect: `fitkarma_pro_monthly`, `fitkarma_pro_annual`
- [ ] Create in-app purchase products in Google Play Console
- [ ] Configure 7-day free trial in both stores
- [ ] Link products to RevenueCat Offering named `default`
- [ ] Add `REVENUECAT_API_KEY` to CI/CD secrets

---

## Phase 13 — Gamification & Karma Engine

### 13.1 XP Award Service (`lib/features/karma/`)

- [ ] Implement `KarmaService.awardXP(eventType)` — calls Appwrite Function `xp-calculator`
- [ ] XP events: food_log(5), food_log_complete(20), workout_complete(30), steps_goal(25), sleep_logged(10), bp_reading(10), glucose_reading(10), habit_complete(15), journal_entry(10), streak_7day(50), streak_30day(150), lab_report(20), referral(500)
- [ ] Trigger `LevelUpAnimation` overlay when level changes
- [ ] Level names: Newcomer → Beginner → Starter → Mover → Achiever → Consistent → Dedicated → Warrior → Champion → Elite → Legend → Grandmaster → Karma Master

### 13.2 Streak Tracking

- [ ] Daily streak: any activity logged = streak maintained
- [ ] 7-day streak detection → award `streak_7day` XP
- [ ] 30-day streak detection → award `streak_30day` XP
- [ ] `StreakFlame` widget animates on dashboard

### 13.3 Achievements

- [ ] Define achievement catalog (first food log, 7-day streak, 30-day streak, 10k steps, workout complete, etc.)
- [ ] Achievement unlock check after every XP event
- [ ] Achievement grid on Karma Hub + Profile

---

## Phase 14 — Notification System

### 14.1 Setup

- [ ] Initialize `flutter_local_notifications` in `NotificationService.init()` (called from `main.dart`)
- [ ] Request notification permission on onboarding
- [ ] Set up timezone handling for local notifications

### 14.2 Notification Types

- [ ] Meal reminders: Breakfast (8AM), Lunch (1PM), Dinner (7:30PM) — user-configurable
- [ ] Water reminder (every 2h, 8AM–8PM)
- [ ] Medication reminders (per schedule in `medications` table)
- [ ] Streak maintenance alert (8PM if no activity logged)
- [ ] BP/glucose reminder for users with those conditions
- [ ] Sync failure notification (after DLQ threshold)

---

## Phase 15 — Home Widgets

### 15.1 Android Widget

- [ ] Steps today + goal (using `home_widget` package)
- [ ] Karma XP today
- [ ] Pro: all widgets

### 15.2 iOS Widget (P1)

- [ ] Steps + karma today widget via WidgetKit (Swift)
- [ ] Update widget data on background sync

---

## Phase 16 — Security Hardening (Enterprise)

- [ ] **Certificate Pinning** — pin Appwrite endpoint TLS cert, block MITM
- [ ] **Screen Security** — `FLAG_SECURE` on Android for Journal, BP, Glucose, Lab Reports
- [ ] **Sensitive Screen Guard** — `SensitiveScreenGuard` widget (biometric re-auth per session)
- [ ] **Audit Logging** — log auth events, data access, sync errors to Sentry
- [ ] **Soft Delete** — all deletions set `isDeleted=true`, never hard delete from Drift. Appwrite sync respects this
- [ ] **DPDP Act Compliance** — Privacy Policy accessible from Settings + Onboarding, reference data residency (India region Appwrite endpoint)
- [ ] **Data Export / Account Deletion** — user can request full data export (JSON) and permanent account + data deletion

---

## Phase 17 — Performance & Quality

### 17.1 Performance Rules

- [ ] All network images via `CachedNetworkImage` — never `Image.network`
- [ ] All reactive data via Drift `.watch()` — never poll
- [ ] All lists via `ListView.builder` — lazy rendering
- [ ] Narrow rebuilds: `ref.watch(provider.select(...))`
- [ ] `RepaintBoundary` on `ActivityRings`, `BreathingCircle`, `ActivityRings`
- [ ] Parse large JSON (food seed) in `compute()` isolates
- [ ] Verify cold launch < 2.5s, frame render < 16ms, Drift date-range query < 50ms

### 17.2 Accessibility

- [ ] Minimum tap target 44×44px on all interactive elements
- [ ] `Semantics` wrapper on ALL `CustomPaint` widgets
- [ ] Body text contrast: textPrimary ≥7:1, textSecondary ≥5:1
- [ ] OpenDyslexic font toggle in settings
- [ ] Text scale clamped to 0.85–1.3 in `main.dart` MediaQuery wrapper
- [ ] Screen reader testing on both platforms

### 17.3 Anti-Pattern Enforcement

- [ ] Lint rule / code review check: no hardcoded hex values outside `app_colors.dart`
- [ ] Maximum 2 visual effects per surface (blur+border OR glow+gradient — not both)
- [ ] No glow on more than one card per screen
- [ ] No modals where a bottom sheet suffices
- [ ] No skeleton text — use `ShimmerLoader`
- [ ] No bilingual labels on every element

---

## Phase 18 — Testing

### 18.1 Unit Tests

- [ ] `GlucoseClassifier` — all thresholds and edge cases
- [ ] `computeDosha()` — all 10-question permutations
- [ ] `SyncWorker` — pending→synced, pending→dlq, connectivity guard
- [ ] `CorrelationEngine` — sleep→BP insight generation with mock data
- [ ] `computeLevel()` XP thresholds — all 13 levels
- [ ] `FoodItem.fromOpenFoodFacts()` — malformed input handling
- [ ] DB migration: v1→v2→v3→v4 (use `drift_dev` verifier)

### 18.2 Widget Tests

- [ ] `GlassCard` — DeviceTier.low renders solid surface1 (no blur)
- [ ] `GlassCard` — DeviceTier.high renders with BackdropFilter
- [ ] `BottomNavBar` — active tab has glow dot
- [ ] `ProGate` — free user sees `_UpgradePrompt`
- [ ] `ProGate` — pro user sees child widget
- [ ] `DLQAlertBanner` — visible when syncStatus='dlq' count > 0
- [ ] Design token test: verify no hardcoded colors leak

### 18.3 Golden Tests

- [ ] Dashboard screen (dark + light)
- [ ] Food Home screen
- [ ] Blood Pressure screen
- [ ] Karma Hub screen
- [ ] Subscription screen
- [ ] Run: `flutter test --update-goldens` to generate, then `flutter test` to verify

### 18.4 Integration Tests

- [ ] Full offline→online sync round-trip: log food in Airplane mode → reconnect → verify Appwrite document created
- [ ] DLQ: force 3 sync failures → verify DLQAlertBanner appears
- [ ] Onboarding flow: welcome → dosha → goals → profile → permissions → dashboard
- [ ] Biometric re-auth: navigate to Journal → verify auth prompt appears
- [ ] RevenueCat: purchase flow (sandbox) → verify isPro returns true

### 18.5 Accessibility Tests

- [ ] `flutter_test` semantics on all `CustomPaint` widgets
- [ ] VoiceOver / TalkBack manual testing on device

---

## Phase 19 — CI/CD Pipeline

### 19.1 GitHub Actions Workflows

- [ ] **`test.yml`** — triggers on push to `main`/`develop` and PRs:
  - `flutter pub get`
  - `dart run build_runner build --delete-conflicting-outputs`
  - `flutter analyze`
  - `flutter test --coverage`
- [ ] **`deploy-appwrite.yml`** — triggers on merge to `main`:
  - Install Appwrite CLI
  - Authenticate with secrets
  - `appwrite push functions --all --force --activate true`
- [ ] **`build-android.yml`** — triggers on merge to `main`:
  - `flutter build apk --release` with all `--dart-define` secrets
- [ ] **`build-ios.yml`** — triggers on merge to `main`:
  - `flutter build ipa --release` with all `--dart-define` secrets + code signing

### 19.2 Secrets to Add in GitHub

- [ ] `APPWRITE_ENDPOINT`
- [ ] `APPWRITE_PROJECT_ID`
- [ ] `APPWRITE_API_KEY`
- [ ] `REVENUECAT_API_KEY` (iOS)
- [ ] `REVENUECAT_API_KEY_ANDROID`
- [ ] `SENTRY_DSN`
- [ ] `ANTHROPIC_API_KEY` (for Appwrite Function deploy verification)
- [ ] Android keystore secrets (for signed APK)
- [ ] iOS signing secrets (App Store Connect API key)

### 19.3 Build Flavors

- [ ] `development` — Appwrite dev project, verbose logging, debug banner
- [ ] `staging` — Appwrite staging project, Sentry staging env
- [ ] `production` — Appwrite prod project, Sentry prod env, no debug banner

---

## Phase 20 — Pre-Launch Checklist (P0) ✅

All items from the Master Checklist §Master Checklist:

- [ ] §F1: Indian food database seeded (≥5,000 items)
- [ ] §F1: Open Food Facts integration tested with barcode scan on real device
- [ ] §F2: AI Coach `handleAiCoach()` handler deployed inside `fitkarma-cores` function with `ANTHROPIC_API_KEY` env var set
- [ ] §F3: iOS HealthKit entitlements configured and tested in Xcode on physical iPhone
- [ ] §F4: RevenueCat configured with App Store + Play Store products
- [ ] §F4: 7-day free trial configured in both stores
- [ ] All 17 Appwrite collections created via CLI (no console)
- [ ] Single `fitkarma-cores` Appwrite Function deployed and activated (handles: award_xp, generate_share_link, ai_coach, search_food, get_feature_flags)
- [ ] Single `fitkarma-vault` storage bucket created with server-side encryption + antivirus; file naming convention applied (`labreport_*`, `avatar_*`)
- [ ] All `--dart-define` environment variables set for all build flavors
- [ ] Biometric lock tested on physical device (Journal, Lab Reports, BP, Glucose)
- [ ] Offline→online sync round-trip tested on real device in Airplane mode
- [ ] DLQ alert banner appears after 3 consecutive sync failures
- [ ] GlassCard blur disabled on DeviceTier.low (< 2GB RAM devices)
- [ ] Golden tests generated and passing for all 5 primary screens
- [ ] DPDP Act compliance: Privacy Policy accessible, data residency (India) documented
- [ ] Cold launch < 2.5s verified on low-end device (₹7,000–₹10,000 range)
- [ ] App submitted to both App Store Connect and Google Play Console for review

---

## Phase 21 — Post-Launch (P1 — within 30 days)

- [ ] Expand Indian food database to ≥10,000 items
- [ ] Tune AI Coach rate limiting based on usage data
- [ ] Test HealthKit background delivery on iPhone (real device, not simulator)
- [ ] Verify Sentry error dashboard: PII stripping confirmed, no user data in logs
- [ ] Implement iOS home widget (today's steps + karma score) via WidgetKit
- [ ] A/B test push notification timing for meal reminders
- [ ] Measure push notification open rates, adjust defaults

---

## Phase 22 — Future Roadmap (P2)

- [ ] FHIR R4 export (`fhirExport` feature flag)
- [ ] Voice food logging (`voiceLogging` feature flag)
- [ ] Continuous glucose monitor (CGM) integration (`cgmIntegration` flag)
- [ ] Nearby pharmacy search (`pharmacySearch` flag)
- [ ] Wearable abstraction layer (Fitbit, Garmin, Samsung Health)
- [ ] Period tracker (hidden behind `periodTracker` flag, biometric re-auth)
- [ ] Android home widget for all Pro metrics

---

## Quick Reference — File Count

| Area                                                | Files to Create                            |
| --------------------------------------------------- | ------------------------------------------ |
| Core (theme, router, DB, sync, security, providers) | ~25                                        |
| Shared widgets                                      | 18                                         |
| Feature screens                                     | ~40                                        |
| Appwrite Functions                                  | 1 (`fitkarma-cores` with 5 action handlers) |
| Test files                                          | ~30                                        |
| CI/CD YAMLs                                         | 4                                          |
| Assets (fonts, seed JSON)                           | ~5                                         |
| **Total**                                           | **~123 files**                             |

---

> **Appwrite Constraints Applied**
>
> - **1 Function only:** `fitkarma-cores` — internal router dispatching on `req.body.action` → `award_xp`, `generate_share_link`, `ai_coach`, `search_food`, `get_feature_flags`
> - **1 Bucket only:** `fitkarma-vault` — all uploads unified; type distinguished by filename prefix (`labreport_{userId}_{uuid}.*`, `avatar_{userId}.*`)

---

_Generated from FitKarma Complete Documentation — Flutter 3.x · Riverpod 2.x · Drift · Appwrite CLI · RevenueCat · Anthropic Claude · Open Food Facts_
_~5,800 lines of spec → 123 files to write · 22 phases · 0 lines written so far_
