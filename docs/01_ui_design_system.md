# Part I — UI Design System

## 1. Design Philosophy

### Six Pillars

| Pillar               | Expression                                                                                |
| -------------------- | ----------------------------------------------------------------------------------------- |
| **Spatial Depth**    | Three-layer system: background → mid-layer → foreground. Real blur, shadow, translucency. |
| **Fluid Motion**     | Spring physics everywhere. No linear tweens. 100ms touch-to-response.                     |
| **Bold Information** | One dominant metric per screen at 56–72sp. Context recedes, data leads.                   |
| **Visual Restraint** | Glow reserved for active metric, primary CTA, and ring fill only. Not every card glows.   |
| **Dark-First**       | Dark mode is the primary target. Light mode is a warm inversion, not an afterthought.     |
| **Cultural Pulse**   | Orange-indigo-saffron palette. Bilingual labels used strategically, not everywhere.       |

### ❌ Anti-Patterns — Never Do These

```text
❌ Plain white cards with grey text on white backgrounds
❌ Skeleton screens on core data — use Drift optimistic UI
❌ Hardcoded hex values outside the token file
❌ Modals/dialogs when a bottom sheet suffices
❌ Glow on every card
❌ Two competing hero elements on the same screen
❌ Bilingual labels on every element
❌ Blur + glow + gradient + animation on the same card (max 2 effects per surface)
```

> **Rule of two:** Each surface can have at most two visual effects. Valid combos: `blur + border`, `glow + gradient`. Not `blur + glow + gradient + animation`.

---

## 2. Project Structure

```text
lib/
├── core/
│   ├── config/
│   │   ├── device_tier.dart
│   │   ├── user_experience_stage.dart
│   │   └── app_config.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_theme.dart
│   │   ├── app_spacing.dart
│   │   ├── app_gradients.dart
│   │   └── app_springs.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── transitions.dart
│   ├── database/
│   │   └── app_database.dart
│   ├── sync/
│   │   ├── sync_worker.dart
│   │   ├── dlq_provider.dart
│   │   └── connectivity_service.dart
│   ├── security/
│   │   ├── biometric_lock.dart
│   │   └── sensitive_screen_guard.dart
│   └── providers/
│       ├── device_tier_provider.dart
│       ├── ux_stage_provider.dart
│       ├── core_providers.dart
│       └── low_data_mode_provider.dart
├── shared/
│   └── widgets/
│       ├── bento_card.dart
│       ├── activity_rings.dart
│       ├── glowing_metric.dart
│       ├── insight_card.dart
│       ├── quick_log_fab.dart
│       ├── bilingual_label.dart
│       ├── encryption_badge.dart
│       ├── shimmer_loader.dart
│       ├── trend_chip.dart
│       ├── pulse_ring.dart
│       ├── streak_flame.dart
│       ├── bottom_nav_bar.dart
│       ├── empty_state.dart
│       ├── animation_widgets.dart
│       ├── level_up_animation.dart
│       ├── breathing_circle.dart
│       ├── sync_status_banner.dart
│       └── logo_reveal.dart
├── features/
│   ├── onboarding/
│   ├── dashboard/
│   ├── food/
│   │   ├── data/
│   │   │   ├── food_database_service.dart   ← NEW §F1
│   │   │   ├── open_food_facts_client.dart  ← NEW §F1
│   │   │   └── indian_food_repository.dart  ← NEW §F1
│   │   └── ...
│   ├── workout/
│   ├── steps/
│   ├── health/
│   ├── karma/
│   ├── social/
│   ├── reports/
│   ├── festival/
│   ├── wedding/
│   ├── ai_coach/                            ← NEW §F2
│   │   ├── ai_coach_screen.dart
│   │   └── ai_coach_provider.dart
│   └── settings/
│       └── subscription_screen.dart         ← NEW §F4
└── main.dart

assets/
├── fonts/
│   ├── PlusJakartaSans[wght].ttf
│   ├── JetBrainsMono[wght].ttf
│   └── OpenDyslexic-Regular.ttf
├── data/
│   └── indian_foods_seed.json               ← NEW §F1
└── logo.png

functions/
├── xp-calculator/src/main.js
├── report-share/src/main.js
├── ai-coach/src/main.js                     ← NEW §F2
└── food-search/src/main.js                  ← NEW §F1
```

---

## 3. Design Tokens — Flutter ThemeData

> **Rule:** Never hardcode hex values in widget files. All colors must come from `AppColorsDark` / `AppColorsLight`.

### 3.1 Color Tokens

```dart
// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColorsDark {
  AppColorsDark._();

  static const bg0         = Color(0xFF080810);
  static const bg1         = Color(0xFF0F0F1A);
  static const bg2         = Color(0xFF161625);
  static const surface0    = Color(0xFF1C1C2E);
  static const surface1    = Color(0xFF22223A);
  static const surface2    = Color(0xFF2A2A45);

  static const glass       = Color(0x0FFFFFFF);
  static const glassBorder = Color(0x1AFFFFFF);

  static const primary        = Color(0xFFFF6B35);
  static const primaryGlow    = Color(0x40FF6B35);
  static const primaryMuted   = Color(0x30FF6B35);

  static const accent         = Color(0xFFFFB547);
  static const accentGlow     = Color(0x33FFB547);

  static const secondary      = Color(0xFF7B6FF0);
  static const secondaryGlow  = Color(0x407B6FF0);

  static const teal           = Color(0xFF00D4B4);
  static const tealGlow       = Color(0x3300D4B4);
  static const success        = Color(0xFF4ADE80);
  static const successGlow    = Color(0x334ADE80);
  static const warning        = Color(0xFFFBBF24);
  static const error          = Color(0xFFF87171);
  static const rose           = Color(0xFFFB7185);
  static const purple         = Color(0xFFC084FC);

  static const textPrimary    = Color(0xFFF1F0FF);
  static const textSecondary  = Color(0xFF9B99CC);
  static const textMuted      = Color(0xFF6B68A0);
  static const divider        = Color(0x14FFFFFF);
}

class AppColorsLight {
  AppColorsLight._();

  static const bg0            = Color(0xFFF7F0E8);
  static const bg1            = Color(0xFFFDF6EC);
  static const bg2            = Color(0xFFFFF9F2);
  static const surface0       = Color(0xFFFFFFFF);
  static const surface1       = Color(0xFFFFFAF5);
  static const surface2       = Color(0xFFFFF3EF);
  static const glass          = Color(0xB3FFFAF5);
  static const glassBorder    = Color(0x26FF6B35);

  static const primary        = Color(0xFFF4511E);
  static const primaryMuted   = Color(0xFFFEE8E2);
  static const accent         = Color(0xFFF59E0B);
  static const secondary      = Color(0xFF5B50D4);
  static const teal           = Color(0xFF0D9488);
  static const success        = Color(0xFF22C55E);

  static const textPrimary    = Color(0xFF1A1830);
  static const textSecondary  = Color(0xFF6B6A96);
  static const textMuted      = Color(0xFFB0AEC8);
  static const divider        = Color(0x121A1830);
}
```

#### Color Semantic Quick-Reference

| Color            | Token       | Use Case                                  |
| ---------------- | ----------- | ----------------------------------------- |
| Orange `#FF6B35` | `primary`   | CTA buttons, active nav, hero metric glow |
| Amber `#FFB547`  | `accent`    | XP coins, streaks, insight highlights     |
| Indigo `#7B6FF0` | `secondary` | Level badges, sleep screen                |
| Teal `#00D4B4`   | `teal`      | Water, SpO2, medication, Ayurveda         |
| Green `#4ADE80`  | `success`   | Steps goal, healthy readings, habits done |
| Amber `#FBBF24`  | `warning`   | Elevated readings, moderate risk          |
| Red `#F87171`    | `error`     | Crisis readings, destructive actions      |
| Rose `#FB7185`   | `rose`      | Period tracker                            |
| Purple `#C084FC` | `purple`    | Active minutes ring                       |

### 3.2 Spacing & Radius Tokens

```dart
class AppSpacing {
  AppSpacing._();
  static const double screenH      = 20.0;
  static const double cardH        = 16.0;
  static const double fabClearance = 120.0;
  static const double bentoGap     = 12.0;
}

class AppRadius {
  AppRadius._();
  static const double sm   = 10.0;
  static const double md   = 16.0;
  static const double lg   = 20.0;
  static const double xl   = 28.0;
  static const double full = 9999.0;
  static const double bentoInner = 14.0;
  static const double bentoOuter = 20.0;
  static const double bentoHero  = 28.0;
}
```

### 3.3 ThemeData Builder

```dart
// lib/core/theme/app_theme.dart
class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    const c = AppColorsDark;
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: c.bg1,
      colorScheme: const ColorScheme.dark(
        primary: c.primary, secondary: c.secondary, surface: c.surface0,
        error: c.error, onPrimary: Colors.white, onSecondary: Colors.white,
        onSurface: c.textPrimary, onError: Colors.white,
      ),
      textTheme: AppTypography.darkTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, elevation: 0,
        scrolledUnderElevation: 0, centerTitle: true,
        iconTheme: IconThemeData(color: c.textSecondary),
        titleTextStyle: TextStyle(
          color: c.textPrimary, fontSize: 24, fontWeight: FontWeight.w600,
          fontFamily: 'PlusJakartaSans', letterSpacing: -0.3,
        ),
      ),
      dividerTheme: const DividerThemeData(color: c.divider, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: c.surface1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
        elevation: 8,
      ),
    );
  }
}
```

### 3.4 Hero Gradients

```dart
class AppGradients {
  AppGradients._();
  static const heroDeep = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF0A0818), Color(0xFF1E1850)],
  );
  static const heroSleep = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFF04020F), Color(0xFF0D0B2E), Color(0xFF1C1A48)],
  );
  static const heroFestival = LinearGradient(
    begin: Alignment(-.5, -1), end: Alignment(.5, 1),
    colors: [Color(0xFF1A0A00), Color(0xFF3D1500)],
  );
  static const heroWedding = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF1A0008), Color(0xFF3D0015)],
  );
}
```

---

## 4. Typography System

### 4.1 Font Stack

| Font                   | Role                                   | Weights            |
| ---------------------- | -------------------------------------- | ------------------ |
| **PlusJakartaSans**    | Body, headings, labels                 | 400–700 (variable) |
| **JetBrainsMono**      | Numeric stats, counters, live readings | 400–700 (variable) |
| **OpenDyslexic**       | Accessibility option                   | Regular            |
| **NotoSansDevanagari** | Hindi labels (system font)             | —                  |

### 4.2 TextStyle Definitions

```dart
class AppTypography {
  AppTypography._();
  static const _body = 'PlusJakartaSans';
  static const _mono = 'JetBrainsMono';

  static TextStyle heroDisplay({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _body, fontSize: 72, fontWeight: FontWeight.w800,
                letterSpacing: -2.0, height: 1.0, color: color);
  static TextStyle metricXL({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _body, fontSize: 56, fontWeight: FontWeight.w700,
                letterSpacing: -1.5, height: 1.1, color: color);
  static TextStyle metricLg({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _body, fontSize: 40, fontWeight: FontWeight.w700,
                letterSpacing: -1.0, height: 1.1, color: color);
  static TextStyle displayLg({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _body, fontSize: 32, fontWeight: FontWeight.w700,
                letterSpacing: -0.8, color: color);
  static TextStyle h1({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _body, fontSize: 24, fontWeight: FontWeight.w600,
                letterSpacing: -0.3, color: color);
  static TextStyle h2({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _body, fontSize: 20, fontWeight: FontWeight.w600,
                letterSpacing: -0.2, color: color);
  static TextStyle h3({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _body, fontSize: 17, fontWeight: FontWeight.w600,
                letterSpacing: -0.1, color: color);
  static TextStyle h4({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _body, fontSize: 15, fontWeight: FontWeight.w600, color: color);
  static TextStyle labelLg({Color color = AppColorsDark.textSecondary}) =>
      TextStyle(fontFamily: _body, fontSize: 13, fontWeight: FontWeight.w600,
                letterSpacing: 0.1, color: color);
  static TextStyle labelMd({Color color = AppColorsDark.textSecondary}) =>
      TextStyle(fontFamily: _body, fontSize: 11, fontWeight: FontWeight.w500,
                letterSpacing: 0.2, color: color);
  static TextStyle bodyLg({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _body, fontSize: 16, fontWeight: FontWeight.w400, color: color);
  static TextStyle bodyMd({Color color = AppColorsDark.textSecondary}) =>
      TextStyle(fontFamily: _body, fontSize: 14, fontWeight: FontWeight.w400, color: color);
  static TextStyle bodySm({Color color = AppColorsDark.textMuted}) =>
      TextStyle(fontFamily: _body, fontSize: 12, fontWeight: FontWeight.w400,
                letterSpacing: 0.1, color: color);
  static TextStyle monoXL({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _mono, fontSize: 48, fontWeight: FontWeight.w700,
                letterSpacing: -1.0, color: color);
  static TextStyle monoLg({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(fontFamily: _mono, fontSize: 28, fontWeight: FontWeight.w600,
                letterSpacing: -0.5, color: color);
  static TextStyle caption({Color color = AppColorsDark.textMuted}) =>
      TextStyle(fontFamily: _body, fontSize: 11, fontWeight: FontWeight.w400,
                letterSpacing: 0.3, color: color);
  static TextStyle hindi({Color color = AppColorsDark.textSecondary}) =>
      TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 12,
                fontWeight: FontWeight.w500, color: color);
}
```

---

## 5. Motion & Animation

> All animations are pure Dart — `AnimationController`, `CustomPainter`, `AnimatedBuilder`, `TweenSequence`. Zero external animation libraries.

### 5.1 Spring Presets

```dart
class AppSprings {
  AppSprings._();
  static const light    = SpringDescription(mass: 1.0, stiffness: 400, damping: 28.28);
  static const standard = SpringDescription(mass: 1.0, stiffness: 250, damping: 22.36);
  static const dramatic = SpringDescription(mass: 1.0, stiffness: 180, damping: 18.97);
}
```

### 5.2 Animation Duration Guidelines

| Interaction              | Duration           | Curve           |
| ------------------------ | ------------------ | --------------- |
| Micro (toggle, checkbox) | 80–120ms           | `easeInOut`     |
| Card tap feedback        | 80ms               | `easeInOut`     |
| Screen push              | 320ms / 280ms back | `easeOutCubic`  |
| Hero metric reveal       | Spring `dramatic`  | —               |
| Bottom sheet             | 350ms              | `easeOutCubic`  |
| Level-up burst           | 600ms              | `TweenSequence` |

---

## 6. Surface & Depth System

### Three-Layer Depth Model

```text
PLANE 3 — Foreground
  FAB · Bottom sheets · Tooltips · Modals

PLANE 2 — Mid-layer
  Cards · Charts · Insight panels · Bento cells

PLANE 1 — Background
  Scaffold · Hero gradients · Ambient glow blobs
```

### GlassCard Widget (Tier-Aware)

```dart
class GlassCard extends ConsumerWidget {
  final Widget child;
  final Color? glowColor;
  final double? customRadius;
  final EdgeInsetsGeometry? padding;

  const GlassCard({super.key, required this.child,
    this.glowColor, this.customRadius, this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier = ref.watch(deviceTierProvider).valueOrNull ?? DeviceTier.mid;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = customRadius ?? AppRadius.md;

    if (tier == DeviceTier.low) {
      return Container(
        padding: padding ?? const EdgeInsets.all(AppSpacing.cardH),
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.surface1 : AppColorsLight.surface1,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder),
          boxShadow: glowColor != null
              ? [BoxShadow(color: glowColor!.withOpacity(0.25), blurRadius: 20)]
              : null,
        ),
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardH),
          decoration: BoxDecoration(
            color: isDark ? AppColorsDark.glass : AppColorsLight.glass,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder),
            boxShadow: glowColor != null
                ? [BoxShadow(color: glowColor!.withOpacity(0.25), blurRadius: 24)]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
```

---

## 7. Device Tier System

> Gates expensive visual effects based on RAM to maintain 60fps on ₹7,000–₹10,000 devices.

| Feature           | Low (< 2 GB)      | Mid (2–4 GB) | High (> 4 GB) |
| ----------------- | ----------------- | ------------ | ------------- |
| Backdrop blur     | ❌ solid surface1 | ✅ blur(12)  | ✅ blur(16)   |
| Ambient glow      | ❌                | ✅ Reduced   | ✅ Full       |
| Spring physics    | ❌ easeOutCubic   | ✅ standard  | ✅ dramatic   |
| Native animations | ❌ Static         | ✅           | ✅            |
| Sync interval     | Every 6h          | Every 30min  | Every 15min   |

---

## 8. Universal Screen Rules

- `horizontalPadding: 20px` on all scroll content
- `bottomPadding: 120px` to clear the Quick Log FAB
- `SafeArea` wraps all content
- Exactly one `heroDisplay` or `metricXL` per visible scroll area
- Write to Drift first, update UI immediately (optimistic)
- Use `ShimmerLoader` for first-load; never skeleton text

---

## 9. Scaffold Patterns

### Pattern A — Standard Scroll

Dashboard, Food, Steps, Karma, Reports, Settings.

```dart
Scaffold(
  backgroundColor: AppColorsDark.bg1,
  appBar: AppBar(/* transparent, no elevation */),
  body: Stack(children: [
    const AmbientBlobs(),
    SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.fabClearance),
        child: Column(children: [...]),
      ),
    ),
  ]),
  floatingActionButton: const QuickLogFab(),
)
```

### Pattern B — Hero + Overlapping Body

Profile, Blood Pressure, Glucose, Sleep, Workout Detail.

```dart
Scaffold(
  extendBodyBehindAppBar: true,
  body: Stack(children: [
    Container(height: 320, decoration: BoxDecoration(gradient: AppGradients.heroDeep)),
    // Body panel overlaps hero by 28px
    Positioned(
      top: 292, left: 0, right: 0, bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColorsDark.bg1,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(/* content */),
      ),
    ),
  ]),
)
```

### Pattern C — Full Bleed

Active Workout, Fasting Timer, Sleep Active, Breathing Exercise.

```dart
Scaffold(
  backgroundColor: AppColorsDark.bg0,
  extendBodyBehindAppBar: true,
  body: Stack(children: [
    Container(decoration: BoxDecoration(gradient: AppGradients.heroDeep)),
    SafeArea(child: /* hero content fills viewport */),
  ]),
)
```

### Calm Zone

Settings, Journal, Emergency Card, Lab Reports. **NO blobs, glow, blur, or spring animations on ANY device tier.**

---

## 10. Shared Component Library

| Widget             | File                      | Notes                        |
| ------------------ | ------------------------- | ---------------------------- |
| `GlassCard`        | `bento_card.dart`         | Tier-aware blur              |
| `ActivityRings`    | `activity_rings.dart`     | CustomPainter, 3 rings       |
| `GlowingMetric`    | `glowing_metric.dart`     | Hero element                 |
| `InsightCard`      | `insight_card.dart`       | 👍👎 feedback                |
| `QuickLogFab`      | `quick_log_fab.dart`      | Bottom-right FAB, persistent |
| `BilingualLabel`   | `bilingual_label.dart`    | Strategic use only           |
| `EncryptionBadge`  | `encryption_badge.dart`   | Teal lock + "AES-256"        |
| `ShimmerLoader`    | `shimmer_loader.dart`     | First-load placeholder       |
| `TrendChip`        | `trend_chip.dart`         | ↑↓ color-coded               |
| `PulseRing`        | `pulse_ring.dart`         | Animated glow ring           |
| `StreakFlame`      | `streak_flame.dart`       | Animated flame, amber        |
| `BottomNavBar`     | `bottom_nav_bar.dart`     | 5 tabs, glass bg             |
| `EmptyState`       | `empty_state.dart`        | Animated icon                |
| `ErrorRetryWidget` | `animation_widgets.dart`  | Animated error               |
| `LevelUpAnimation` | `level_up_animation.dart` | Burst overlay                |
| `BreathingCircle`  | `breathing_circle.dart`   | Inhale/hold/exhale           |
| `LogoReveal`       | `logo_reveal.dart`        | Splash screen                |
| `DLQAlertBanner`   | `sync_status_banner.dart` | Sync failure warning         |

---

## 11. Screen Specifications

### 11.1 Dashboard Screen

**Route:** `/home/dashboard` · **Scaffold:** Pattern A

```text
AppBar: Avatar (→ /profile) · "Good morning, {Name}" h1 · Notification bell

Scroll content:
1. Activity Rings card (GlassCard, xl radius, primaryGlow border)
   ActivityRings: Steps / Calories / Active Minutes
   Center: metricLg steps · Below: monoLg "1,234 / 8,000 steps"

2. Bento grid (2 col, 12px gap):
   Calories card (half) → /food
   Water card (half)    → /water
   Streak card (full)   → StreakFlame
   Karma XP card (full) → /karma

3. Today's Meals — horizontal scroll

4. AI Insight card (if ≥7 days data) — InsightCard with 👍👎
   [NEW: if aiInsights flag ON → AI-powered insight via §F2]

5. Quick Stats bento: Last BP · Last Glucose · Sleep

6. Challenges / Active Program card

FAB: QuickLogFab (persistent)
```

### 11.2 Food Home Screen

**Route:** `/home/food` · **Scaffold:** Pattern A

```text
AppBar: "Food" · Search icon (→ food search [§F1])

Macro Ring card: Donut Protein/Carbs/Fat · Center: remaining kcal metricLg

Meal sections (4): Breakfast · Lunch · Dinner · Snacks
  Each: meal name h3 + kcal labelLg + [+ Add] → food search sheet [§F1]
  Food rows: emoji/photo · name bodyMd · kcal · portion

Daily Totals: Calories · Protein · Carbs · Fat · Fiber · Water (monoLg)
```

### 11.3 Blood Pressure Screen

**Route:** `/blood-pressure` · **Scaffold:** Pattern B (`heroDeep`)

```text
Hero (320px):
  GlowingMetric: "{systolic}/{diastolic}" metricXL, primaryGlow
  Pulse: monoLg "{pulse} bpm"
  Classification chip: "Normal ✓" success color

Body:
  Last 7 readings chart (fl_chart LineChart)
  Reading history list
  [Log Reading] primary button
  EncryptionBadge
```

**BP Classification Table:**

| Range            | Classification      | Color           |
| ---------------- | ------------------- | --------------- |
| < 120/80         | Normal              | `success`       |
| 120–129 / < 80   | Elevated            | `warning`       |
| 130–139 / 80–89  | Stage 1             | `warning`       |
| 140–179 / 90–119 | Stage 2             | `error`         |
| ≥ 180 / ≥ 120    | Hypertensive Crisis | `error` + alert |

### 11.4 Steps Screen

**Route:** `/home/steps` · **Scaffold:** Pattern C

```text
heroDeep gradient full-bleed
heroDisplay: "{step_count}" 72sp, white, glow
monoLg: "{distance_km} km · {calories} kcal"
Progress arc: CustomPaint semicircle 0→goal, orange fill
Hourly chart: fl_chart BarChart last 12h
```

### 11.5 Sleep Screen

**Route:** `/sleep` · **Scaffold:** Pattern B (`heroSleep`)

```text
Hero: metricXL "7h 24m" · monoLg "Sleep Score: 82"
Body: Sleep stages chart · Bedtime/Wake · SpO2 avg · 7-day trend
```

---

## 12. Bottom Navigation Bar

5 tabs: Home · Food · Workout · Steps · Karma. Glass background (tier-aware). Active tab gets primary glow dot.

```dart
static const _tabs = [
  _NavTab(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
  _NavTab(icon: Icons.restaurant_menu_outlined, activeIcon: Icons.restaurant_menu, label: 'Food'),
  _NavTab(icon: Icons.fitness_center_outlined, activeIcon: Icons.fitness_center, label: 'Workout'),
  _NavTab(icon: Icons.directions_walk_outlined, activeIcon: Icons.directions_walk, label: 'Steps'),
  _NavTab(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome_rounded, label: 'Karma'),
];
```

---

## 13. Common UI Patterns

### 13.1 Quick Log Bottom Sheet

Triggered by FAB. 3×2 grid: [🍽 Food] [💧 Water] [🏋️ Workout] [💊 Medication] [😊 Mood] [❤️ BP]

### 13.2 Bento Grid Layout

```dart
GridView(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: AppSpacing.bentoGap,
    mainAxisSpacing: AppSpacing.bentoGap,
    childAspectRatio: 1.1,
  ),
  children: [/* cells */],
)
```

---

## 14. Accessibility & Bilingual Rules

- Minimum tap target: 44×44px
- Body text must use `textPrimary` (≥7:1) or `textSecondary` (≥5:1)
- `Semantics` wrapper on all `CustomPaint` widgets
- `BilingualLabel` only on: category headers, empty state messages, crisis helplines, festival headers
- Hindi always uses `AppTypography.hindi()` — never PlusJakartaSans for Devanagari

---

## 15. Additional Screen Specifications

### 15.1 Karma Hub Screen

**Route:** `/karma` · **Scaffold:** Pattern B (`heroDeep`)

```text
Hero: displayLg XP total · Level badge "⚡ Level 8 Warrior" · XP progress bar
Body: Today's karma events · XP breakdown bento · Achievements grid · Leaderboard tab · Challenges
```

### 15.2 Journal Screen — Calm Zone

**Route:** `/journal` · Biometric re-auth on first enter per session.

### 15.3 Emergency Card Screen — Calm Zone

**Route:** `/emergency` · Contacts: 108 Ambulance · AIIMS · User-configured × 2

### 15.4 Workout Active Screen

**Route:** `/workout/active/{workoutId}` · **Scaffold:** Pattern C

### 15.5 Mental Health Hub

**Route:** `/mental-health` · CBT Insight · Breathing (4-7-8, Box, 2-1-4-1) · Burnout gauge
Indian crisis helplines always visible: iCall 9152987821 · Vandrevala 1860-2662-345 · NIMHANS 080-46110007

### 15.6 Profile Screen

**Route:** `/profile` · **Scaffold:** Pattern B (`heroDeep`)
Hero: CircleAvatar + name + email · Body: KarmaLevel compact · DoshaDonut · Personal info rows · Achievements · Referral card

---

## 16. Low Data Mode — Implementation

When enabled: network images → emoji placeholders · sync interval → 6h · blur disabled · background sync paused.

```dart
Widget foodPhoto(String? url, String emoji, bool lowData) {
  if (lowData || url == null) {
    return Container(
      width: 60, height: 60, color: AppColorsDark.surface0,
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
    );
  }
  return CachedNetworkImage(imageUrl: url, width: 60, height: 60, fit: BoxFit.cover);
}
```

---

## 17. Dosha Quiz Implementation

10-question quiz covering: body frame, skin, energy, sleep, digestion, memory, speech, emotional nature, temperature preference, appetite.

```dart
DoshaResult computeDosha(List<String> selectedDoshas) {
  final counts = {'vata': 0, 'pitta': 0, 'kapha': 0};
  for (final d in selectedDoshas) counts[d] = (counts[d] ?? 0) + 1;
  final total = selectedDoshas.length;
  return DoshaResult(
    vata:     (counts['vata']!  / total * 100).round(),
    pitta:    (counts['pitta']! / total * 100).round(),
    kapha:    (counts['kapha']! / total * 100).round(),
    dominant: counts.entries.reduce((a, b) => a.value > b.value ? a : b).key,
  );
}
```

---

## §17A. Health Goals Setup Screen _(Onboarding Step 2)_

**Route:** `/onboarding/goals` · **Scaffold:** Pattern C · **Gradient:** `AppGradients.heroDeep`

```text
Header: 🎯 icon (64px) · h1 "What's your goal?" · bodyMd description

Goal selector — 2×3 bento grid (multi-select, max 3):
  🏃 Lose Weight | 💪 Build Muscle
  ❤️ Heart Health | 🩸 Manage BP / Glucose
  🧘 Reduce Stress | ⚡ More Energy

  Selected: primaryGlow border + primaryMuted fill + orange ✓ top-right
  Spring bounce on tap (scale 0.96→1.0)

  4th goal tap → micro-shake + SnackBar "Max 3 goals — deselect one first"

Conditional metric slider (AnimatedSize, 300ms spring):
  Lose Weight  → calorie target 1200–2800 kcal, step 50
                 Presets: [Light -500] [Moderate -250] [Maintain]
  Build Muscle → protein target 80–220g, step 5g
                 Hint: "~{weight_kg × 1.6}g recommended"
  Heart/BP/Glucose → steps goal 4,000–15,000, step 500
                 Presets: [Easy 5k] [Active 8k] [Athletic 12k]
  Stress/Energy → sleep target 6–9h, step 30min
                 Hint: "Adults need 7–8h"

[Continue →] disabled (opacity 0.4) until ≥1 goal selected
[Skip] text button top-right (screens 2–4 only)
```

```dart
@freezed
class GoalsState with _$GoalsState {
  const factory GoalsState({
    @Default({}) Set<FitnessGoal> selectedGoals,
    @Default(1800) int dailyCalorieTarget,
    @Default(120)  int dailyProteinG,
    @Default(8000) int dailyStepsGoal,
    @Default(8.0)  double sleepTargetHours,
  }) = _GoalsState;
}
```

---

## §17B. Permissions & Privacy Screen _(Onboarding Step 5)_

**Route:** `/onboarding/permissions` · **Scaffold:** Calm Zone (bg2 solid, zero decoration)

```text
Header: 🔒 icon (48px, teal) · h1 "Your data, your rules"
  bodyMd: "FitKarma works fully offline. Permissions below make it smarter..."

Permission cards (surface0, AppRadius.md, 1px divider border):
  🏃 Health Connect      [ON ] Auto-sync steps & heart rate
  🔔 Notifications       [ON ] Meal reminders, streak alerts
  📷 Camera              [OFF] Scan food barcodes
  🧬 Biometric Lock      [ON ] Fingerprint / face unlock

  Default: Health Connect OFF, Notifications ON, Camera OFF, Biometric ON
  Biometric row hidden if no hardware detected

Privacy commitment card (surface1, teal 3px left border — NOT a glow):
  · Encrypted on your device with AES-256
  · Never sold to advertisers — ever
  · Delete your account and all data anytime
  EncryptionBadge at bottom

[Get Started →] non-skippable
  While requesting: CircularProgressIndicator replaces label text
  OS denial → silent, feature unavailable, no blocking error

  On success:
    1. Request OS permissions for toggled-ON items
    2. Persist choices to Drift users table (syncStatus = 'pending')
    3. Set UXStage = firstWeek
    4. GoRouter.go('/home/dashboard')  — replaceAll clears onboarding stack
```

---

## 18. Complete `pubspec.yaml`

```yaml
name: fitkarma
description: Offline-first health tracking for India
version: 1.0.0+1
publish_to: "none"

environment:
  sdk: ">=3.4.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # State & Navigation
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.7

  # Local Database
  drift: ^2.19.1
  sqlite3_flutter_libs: ^0.5.24
  path_provider: ^2.1.3
  path: ^1.9.0

  # Encryption
  flutter_secure_storage: ^9.0.0
  sqflite_cipher: ^3.0.1+2

  # Backend
  appwrite: ^13.0.0

  # Network
  dio: ^5.6.0
  connectivity_plus: ^6.0.3
  cached_network_image: ^3.3.1

  # Animations
  shimmer: ^3.0.0

  # Charts
  fl_chart: ^0.68.0

  # Health
  health: ^10.2.0
  local_auth: ^2.3.0

  # Media
  image_picker: ^1.1.2
  file_picker: ^8.0.7

  # Device
  device_info_plus: ^10.1.2

  # Maps (GPS workouts)
  flutter_map: ^7.0.2
  latlong2: ^0.9.1

  # Rich Text (Journal)
  flutter_quill: ^10.6.0

  # Notifications
  flutter_local_notifications: ^17.2.2
  workmanager: ^0.5.2

  # Home Widgets
  home_widget: ^0.5.0

  # Food database [§F1 NEW]
  http: ^1.2.1

  # Utilities
  intl: ^0.19.0
  uuid: ^4.4.2
  equatable: ^2.0.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  collection: ^1.18.0

  # Purchases [§F4 NEW]
  purchases_flutter: ^7.0.0 # RevenueCat

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.3
  drift_dev: ^2.19.1
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  mocktail: ^1.0.4
  fake_async: ^1.3.1
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  fonts:
    - family: PlusJakartaSans
      fonts:
        - asset: assets/fonts/PlusJakartaSans[wght].ttf
    - family: JetBrainsMono
      fonts:
        - asset: assets/fonts/JetBrainsMono[wght].ttf
    - family: OpenDyslexic
      fonts:
        - asset: assets/fonts/OpenDyslexic-Regular.ttf
  assets:
    - assets/logo.png
    - assets/data/indian_foods_seed.json # [§F1 NEW]
```

---

## 19. Code Generation Commands

```bash
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs
```

---

## 20. Design System Quick Reference Card

```text
COLORS (Dark Mode):
bg1       #0F0F1A  → Primary scaffold
surface0  #1C1C2E  → Base card
primary   #FF6B35  → Orange CTA, active nav, hero glow
teal      #00D4B4  → Water, SpO2, Ayurveda, medication
success   #4ADE80  → Steps complete, healthy readings
warning   #FBBF24  → Elevated readings
error     #F87171  → Crisis readings, destructive

TYPOGRAPHY:
heroDisplay  72sp  → One per screen (step count or fasting timer)
metricXL     56sp  → BP, Glucose, Sleep readings
metricLg     40sp  → Dashboard rings center only
monoXL       48sp  → Live HR, CGM glucose (real-time only)
h1           24sp  → AppBar titles

SCAFFOLD PATTERNS:
Pattern A — bg1 + transparent AppBar + AmbientBlobs
Pattern B — heroGradient(320px) + panel overlapping 28px
Pattern C — bg0 + full-screen Stack
Calm Zone — bg2 solid + NO blobs/glow/blur (all tiers)

EFFECT RULES:
✅ Glow ON:  Hero metric · Primary CTA · Active ring · Active nav
❌ Glow OFF: Secondary cards · Headers · All Calm Zone screens
Max 2 effects per card: blur+border OR glow+gradient
```
