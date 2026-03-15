# ✅ FitKarma — Project TODO
> **Beginner-friendly task checklist** · Work through phases in order · Each task is self-contained
> 
> **Legend:** 🟢 Easy · 🟡 Medium · 🔴 Hard · 🔒 Security-critical · ⚡ Do this first in the phase

---

## 📋 How to Use This File

- Work **top to bottom** — later phases depend on earlier ones.
- Mark tasks done with `[x]` in your editor.
- Each phase can be a separate **Git branch** (e.g. `feat/phase-1-setup`).
- Don't skip the 🔒 tasks — they protect user data.
- Stuck? The section number links back to the developer docs.

---

## Phase 0 — Developer Environment Setup
> *Get your machine ready before writing a single line of app code.*

- [x] ⚡🟢 Install **Flutter 3.x stable** — follow [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- [x] 🟢 Run `flutter doctor` and fix every ❌ shown
- [x] 🟢 Install **Android Studio** (for Android emulator) and/or **Xcode** (Mac only, for iOS simulator)
- [x] 🟢 Install **VS Code** + Flutter & Dart extensions (or use Android Studio)
- [x] 🟢 Install **Git** and create a GitHub account if you don't have one
- [x] 🟢 Install **Node.js 18+** — needed later for Appwrite Functions
- [x] 🟢 Install the **Appwrite CLI**: `npm install -g appwrite-cli`
- [x] 🟡 Create a free account at [cloud.appwrite.io](https://cloud.appwrite.io) (your backend lives here)
- [x] 🟡 Create a new Appwrite **project** — note down the `Project ID`

---

## Phase 1 — Project Scaffold
> *Create the Flutter project and set up the folder structure from the docs.*

### 1.1 Flutter Project
- [x] ⚡🟢 Run `flutter create --org com.fitkarma fitkarma` to create the project
- [x] 🟢 Delete the default counter app code from `lib/main.dart`
- [x] 🟢 Add `.env` to your `.gitignore` file immediately — **before your first commit** 🔒
- [x] 🟢 Create the `.env` file and fill in your Appwrite `Project ID` and `Endpoint`

### 1.2 Folder Structure
> Create these folders inside `lib/` — they can be empty for now
- [] 🟢 Create `lib/core/constants/`
- [] 🟢 Create `lib/core/di/`
- [] 🟢 Create `lib/core/errors/`
- [] 🟢 Create `lib/core/network/`
- [] 🟢 Create `lib/core/security/`
- [] 🟢 Create `lib/core/storage/`
- [] 🟢 Create `lib/core/utils/`
- [] 🟢 Create `lib/features/` (all feature subfolders come later — add them as you build)
- [] 🟢 Create `lib/shared/widgets/` and `lib/shared/theme/`
- [] 🟢 Create `lib/l10n/` for language files

### 1.3 Dependencies
> Add these to `pubspec.yaml` — copy from Section 23 of the docs
- [] ⚡🟡 Add all packages listed in the `pubspec.yaml` section of the docs to your `pubspec.yaml`
- [] 🟢 Run `flutter pub get` — fix any version conflicts shown in the terminal
- [] 🟡 Run `flutter pub run build_runner build` — generates Hive and Riverpod code (you'll re-run this often)

### 1.4 App Config
- [] 🟡 Create `lib/core/constants/app_config.dart` — copy the `AppConfig` class from the docs (Section 23)
- [] 🟡 Create `lib/core/constants/api_endpoints.dart` — copy the `AW` constants class from the docs (Section 5.3)
- [] 🟡 Create `lib/core/constants/hive_boxes.dart` — add string constants for every box name from Section 7

---

## Phase 2 — Theme & Design System
> *Build the shared UI components once so you never have to repeat styling.*

### 2.1 Colours & Typography
- [] ⚡🟢 Create `lib/shared/theme/app_colors.dart` — add all colour constants from Section 2.2 of the docs
  - Primary orange `#FF5722`, Indigo `#3F3D8F`, Amber `#FFC107`, Background `#FDF6EC`
- [] 🟢 Create `lib/shared/theme/app_text_styles.dart` — define heading, body, caption text styles
- [] 🟢 Create `lib/shared/theme/app_theme.dart` — wire colours and fonts into a `ThemeData`
- [] 🟢 Apply the theme in `lib/app.dart`

### 2.2 Shared Widgets
> Build each widget in `lib/shared/widgets/` — test each one in isolation before moving on
- [] 🟡 `shimmer_loader.dart` — loading placeholder (build this first, used everywhere)
- [] 🟡 `bilingual_label.dart` — stacked English + Hindi `Text` widget
- [] 🟡 `activity_rings.dart` — four concentric rings (orange, green, teal, purple)
- [] 🟡 `insight_card.dart` — amber card with lightbulb icon and 👍/👎 buttons
- [] 🟡 `food_item_card.dart` — photo, name, portion, kcal, `+` button
- [] 🔴 `karma_level_card.dart` — dark purple gradient card with progress bar
- [] 🔴 `dosha_chart.dart` — three-segment donut using `fl_chart`
- [] 🟡 `challenge_card.dart` — horizontally scrollable challenge card
- [] 🟡 `quick_log_fab.dart` — speed-dial orange FAB
- [] 🟡 `meal_tab_bar.dart` — Breakfast / Lunch / Dinner / Snacks tab bar

### 2.3 Navigation
- [] ⚡🟡 Create `lib/app.dart` with `GoRouter` — add all routes from the Route Map in Section 19
- [] 🟡 Add the 5-tab `BottomNavigationBar` (Home · Food · Workout · Steps · Me) with bilingual labels

---

## Phase 3 — Core Infrastructure
> *The plumbing that every feature depends on. Get this solid before features.*

### 3.1 Appwrite Client
- [] ⚡🟡 Create `lib/core/network/appwrite_client.dart` — copy the singleton from Section 5.2
- [] 🟢 Test the connection: call `AppwriteClient.account.get()` and log the result

### 3.2 Hive Local Storage
- [] ⚡🟡 Create `lib/core/storage/hive_service.dart` — initialises and opens all Hive boxes on app start
- [] 🟢 Open all **non-encrypted** boxes from the box registry in Section 7
- [] 🔒🔴 Open all **encrypted** boxes with `HiveAesCipher` — see Section 16.2 for the key derivation code
- [] 🔒🔴 Encrypted boxes: `period_logs`, `journal`, `blood_pressure`, `glucose`, `appointments`

### 3.3 Encryption Service
- [] 🔒🔴 Create `lib/core/security/encryption_service.dart` — AES-256-GCM + PBKDF2 (100,000 iterations)
- [] 🔒🔴 Create `lib/core/security/key_manager.dart` — derives and caches the encryption key using device ID + user password + stored salt
- [] 🔒🟡 Store the salt in `flutter_secure_storage` — never in Hive or plaintext files

### 3.4 Connectivity & Sync Queue
- [] 🟡 Create `lib/core/network/connectivity_service.dart` — wraps `connectivity_plus`, exposes an `isOnline` stream
- [] 🟡 Create the `SyncQueueItem` model — copy from Section 8
- [] 🔴 Create `lib/core/network/sync_queue.dart`:
  - Write sync items to `sync_queue_box` on every local create/update/delete
  - Background isolate watches connectivity; flushes queue in batches of 20 when online
  - Exponential backoff: 1s → 2s → 4s → 8s → 16s, max 5 retries
- [] 🟡 Implement delta sync: on app resume, query Appwrite for `$updatedAt > lastSyncTimestamp`

### 3.5 Error Handling
- [] 🟡 Create `lib/core/errors/app_exception.dart` — custom exception types (NetworkException, StorageException, AuthException, EncryptionException)
- [] 🟡 Create `lib/core/errors/error_handler.dart` — maps raw exceptions to friendly UI messages

---

## Phase 4 — Authentication & Onboarding
> *Users can't do anything until they can log in. Build auth before any features.*

### 4.1 Auth Service
- [] ⚡🟡 Create `lib/features/auth/data/auth_aw_service.dart` — copy `login()`, `register()`, `logout()`, `getCurrentUser()` from Section 9
- [] 🟡 Store the Appwrite session JWT in `flutter_secure_storage` after login
- [] 🟡 On app start, check for a stored session and navigate directly to Dashboard if valid (skip login screen)
- [] 🟡 Add Google OAuth2 login — copy the `createOAuth2Session` snippet from Section 9
- [] 🟡 Add Apple Sign-In (iOS only) via the same Appwrite OAuth2 method

### 4.2 Auth Screens
- [] 🟡 Build `LoginScreen` — email/password fields, Google sign-in button, "Register" link
- [] 🟡 Build `RegisterScreen` — name, email, password fields, "Already have an account?" link
- [] 🟢 Add form validation (email format, password min 8 chars)
- [] 🟡 Show loading state during login/register — use `ShimmerLoader`
- [] 🟡 Show friendly error messages on failure (wrong password, network error)

### 4.3 Onboarding Flow
- [] 🟡 Screen 1: **Name** — text input
- [] 🟡 Screen 2: **Gender / Date of Birth** — dropdown + date picker
- [] 🟡 Screen 3: **Height / Weight** — numeric inputs with cm/kg labels
- [] 🟡 Screen 4: **Fitness Goal** — 4 option cards (Lose Weight / Gain Muscle / Maintain / Endurance)
- [] 🟡 Screen 5: **Activity Level** — 5 option cards (Sedentary → Very Active)
- [] 🟡 Screen 6: **Chronic Conditions** — optional multi-select (Diabetes, Hypertension, PCOD, etc.)
- [] 🟡 Screen 7: **Dosha Quiz** — 12 questions, auto-calculate Vata/Pitta/Kapha %
- [] 🟡 Screen 8: **Language Selection** — 8 Indian languages
- [] 🟡 Screen 9: **Health Permissions** — ask for step counting, health data access (contextual, not at launch)
- [] 🟡 Screen 10: **Wearable Connection** — optional, skippable
- [] 🟢 On completion: write user profile to Hive + Appwrite `users` collection
- [] 🟢 Award **+50 XP** on onboarding completion
- [ ] 🔒🟡 Set document-level permissions (`Role.user(uid)` read/write) on the `users` document

### 4.4 Biometric Lock
- [ ] 🟡 Add `local_auth` biometric check on app resume (not on first launch)
- [ ] 🟢 Add toggle in Settings to enable/disable biometric lock

---

## Phase 5 — Dashboard (Home Screen)
> *The first thing users see every day — must load from Hive in under 1 second.*

- [] ⚡🟡 Build `DashboardScreen` — reads **only from Hive** on first render (no Appwrite calls)
- [] 🟡 Add the **header** — avatar, "Namaste, [Name] 🙏", karma XP and level badge
- [] 🟡 Add the `ActivityRingsWidget` — wire calories, steps, water, active minutes progress
- [] 🟡 Add the `InsightCard` — show one rule result from the Rule Engine
- [] 🟡 Add **Today's Meals section** — tab bar + meal summary cards
- [] 🟡 Add the `QuickLogFAB` — speed-dial with: Food, Water, Mood, Workout, BP, Glucose
- [] 🟢 Add latest workout summary card and sleep recovery score card
- [] 🟡 Background: fetch Appwrite updates after render (delta sync) and refresh UI if new data arrives
- [ ] 🔴 Android home screen widgets — Steps ring, Calorie ring, Water ring (do this last)

---

## Phase 6 — Food Logging
> *The most-used feature. Build search and manual entry first, then add the fancier methods.*

### 6.1 Food Database
- [] ⚡🟡 Seed the Indian food database into the Appwrite `food_items` collection (use the Appwrite Console importer or a seed script)
- [] 🟡 Include `name` (English) and `name_hi` (Devanagari) fields for every item
- [] 🟡 Include `serving_sizes` JSON: e.g. `[{"name":"katori","grams":150}]`

### 6.2 Food Log Service
- [] 🟡 Create `lib/features/food/data/food_hive_service.dart` — read/write `FoodLog` to Hive
- [] 🟡 Create `lib/features/food/data/food_aw_service.dart` — copy `searchFoodItems()` and `logFood()` from Section 10.2
- [] 🟡 Create `lib/features/food/data/food_repository.dart` — Hive first, Appwrite fallback, queue sync

### 6.3 Food Log Model
- [] 🟡 Create `lib/features/food/domain/food_log_model.dart` — copy the `FoodLog` Hive model from Section 7
- [] 🟢 Run `flutter pub run build_runner build` to generate the Hive type adapter

### 6.4 Food Log Screen
- [] 🟡 Build `FoodLogScreen` (e.g. "Log Breakfast") with:
  - [] Bilingual search bar (redirection to search screen)
  - [] Three quick-action chips: `📷 Scan Label` · `🍽 Upload Plate Photo` · `✏ Manual Entry`
  - [] `Frequent Indian Portions` — horizontal list of frequent items
  - [] `Recent Logs` — list of past entries for the meal type
- [] 🟡 Implement **text search** — logic moved to `FoodSearchScreen` with Hive/Appwrite search
- [] 🟡 Implement **portion selection** — dynamic scaling of nutrition data in `FoodEntryScreen`
- [] 🟡 Implement **manual entry** — dedicated sheet with macro inputs
- [] 🟡 On log: write to Hive → award +10 XP (+30 for first log) → reactive UI update via `FoodNotifier`
- [] 🟡 Implement **macro ratios** — dynamic goals based on TDEE/fitness goal

### 6.5 Advanced Food Logging Methods
- [] 🟢 **Barcode scanner** — `flutter_barcode_scanner` → OpenFoodFacts API → cache result
- [] 🟢 **OCR (Scan Label)** — Google ML Kit `TextRecognitionV2` to read nutrition labels
- [] 🟢 **Photo AI (Upload Plate Photo)** — Google ML Kit `ImageLabeling` to identify food
- [] 🟢 **Voice logging** — `speech_to_text` → *"dal chawal"* → search → confirm screen

---

## Phase 7 — Step Tracking
- [] ⚡🟢 Integrate the `health` package — request Health Connect (Android) / HealthKit (iOS) permissions
- [] 🟢 Read today's step count and write to `step_logs_box` in Hive
- [] 🟢 Fallback: use `pedometer` package if health platform permissions are denied
- [] 🟢 Set up background sync — WorkManager (Android) / `BGAppRefreshTask` (iOS) to batch-sync steps at midnight
- [] 🟢 Implement **adaptive goal** — daily target = 7-day rolling average
- [] 🟢 Add inactivity nudge — detect > 60 min phone inactivity → push gentle movement reminder
- [] 🟢 Award +5 XP per 1,000 steps (max 50 XP/day)
- [] 🟢 Build `StepsScreen` — today's count, goal ring, weekly bar chart

---

## Phase 8 — Karma System
> *XP is earned in almost every feature, so build the service early.*

- [] ⚡🟢 Create `lib/features/karma/data/karma_hive_service.dart` — instant local XP snapshot
- [] 🟢 Create `lib/features/karma/data/karma_aw_service.dart` — write `karma_transactions` documents to Appwrite; server is the source of truth for balances
- [] 🟢 Create `KarmaNotifier` (Riverpod `StateNotifier`) — `addXP(int amount, String action)` method
- [] 🟢 Subscribe to Appwrite Realtime `karma_transactions` collection — copy the subscription snippet from Section 8
- [] 🟢 Build `KarmaHub` screen — level card, XP bar, karma history list
- [] 🟢 Build `KarmaStore` screen — list of rewards redeemable with XP
- [] 🟢 Build `Leaderboard` screen — Friends / City / National tabs with weekly reset
- [] 🟢 Implement streak multipliers — ×1.5 at 7-day streak, ×2.0 at 30-day streak

---

## Phase 9 — Workout System
- [] ⚡🟡 Seed workout data into the Appwrite `workouts` collection (title, YouTube ID, duration, difficulty, category)
- [] 🟡 Build `WorkoutHomeScreen` — category grid (Yoga, HIIT, Strength, Dance, Bollywood, Pranayama…)
- [] 🟡 Build `WorkoutDetailScreen` — thumbnail, description, difficulty, duration, Start button
- [] 🔴 **YouTube player** — `youtube_player_flutter` — play workout by YouTube video ID
- [] 🔴 **GPS Outdoor** — `geolocator` tracks location → `flutter_map` draws the route on OpenStreetMap
- [] 🟡 **Custom Workout Builder** — add exercises with sets/reps/rest time; save as a custom workout
- [] 🟡 **Workout Calendar** — schedule future workouts; mark rest days
- [] 🟡 Log completed workout to `workout_logs_box` → sync queue → award +20 XP
- [] 🟡 Auto-detect **personal records** (e.g. max lift) and award +100 XP

---

## Phase 10 — Nutrition Goal Engine
- [] ⚡🟡 Implement TDEE calculator — copy the Mifflin-St Jeor formula from Section 11.7
- [] 🟡 Calculate and store macro targets (55% carbs / 20% protein / 25% fat) in `nutrition_goals_box`
- [] 🟡 Build daily nutrition ring charts with traffic-light status 🟢🟡🔴
- [] 🟡 Micronutrient tracking — Iron, B12, Vitamin D, Calcium
- [] 🟡 Grocery list generator — derive shopping list from current nutrition goals
- [] 🟢 Weekly micronutrient gap analysis report

---

## Phase 11 — On-Device AI Insight Engine
> *Pure Dart logic — zero server calls, zero ML models.*
- [] ⚡🟡 Create `lib/features/insight_engine/rule_engine.dart`
- [] 🟡 Implement all rules from Section 11.13 (sleep, steps, water, workout, protein, cycle, streak, BP, fasting, glucose, burnout, BMI)
- [] 🟢 Evaluate rules daily — surface max 2 cards on the Dashboard
- [] 🟢 Store user's 👍/👎 feedback locally to suppress unhelpful rules
- [] 🟢 Wire the `InsightCard` widget on the Dashboard to show rule results

---

## Phase 12 — Health Monitoring Modules
> *Build these together — they share the same encryption and chart patterns.*

### 12.1 Blood Pressure Tracker 🔒
- [] ⚡🟡 Create `BPLog` Hive model with `@HiveType` annotation
- [] 🔴 Open `blood_pressure` box with `HiveAesCipher` encryption
- [] 🟡 Build logging screen — systolic / diastolic / pulse inputs (< 20 seconds to log)
- [] 🟡 Implement `classify()` function — copy from Section 12.1 (Normal / Elevated / Stage 1 / Stage 2 / Crisis)
- [] 🔴 Emergency alert — reading ≥ 180/120 → immediate care prompt
- [] 🟡 7/30/90-day trend chart with AHA colour bands using `fl_chart`
- [] 🟢 Morning/evening reminder notifications
- [] 🟢 Award +5 XP per BP log

### 12.2 Blood Glucose Tracker 🔒
- [] 🟡 Create `GlucoseLog` Hive model + encrypted box
- [] 🟡 Build logging screen — reading type selector (Fasting / Post-meal / Random / Bedtime) + mg/dL input
- [] x Implement `classifyFasting()` and `classifyPostMeal2h()` — copy from Section 12.2
- [] 🟡 HbA1c estimator — 90-day average glucose → estimated A1c %
- [] 🟡 Meal correlation — link post-meal glucose to a specific food log entry
- [] 🟡 Trend chart with configurable target bands
- [] 🟢 Award +5 XP per glucose log

### 12.3 SpO2 Tracker
- [] 🟢 Create `SpO2Log` Hive model (no encryption required)
- [] 🟡 Build manual logging screen — SpO2 % + pulse
- [] 🟡 Alert when SpO2 < 95% — "Please consult your doctor"
- [] 🟢 30-day trend chart with 95% lower reference band

### 12.4 Doctor Appointments 🔒
- [] 🔴 Create `Appointment` Hive model with encrypted `notes` field
- [] 🔴 Prescription photos stored **locally only** — file path in model, never uploaded
- [] 🟡 Build appointments list + add/edit screens
- [] 🟡 24h reminder notification using `flutter_local_notifications`

---

## Phase 13 — Lifestyle & Wellness Modules

### 13.1 Sleep Tracker
- [ ] 🟡 Build sleep logging screen — bedtime/wake time pickers, emoji quality scale (1–5)
- [ ] 🟡 Auto-sync from Health Connect / HealthKit when permission is granted
- [ ] 🟡 Weekly sleep chart + sleep debt indicator
- [ ] 🟢 Award +5 XP per sleep log

### 13.2 Mood Tracker
- [ ] 🟡 Build mood logging screen — 5-emoji selector + energy/stress sliders + tag chips
- [ ] 🟡 Voice note — record and store **locally only**, never upload
- [ ] 🟡 Mood heatmap calendar using `fl_chart`
- [ ] 🟢 Award +3 XP per mood log

### 13.3 Period Tracker 🔒
- [ ] 🔴 Create `PeriodLog` Hive model
- [ ] 🔴 All writes go through `EncryptionService` before touching Hive
- [ ] 🔴 Sync to Appwrite is **opt-in only** — default is local-only (add a Settings toggle)
- [ ] 🟡 Cycle prediction — average of last 3 cycles
- [ ] 🟡 Ovulation window estimation
- [ ] 🟡 Symptom tracking — cramps, bloating, mood swings, headache, fatigue, spotting
- [ ] 🟡 Workout suggestions per cycle phase
- [ ] 🟡 PCOD/PCOS management mode — activate from Chronic Conditions selection

### 13.4 Medication Reminder
- [ ] 🟡 Build medication list screen + add/edit form (name, dosage, frequency, category)
- [ ] 🟡 Schedule reminder notifications with `flutter_local_notifications` — fully offline
- [ ] 🟡 Refill alert — notification 3 days before estimated refill date
- [ ] 🟢 Auto-populate active medications into the Emergency Health Card

### 13.5 Habit Tracker
- [ ] 🟡 Build preset habits — 8 glasses water, 10-min meditation, 30-min walk, read 10 pages, no sugar
- [ ] 🟡 Custom habit creator — name, emoji, target count, unit, frequency
- [ ] 🟡 Streak tracking with flame indicator per habit
- [ ] 🟡 Weekly completion heatmap (GitHub graph style)
- [ ] 🟢 Award +2 XP per habit, +10 XP for 7-day streak

### 13.6 Body Measurements Tracker
- [ ] 🟡 Build measurement logging screen — weight, chest, waist, hips, arms, thighs, body fat %
- [ ] 🟡 Auto-calculate BMI, waist-to-hip ratio, waist-to-height ratio
- [ ] 🟡 Trend charts for 30/90/180-day windows
- [ ] 🔒🟢 Progress photos stored **locally only** — never upload to Appwrite

### 13.7 Intermittent Fasting Tracker
- [ ] 🟡 Protocol selector — 16:8 / 18:6 / 5:2 / OMAD / Custom
- [ ] 🟡 Countdown timer with fasting stage ring — copy `FastingStage` enum and `getStage()` from Section 13.3
- [ ] 🟡 Hydration alerts during fasting window
- [ ] 🟢 Ramadan mode — Sehri/Iftar as fasting boundary
- [ ] 🟢 Award +15 XP per completed fast

### 13.8 Meal Planner
- [ ] 🟡 Build 7-day grid planner — Breakfast / Lunch / Dinner / Snacks per day
- [ ] 🟡 Rule Engine generates suggested plan from TDEE + dosha + nutrition gaps (zero server calls)
- [ ] 🟡 Indian meal templates — North Indian, South Indian, Bengali, Gujarati
- [ ] 🟢 One-tap log — tap a planned meal to log it directly (sets `log_method: planner`)
- [ ] 🟢 Grocery list auto-generator from the week's plan

### 13.9 Recipe Builder
- [ ] 🟡 Build recipe form — add ingredients from food DB, set quantities and servings
- [ ] 🟡 Auto-calculate total macros per serving
- [ ] 🟡 Save recipe → log entire recipe as one food entry in one tap
- [ ] 🟢 Community sharing — mark recipe as public

### 13.10 Ayurveda Personalisation Engine
- [ ] 🟡 Build 12-question dosha quiz and scoring algorithm
- [ ] 🟡 `DoshaProfile` screen — `DoshaDonutChart` + vata/pitta/kapha percentages
- [ ] 🟡 `DailyRituals` checklist — Dinacharya tasks based on dosha type and current season
- [ ] 🟡 `SeasonalPlan` screen — food/activity adjustments per Indian season (Ritucharya)
- [ ] 🟢 Herbal remedies library — ashwagandha, triphala, brahmi, turmeric with evidence notes

### 13.11 Guided Meditation & Pranayama
- [ ] 🟡 Bundle audio files for 5/10/15/20-min guided sessions
- [ ] 🟡 Pranayama library — Anulom Vilom, Bhramari, Kapalbhati, Bhastrika with inhale/hold/exhale timers
- [ ] 🟡 Use `just_audio` for fully offline playback
- [ ] 🟢 Trigger 3-min breathing exercise when `stress_level > 7` in mood log
- [ ] 🟢 Award +5 XP per session, +10 XP for 7-day streak

### 13.12 Journaling 🔒
- [ ] 🔴 Build journal entry screen using `flutter_quill` for rich text
- [ ] 🔴 AES-256 encrypt content before writing to Hive
- [ ] 🔴 Sync to Appwrite **opt-in only** — same model as period tracker
- [ ] 🟢 Weekly prompt suggestions

### 13.13 Mental Health & Stress Management
- [ ] 🟡 Build burnout detection — sustained low mood + poor sleep + low energy over 7 days → recovery flow
- [ ] 🟡 7-day CBT-lite stress program
- [ ] 🟢 Surface Indian helpline resources — iCall, Vandrevala Foundation, NIMHANS
- [ ] 🟢 Gentle professional help prompt after 14 days of consistently low mood

---

## Phase 14 — Social & Community Modules
- [ ] 🟡 Build `SocialFeedScreen` — post workouts/meals/milestones, like and comment
- [ ] 🟡 Follow system — follow users, see their public posts in the main feed
- [ ] 🟡 Build `CommunityGroupsScreen` — create/join groups (diet, location, sport, challenge, support)
- [ ] 🟡 Group feed, group challenges, group leaderboard
- [ ] 🟡 Direct Messaging (DMs) — one-to-one messaging
- [ ] 🟢 Verified nutritionist / trainer badge on professional accounts

---

## Phase 15 — Family Health Profiles
- [ ] 🟡 Family admin can invite up to 5 members (Family plan only)
- [ ] 🟡 Admin has view-only access to each member's summary (not raw logs)
- [ ] 🟡 Weekly step leaderboard across family members
- [ ] 🟡 Family challenges — 7-day step goal, water challenge, screen-free morning
- [ ] 🟢 Group push notifications via Appwrite Functions

---

## Phase 16 — Wearable Integrations
- [ ] ⚡🟡 Health Connect (Android) + HealthKit (iOS) via `health` package — steps, sleep, HR, SpO2, BP
- [ ] 🔴 Fitbit Web API — copy OAuth2 flow from Section 17.3; keep `client_secret` in Appwrite Function only 🔒
- [ ] 🔴 Garmin Connect IQ — OAuth1; keep secret in Appwrite Function only 🔒
- [ ] 🟡 Mi Band / boAt — bridge through Health Connect
- [ ] 🟡 Delta sync on app resume — only fetch data since `last_sync_at`
- [ ] 🟢 Low Data Mode: reduce wearable sync to 6-hour intervals

---

## Phase 17 — Platform & Infrastructure

### 17.1 Emergency Health Card
- [ ] ⚡🟡 Build the Emergency Card screen — blood group, allergies, conditions, medications, emergency contact
- [ ] 🟢 Accessible from Android lock screen widget / iOS Home Screen widget
- [ ] 🔒🟢 Store **locally only** — no Appwrite sync ever
- [ ] 🟡 Export as PDF or QR code

### 17.2 Festival Fitness Calendar
- [ ] 🟡 Hardcode Indian festival database — Navratri, Ramadan, Diwali, Karwa Chauth (zero API dependency),Holi
- [ ] 🟡 Navratri: 9-day fasting guide + Garba calorie tracker
- [ ] 🟡 Ramadan: Sehri/Iftar planner (integrates with Fasting Tracker)
- [ ] 🟡 Diwali: sweet calorie tracker + healthy alternatives
- [ ] 🟢 Auto push notification 3 days before each festival

### 17.3 Automated Health Reports
- [ ] 🟡 Auto-generate weekly/monthly PDF reports using the `pdf` package in a Dart isolate
- [ ] 🔒🟡 Save PDF **locally only** — never upload to Appwrite Storage
- [ ] 🟢 Doctor-friendly format — medical metrics with reference ranges clearly labelled
- [ ] 🟢 Share/print PDF from the Reports screen

### 17.4 Personal Records Tracker
- [ ] 🟡 Auto-detect new PRs from workout logs (max lift per exercise, fastest 5K, longest run)
- [ ] 🟡 PR celebration notification
- [ ] 🟡 PR history chart per exercise
- [ ] 🟢 Award +100 XP for any new PR

### 17.5 Referral Program
- [ ] 🟡 Generate unique referral code at registration — store in `users.referral_code`
- [ ] 🟡 Referrer receives +500 XP when referred user completes onboarding
- [ ] 🟡 Referred user receives +100 XP on signup
- [ ] 🟢 Referral leaderboard in Karma Hub

### 17.6 Low Data Mode
- [ ] 🟡 Toggle in Settings — disable image loading, reduce sync to every 6 hours
- [ ] 🟢 Auto-detect connection speed and enable automatically on slow connections
- [ ] 🟢 Compress images to ≤ 200 KB before upload when in Low Data Mode

---

## Phase 18 — Appwrite Backend Setup
> *Most of this is done in the Appwrite Console, not in Flutter code.*

- [ ] ⚡🟡 Create the Appwrite Database — note the `DATABASE_ID`
- [ ] 🟡 Create all **core collections** — `users`, `food_logs`, `food_items`, `workout_logs`, `step_logs`, `sleep_logs`, `mood_logs`, `period_logs`, `medications`, `habits`, `body_measurements`, `karma_transactions`, `nutrition_goals`, `posts`, `challenges`, `subscriptions`, `family_groups`, `workouts`
- [ ] 🟡 Create all **extended collections** — `blood_pressure_logs`, `glucose_logs`, `spo2_logs`, `doctor_appointments`, `fasting_logs`, `meal_plans`, `recipes`, `journal_entries`, `personal_records`, `community_groups`, `health_reports`, `community_dms`
- [ ] 🔒🔴 Set `Role.user({userId})` read + write permissions on **every collection** — no admin read on sensitive collections
- [ ] 🟡 Enable Google OAuth2 in Auth → OAuth2 Providers
- [ ] 🟡 Enable SMTP in Settings → SMTP (for password reset emails)
- [ ] 🟡 Create Storage buckets: `avatars` and `posts_media`
- [ ] 🔴 Deploy Appwrite Function: **FCM Push Notifications** (copy from Section 17.5)
- [ ] 🔴 Deploy Appwrite Function: **Razorpay Webhook** (copy from Section 17.6)
- [ ] 🔴 Deploy Appwrite Function: **Fitbit Token Exchange** (copy from Section 17.4) 🔒
- [ ] 🔴 Deploy Appwrite Function: **Garmin Token Exchange** 🔒
- [ ] 🔒🟡 Store all secrets (Fitbit secret, Garmin secret, Razorpay secret) as Appwrite Function environment variables — **never in the Flutter app**
- [ ] 🟡 Configure API rate limiting in the Appwrite Console
- [ ] 🟡 Set up daily database export cron for disaster recovery (copy the backup cron from Section 24)

---

## Phase 19 — Monetization (Razorpay)
- [ ] 🟡 Add Razorpay keys (`RAZORPAY_KEY_ID`) to `.env` — key secret goes to Appwrite Function only 🔒
- [ ] 🟡 Build `SubscriptionScreen` — show Free / Monthly / Quarterly / Yearly / Family plan cards
- [ ] 🔴 Implement subscription purchase flow — copy the 5-step flow from Section 17.6
- [ ] 🔴 Implement Razorpay webhook in Appwrite Function — verify HMAC signature before updating `subscriptions` collection
- [ ] 🟡 Implement free-tier data archival — show data for 7 days, archive older records, restore on upgrade
- [ ] 🟢 À la carte workout pack purchases (one-time payment)

---

## Phase 20 — Localisation (8 Indian Languages)
- [ ] 🟡 Configure `flutter_localizations` in `pubspec.yaml` and `app.dart`
- [ ] 🟡 Create `.arb` files: `app_en.arb`, `app_hi.arb`, `app_ta.arb`, `app_te.arb`, `app_kn.arb`, `app_mr.arb`, `app_bn.arb`, `app_gu.arb`
- [ ] 🟡 Add all string keys to `app_en.arb` first
- [ ] 🟡 Translate all strings — use a professional translator or community contributors (not just Google Translate)
- [ ] 🟢 Verify Devanagari rendering on Android (Hindi, Marathi) and Gujarati/Bengali scripts

---

## Phase 21 — Accessibility
- [ ] 🟡 Add `Semantics` widgets to all interactive elements — screen reader support
- [ ] 🟢 Test with TalkBack (Android) and VoiceOver (iOS)
- [ ] 🟢 Ensure all text scales correctly when the system font size is increased to 200%
- [ ] 🟢 Build high-contrast mode — add a toggle in Settings

---

## Phase 22 — Testing
> *Write tests alongside the feature, not after the whole app is done.*

### Unit Tests (target ≥ 60% coverage for `/data/` and `/domain/`)
- [ ] 🟡 TDEE / BMR formula — all goal types and activity factors
- [ ] 🟡 Blood pressure `classify()` — all AHA threshold boundaries
- [ ] 🟡 Glucose `classifyFasting()` and `classifyPostMeal2h()`
- [ ] 🟡 Dosha quiz scoring algorithm
- [ ] 🔴 AES-256 round-trip — encrypt then decrypt all sensitive models (period, journal, BP, glucose, appointments)
- [ ] 🟡 Karma XP accumulation with streak multipliers
- [ ] 🟡 Fasting stage machine — in-progress, completed, broken states
- [ ] 🟡 Recipe calorie auto-calculation from ingredient list
- [ ] 🟡 Sync conflict resolution for all data types from the conflict matrix
- [ ] 🟢 Referral code uniqueness (collision probability test)

### Widget Tests
- [ ] 🟡 `ActivityRingsWidget` — various progress levels (0%, 50%, 100%, overflow)
- [ ] 🟡 `BPTrendChart` — correct colour banding for all AHA classifications
- [ ] 🟡 `FastingProgressRing` — correct phase labels and countdown
- [ ] 🟡 `GlucoseHistoryChart` — target bands per reading type
- [ ] 🟡 `DoshaDonutChart` — segment proportions for all dosha combinations
- [ ] 🟢 `ShimmerLoader` and `ErrorWidget` — render in all async states
- [ ] 🟢 `MoodEmojiSelector` — tap selection and slider interactions

### Integration Tests
- [ ] 🔴 Full food log flow — search → select → confirm → verify Hive write → verify sync queue entry
- [ ] 🔴 Offline → online sync — log items offline, restore connectivity, verify Appwrite document created
- [ ] 🔴 Auth flow — register → onboarding → dashboard loads from Hive
- [ ] 🔴 Period encryption — log entry → read back → verify decryption → verify raw Hive bytes are not plaintext
- [ ] 🔴 BP log flow — log → AES encryption → correct AHA classification displayed
- [ ] 🔴 Fasting flow — start → advance time → eat → verify completion and XP awarded
- [ ] 🟡 Recipe builder — add ingredients → calculate → save → log → verify calorie total
- [ ] 🟡 Meal planner → food log — plan a meal → log it → verify `log_method: planner`
- [ ] 🟡 Referral flow — generate code → sign up with code → verify XP awarded to both parties

### Performance Benchmarks
- [ ] 🟡 Dashboard cold start < 2s on a 3 GB RAM device
- [ ] 🟡 Hive food search < 200ms against a 10,000-item database
- [ ] 🟡 Sync queue flush — 20 records < 5s on a 3G connection
- [ ] 🟡 PDF report generation < 3s for a 30-day report
- [ ] 🟢 BP/Glucose chart render < 300ms with 90 data points
- [ ] 🟢 Memory leak check — food log screen after 50 entries

---

## Phase 23 — CI/CD Pipeline
- [ ] ⚡🟡 Create `.github/workflows/ci.yml` — copy the GitHub Actions workflow from Section 24
- [ ] 🟡 Add `APPWRITE_PROJECT_ID`, `APPWRITE_DATABASE_ID` as GitHub repository secrets
- [ ] 🟡 Add `RAZORPAY_KEY_ID`, Fitbit/Garmin client IDs as GitHub secrets
- [ ] 🔴 Add `.env.prod` to GitHub secrets (never commit the file itself)
- [ ] 🟡 Configure Codecov to track test coverage
- [ ] 🟡 Deploy Appwrite Functions via CLI — copy the `appwrite deploy` commands from Section 24
- [ ] 🟢 Set up the daily backup cron (Appwrite DB export → Backblaze B2)

---

## Phase 24 — Pre-Launch Checklist
- [ ] 🔒🔴 Final security audit — check every Appwrite collection has correct `Role.user(uid)` permissions
- [ ] 🔒🔴 Verify no secrets are hardcoded in Flutter source (`grep -r "client_secret"`)
- [ ] 🔒🟡 Verify `.env` is in `.gitignore` — run `git log --all -- .env` to confirm it was never committed
- [ ] 🔴 Verify sensitive data in Hive is actually encrypted — read raw bytes and confirm they are not plaintext
- [ ] 🔴 Test payment flow end-to-end in Razorpay **test mode** before enabling live keys
- [ ] 🟡 Verify installed app size < 50 MB — run `flutter build appbundle --release` and check output
- [ ] 🟡 Cold start benchmark < 2s on a real mid-range device (not a simulator)
- [ ] 🟡 Test offline mode thoroughly — enable airplane mode and use every core feature
- [ ] 🟡 Test on a real 2G/3G connection with Low Data Mode enabled
- [ ] 🟢 Verify all 8 language `.arb` files are complete — no missing keys
- [ ] 🟢 Test with TalkBack / VoiceOver — all interactive elements reachable
- [ ] 🟢 Submit to Google Play (internal track first) and Apple App Store (TestFlight first)
- [ ] 🟢 Set up Sentry DSN and verify crash reports are coming through from the production build

---

## 📌 Quick Reference

| Phase | What you're building | Rough effort |
|-------|---------------------|-------------|
| 0–1 | Environment + scaffold | 1–2 days |
| 2 | Theme + shared widgets | 3–5 days |
| 3 | Core infrastructure | 3–5 days |
| 4 | Auth + onboarding | 3–5 days |
| 5 | Dashboard | 2–3 days |
| 6 | Food logging | 1–2 weeks |
| 7–8 | Steps + Karma | 3–5 days |
| 9–10 | Workouts + Nutrition | 1–2 weeks |
| 11–12 | Insight Engine + Health modules | 1–2 weeks |
| 13 | Lifestyle & wellness | 2–3 weeks |
| 14–16 | Social + Family + Wearables | 2–3 weeks |
| 17 | Platform + infrastructure | 1 week |
| 18–19 | Appwrite backend + Razorpay | 1 week |
| 20–21 | i18n + Accessibility | 1 week |
| 22–24 | Testing + CI/CD + Launch | 1–2 weeks |

---

*FitKarma · Flutter · Riverpod · Hive · Appwrite · Built for India*