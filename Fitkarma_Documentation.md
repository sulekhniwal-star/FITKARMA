# FitKarma — Complete Master Documentation v1
### India's Intelligent Health Operating System
**Flutter 3.x · Riverpod 2.x · Drift · Appwrite CLI · RevenueCat · Groq Llama-3**

> **Offline-First · Privacy-Centric · Built for India · AI-Adaptive**
> Dark mode primary · Glassmorphism · Spring physics · Bento grid
> All backend via **Appwrite CLI** — no console needed.

---

## Vision Statement

FitKarma is not a fitness tracker. It is **India's intelligent health operating system** — an adaptive AI system that creates and evolves a complete life plan for each user, providing the kind of personalized coaching that was previously only available to celebrities and elite athletes.

> "Stop making it only a tracker. Make it a decision engine + life operating system."

---

## Development Roadmap — Master Order

This document is structured in the exact order the app should be built:

| Phase | What You Build | Why First |
|-------|---------------|-----------|
| **Phase 0** | Foundation — Design System, Architecture, DevOps | Everything else depends on this |
| **Phase 1** | Core Onboarding + User Profile | Personalization data collected before any features |
| **Phase 2** | Daily Mission + Readiness Engine | The emotional core users return to every morning |
| **Phase 3** | AI Adaptive Coach | Transforms tracker into coaching system |
| **Phase 4** | Health Tracking (Steps, Sleep, Vitals) | Core data inputs for AI decisions |
| **Phase 5** | Smart Indian Nutrition System | Strongest moat; deepest Indian food intelligence |
| **Phase 6** | Workout + Progressive Overload | Intelligent progression, not just logging |
| **Phase 7** | Gamification + Karma System | Retention and motivation engine |
| **Phase 8** | Transformation Journey + Psychology | Anti-quit system |
| **Phase 9** | Social + Squad Accountability | Growth lever |
| **Phase 10** | Predictive Health + Preventive Intelligence | Life-changing health risk system |
| **Phase 11** | Visual Body Analytics | Retention through future projections |
| **Phase 12** | Festival + Cultural Intelligence | Uniquely Indian |
| **Phase 13** | Premium + Monetisation | Revenue unlocked after retention proven |
| **Phase 14** | Enterprise Hardening + CI/CD | Production readiness |

---

## Quick Navigation

| Need | Go to |
|------|--------|
| Start a new project | §P0-A Prerequisites → §P0-B Project Setup |
| Understand architecture | §P0-C Architecture Overview |
| Design tokens / colors | §P0-D Design Tokens |
| Build onboarding screens | §P1 Onboarding |
| Daily Readiness Score | §P2-A Readiness Engine |
| Daily Briefing Screen | §P2-B Daily Mission Screen |
| AI Adaptive Coach | §P3 AI Coach System |
| Health tracking screens | §P4 Health Tracking |
| Indian nutrition AI | §P5 Smart Nutrition |
| Workout intelligence | §P6 Workout System |
| Karma + gamification | §P7 Karma System |
| Anti-quit psychology | §P8 Transformation Journey |
| Social + squads | §P9 Community System |
| Predictive health | §P10 Health Intelligence |
| Body analytics | §P11 Visual Analytics |
| Festival mode | §P12 Festival Intelligence |
| Subscriptions | §P13 Monetisation |
| CI/CD + testing | §P14 Enterprise Hardening |
| Database schema | §DB Database Schema |
| Appwrite CLI setup | §AW Appwrite CLI |
| Glossary + ADRs | §GLO Glossary |

---

# PHASE 0 — FOUNDATION

---

## §P0-A. Design Philosophy

### Six Pillars

| Pillar | Expression |
|--------|-----------|
| **Spatial Depth** | Three-layer system: background → mid-layer → foreground. Real blur, shadow, translucency. Every screen has depth, never flat. |
| **Fluid Motion** | Spring physics everywhere. No linear tweens. 100ms touch-to-response. Animations must feel alive, not mechanical. |
| **Bold Information** | One dominant metric per screen at 56–72sp. Context recedes, data leads. Hierarchy is the UX. |
| **Visual Restraint** | Glow reserved for the active metric, primary CTA, and ring fill only. Not every card glows — glow is punctuation, not prose. |
| **Dark-First** | Dark mode is the primary target. Light mode is a warm, saffron inversion — not an afterthought. |
| **Cultural Pulse** | Orange-indigo-saffron palette echoes Indian aesthetics. Bilingual labels used surgically — for emotional connection, not everywhere. |

### ❌ Anti-Patterns — Never Do These

```
❌ Plain white cards with grey text on white backgrounds
❌ Skeleton screens on core data — use Drift optimistic UI
❌ Hardcoded hex values outside the token file
❌ Modals/dialogs when a bottom sheet suffices
❌ Glow on every card
❌ Two competing hero elements on the same screen
❌ Bilingual labels on every element — only category headers, crisis lines, festival banners
❌ Blur + glow + gradient + animation on the same card (max 2 effects per surface)
❌ Linear easing curves anywhere — always spring or easeOutCubic minimum
❌ Showing empty state before first data load — use ShimmerLoader
❌ Blocking UI for network operations — write to Drift first, sync in background
❌ Generic advice from the AI coach — always personalize using user context
❌ Treating festivals as disruptions — adapt plans around them instead
```

> **Rule of Two:** Each surface can have at most two visual effects simultaneously.
> Valid combos: `blur + border`, `glow + gradient`, `gradient + shadow`.
> Invalid: `blur + glow + gradient + animation`.

---

## §P0-B. Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── device_tier.dart            # RAM detection → Low/Mid/High
│   │   ├── user_experience_stage.dart  # firstWeek/familiar/expert
│   │   └── app_config.dart             # --dart-define constants
│   ├── theme/
│   │   ├── app_colors.dart             # AppColorsDark + AppColorsLight tokens
│   │   ├── app_typography.dart         # PlusJakartaSans scale + Devanagari
│   │   ├── app_theme.dart              # ThemeData builder (dark + light)
│   │   ├── app_spacing.dart            # Spacing + radius tokens
│   │   ├── app_gradients.dart          # heroDeep, heroSleep, heroFire, etc.
│   │   └── app_springs.dart            # SpringDescription presets
│   ├── router/
│   │   ├── app_router.dart             # GoRouter config
│   │   └── transitions.dart            # SharedAxisTransition, FadeThrough
│   ├── database/
│   │   └── app_database.dart           # Drift schema + migration strategy
│   ├── sync/
│   │   ├── sync_worker.dart            # Priority-based sync engine
│   │   ├── dlq_provider.dart           # Dead letter queue state
│   │   └── connectivity_service.dart   # Network monitoring
│   ├── security/
│   │   ├── biometric_lock.dart         # LocalAuthentication wrapper
│   │   └── sensitive_screen_guard.dart # FLAG_SECURE + biometric gate
│   └── providers/
│       ├── appwrite_provider.dart
│       ├── device_tier_provider.dart
│       ├── ux_stage_provider.dart
│       ├── core_providers.dart
│       └── low_data_mode_provider.dart
├── shared/
│   └── widgets/
│       ├── bento_card.dart             # GlassCard: tier-aware blur/border
│       ├── activity_rings.dart         # CustomPainter, 3 concentric rings
│       ├── glowing_metric.dart         # Hero number with glow shadow
│       ├── insight_card.dart           # AI/rule insight + 👍👎 feedback
│       ├── quick_log_fab.dart          # Persistent bottom-right FAB
│       ├── bilingual_label.dart        # Strategic Hindi/English label
│       ├── encryption_badge.dart       # Teal lock icon + "AES-256"
│       ├── shimmer_loader.dart         # First-load skeleton shimmer
│       ├── trend_chip.dart             # ↑ ↓ → color-coded delta chip
│       ├── pulse_ring.dart             # Animated glow ring (CustomPainter)
│       ├── streak_flame.dart           # Custom animated flame
│       ├── bottom_nav_bar.dart         # 5-tab glass nav bar
│       ├── empty_state.dart            # Animated icon + message + CTA
│       ├── animation_widgets.dart      # ErrorRetryWidget, etc.
│       ├── level_up_animation.dart     # Full-screen XP burst overlay
│       ├── breathing_circle.dart       # Inhale/hold/exhale custom painter
│       ├── sync_status_banner.dart     # DLQAlertBanner
│       ├── readiness_ring.dart         # Daily Readiness Score ring (NEW)
│       ├── daily_briefing_card.dart    # Morning mission card (NEW)
│       ├── recovery_badge.dart         # Recovery status chip (NEW)
│       └── logo_reveal.dart            # Splash screen logo animation
├── features/
│   ├── onboarding/
│   ├── dashboard/
│   ├── daily_mission/                  # NEW — Phase 2
│   ├── readiness/                      # NEW — Phase 2
│   ├── ai_coach/
│   │   ├── ai_coach_screen.dart
│   │   ├── ai_coach_provider.dart
│   │   └── context_builder.dart        # NEW — assembles full user context
│   ├── food/
│   │   ├── data/
│   │   │   ├── food_database_service.dart
│   │   │   ├── open_food_facts_client.dart
│   │   │   ├── indian_food_repository.dart
│   │   │   └── meal_photo_analyzer.dart  # NEW — Phase 5
│   │   └── presentation/
│   ├── workout/
│   │   ├── progressive_overload.dart     # NEW — Phase 6
│   │   └── workout_blueprint.dart        # NEW — Phase 6
│   ├── steps/
│   ├── health/
│   ├── recovery/                         # NEW — Phase 2
│   ├── transformation/                   # NEW — Phase 8
│   ├── karma/
│   ├── social/
│   │   └── squad/                        # NEW — Phase 9
│   ├── reports/
│   ├── festival/
│   ├── wedding/
│   └── settings/
│       └── subscription_screen.dart
└── main.dart
```

---

## §P0-C. Architecture Overview

### Core Architecture Principle: Offline-First + AI-Adaptive

```
User Action
    ↓
Drift (local SQLite AES-256)  ← Source of truth
    ↓ (immediate UI update)
Riverpod State Layer
    ↓ (background)
Sync Worker → Appwrite (cloud)
    ↓ (periodic / on-demand)
AI Context Builder → Groq Llama-3 (via Appwrite Function)
    ↓
Adaptive Recommendations → Drift cache → UI
```

### Three-Layer Offline Strategy

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Local DB** | Drift + SQLCipher | All reads; AES-256 encrypted at page level |
| **Sync Engine** | Priority queue + DLQ | Background writes to Appwrite; retries 3× then DLQ |
| **Cloud** | Appwrite (self-hostable) | Cross-device sync, AI functions, auth |

### AI Decision Engine (NEW)

The AI system should know at all times:

- User goals, body fat, BMI, BMR/TDEE
- Sleep quality and HRV for last 7 days
- Energy level and mood logs
- Diet consistency (protein, calories, fiber)
- Missed workouts and streak status
- Stress indicators and resting heart rate
- Schedule (work type, activity level)
- Festivals and special events
- Menstrual cycle (if applicable)
- Injuries and limitations
- Gym access and equipment available
- Weather conditions (from device location)
- Indian foods eaten (regional preferences)
- Recovery score and fatigue index

This context is assembled by `context_builder.dart` and sent to Groq on each AI request.

---

## §P0-D. Design Tokens

> **Rule:** Never hardcode hex values in widget files. All colors must come from `AppColorsDark` / `AppColorsLight`.

### Color Tokens

```dart
// lib/core/theme/app_colors.dart

class AppColorsDark {
  AppColorsDark._();

  // Background layers (deepest to nearest)
  static const bg0         = Color(0xFF080810); // Void black — scene background
  static const bg1         = Color(0xFF0F0F1A); // Default scaffold background
  static const bg2         = Color(0xFF161625); // Elevated sections

  // Surface layers
  static const surface0    = Color(0xFF1C1C2E); // Cards, bottom sheets
  static const surface1    = Color(0xFF22223A); // Elevated cards
  static const surface2    = Color(0xFF2A2A45); // Input fields, selected states

  // Glassmorphism
  static const glass       = Color(0x0FFFFFFF); // 6% white fill
  static const glassBorder = Color(0x1AFFFFFF); // 10% white border

  // Brand — Orange (primary action, active state, hero glow)
  static const primary        = Color(0xFFFF6B35);
  static const primaryGlow    = Color(0x40FF6B35);
  static const primaryMuted   = Color(0x30FF6B35);

  // Brand — Amber (XP, streaks, achievements)
  static const accent         = Color(0xFFFFB547);
  static const accentGlow     = Color(0x33FFB547);

  // Secondary — Indigo/Violet (levels, sleep, meditation)
  static const secondary      = Color(0xFF7B6FF0);
  static const secondaryGlow  = Color(0x407B6FF0);

  // Teal (water, SpO2, Ayurveda, medication)
  static const teal           = Color(0xFF00D4B4);
  static const tealGlow       = Color(0x3300D4B4);

  // Semantic
  static const success        = Color(0xFF4ADE80);
  static const successGlow    = Color(0x334ADE80);
  static const warning        = Color(0xFFFBBF24);
  static const error          = Color(0xFFF87171);
  static const rose           = Color(0xFFFB7185);
  static const purple         = Color(0xFFC084FC);

  // Text
  static const textPrimary    = Color(0xFFF1F0FF);
  static const textSecondary  = Color(0xFF9B99CC);
  static const textMuted      = Color(0xFF6B68A0);
  static const divider        = Color(0x14FFFFFF);
}
```

### Color Semantic Quick-Reference

| Color | Token | Use Case |
|-------|-------|----------|
| Orange `#FF6B35` | `primary` | CTA buttons, active nav tab, hero metric glow |
| Amber `#FFB547` | `accent` | XP coins, streak flames, achievement highlights |
| Indigo `#7B6FF0` | `secondary` | Level badges, sleep screen gradient, meditation |
| Teal `#00D4B4` | `teal` | Water tracker, SpO2, medication, Ayurveda |
| Green `#4ADE80` | `success` | Steps goal achieved, healthy readings, habits done |
| Amber `#FBBF24` | `warning` | Elevated BP/glucose, moderate risk states |
| Red `#F87171` | `error` | Crisis readings, destructive actions |
| Rose `#FB7185` | `rose` | Period tracker, menstrual health |
| Purple `#C084FC` | `purple` | Active minutes ring, move goal |

### Spacing & Radius Tokens

```dart
class AppSpacing {
  static const double screenH      = 20.0;
  static const double cardH        = 16.0;
  static const double fabClearance = 120.0;
  static const double bentoGap     = 12.0;
}

class AppRadius {
  static const double sm         = 10.0;
  static const double md         = 16.0;
  static const double lg         = 20.0;
  static const double xl         = 28.0;
  static const double full       = 9999.0;
  static const double bentoInner = 14.0;
  static const double bentoOuter = 20.0;
  static const double bentoHero  = 28.0;
}
```

### Typography System

```dart
class AppTypography {
  static const heroDisplay  = TextStyle(fontSize: 72, fontWeight: FontWeight.w800, letterSpacing: -2.0, height: 0.95);
  static const metricXL     = TextStyle(fontSize: 56, fontWeight: FontWeight.w700, letterSpacing: -1.5, height: 1.0);
  static const metricLg     = TextStyle(fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -1.0, height: 1.1);
  static const displayLg    = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.8, height: 1.15);
  static const displayMd    = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.4, height: 1.2);
  static const h1           = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3, height: 1.25);
  static const h2           = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.3);
  static const h3           = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.1, height: 1.35);
  static const bodyLg       = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static const bodyMd       = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static const bodySm       = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);
  static const labelLg      = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.2, height: 1.4);
  static const labelMd      = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, height: 1.4);
  static const monoXL       = TextStyle(fontFamily: 'JetBrainsMono', fontSize: 48, fontWeight: FontWeight.w700);
  static const monoLg       = TextStyle(fontFamily: 'JetBrainsMono', fontSize: 28, fontWeight: FontWeight.w600);
  static const monoMd       = TextStyle(fontFamily: 'JetBrainsMono', fontSize: 18, fontWeight: FontWeight.w500);
  static const monoSm       = TextStyle(fontFamily: 'JetBrainsMono', fontSize: 13, fontWeight: FontWeight.w400);

  // Devanagari — NEVER use PlusJakartaSans for Hindi
  static TextStyle hindi({double size = 14, FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: size, fontWeight: weight, height: 1.6);
}
```

### Motion & Spring Presets

```dart
class AppSprings {
  static const standard = SpringDescription(mass: 1.0, stiffness: 300.0, damping: 28.0);
  static const dramatic  = SpringDescription(mass: 1.0, stiffness: 200.0, damping: 20.0);
  static const gentle    = SpringDescription(mass: 1.0, stiffness: 150.0, damping: 22.0);
  static const bouncy    = SpringDescription(mass: 1.0, stiffness: 400.0, damping: 18.0);
}
```

### Animation Rules

| Rule | Detail |
|------|--------|
| Touch to response | ≤ 100ms always |
| No linear curves | `Curves.linear` is banned — use `easeOutCubic` minimum |
| Entrance duration | 250–400ms |
| Exit duration | 200ms max |
| Stagger offset | 60ms between list items, max 6 |
| Device tier gates | `DeviceTier.low` → replace spring with `easeOutCubic`, no blur |
| Reduced motion | Respect `MediaQuery.disableAnimations` |

### Device Tier System

```dart
enum DeviceTier { low, mid, high }

DeviceTier detectTier(int ramMb) {
  if (ramMb < 2048) return DeviceTier.low;
  if (ramMb < 4096) return DeviceTier.mid;
  return DeviceTier.high;
}
```

| Feature | Low (< 2 GB) | Mid (2–4 GB) | High (> 4 GB) |
|---------|-------------|-------------|--------------|
| Backdrop blur | ❌ solid surface | ✅ blur(12) | ✅ blur(16) |
| Ambient glow | ❌ | ✅ reduced | ✅ full |
| Spring physics | ❌ easeOutCubic | ✅ standard | ✅ dramatic |
| Complex animations | ❌ static | ✅ | ✅ |
| Sync interval | Every 6h | Every 30min | Every 15min |

---

## §P0-E. Scaffold Patterns

### Pattern A — Standard Scroll
Used by: Dashboard, Food Home, Steps, Karma, Reports, Settings, Social, Water, Habits

### Pattern B — Hero + Overlapping Body
Used by: Profile, Blood Pressure, Glucose, Sleep, Workout Detail, Karma Hub, Festival Detail

### Pattern C — Full Bleed
Used by: Active Workout, Steps active, Fasting Timer, Breathing Exercise

### Calm Zone
Used by: Settings, Journal, Emergency Card, Lab Reports, Biometric screens
Rules: Zero blobs, zero glow, zero blur, zero spring animations on ANY device tier.

---

## §P0-F. Shared Component Library

### Core Components (Build First)

| Component | File | Purpose |
|-----------|------|---------|
| GlassCard | `bento_card.dart` | Tier-aware blur card — base for everything |
| GlowingMetric | `glowing_metric.dart` | Single hero number per screen |
| ActivityRings | `activity_rings.dart` | 3 concentric CustomPainter rings |
| QuickLogFab | `quick_log_fab.dart` | Persistent bottom-right FAB |
| InsightCard | `insight_card.dart` | AI insight with 👍👎 feedback |
| TrendChip | `trend_chip.dart` | ↑ ↓ → delta chip |
| ShimmerLoader | `shimmer_loader.dart` | First-load skeleton |
| ErrorRetryWidget | `animation_widgets.dart` | Error + retry UI |
| DailyBriefingCard | `daily_briefing_card.dart` | Morning mission card (NEW) |
| ReadinessRing | `readiness_ring.dart` | Daily readiness score ring (NEW) |
| RecoveryBadge | `recovery_badge.dart` | Recovery status chip (NEW) |

### QuickLogFab Grid (Updated)

```
Row 1: [🍽 Food] [💧 Water] [🏋️ Workout]
Row 2: [💊 Medication] [😊 Mood] [❤️ BP]
Row 3: [😴 Sleep] [🩸 Glucose] [⚡ Energy]  ← NEW row
```

---

## §P0-G. pubspec.yaml (Key Dependencies)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  drift: ^2.18.0
  drift_flutter: ^0.1.0
  sqlcipher_flutter_libs: ^0.5.4
  appwrite: ^12.0.1
  go_router: ^13.2.0
  revenuecat_flutter_sdk: ^6.3.0
  health: ^10.2.0
  local_auth: ^2.3.0
  sentry_flutter: ^7.20.1
  cached_network_image: ^3.3.1
  image_picker: ^1.1.2
  mobile_scanner: ^5.1.0
  permission_handler: ^11.3.1
  shared_preferences: ^2.2.3
  connectivity_plus: ^6.0.3
  workmanager: ^0.5.15
  firebase_messaging: ^15.0.4
  geolocator: ^11.0.0           # For weather-aware recommendations
  weather: ^3.1.1               # Weather API for adaptive plans
  fl_chart: ^0.68.0
  lottie: ^3.1.2
  shimmer: ^3.0.0
  google_fonts: ^6.2.1

dev_dependencies:
  build_runner: ^2.4.11
  drift_dev: ^2.18.0
  riverpod_generator: ^2.4.0
```

---

## §P0-H. Appwrite CLI Setup

### Prerequisites
- Node.js 18+, Appwrite CLI (`npm install -g appwrite-cli@latest`)
- Appwrite Cloud project or self-hosted instance (India region recommended)
- Flutter 3.x, Dart 3.x

### CLI Init

```bash
appwrite login
appwrite init project
# Enter project name: FitKarma
# Select region: Mumbai (or nearest)
```

### Collections to Create (All 19)

```bash
# Run in sequence — each creates one Appwrite collection

# 1. users
appwrite databases createCollection \
  --databaseId fitkarma-db \
  --collectionId users \
  --name "Users"

# 2. user_vitals (steps, calories, active minutes — daily summaries)
# 3. food_logs
# 4. workout_logs
# 5. sleep_logs
# 6. bp_readings
# 7. glucose_readings
# 8. water_logs
# 9. habit_logs
# 10. mood_logs
# 11. medication_logs
# 12. karma_events
# 13. ai_insights
# 14. diet_plans
# 15. squad_groups           (NEW — Phase 9)
# 16. squad_members          (NEW — Phase 9)
# 17. transformation_checks  (NEW — Phase 8)
# 18. recovery_logs          (NEW — Phase 2)
# 19. body_measurements      (NEW — Phase 11)

# (Full attribute schemas in §DB section)
```

---

# PHASE 1 — ONBOARDING + USER PROFILE

---

## §P1-A. Onboarding Flow Order

```
1. /onboarding/welcome          → Splash + value proposition
2. /onboarding/goals            → What do you want to achieve? (Step 1 of 5)
3. /onboarding/demographics     → Physical profile + BMI (Step 2 of 5)  [REQUIRED, no Skip]
4. /onboarding/diet_plan        → AI-generated 7-day diet preview (no step indicator)
5. /onboarding/dosha            → Ayurvedic body type quiz (Step 3 of 5)
6. /onboarding/program_select   → Choose your Blueprint (Step 4 of 5)   [NEW]
7. /onboarding/permissions      → Health + notification permissions (Step 5 of 5)
```

---

## §P1-B. Welcome Screen

**Route:** `/onboarding/welcome`
**Scaffold:** Pattern C (full-bleed `heroDeep` gradient)

```
Center vertical stack:
  Animated logo (64px, spring reveal at 300ms)
  56px gap
  "Your health, your karma."
  AppTypography.heroDisplay (72sp, white, letterSpacing -2)
  16px gap
  "Track steps, food, sleep, and vitals.
   Earn karma. Build habits that last."
  AppTypography.bodyLg, textSecondary
  48px gap
  [Get Started →] ElevatedButton, full width
  16px gap
  [I already have an account] TextButton

Bottom dots indicator: 3 dots, step 1 active
```

---

## §P1-C. Goals Screen

**Route:** `/onboarding/goals` | **Step:** 1 of 5

Goal grid (2 columns, 6 cells):
```
┌─────────────┬─────────────┐
│ 🏃 Lose     │ 💪 Build    │
│   Weight    │   Muscle    │
├─────────────┼─────────────┤
│ ❤️ Heart    │ 🩸 Manage   │
│   Health    │   BP/Glucose│
├─────────────┼─────────────┤
│ 🧘 Reduce   │ ⚡ More     │
│   Stress    │   Energy    │
└─────────────┴─────────────┘
```
- Max 3 goals selectable
- Conditional metric slider appears based on goal selected
- Saves to Drift `users.goals` on Continue

---

## §P1-D. Demographics Screen

**Route:** `/onboarding/demographics` | **Step:** 2 of 5 | **No Skip button**

### Purpose
Collects the user's physical profile to power:
1. Live BMI calculation as user types
2. Adaptive daily targets (steps, workout, hydration, calories) per BMI category
3. 7-day AI diet plan via Groq Llama-3

### Form Cards

**Card 1 — Name**
```
GlassCard → TextField
prefixIcon: Icons.person_outline_rounded
hint: "e.g. Arjun Sharma"
```

**Card 2 — Physical Metrics**
```
Age field     → suffixText: "years", numeric
Gender        → [Male] [Female] [Other] segmented control
Height field  → supports both cm and ft/in (toggle unit)
Weight field  → supports kg and lbs (toggle unit)
```

**Card 3 — Activity Level**
```
Segmented: [Sedentary] [Light] [Moderate] [Active] [Very Active]
Subtitle: descriptive text per selection
```

**Card 4 — Work Style** *(NEW)*
```
[Desk job / WFH] [Field work] [Mixed] [Physical labor]
Used by AI to adapt standing time and movement recommendations
```

**Live BMI Card (AnimatedSize)**
Appears immediately when height + weight are both entered:
```
┌────────────────────────────────────┐
│ 📊 Your BMI: 24.2  Normal Weight  │
│ Calculated from: 170cm · 70kg     │
│ ████████░░░░░░ Healthy Range      │
└────────────────────────────────────┘
```

BMI color coding:
- < 18.5 → `secondary` (underweight)
- 18.5–24.9 → `success` (normal)
- 25–29.9 → `warning` (overweight)
- ≥ 30 → `error` (obese)

### Adaptive Targets Generated from BMI

| BMI Category | Steps | Workout | Water | Calories |
|-------------|-------|---------|-------|----------|
| Underweight | 6,000 | 30 min | 2.0 L | TDEE + 300 |
| Normal | 8,000 | 45 min | 2.5 L | TDEE |
| Overweight | 10,000 | 60 min | 3.0 L | TDEE − 300 |
| Obese | 8,000 | 45 min | 3.5 L | TDEE − 500 |

TDEE formula: **Mifflin-St Jeor** × activity multiplier (1.2–1.9 based on activity level)

### On Continue
```dart
// 1. Calculate BMI + TDEE + adaptive targets
// 2. Save to Drift users table (syncStatus: 'pending')
// 3. Trigger background Groq diet plan generation (don't await)
// 4. Navigate to /onboarding/diet_plan
```

---

## §P1-E. AI Diet Plan Results Screen

**Route:** `/onboarding/diet_plan` | **No step indicator**

### States
1. **Loading** → ShimmerLoader with "Crafting your personalized 7-day plan…"
2. **Error** → ErrorRetryWidget with retry button
3. **Success** → Full 7-day plan

### Layout (Success State)
```
Header: "🥗 Your 7-Day Plan"
Subtitle: "Built for your body and Indian diet preferences"

Day tabs: [Mon] [Tue] [Wed] [Thu] [Fri] [Sat] [Sun]
  AnimatedSwitcher on tab change

Per Day:
  GlassCard for each meal (Breakfast / Lunch / Dinner / Snack)
  ┌──────────────────────────────────┐
  │ 🌅 Breakfast                     │
  │ Moong Dal Chilla + Curd          │
  │ ~380 kcal · 22g protein          │
  │ 🔸 Add 1 egg to boost protein    │  ← AI tip
  └──────────────────────────────────┘

Daily totals bar:
  Calories · Protein · Carbs · Fat
  Horizontal progress bars (primaryMuted fill)

Bottom:
  [Looks Good, Continue →] ElevatedButton
  [Regenerate Plan] TextButton (textSecondary)
```

### Groq Prompt Template

```
You are an expert Indian nutritionist. Generate a 7-day personalized meal plan.

User Profile:
- Name: {name}, Age: {age}, Gender: {gender}
- Height: {height}cm, Weight: {weight}kg, BMI: {bmi}
- Goal: {goals}, Activity: {activityLevel}
- Work style: {workStyle}
- Dosha (if available): {dosha}
- Dietary preference: {dietType} (vegetarian/non-vegetarian/vegan)
- Daily calorie target: {calorieTarget} kcal
- Daily protein target: {proteinTarget}g

Rules:
- Use ONLY authentic Indian foods (no generic "salad" or "grilled chicken")
- Include regional variety (South Indian, North Indian, etc.)
- Respect fasting days if applicable
- Every meal must have name, calories, protein, carbs, fat
- Include one practical AI tip per meal

Return ONLY valid JSON. No markdown. No explanation.
Format: { "days": [ { "day": "Monday", "meals": [ ... ] } ] }
```

### Caching
- Cache to Drift `diet_plans` table
- Expiry: 7 days
- Invalidate if BMI delta ≥ 1.0 (weight change triggers regeneration)

---

## §P1-F. Dosha Quiz Screen

**Route:** `/onboarding/dosha` | **Step:** 3 of 5

10 questions, spring slide between them. After Q10: 3–5s processing animation → dosha result reveal.

Questions:
1. Body frame — Thin / Medium / Large
2. Skin type — Dry / Normal / Oily
3. Energy pattern — Variable / Moderate / Sustained
4. Sleep quality — Light / Sound / Deep
5. Digestion — Irregular / Regular / Slow
6. Memory — Quick but forgetful / Sharp / Slow but permanent
7. Speech — Fast / Moderate / Deliberate
8. Emotional nature — Anxious / Passionate / Calm
9. Temperature preference — Cold avoidance / Neutral / Heat avoidance
10. Appetite — Variable / Strong / Low

Result influences: Ayurvedic meal recommendations, supplement suggestions, stress management approach.

---

## §P1-G. Program Blueprint Selection Screen *(NEW)*

**Route:** `/onboarding/program_select` | **Step:** 4 of 5

This is where FitKarma delivers the "celebrity treatment" — a personalized program named for the user's exact situation.

AI generates the appropriate program name based on demographics + goals. User sees:

```
"Based on your profile, we've selected:"

┌────────────────────────────────────┐
│ 🏢 Corporate Fat Loss              │
│ Designed for desk workers with     │
│ high stress and low movement       │
│ 12 weeks · Moderate intensity      │
│ ✓ Fits your schedule               │
│ ✓ Home-friendly                    │
│ ✓ Indian vegetarian meals          │
└────────────────────────────────────┘

[Switch Program] → shows full program library
```

### Program Library (AI-Selectable or User-Selectable)

| Program | Target User |
|---------|------------|
| Corporate Fat Loss | Office workers, high stress, low movement |
| Indian Vegetarian Muscle Gain | Veg users wanting to build muscle |
| PCOS Fat Loss | Women with PCOS |
| Wedding Transformation | 8–16 week goal-based |
| New Mom Recovery | Postpartum fitness |
| Student Hostel Fitness | No gym, budget constraints |
| Diabetes Reversal Support | High glucose users |
| Heart Health Guardian | Elevated BP or cardiac risk |
| Senior Strength & Balance | Users 50+ |
| Athletic Performance | Already fit, wants to optimize |
| Menopause Wellness | Women 45–60 |

Each program includes:
- Workout plan (type, frequency, duration, intensity)
- Nutrition framework (calories, macros, meal timing)
- Recovery plan (deload weeks, rest days)
- Duration and milestone checkpoints
- Adaptation rules (when AI can modify the plan)

---

## §P1-H. Permissions & Privacy Screen

**Route:** `/onboarding/permissions` | **Step:** 5 of 5

Permissions requested:
- Health data (HealthKit / Health Connect)
- Activity recognition
- Notifications (with timing preferences)
- Camera (meal photos, barcode scanning)
- Location (weather-aware recommendations — optional)

DPDP Act compliance notice visible on this screen.

---

# PHASE 2 — DAILY MISSION + READINESS ENGINE

> This is the app's emotional core. Users should open FitKarma every morning because this screen makes them feel coached.

---

## §P2-A. Daily Readiness Score Engine

The Readiness Score is the single most important new feature. It makes FitKarma feel like WHOOP or Oura, but for India, for free users.

### Readiness Inputs

| Input | Source | Weight |
|-------|--------|--------|
| Sleep duration | HealthKit / manual | High |
| Sleep quality | User rating / HRV proxy | High |
| Resting heart rate | HealthKit / wearable | High |
| HRV (if available) | HealthKit / wearable | High |
| Yesterday's activity load | Steps + workout intensity | Medium |
| Self-reported soreness | Morning check-in | Medium |
| Self-reported stress | Morning check-in | Medium |
| Hydration yesterday | Water logs | Medium |
| Mood yesterday | Mood logs | Low |
| Consecutive hard training days | Workout log | High |

### Readiness Score Calculation

```dart
double calculateReadiness({
  required double sleepScore,      // 0–100 based on duration + quality
  required double hrrScore,        // 0–100, resting HR vs baseline
  required double recoveryScore,   // 0–100, based on yesterday's load
  required double sorenessScore,   // 0–100, inverse of soreness rating
  required double stressScore,     // 0–100, inverse of stress rating
  required double hydrationScore,  // 0–100, yesterday's water vs target
}) {
  return (sleepScore * 0.30) +
         (hrrScore * 0.20) +
         (recoveryScore * 0.20) +
         (sorenessScore * 0.15) +
         (stressScore * 0.10) +
         (hydrationScore * 0.05);
}
```

### Readiness Zones + Actions

| Score | Zone | Color | AI Action |
|-------|------|-------|-----------|
| 85–100 | Peak | `success` | "Go all out today — you're fully recovered" |
| 70–84 | High | `success` muted | "Great day for a hard session" |
| 55–69 | Moderate | `accent` | "Moderate workout — push but don't max out" |
| 40–54 | Low | `warning` | "Light session only — mobility or easy cardio" |
| < 40 | Recovery | `error` | "Rest day — prioritize sleep and nutrition today" |

### AI Intensity Adjustment

Based on readiness, the AI automatically adjusts:
- Workout intensity (reduces by up to 40% on low readiness days)
- Daily calorie target (increases by up to 200 kcal on recovery days for repair)
- Hydration target (increases on high-activity high-readiness days)
- Protein recommendation (increases on high-readiness training days)
- Step goal (reduces on recovery days to avoid overtraining)

### Recovery Tracking Inputs

Track daily:
- Sleep quality (1–5 stars)
- HRV trend (if wearable connected)
- Resting heart rate vs 7-day baseline
- Muscle soreness (1–5 by body region)
- Stress level (1–5)
- Hydration achieved (vs target)
- Activity load score (METs × duration)

Calculate:
- **Recovery Score**: How well the body recovered from yesterday
- **Training Readiness**: Can the user train hard today?
- **Fatigue Index**: Cumulative load vs recovery ratio over 7 days
- **Biological Debt**: Sleep debt accumulated over the week

---

## §P2-B. Daily Briefing Screen (Daily Mission)

**Route:** `/mission` (home tab, shown first on app open every morning)
**Scaffold:** Pattern B — Hero + overlapping body

This is the first screen users see every morning. It must feel like a personal coach greeting them.

### Morning Check-In (Shown Before Briefing if No Data Yet)

A 3-question morning ritual (30 seconds max):
```
1. "How did you sleep?" → 1–5 stars
2. "How sore are you?" → [Fresh] [Mild] [Moderate] [Very Sore]
3. "Stress level today?" → 1–5 slider
```
After 3 taps → instant readiness score calculation → Briefing screen animates in.

### Daily Briefing Layout

```
Hero Section (320px, heroDeep gradient):
  Top: "Good morning, Arjun 👋" (bodyLg, textSecondary)
  Center: Readiness Score Ring (128px diameter)
    Number: 76 (heroDisplay, white)
    Label: "READINESS" (labelSm, textSecondary)
    Ring fill: scored color (green/amber/red)
    Outer ring: subtle pulse animation (high tier only)
  Bottom: "High — Great day for a hard session" (bodyMd, white)

Body Panel (overlapping hero):

  ── Today's Mission Card ──────────────────────────────
  GlassCard, primaryGlow border
  "🎯 Today's Mission"
  
  Three mission items (animated list, 60ms stagger):
  ┌────────────────────────────────────────┐
  │ 💪  Upper Body Workout · 45 min        │
  │     [Start Workout →]                  │
  ├────────────────────────────────────────┤
  │ 🥗  Priority: Protein ≥ 110g today     │
  │     You averaged 58g last 6 days       │
  ├────────────────────────────────────────┤
  │ 💧  Drink 3.2L (High heat today)       │
  │     Weather: 38°C in your area         │
  └────────────────────────────────────────┘

  ── Today's Focus ─────────────────────────────────────
  Bento 2-column grid:
  ┌───────────────┬──────────────────┐
  │ 😴 Sleep Debt  │ ⚡ Energy        │
  │ -45 min       │ Moderate         │
  │ vs baseline   │ Based on HRV     │
  ├───────────────┼──────────────────┤
  │ 🔥 Streak     │ 🏆 Karma Today   │
  │ 12 days       │ +45 XP target    │
  └───────────────┴──────────────────┘

  ── AI Coach Insight ──────────────────────────────────
  InsightCard (orange border):
  "Your protein intake has averaged 58g for 6 days
   while your muscle-building goal requires ~110g.
   Add paneer or eggs to breakfast to improve recovery."
  [👍 Helpful] [👎 Not relevant]

  ── Recovery Alert (conditional) ─────────────────────
  Only shown if readiness < 55:
  WarningCard (warning color):
  "You're entering a high fatigue phase.
   Switching to light training today protects
   your long-term progress."

  ── Quick Actions ─────────────────────────────────────
  Row: [Log Breakfast] [Start Workout] [Log Water]
  3 chips, primary outline style
```

### Data Sources for Daily Briefing

```dart
class DailyBriefingData {
  final int readinessScore;
  final String readinessLabel;
  final WorkoutPlan todaysWorkout;
  final String nutritionFocus;
  final double hydrationTarget;
  final String weatherContext;    // from location + weather API
  final int sleepDebtMinutes;
  final double energyLevel;
  final int streakDays;
  final int karmaXpToday;
  final AiInsight primaryInsight;
  final bool showRecoveryAlert;
  final String recoveryMessage;
}
```

---

## §P2-C. Recovery Log Screen

**Route:** `/recovery` (accessible from Health tab)

Tracks the full recovery picture:

```
Sections:
  Today's Recovery Status
  └── Recovery Score: 68 (Moderate)
  
  Sleep Last Night
  └── Duration: 6h 20min
  └── Quality: ★★★☆☆
  └── Sleep debt: -40 min vs target
  
  Body Soreness Map
  └── Tap-to-select body region diagram
  └── Soreness 1–5 per region
  
  HRV Trend (7-day chart)
  └── fl_chart line chart
  └── Below baseline alerts
  
  Resting HR
  └── Today: 68 bpm vs baseline 64 bpm
  └── Trend arrow (TrendChip)
  
  Fatigue Index (7-day rolling)
  └── Load vs Recovery ratio bar
  └── "Accumulated fatigue: Moderate"
  
  AI Recovery Recommendation
  └── "Take 1–2 lighter days before next hard session"
```

---

# PHASE 3 — AI ADAPTIVE COACH

---

## §P3-A. AI Coach Philosophy

**Bad AI response:**
> "Eat more protein."

**Good AI response:**
> "Your protein intake has averaged 58g for 6 days while your muscle-building goal requires ~110g. Add paneer or eggs to breakfast to improve recovery."

The AI should never give generic advice. Every response must reference specific user data.

---

## §P3-B. AI Context Builder

Before every AI call, assemble the full user context:

```dart
class AIContextBuilder {
  Future<Map<String, dynamic>> build(String userId) async {
    final user = await _userRepo.getUser(userId);
    final recentLogs = await _logsRepo.getLast7Days(userId);
    final readiness = await _readinessRepo.getToday(userId);
    final weather = await _weatherService.getCurrent(user.location);
    final festival = await _festivalRepo.getUpcoming(user.region);

    return {
      // Profile
      'name': user.name,
      'age': user.age,
      'gender': user.gender,
      'bmi': user.bmi,
      'goals': user.goals,
      'dosha': user.dosha,
      'program': user.currentProgram,
      'dietType': user.dietType,
      'workStyle': user.workStyle,
      'gymAccess': user.gymAccess,
      'injuries': user.injuries,

      // Today's state
      'readinessScore': readiness.score,
      'sleepLastNight': recentLogs.lastSleep,
      'stressLevel': readiness.stressLevel,
      'energyLevel': readiness.energyLevel,
      'soreness': readiness.sorenessRegions,

      // 7-day history
      'avgSteps7d': recentLogs.avgSteps,
      'avgProtein7d': recentLogs.avgProtein,
      'avgCalories7d': recentLogs.avgCalories,
      'avgSleep7d': recentLogs.avgSleep,
      'workoutsCompleted7d': recentLogs.workoutsCompleted,
      'missedWorkouts7d': recentLogs.missedWorkouts,
      'streakDays': recentLogs.streakDays,

      // Context
      'weatherToday': weather.description,
      'tempCelsius': weather.temperature,
      'upcomingFestival': festival?.name,
      'festivalDaysAway': festival?.daysAway,
      'menstrualCycleDay': user.menstrualCycleDay, // null if not applicable
    };
  }
}
```

---

## §P3-C. AI Coach Screen

**Route:** `/ai-coach`
**Scaffold:** Pattern A

### Layout

```
AppBar: "🤖 AI Coach" | [History icon]

Context Banner (GlassCard, accent border):
"Based on your data from the last 7 days"
Shows: readiness score chip + streak chip + primary concern

Chat Interface:
  Messages list (reverse scroll)
  
  AI messages:
    Left-aligned, primaryMuted background
    Avatar: FitKarma bot icon (32px)
    Typewriter animation on new responses
    Source chips: [Based on 7-day avg] [From your goals]
    
  User messages:
    Right-aligned, surface2 background

Suggested Prompts (shown when chat is empty):
  Chip row (horizontal scroll):
  "Why am I not losing weight?"
  "What should I eat post-workout?"
  "Is my sleep affecting my gains?"
  "Adapt my plan for this week"
  "I have a wedding in 2 weeks"

Input bar (sticky bottom):
  TextField + [Send] + [🎤 Voice] + [📸 Photo]
  Voice → speech_to_text → auto-fill
  Photo → meal photo analysis mode
```

### Appwrite Function: `fitkarma-coach`

```javascript
// functions/fitkarma-coach/index.js
export default async ({ req, res, log }) => {
  const { userId, message, conversationHistory } = JSON.parse(req.body);

  // 1. Build full user context
  const context = await buildUserContext(userId);

  // 2. Build system prompt
  const systemPrompt = `
You are FitKarma's AI health coach — personalized, warm, direct, and data-driven.
You have access to the user's complete health context.
ALWAYS reference specific numbers from their data. Never give generic advice.
Use Indian food examples when making nutrition suggestions.
Adapt to their goals: ${context.goals}.
Today's readiness: ${context.readinessScore}/100.
Recent concern: protein avg ${context.avgProtein7d}g vs target ${context.proteinTarget}g.

Full context: ${JSON.stringify(context)}
  `;

  // 3. Call Groq
  const response = await fetch('https://api.groq.com/openai/v1/chat/completions', {
    method: 'POST',
    headers: { Authorization: `Bearer ${process.env.GROQ_API_KEY}` },
    body: JSON.stringify({
      model: 'llama-3.1-70b-versatile',
      messages: [
        { role: 'system', content: systemPrompt },
        ...conversationHistory,
        { role: 'user', content: message }
      ],
      max_tokens: 400,
      temperature: 0.7,
    })
  });

  const data = await response.json();
  return res.json({ reply: data.choices[0].message.content });
};
```

### AI Coach Insight Automation

The AI should also generate **proactive insights** (not just respond to questions). Generate these daily via a scheduled Appwrite Function:

```
Trigger conditions → AI Insight generated:

If protein < 60% of target for 5+ days:
  → "Your protein intake has averaged Xg for Y days..."

If sleep < 6h for 3+ consecutive nights:
  → "Sleep deprivation is reducing your recovery by ~30%..."

If steps dropping for 5+ days:
  → "Your step count has fallen Z% this week..."

If weight plateau for 3+ weeks:
  → "You've been at the same weight for 3 weeks. Let's adjust..."

If workout missed 3+ in a row:
  → "You've missed 3 workouts. Want to switch to a lighter plan?"
```

---

# PHASE 4 — HEALTH TRACKING

---

## §P4-A. Dashboard Screen

**Route:** `/dashboard`
**Scaffold:** Pattern B (Hero + overlapping body)

### Hero Section

```
Gradient: heroDeep (320px)
  
  Top row:
    "Good {time}, {name}" (bodyLg, textSecondary)
    [DLQAlertBanner] if syncStatus failures
  
  Center: Activity Rings (180px diameter)
    Outer ring: Steps progress (orange)
    Middle ring: Calories (amber)
    Inner ring: Active minutes (purple)
  
  Below rings:
    Steps count: heroDisplay (white)
    "of 10,000 steps" (bodyMd, textSecondary)
    TrendChip: ↑ 12% vs yesterday
```

### Body Panel Cards

```
── Daily Readiness (NEW — appears first) ───────────────
ReadinessRing (80px) + score + zone label
"Tap to see today's mission →"

── Bento Grid Row 1 ────────────────────────────────────
┌──────────────────┬──────────────────┐
│ 💧 Water          │ 🔥 Calories      │
│ 1.8 / 3.0 L      │ 1,240 / 1,800    │
│ ████░░░           │ ███████░░░       │
└──────────────────┴──────────────────┘

── AI Coach Insight ────────────────────────────────────
InsightCard (orange border)
Rotating daily — new insight every morning

── Bento Grid Row 2 ────────────────────────────────────
┌──────────────────┬──────────────────┐
│ 😴 Sleep          │ ❤️ Resting HR    │
│ 6h 20min         │ 68 bpm           │
│ ↓ 40min debt     │ → Baseline       │
└──────────────────┴──────────────────┘

── Streak + Karma ──────────────────────────────────────
┌──────────────────┬──────────────────┐
│ 🔥 12-day streak │ ⭐ 4,280 karma   │
│ Keep it going!   │ Level 8 Warrior  │
└──────────────────┴──────────────────┘

── Quick Log ───────────────────────────────────────────
Row: [+ Food] [+ Water] [+ Workout] (chips)
```

---

## §P4-B. Steps Screen

**Route:** `/steps`
**Scaffold:** Pattern C (Pattern B on idle state)

```
Hero: Steps count (heroDisplay) + activity ring
Body: Hourly step bar chart (fl_chart)
Bento: [Distance] [Active Min] [Calories] [Floors]
AI Insight: "Your steps are 23% higher on days you log breakfast."
```

Auto-detection: `health` package → HealthConnect (Android) / HealthKit (iOS)
Background sync: `workmanager` every 15 minutes on High tier devices.

---

## §P4-C. Sleep Screen

**Route:** `/sleep`
**Scaffold:** Pattern B (heroSleep gradient)

```
Hero: Sleep duration (metricXL) + quality stars
Sleep stages chart: Deep / Light / REM / Awake (stacked bar)
HRV chart (7-day, if wearable connected)
Resting HR trend
Sleep debt accumulation (7-day rolling)
AI Insight: "Your deep sleep dropped 45% this week — avoid screens 1h before bed."
```

---

## §P4-D. Blood Pressure Screen

**Route:** `/health/bp`
**Scaffold:** Pattern B | **Calm Zone**
**Biometric lock required**

```
Hero: Latest reading (metricXL, semantic color)
Classification: [Normal] [Elevated] [Stage 1 HT] [Stage 2 HT] [Crisis]
History chart: 30-day systolic/diastolic dual line chart
AI Risk Alert (conditional):
  "Your BP has been elevated for 8 days.
   Prioritize walking and reduce sodium-heavy dinners this week."
```

---

## §P4-E. Glucose Screen

**Route:** `/health/glucose`
**Scaffold:** Pattern B | **Calm Zone**
**Biometric lock required**

Similar to BP screen. Shows:
- Fasting vs post-meal readings
- HbA1c estimate (if 3+ months of data)
- Food correlation (which meals spike glucose)
- AI risk alerts if trending upward

---

## §P4-F. Preventive Health Intelligence *(NEW)*

Cross-correlates multiple vitals to detect risk patterns:

```dart
class PreventiveIntelligenceEngine {
  HealthRiskAlert? analyze(UserHealthData data) {
    // Hypertension risk pattern
    if (data.bpTrend == Trend.rising &&
        data.sleepTrend == Trend.declining &&
        data.weightTrend == Trend.rising &&
        data.stepsTrend == Trend.declining) {
      return HealthRiskAlert(
        risk: 'Hypertension',
        severity: RiskSeverity.moderate,
        message: 'Your current pattern increases hypertension risk. '
                 'Prioritize walking and reduce sodium-heavy dinners this week.',
        actions: ['Log a 20-min walk', 'Reduce pickle/papad intake', 'Check BP tomorrow'],
      );
    }
    // Diabetes risk pattern
    if (data.glucoseTrend == Trend.rising &&
        data.bmi >= 27 &&
        data.stepAvg7d < 5000) {
      return HealthRiskAlert(
        risk: 'Type 2 Diabetes',
        severity: RiskSeverity.moderate,
        message: 'Elevated glucose combined with low activity is a risk signal. '
                 'A 15-min post-meal walk significantly reduces glucose spikes.',
        actions: ['Walk after meals', 'Reduce refined carbs', 'Log fasting glucose tomorrow'],
      );
    }
    return null;
  }
}
```

Risk alerts appear:
1. As a banner on the Dashboard (warning color, dismissible)
2. As an AI Coach insight card
3. As a push notification (once per risk, not repeated daily)

---

# PHASE 5 — SMART INDIAN NUTRITION SYSTEM

---

## §P5-A. Food Screen Home

**Route:** `/food`
**Scaffold:** Pattern A

```
AppBar: "🥗 Nutrition" | [📸 Scan] [🔍 Search]

Today's Summary (GlassCard, hero):
  Calorie ring (80px) + macros progress bars
  Calories: 1,240 / 1,800 kcal
  Protein: 58g / 110g  ← highlighted red if below target
  Carbs: 180g / 220g
  Fat: 45g / 60g
  
  Protein Alert (if below 70% of target):
  "⚠️ Protein low — add paneer or eggs to your next meal"

Meal Sections (collapsible):
  🌅 Breakfast · 380 kcal
  ☀️ Lunch · 520 kcal
  🌙 Dinner · 340 kcal
  🍎 Snacks · 0 kcal (tap to add)

Each food entry:
  [Food name] [Portion] [Calories]
  Protein badge if high-protein food
  Swipe left → delete (soft delete + Undo)

Meal Quality Score (NEW):
  Not just calories — show per meal:
  ├── Protein score: ██░░░ 3/5
  ├── Fiber score: ████░ 4/5
  ├── Glycemic load: Low ✓
  └── Satiety: High ✓

Bottom InsightCard:
  "Your lunch thali averaged 420 kcal this week.
   Add dal or curd to bring protein to 25g per meal."
```

---

## §P5-B. Food Search + Indian Food Database

```
Search bar (auto-focus):
  Recent searches row (chips)
  
Results grouped:
  Your Foods (logged in last 30 days)
  Indian Foods (custom DB — 50k+ items)
  Global (Open Food Facts — 3M+ items)
  Packaged (barcode scan)

Indian Food DB features:
  Hindi + English names
  Regional variants (e.g., "Sambar" has Tamil Nadu / Karnataka variants)
  Seasonal availability tags
  Festival food tags (Navratri, Ramadan, etc.)
  Home-cooked size estimates ("1 katori", "1 chapati")
  Regional oil usage profiles (mustard, coconut, groundnut)
  Street food entries (vada pav, pani puri, bhel)
  Restaurant chain items (major Indian chains)

Smart portion suggestions:
  "1 medium chapati (30g)" not just "chapati"
  "1 katori dal (~150g)" not just "dal"
```

---

## §P5-C. Meal Quality Scoring *(NEW)*

Every meal gets a quality score across 5 dimensions:

| Dimension | Calculation | Icon |
|-----------|-------------|------|
| Protein score | grams / per-meal target × 5 | 💪 |
| Fiber score | grams / 8g target per meal × 5 | 🌿 |
| Glycemic load | sum of GI × carbs / 100 → Low/Med/High | 📊 |
| Satiety score | based on fiber + protein + fat combination | 😊 |
| Recovery score | amino acid completeness + anti-inflammatory index | 🔄 |

Shown as: star rating per dimension, not a single number (avoids oversimplification).

---

## §P5-D. "Fix My Meal" — AI Meal Photo Analysis *(NEW)*

**Trigger:** Camera icon on Food screen → [Analyze Meal]

### Flow

```
1. User taps 📸 → camera opens
2. Photo captured → sent to Groq Vision via Appwrite Function
3. ShimmerLoader: "Analyzing your meal..."
4. Results screen:

┌────────────────────────────────────┐
│ 📸 Your Meal Analysis              │
│                                    │
│ Detected: Dal Makhani + 2 Rotis    │
│ + Onion Salad                      │
│                                    │
│ Estimated Macros:                  │
│ ~580 kcal · 18g protein            │
│ 72g carbs · 22g fat                │
│                                    │
│ What's Missing:                    │
│ ⚠️ Protein low for muscle goal     │
│ ✓ Good fiber content               │
│ ⚠️ High glycemic load (rotis)      │
│                                    │
│ Healthier Swaps:                   │
│ + Add curd or paneer for protein   │
│ + Replace 1 roti with salad        │
│                                    │
│ [Log This Meal] [Adjust Portions]  │
└────────────────────────────────────┘
```

### Appwrite Function: `fitkarma-meal-vision`

```javascript
// Sends meal image to Groq Vision (llama-3.2-vision)
// Returns: detected foods, estimated macros, improvement suggestions
// Falls back to manual entry if detection confidence < 70%
```

---

## §P5-E. Smart Indian Meal Intelligence *(NEW)*

The AI understands Indian meal complexity:

**Thali composition:**
- Estimates dal + sabzi + roti + rice + sides as a unit
- Does not require logging 8 separate items
- "Gujarati Thali (medium)" logs as a complete entry with regional macro averages

**Oil estimation:**
- Knows typical oil usage per cooking style
- "Tadka dal" adds 1–2 tsp mustard oil to macros automatically
- Regional profiles: South (coconut), North (ghee/mustard), West (groundnut)

**Fasting food intelligence:**
- Navratri mode: database filtered to fasting-appropriate items
- Ramadan mode: Sehri and Iftar meal planning templates
- Ekadashi: auto-flag grain-containing foods

**Festival adaptation:**
- Diwali week: AI adjusts daily targets to account for sweet consumption
- "Festival Survival Mode" — see Phase 12

---

# PHASE 6 — WORKOUT + PROGRESSIVE OVERLOAD INTELLIGENCE

---

## §P6-A. Workout Screen Home

**Route:** `/workout`
**Scaffold:** Pattern A

```
Header: Current Program name + week/day
  "Week 3, Day 2 — Upper Body Push"

Today's Workout Card (GlassCard, primaryGlow):
  Exercise list (3–6 exercises)
  Each: [Exercise name] [Sets × Reps] [Weight] [Rest]
  Progressive overload badge: "↑ Weight" or "↑ Reps" if applicable
  [Start Workout →] primary CTA

Program Progress:
  Horizontal progress bar: Week 3 of 12
  Milestones: ✓ Week 1 Foundation · ✓ Week 2 · → Week 3 · ○ Week 4...

Recent History:
  Last 3 workout cards (compact)
  Volume trend chart (7-day)
```

---

## §P6-B. Active Workout Screen

**Route:** `/workout/active`
**Scaffold:** Pattern C (full-bleed)

```
Top: Exercise name (h1) + set counter "Set 2 of 4"
Hero: Weight (metricXL) × Reps (metricXL)
  Both tappable to adjust
  
Rest timer: countdown circle (CustomPainter)
  Spring pop animation on timer end
  Vibration feedback

Controls: [← Previous] [Skip →] [✓ Done]

Notes field: collapsible, voice input supported

Completion overlay (full-screen burst):
  LevelUpAnimation if new XP threshold crossed
  Workout summary card slides up
```

---

## §P6-C. Progressive Overload Intelligence *(NEW)*

```dart
class ProgressiveOverloadEngine {
  ProgressionSuggestion? suggest({
    required Exercise exercise,
    required List<WorkoutSession> recentSessions,
  }) {
    // Check last 3 sessions at same weight
    final last3 = recentSessions.takeLast(3);
    final allCompletedComfortably = last3.every(
      (s) => s.repsCompleted >= s.repsTarget && s.rpe <= 7
    );

    if (allCompletedComfortably) {
      return ProgressionSuggestion(
        type: ProgressionType.increaseWeight,
        message: 'You completed 3 sessions at ${exercise.currentWeight}kg '
                 'comfortably. Increase to ${exercise.nextWeightStep}kg next session.',
        newWeight: exercise.nextWeightStep,
      );
    }

    // Detect plateau (same weight/reps for 4+ weeks)
    if (_isPlateau(recentSessions)) {
      return ProgressionSuggestion(
        type: ProgressionType.deload,
        message: 'You\'ve been at the same weight for 4 weeks. '
                 'Take a deload week at 60% intensity, then resume.',
      );
    }

    return null;
  }

  bool _requiresDeloadWeek(List<WorkoutSession> sessions) {
    // 3 consecutive weeks of declining performance → deload
    return _isPerformanceDeclining(sessions, weeksBack: 3);
  }
}
```

Progression suggestions appear:
1. Before the next session as a banner
2. In the active workout screen next to the exercise
3. In the AI Coach daily insight

---

## §P6-D. Dynamic Fitness Blueprint Generator *(NEW)*

After program selection in onboarding, the AI generates a full workout blueprint:

**Inputs:**
- Age, gender, BMI, body fat % (if known)
- Goals, injuries, equipment available
- Schedule (days per week, session duration)
- Experience level (beginner / intermediate / advanced)
- Activity level and work style

**Output (Groq-generated, cached to Drift):**

```json
{
  "programName": "Corporate Fat Loss",
  "durationWeeks": 12,
  "daysPerWeek": 4,
  "sessionDuration": 45,
  "phases": [
    {
      "name": "Foundation",
      "weeks": "1-3",
      "focus": "Build movement patterns, establish consistency",
      "intensity": "Moderate (RPE 6-7)",
      "workouts": [...]
    },
    {
      "name": "Build",
      "weeks": "4-8",
      "focus": "Progressive overload, increase volume",
      "intensity": "High (RPE 7-8)",
      "workouts": [...]
    },
    {
      "name": "Peak",
      "weeks": "9-12",
      "focus": "Maximum intensity, body composition shift",
      "intensity": "Very High (RPE 8-9)",
      "workouts": [...]
    }
  ],
  "deloadWeeks": [4, 8, 12],
  "nutritionProtocol": {...},
  "recoveryProtocol": {...}
}
```

---

# PHASE 7 — GAMIFICATION + KARMA SYSTEM

---

## §P7-A. Karma System Design

Karma is the emotional engine of FitKarma. Every healthy action earns XP.

### XP Events

| Action | XP | Bonus Condition |
|--------|----|----------------|
| Workout completed | +50 | +20 if readiness < 50 (pushed through fatigue) |
| Steps goal hit | +30 | +10 per 1,000 above goal |
| Food logged (all meals) | +20 | +15 if protein target hit |
| Sleep ≥ 7h logged | +25 | +10 if quality ≥ 4 stars |
| Water goal achieved | +15 | — |
| BP/Glucose logged | +20 | — |
| Habit completed | +10 per habit | — |
| Streak milestone | +100 | 7-day, 14-day, 30-day, 90-day |
| Program week completed | +150 | — |
| Readiness check-in | +10 | — |
| AI insight feedback given | +5 | — |
| Invited a friend who joined | +200 | — |

### Karma Levels (20 levels)

| Level | Name | XP Required | Reward Unlocked |
|-------|------|-------------|----------------|
| 1 | Beginner | 0 | — |
| 2 | Seeker | 200 | Custom avatar border |
| 3 | Striver | 500 | Advanced insights |
| 4 | Builder | 1,000 | Recovery analytics |
| 5 | Achiever | 2,000 | AI program adjustment |
| 8 | Warrior | 5,000 | Squad creation |
| 10 | Champion | 10,000 | FitKarma Pro trial (7 days) |
| 15 | Elite | 25,000 | Priority AI response |
| 20 | Legend | 60,000 | Lifetime badge |

### Level Up Animation
Full-screen overlay (1.2s) on every level change:
```
XP burst particles + level number springs in
Confetti (amber + orange)
"Level {X} — {Name}!" (heroDisplay)
Reward revealed below
[Claim Reward →] CTA
```

---

## §P7-B. Karma Hub Screen

**Route:** `/karma`
**Scaffold:** Pattern B (heroDeep gradient)

```
Hero:
  Total karma: 4,280 (heroDisplay, accent color glow)
  "Level 8 — Warrior" (bodyLg)
  XP to next level: progress bar (76% to Level 9)

Body Panel:
  ── Streaks ──────────────────────────────────────────
  GlassCard (streak_flame animation center-right)
  Current streak: 12 days (metricLg)
  Best streak: 31 days
  TrendChip: ↑ 3 vs last month

  ── Achievements ────────────────────────────────────
  Grid (3 columns) of achievement badges
  Earned: full color + glow
  Locked: grayscale + lock overlay + progress hint
  Tap → achievement detail bottom sheet

  ── XP History ──────────────────────────────────────
  7-day bar chart (fl_chart)
  Each bar colored by primary XP source (workout/food/steps)

  ── Leaderboard ─────────────────────────────────────
  Squad leaderboard (if in a squad)
  Friends leaderboard
  Weekly + All-time tabs
```

---

## §P7-C. Habit Automation System *(NEW)*

```
Habits Screen — /habits

Habit categories:
  💪 Fitness    → Morning workout, evening walk
  🥗 Nutrition  → Log breakfast, hit protein target
  💧 Hydration  → 8am glass, pre-workout hydration
  😴 Sleep      → 10pm wind-down, no screens 1h before
  🧘 Wellness   → 5-min breathing, gratitude log

Intelligent habit triggers (NOT fixed reminders):
  - "Protein reminder" fires 30 min after workout (not at 8am)
  - "Sleep wind-down" fires based on usual sleep time ± 30 min
  - "Water reminder" adjusts based on today's temperature + activity
  - "Breathing exercise" fires when resting HR is above baseline
  - "Post-meal walk" nudge fires 20 min after food logged

Each habit:
  Streak counter (flame icon)
  Skip option: [Skip today] → no streak break but no XP
  Habit chain: completing habit A unlocks habit B reminder

Habit Insight (AI):
  "Your best habit days are Tuesdays. You complete 6/6 habits.
   Your worst are Fridays — only 2/6. What changes on Fridays?"
```

---

# PHASE 8 — TRANSFORMATION JOURNEY + ANTI-QUIT PSYCHOLOGY

---

## §P8-A. Transformation Journey Engine *(NEW)*

Most people quit fitness apps within 2 weeks. FitKarma detects quit signals early and intervenes.

### Consistency Tracking

```dart
class ConsistencyTracker {
  ConsistencyStatus analyze(UserBehaviorData data) {
    // Signals of declining engagement
    final signals = [
      data.appOpenFrequencyDropping,         // opens < 3x/week from 7x/week
      data.workoutsMissedInARow >= 3,
      data.junkFoodLoggedDaysInARow >= 4,
      data.sleepDecliningFor >= 5,
      data.lastAppOpen.isMoreThan(days: 2),  // ghost users
      data.motivationRating < 3,             // from morning check-in
    ];

    final riskScore = signals.where((s) => s).length;

    if (riskScore >= 4) return ConsistencyStatus.highRelapse;
    if (riskScore >= 2) return ConsistencyStatus.moderate;
    return ConsistencyStatus.strong;
  }
}
```

### Relapse Intervention System

When `highRelapse` detected, AI intervenes with a tiered response:

**Day 1 — Gentle Nudge:**
> "You've been quieter than usual this week. No pressure — let's restart with something small. A 10-minute walk today counts as a win."

**Day 2 — Plan Adjustment:**
> "I've switched you to the Lite Plan for the next 3 days — 20-min workouts, no calorie counting. Just show up."

**Day 3 — Emergency Reframe:**
> "Missing workouts doesn't erase your 12-day streak last month. That version of you still exists. Let's bring them back with one simple action today."

**Day 5 — Human Connection:**
> "Your squad member Priya is also on a similar streak. She logged a workout today — want to send her a 🔥?"

### Transformation Milestones

Track and celebrate non-scale victories:
- First workout completed
- First week of protein targets hit
- First time resting HR dropped below baseline
- 30-day streak
- First program phase completed
- BMI category change
- Clothes fitting better (user-reported)

Each milestone triggers:
1. Full-screen celebration animation
2. Push notification to share
3. +Bonus XP
4. Milestone card in Transformation Timeline

---

## §P8-B. Transformation Timeline Screen *(NEW)*

**Route:** `/transformation`
**Scaffold:** Pattern A

```
Header: "Your Journey" + [12 weeks] badge

Visual Timeline (vertical scroll):
  Week 1 → Week 12 markers
  
  Each week card:
  ┌─────────────────────────────────┐
  │ Week 3 · Apr 14 – Apr 20        │
  │ ✓ 4/4 workouts completed        │
  │ ✓ Protein target hit 5/7 days   │
  │ ─ Avg steps: 8,240              │
  │ ★ Milestone: First deload done  │
  └─────────────────────────────────┘

Body Stats Timeline:
  Weight chart (fl_chart line)
  BMI trend
  Body measurements (if logged)
  Program phase progress

Photo Progress (optional, biometric-locked):
  Side-by-side before/after comparison
  Stored encrypted, never uploaded to cloud unless user shares
  
AI Physique Prediction (NEW):
  "At your current pace, you may reach 18% body fat in 14 weeks."
  "If you hit protein targets consistently, muscle gain could be +2kg in 8 weeks."
  Shows as a shaded projection on the weight chart
```

---

# PHASE 9 — SOCIAL + SQUAD ACCOUNTABILITY

---

## §P9-A. Social Screen

**Route:** `/social`
**Scaffold:** Pattern A

The social system is NOT generic social media. It's purpose-built accountability.

```
Tabs: [My Squad] [Challenges] [Leaderboard]

My Squad Tab:
  Squad card (if member):
  ┌─────────────────────────────────────┐
  │ 💪 Office Warriors · 5 members      │
  │ Team streak: 8 days                 │
  │ ████████░░ 80% team goal today      │
  │                                     │
  │ Members:                            │
  │ [Arjun ✓] [Priya ✓] [Raj ✗] ...   │
  │                                     │
  │ [Send 🔥] [View Leaderboard]        │
  └─────────────────────────────────────┘

  If no squad: [Create Squad] or [Join via Code]

Challenges Tab:
  Active challenges (joined):
    "10K Steps India — Day 14 of 21"
    "Office Fat Loss Feb — 2nd place"
  
  Available challenges:
    "Navratri Fitness Challenge"
    "30-Day Protein Hit Challenge"
    "PCOS Warriors Monthly"

Leaderboard Tab:
  [Squad] [Friends] [City] tabs
  Ranked list: rank · avatar · name · karma score · trend
```

---

## §P9-B. Squad System *(NEW)*

**Squad size:** 3–8 members (intentionally small — accountability, not audience)

**Squad mechanics:**
- Shared weekly goal (e.g., "1,000 combined active minutes")
- Team streak (all members must log at least one activity daily)
- Collective XP pool → squad level
- Squad challenges (custom, e.g., "Most steps this week")
- Anonymous by default (share only karma score, not health data)

**Squad notifications:**
- "Raj just completed his workout 💪" (within squad)
- "Your team is 2 workouts away from the weekly goal!"
- "Send a 🔥 to motivate a teammate who hasn't logged today"

**Squad creation:**
```
Name: "Office Warriors"
Goal type: [Steps] [Workouts] [Calories] [Custom]
Weekly target: 50,000 steps
Invite: share code or QR → deep link
Privacy: [Friends only] [Invite only]
```

---

## §P9-C. Accountability Communities *(NEW)*

Pre-built communities for common Indian contexts:

| Community | Target |
|-----------|--------|
| 10K Steps India | Anyone wanting to walk more |
| Office Fat Loss | Desk workers |
| PCOS Warriors | Women with PCOS |
| Vegetarian Muscle Builders | Veg users building muscle |
| Diabetes Reversal Support | High glucose users |
| Wedding Transformation | Short-term goal users |
| Navratri Fitness | Seasonal community |
| Senior Strength India | Users 50+ |

Communities are activity feeds (posts, streaks, milestone celebrations) with no personal health data visible to others.

---

# PHASE 10 — PREDICTIVE HEALTH + PREVENTIVE INTELLIGENCE

---

## §P10-A. Health Risk Prevention System *(NEW)*

Already detailed in §P4-F. This phase implements the full risk model:

### Risk Patterns Tracked

| Risk | Input Signals | Alert Trigger |
|------|-------------|---------------|
| Hypertension | BP trend, weight, steps, stress | BP rising + steps declining for 7+ days |
| Type 2 Diabetes | Glucose, BMI, steps, carbs | Glucose trending up + BMI ≥ 27 |
| Heart disease | Resting HR trend, BP, stress, sleep | HR rising + BP elevated + poor sleep |
| Metabolic syndrome | Waist, BP, glucose, triglycerides proxy | 3+ risk factors present |
| Burnout / Overtraining | HRV, resting HR, sleep, workout load | HRV declining + HR elevated + performance dropping |
| Vitamin D deficiency | Sun exposure proxy (steps outdoors), fatigue | Low steps + high fatigue log |

### Biological Age Estimation *(NEW)*

```
Inputs: Resting HR, HRV, sleep quality, BMI, steps average, glucose
Algorithm: Multi-factor regression vs WHO population data
Output: "Your biological age is approximately 28 — 4 years younger than your calendar age!"
  or: "Your biological age is approximately 38 — let's work on that."

Shown on: Profile screen + Monthly Report
Updated: Monthly (not daily — prevents obsessive checking)
```

---

## §P10-B. Monthly Health Report *(NEW)*

**Route:** `/reports/monthly`
**Generated:** First of each month, stored as PDF

```
Cover: Month name + FitKarma logo + user name

Section 1 — Overview
  Karma earned this month
  Consistency score (%)
  Biological age estimate

Section 2 — Body
  Weight trend (chart)
  BMI change
  Body measurements delta (if logged)

Section 3 — Fitness
  Workouts completed vs planned
  Volume trend (total weight lifted)
  Cardio (steps, active minutes)
  VO2 max estimate (if wearable)

Section 4 — Nutrition
  Average daily calories vs target
  Protein hit rate (% of days target met)
  Best meal day / worst meal day
  Top 5 most logged foods

Section 5 — Recovery
  Average sleep duration
  HRV trend
  Recovery score average

Section 6 — Health Vitals
  BP trend (if logged)
  Glucose trend (if logged)
  Resting HR change

Section 7 — Risk Insights
  Any alerts from this month
  Positive trends noted

Section 8 — Next Month Focus
  Top 3 AI recommendations
  Program phase for next month
```

---

# PHASE 11 — VISUAL BODY ANALYTICS

---

## §P11-A. Body Analytics Screen *(NEW)*

**Route:** `/analytics/body`
**Scaffold:** Pattern A | **Biometric lock required**

Not just weight — a complete picture of physical transformation.

```
Header: "Progress Physics"
Subtitle: "Your body in numbers"

Metric Cards (bento grid):

Weight Journey:
  Line chart (90 days)
  Projection line (dashed, AI-estimated)
  "📉 Lost 2.4kg in 8 weeks"

Body Fat % (if tracked or estimated from weight + measurements):
  Gauge chart
  Change: -1.2% this month
  Target: 18% by [date]

Measurements (if logged):
  Waist: 88cm → 84cm (-4cm)
  Chest: [value]
  Arms: [value]
  Thighs: [value]
  Visual tape measure UI

Muscle Gain Proxy:
  Weight + body fat % → lean mass estimate
  "Estimated lean mass gained: +0.8kg this month"

AI Physique Prediction:
  ┌──────────────────────────────────┐
  │ At your current pace:            │
  │ • Reach 18% body fat: 14 weeks  │
  │ • Target weight (72kg): 6 weeks │
  │ • Program end: 9 weeks           │
  │                                  │
  │ Speed up by: hitting protein     │
  │ target 7/7 days this week       │
  └──────────────────────────────────┘

Posture & Face Changes (Phase 2 feature):
  User-initiated photo comparison (front/side view)
  Stored locally, encrypted, never auto-uploaded
```

---

## §P11-B. Progress Photo System *(NEW)*

**Access:** Body Analytics → [Add Progress Photo]
**Storage:** Local Drift DB reference → actual file in device gallery (encrypted copy)
**Cloud:** Opt-in only — never auto-uploaded

```
Photo capture screen:
  Guide overlay (body alignment grid)
  Front / Side / Back view selector
  Date auto-stamped

Comparison view:
  Side-by-side: [Start] vs [Now]
  Week-over-week slider
  Timeline strip (all photos, thumbnail row)

Privacy:
  Biometric lock on this section always
  Share button → creates cropped, no-face version (optional)
  "Delete all photos" option in Settings → Data
```

---

# PHASE 12 — FESTIVAL + CULTURAL INTELLIGENCE

---

## §P12-A. Festival Intelligence System *(NEW)*

Most fitness apps break down during Indian festivals. FitKarma embraces them.

### Festivals Tracked

| Festival | Dates | AI Adaptation |
|----------|-------|---------------|
| Navratri | Oct (9 days) | Fasting food mode, no grain logging |
| Diwali | Oct–Nov | Sweet calorie tracker, "Festival Survival" |
| Holi | Mar | Active celebration tracking, bhang awareness |
| Ramadan | Variable | Sehri/Iftar meal planning, adjusted timing |
| Eid | Post-Ramadan | Biryani + sweets budgeting |
| Ganesh Chaturthi | Sep | Modak macros, family meal tracking |
| Onam | Sep | Sadya thali macros |
| Christmas | Dec | Party season adaptation |
| Karva Chauth | Oct | Fasting + feasting cycle |
| Makar Sankranti | Jan | Til + jaggery nutritional benefits |

### Festival Survival Mode

Activated automatically 3 days before a detected festival:

```
Festival Banner (amber gradient, festive icons):
"🪔 Diwali in 3 days — Survival Mode Active"

AI adjusts:
  Daily calorie target: +200 kcal buffer
  Workout: "Burn first, celebrate later" — morning workout pushed
  Hydration: +0.5L (counteract sweets)
  Alcohol (if applicable): awareness logging
  Sleep: extra emphasis (parties disrupt sleep)

Festival Day dashboard card:
  "🎆 Happy Diwali, Arjun!"
  "You've banked 320 calories from this morning's workout.
   Enjoy 4–5 mithai without guilt. Hydrate between sweets."
  [Log Sweets] [Log Activity]

Post-Festival Recovery:
  3-day gentle plan
  "Your body may feel heavy from festive eating.
   Back to your program gently — no punishment workouts."
```

---

## §P12-B. Wedding Transformation Mode *(Existing + Enhanced)*

**Route:** `/programs/wedding`

Enhanced with:
- Countdown timer on Dashboard (days to wedding)
- Phase-based intensity (calm foundation → peak → taper week before)
- Bride/Groom specific nutrition (lehenga-ready vs sherwani-ready focus)
- Skin nutrition tracking (collagen foods, hydration)
- Stress management protocols (weddings are stressful)
- AI adjusts plan if wedding date changes

---

## §P12-C. AI Roast Mode *(Viral Feature — NEW)*

Optional. Toggle in Settings. For users who prefer tough love.

Examples:

> "You burned 400 calories and then attacked 900 calories of biryani. Respect the hustle. Your goals don't."

> "Third day of not logging meals. Either you're on a silent diet or you forgot FitKarma exists."

> "You slept 4 hours and skipped leg day. Your body is filing a complaint."

> "Your step count today: 847. Your sofa's step count: also 847. Coincidence?"

Roast mode:
- Opt-in only (never shown to new users)
- Tone selector: [Gentle] [Motivational] [Roast] [No Nonsense]
- AI adjusts all messages based on tone setting
- Crisis mode: roast auto-disabled if signs of distress detected

---

# PHASE 13 — PREMIUM + MONETISATION

---

## §P13-A. Subscription Architecture

**Platform:** RevenueCat (handles App Store + Play Store receipts)

### Plan Tiers

| Feature | Free | FitKarma Pro | Elite Coach |
|---------|------|-------------|-------------|
| Daily Readiness Score | Basic | Full | Full |
| AI Coach messages | 5/day | Unlimited | Unlimited |
| Meal photo analysis | 2/day | Unlimited | Unlimited |
| Adaptive plans | Static | AI-adaptive | Human + AI |
| Recovery analytics | Basic | Full | Full |
| Monthly reports | No | Yes | Yes |
| Squad creation | Join only | Create | Create |
| Festival modes | Yes | Yes | Yes |
| Advanced body analytics | No | Yes | Yes |
| Biological age | No | Yes | Yes |
| Priority AI | No | No | Yes |
| Human coach review | No | No | Weekly |

### Pricing (India-first)

```
FitKarma Pro:
  Monthly: ₹299/month
  Quarterly: ₹699/quarter (saves 22%)
  Annual: ₹1,999/year (saves 44%)
  
Elite Coach (waitlist):
  Monthly: ₹1,499/month
  
7-day free trial on all paid plans
```

### RevenueCat Setup

```dart
// lib/features/settings/subscription_screen.dart

await Purchases.configure(
  PurchasesConfiguration(
    Platform.isIOS
      ? 'appl_xxxxxxxxxxxx'
      : 'goog_xxxxxxxxxxxx',
  )
);

// Entitlement IDs
const proEntitlement = 'fitkarma_pro';
const eliteEntitlement = 'fitkarma_elite';
```

### Premium Paywall Triggers (UX)

Show paywall when free user:
- Tries to send 6th AI message in a day
- Tries to create a squad (can only join)
- Tries to view Monthly Report
- Tries meal photo analysis 3rd time
- Views body analytics → projection requires Pro

Paywall style: Bottom sheet (not full-screen takeover)
Always shows "Continue with Free" option — no dark patterns.

---

## §P13-B. Coach Mode *(Elite Feature — NEW)*

Human trainers can be verified on FitKarma and monitor their clients:

```
Trainer dashboard (web + mobile):
  Client list with today's readiness scores
  Client workout compliance rates
  Flag clients who are in relapse pattern
  Send custom AI-assisted messages
  Override AI program adjustments
  Generate client progress reports

Client gives coach access via:
  Settings → Coach Access → [Share Code]
  Access is read-only by default; write-access requires explicit unlock
  Can be revoked any time
```

---

# PHASE 14 — ENTERPRISE HARDENING + CI/CD

---

## §P14-A. Security

| Layer | Implementation |
|-------|---------------|
| Database encryption | SQLCipher AES-256 at page level |
| Key storage | Platform keychain (iOS Keychain / Android Keystore) |
| Biometric lock | `local_auth` — Journal, BP, Glucose, Lab Reports, Body Photos |
| Screen capture | `FLAG_SECURE` on sensitive screens |
| Network | TLS 1.3 + certificate pinning |
| AI context | User context never logged in Appwrite Function logs |
| PII | Sentry PII stripping enabled; no names/emails in error reports |

---

## §P14-B. Performance

| Target | Metric |
|--------|--------|
| Cold start | < 2 seconds on mid-tier device |
| Screen transition | < 300ms |
| AI response | < 3 seconds (Groq Llama-3 typical) |
| Drift query | < 50ms for day-range queries |
| Offline write | Immediate (optimistic UI) |
| Chart render | < 100ms (fl_chart with Drift data) |
| Image quality | Low tier: 75%, Mid: 85%, High: 100% |

---

## §P14-C. Testing Strategy

```
Unit Tests:
  BMI calculation, TDEE calculation, readiness score algorithm
  Progressive overload engine
  Consistency tracker, relapse detection
  Festival date detection
  Biological age estimation

Widget Tests:
  GlassCard, ReadinessRing, DailyBriefingCard
  All 5 onboarding screens

Integration Tests:
  Full onboarding flow (welcome → permissions)
  Offline → online sync round-trip
  AI coach message (mock Groq)
  Workout logging → XP award → level up
  Diet plan generation → cache → display

Golden Tests (screenshots):
  Dashboard, Daily Mission, Karma Hub, Food, Profile
  Light + dark mode for each
```

---

## §P14-D. CI/CD Pipeline

```yaml
# .github/workflows/main.yml

name: FitKarma CI/CD

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: flutter test

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: flutter build appbundle --release
        --dart-define=APPWRITE_ENDPOINT=${{ secrets.APPWRITE_ENDPOINT }}
        --dart-define=APPWRITE_PROJECT_ID=${{ secrets.APPWRITE_PROJECT_ID }}
        --dart-define=GROQ_FUNCTION_ID=${{ secrets.GROQ_FUNCTION_ID }}

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - run: flutter build ipa --release
```

---

# §DB. Database Schema

---

## Drift Local Schema (v5)

```dart
// lib/core/database/app_database.dart

// ── Users ──────────────────────────────────────────────────────────────────
class Users extends Table {
  TextColumn get localId => text()();             // UUID, primary key
  TextColumn get appwriteId => text().nullable()();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get gender => text()();             // male/female/other
  RealColumn get heightCm => real()();
  RealColumn get weightKg => real()();
  RealColumn get bmi => real()();
  TextColumn get activityLevel => text()();
  TextColumn get workStyle => text()();          // NEW
  TextColumn get goals => text()();              // JSON array
  TextColumn get dosha => text().nullable()();
  TextColumn get currentProgram => text().nullable()(); // NEW
  TextColumn get dietType => text()();           // veg/non-veg/vegan
  TextColumn get region => text().nullable()();  // for festival detection
  RealColumn get tdee => real()();
  IntColumn get dailyStepsTarget => integer()();
  IntColumn get dailyCalorieTarget => integer()();
  RealColumn get dailyWaterTargetL => real()();
  IntColumn get dailyProteinTargetG => integer()();
  TextColumn get tone => text().withDefault(const Constant('motivational'))(); // NEW (gentle/motivational/roast)
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── Recovery Logs (NEW) ─────────────────────────────────────────────────────
class RecoveryLogs extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  IntColumn get readinessScore => integer()();   // 0–100
  IntColumn get sleepQuality => integer()();     // 1–5
  IntColumn get sorenessLevel => integer()();    // 1–5
  IntColumn get stressLevel => integer()();      // 1–5
  IntColumn get energyLevel => integer()();      // 1–5
  RealColumn get restingHR => real().nullable()();
  RealColumn get hrv => real().nullable()();
  TextColumn get sorenessRegions => text()();    // JSON array
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── Body Measurements (NEW) ─────────────────────────────────────────────────
class BodyMeasurements extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get weightKg => real().nullable()();
  RealColumn get bodyFatPct => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get hipsCm => real().nullable()();
  RealColumn get leftArmCm => real().nullable()();
  RealColumn get rightArmCm => real().nullable()();
  RealColumn get leftThighCm => real().nullable()();
  RealColumn get rightThighCm => real().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── Squad Groups (NEW) ──────────────────────────────────────────────────────
class SquadGroups extends Table {
  TextColumn get localId => text()();
  TextColumn get name => text()();
  TextColumn get goalType => text()();           // steps/workouts/calories
  IntColumn get weeklyTarget => integer()();
  TextColumn get inviteCode => text()();
  TextColumn get creatorId => text()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── Transformation Checks (NEW) ─────────────────────────────────────────────
class TransformationChecks extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get checkDate => dateTime()();
  IntColumn get consistencyScore => integer()();   // 0–100
  IntColumn get relapseRisk => integer()();        // 0–100
  TextColumn get interventionType => text().nullable()(); // gentle/plan-switch/reframe
  TextColumn get interventionMessage => text().nullable()();
  BoolColumn get acknowledged => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}

// ── Diet Plans (existing, enhanced) ─────────────────────────────────────────
class DietPlans extends Table {
  TextColumn get localId => text()();
  TextColumn get userId => text()();
  RealColumn get bmiAtGeneration => real()();
  TextColumn get planJson => text()();            // Full 7-day plan
  DateTimeColumn get generatedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();   // +7 days
  BoolColumn get isActive => boolean()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {localId};
}
```

---

## §DB-B. Drift Migration Strategy

```dart
// Schema version: 5
// v1 → v2: added food_logs
// v2 → v3: added bp_readings, glucose_readings
// v3 → v4: added diet_plans, demographic fields on users
// v4 → v5: added recovery_logs, body_measurements, squad_groups,
//           transformation_checks, workStyle + currentProgram + tone on users

@DriftDatabase(tables: [
  Users, FoodLogs, WorkoutLogs, SleepLogs, BpReadings,
  GlucoseReadings, WaterLogs, HabitLogs, MoodLogs, MedicationLogs,
  KarmaEvents, AiInsights, DietPlans, RecoveryLogs, BodyMeasurements,
  SquadGroups, SquadMembers, TransformationChecks,
])
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 5) {
        await m.addColumn(users, users.workStyle);
        await m.addColumn(users, users.currentProgram);
        await m.addColumn(users, users.tone);
        await m.createTable(recoveryLogs);
        await m.createTable(bodyMeasurements);
        await m.createTable(squadGroups);
        await m.createTable(squadMembers);
        await m.createTable(transformationChecks);
      }
    },
  );
}
```

---

# §AW. Appwrite CLI — All Functions

---

## Appwrite Functions (5 total)

```
fitkarma-cores         → Main function: diet plan generation, readiness AI
fitkarma-coach         → AI Coach (context-aware chat responses)
fitkarma-meal-vision   → Meal photo analysis (Groq Vision)
fitkarma-insights      → Daily proactive insight generation (scheduled)
fitkarma-reports       → Monthly report generation (scheduled, 1st of month)
```

### fitkarma-cores Actions

```javascript
// Handles multiple actions via req.body.action

switch(action) {
  case 'generate_diet_plan':    // Called during onboarding
  case 'generate_program':      // Called when program selected
  case 'calculate_readiness':   // Called after morning check-in
  case 'check_progression':     // Called after workout completion
  case 'check_relapse_risk':    // Called daily by scheduler
  case 'biological_age':        // Called monthly
}
```

---

# §GLO. Glossary & Architecture Decision Records

---

## Glossary

| Term | Definition |
|------|-----------|
| **Readiness Score** | 0–100 daily score based on sleep, HRV, resting HR, soreness, stress, hydration |
| **Fatigue Index** | 7-day rolling load-to-recovery ratio. > 1.0 = overtraining risk |
| **Training Readiness** | Derived from Readiness Score — recommends workout intensity |
| **Relapse Detection** | Behavioral pattern analysis to detect users about to quit |
| **Festival Mode** | AI adaptation of plans to accommodate Indian festival eating/activity patterns |
| **Blueprint** | AI-generated personalized program (e.g., "Corporate Fat Loss") |
| **Recovery Score** | How well the body recovered from yesterday's activity |
| **Biological Age** | Estimated metabolic age based on HRV, HR, sleep, BMI, steps |
| **DLQ** | Dead Letter Queue — records that failed to sync 3+ times |
| **Optimistic UI** | UI updates immediately from Drift write; sync happens in background |
| **Calm Zone** | Screens with sensitive content — zero glow, blur, animations |
| **syncStatus** | `pending` → `synced` → `dlq` |
| **UX Stage** | `firstWeek / familiar / expert` — controls onboarding density |
| **Beginner Mode** | Shows only: steps, calories, water, today's mission. Advanced metrics unlocked later |
| **Thali Intelligence** | AI understanding of Indian thali as a composite meal unit |
| **Fix My Meal** | AI meal photo analysis feature — estimates macros + suggests improvements |
| **Squad** | Small accountability group (3–8 users) with shared goals and team streaks |
| **Tone Setting** | User preference: Gentle / Motivational / Roast — affects all AI messages |
| **Single Hero Rule** | Exactly one `metricXL` or `heroDisplay` per visible scroll area |
| **Rule of Two** | No surface may have more than 2 simultaneous visual effects |
| **Soft Delete** | `isDeleted = true` instead of hard DELETE |
| **Device Tier** | Low/Mid/High based on device RAM — gates visual effects for 60fps |
| **Bento Grid** | 2-column asymmetric card grid |
| **Pattern A/B/C** | Three scaffold archetypes (scroll / hero+body / full-bleed) |

---

## Architecture Decision Records

| ADR | Decision | Rationale |
|-----|---------|-----------|
| ADR-001 | **Drift over Hive** | SQL joins needed for date-range queries and relational health logs |
| ADR-002 | **Riverpod over Bloc** | Simpler async composition, better AsyncValue, codegen reduces boilerplate |
| ADR-003 | **Appwrite over Firebase** | Self-hostable (India data residency), no per-read billing, CLI-first |
| ADR-004 | **SQLCipher for encryption** | AES-256 at SQLite page level; raw .db unreadable without keychain key |
| ADR-005 | **Soft Delete** | Health data is irreplaceable; undo and conflict recovery require soft delete |
| ADR-006 | **Pure Dart Animations** | Consistent with token system, zero-latency, no third-party versioning risk |
| ADR-007 | **`--dart-define` for secrets** | No secrets in source; separate build targets per environment |
| ADR-008 | **Sentry over Crashlytics** | Self-hostable, no Google telemetry, avoids GCP lock-in; PII stripping enforced |
| ADR-009 | **lastWriteWins + manualReview** | Clinical records must never auto-overwrite; food/habits use lastWriteWins |
| ADR-010 | **Open Food Facts + Custom Indian DB** | OFF: 3M+ global items. Custom Appwrite: 50k+ Indian items with Hindi names |
| ADR-011 | **LLM via Appwrite Function** | Keeps Groq API key server-side; enables rate limiting, logging, model swapping |
| ADR-012 | **RevenueCat for subscriptions** | Handles App Store + Play Store receipts + entitlements in one SDK |
| ADR-013 | **Mandatory demographics** | BMI-derived targets critical for safe calorie and workout goals; no Skip |
| ADR-014 | **Groq JSON mode for diet generation** | `response_format: json_object` guarantees parseable output; fallback: ErrorRetryWidget |
| ADR-015 | **Diet plan generated before Dosha Quiz** | Physical data already collected; results ready with no perceived wait |
| ADR-016 | **7-day diet cache with BMI staleness check** | Groq calls are expensive; cache avoids redundant generation |
| ADR-017 | **Mifflin-St Jeor for TDEE** | Most validated formula for general population; Harris-Benedict overestimates ~5% |
| ADR-018 | **Readiness Score as daily entry point** | Addictive morning ritual; personalizes every other feature for that day (NEW) |
| ADR-019 | **Relapse detection via behavioral signals** | App opens, logging frequency, and meal quality together predict quit risk (NEW) |
| ADR-020 | **Weather API for hydration/workout adaptation** | India's extreme temperatures (38°C+ summers) make weather a critical health variable (NEW) |
| ADR-021 | **Festival calendar hardcoded + user region** | Indian festivals are predictable; region customizes which festivals appear (NEW) |
| ADR-022 | **Squad max size: 8 members** | > 8 reduces accountability; social loafing increases. 3–8 keeps it personal (NEW) |
| ADR-023 | **Biological age shown monthly, not daily** | Daily biological age creates anxiety; monthly view encourages patience (NEW) |
| ADR-024 | **Tone selector (Gentle/Motivational/Roast)** | Users respond differently to coaching styles; choice increases long-term retention (NEW) |
| ADR-025 | **AI physique predictions shown as range, not exact** | Exact predictions create unrealistic expectations; ranges encourage consistency (NEW) |

---

# Master Launch Checklist

---

## Phase 0 — Foundation (Complete Before Any Features)

- [ ] Flutter project created with `--dart-define` multi-env setup
- [ ] All design tokens in `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`
- [ ] GlassCard tier-aware (blur on Mid/High, solid on Low)
- [ ] All shared components built: GlowingMetric, ActivityRings, QuickLogFab, InsightCard, ShimmerLoader, ErrorRetryWidget
- [ ] New components built: ReadinessRing, DailyBriefingCard, RecoveryBadge
- [ ] Drift schema v5 initialized with all tables
- [ ] SQLCipher encryption configured, key in keychain
- [ ] Sync worker running (priority queue, 3-retry DLQ)
- [ ] Appwrite project created in Mumbai region
- [ ] GoRouter with all routes defined

## Phase 1 — Onboarding (P0 — Required Before Ship)

- [ ] All 7 onboarding screens functional end-to-end on fresh install
- [ ] Demographics screen: no Skip button, BMI card appears live
- [ ] Adaptive targets calculated correctly for all 4 BMI categories
- [ ] Groq diet plan generated with real Indian meal names (zero placeholders)
- [ ] Diet plan cached to Drift with 7-day expiry and BMI delta invalidation
- [ ] Dosha quiz: all 10 questions, result stored to Drift + Appwrite
- [ ] Program Blueprint selection with AI-generated program assignment
- [ ] Permissions screen: HealthKit (iOS) + Health Connect (Android) tested

## Phase 2 — Daily Mission + Readiness (P0)

- [ ] Morning check-in: 3-question ritual (sleep, soreness, stress)
- [ ] Readiness score calculated correctly for all input combinations
- [ ] Daily Briefing Screen: shows readiness ring + mission + AI insight + weather
- [ ] Weather API integrated and hydration target adjusting dynamically
- [ ] Recovery log screen functional
- [ ] Fatigue Index calculated over 7-day rolling window

## Phase 3 — AI Coach (P0)

- [ ] `fitkarma-coach` Appwrite Function deployed with Groq API key
- [ ] AI context builder assembles all 20+ user context fields
- [ ] AI responses always reference user-specific data (tested with varied profiles)
- [ ] Proactive insights generated daily by `fitkarma-insights` scheduler
- [ ] Relapse detection running via `fitkarma-cores`

## Phase 4 — Health Tracking (P0)

- [ ] Dashboard: Activity rings, bento grid, AI insight, streak+karma bento
- [ ] Readiness banner on dashboard (Phase 2 integration)
- [ ] Steps: auto-detection from HealthKit/Health Connect
- [ ] Sleep: duration + quality logging + debt calculation
- [ ] BP + Glucose: biometric-locked, 30-day chart, risk alerts
- [ ] Preventive intelligence engine: hypertension + diabetes patterns

## Phase 5 — Nutrition (P0)

- [ ] Indian food database seeded (5,000+ items at launch)
- [ ] Open Food Facts barcode scan tested on physical device
- [ ] Meal quality scoring (5 dimensions) shown per meal
- [ ] "Fix My Meal" photo analysis (Groq Vision) functional
- [ ] Thali composite entry support
- [ ] Protein alert shown when < 70% of target

## Phase 6 — Workout (P1)

- [ ] Program blueprint generator producing full 12-week plans
- [ ] Progressive overload engine detecting progression triggers
- [ ] Deload week detection and suggestion
- [ ] Active workout screen with rest timer and set logging
- [ ] Workout completion XP award + level-up animation

## Phase 7 — Gamification (P0)

- [ ] All XP events fire correctly
- [ ] Level-up animation plays on every level change
- [ ] Streak flame animation
- [ ] Karma Hub with achievements grid
- [ ] Habit automation: smart triggers (not fixed-time reminders)

## Phase 8 — Transformation (P1)

- [ ] Consistency tracker running daily
- [ ] Relapse intervention messages (3 tiers)
- [ ] Transformation Timeline with per-week cards
- [ ] AI Physique Prediction shown as range on weight chart
- [ ] Progress photo system (encrypted local storage, biometric lock)

## Phase 9 — Social (P1)

- [ ] Squad creation + invite code system
- [ ] Squad leaderboard and team streak
- [ ] Squad challenge system
- [ ] Accountability communities (read-only feed)
- [ ] Relapse detection integrates squad nudge

## Phase 10 — Predictive Health (P1)

- [ ] All 6 risk patterns implemented in PreventiveIntelligenceEngine
- [ ] Biological age estimation (monthly calculation)
- [ ] Monthly report generation (`fitkarma-reports` function)

## Phase 11 — Visual Analytics (P1)

- [ ] Body measurements logging screen
- [ ] All 5 measurement types charted with trend
- [ ] Lean mass estimation from weight + body fat
- [ ] AI physique projection on charts

## Phase 12 — Festival Intelligence (P1)

- [ ] Festival calendar for all 10+ Indian festivals
- [ ] Festival Survival Mode activates 3 days before
- [ ] Navratri fasting food filter
- [ ] Ramadan Sehri/Iftar mode
- [ ] Post-festival recovery plan

## Phase 13 — Premium (P0 for launch)

- [ ] RevenueCat configured with App Store + Play Store product IDs
- [ ] 7-day free trial tested end-to-end
- [ ] Paywall triggers implemented (AI message limit, squad creation, reports)
- [ ] Paywall bottom sheet (no full-screen takeover, always shows "Continue Free")
- [ ] Entitlement checks in all Pro/Elite features

## Phase 14 — Hardening (P0)

- [ ] Biometric lock tested on physical device
- [ ] Offline → online sync round-trip in Airplane mode
- [ ] DLQ alert banner appears after 3 sync failures
- [ ] GlassCard blur disabled on DeviceTier.low
- [ ] All `--dart-define` vars set for dev/staging/prod
- [ ] Sentry error dashboard with PII stripping verified
- [ ] Golden tests generated and passing for all primary screens
- [ ] DPDP Act compliance: Privacy Policy written and linked
- [ ] Performance: cold start < 2s on mid-tier device

---

## Post-Launch (Within 30 Days)

- [ ] Indian food database expanded to 10,000+ items
- [ ] AI Coach rate limiting tuned from real usage data
- [ ] HealthKit background delivery tested for overnight sleep
- [ ] Push notification open rates measured; meal reminder A/B tested
- [ ] Subscription conversion funnel analyzed (trial → paid)
- [ ] Home widget (iOS + Android): today's steps + karma score
- [ ] Wedding mode end-to-end tested with synthetic data
- [ ] AI Roast Mode (Tone selector) implemented and tested

---

*FitKarma — Complete Master Documentation v1*
*India's Intelligent Health Operating System*
*Flutter 3.x · Riverpod 2.x · Drift v5 · Appwrite CLI · RevenueCat · Groq Llama-3 · Open Food Facts*
*Offline-first · AES-256 encrypted · Privacy-centric · AI-adaptive · Built for India*
*14 development phases · 19 Appwrite collections · 5 Appwrite Functions · 30+ screens · Complete AI decision engine*