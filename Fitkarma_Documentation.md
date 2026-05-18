# FitKarma — Complete Enhanced Documentation
### UI Design System · Screen-by-Screen UI/UX Guide · Technical Implementation
**Flutter 3.x · Riverpod 2.x · Drift · Appwrite CLI · RevenueCat · Groq Llama-3**

> **Offline-First · Privacy-Centric · Built for India**
> Dark mode primary · Glassmorphism · Spring physics · Bento grid
> All backend via **Appwrite CLI** — no console needed.

---

## Quick Navigation

| Need | Go to |
|------|--------|
| Start a new project | §22 Prerequisites → §23 Project Setup → §24 Appwrite CLI |
| Understand architecture | §21 Architecture Overview |
| **Build a specific screen (UI/UX)** | **§11 Screen Specifications (Deep)** |
| Add a shared component | §10 Component Library |
| Design tokens / colors | §3 Design Tokens |
| Add Appwrite collection | §24 CLI Setup → §25 Schema |
| Implement sync | §27 Offline-First → §28 Sync Engine |
| Food database integration | §F1 Indian Food Database |
| AI coach | §F2 AI Insight Engine |
| iOS HealthKit | §F3 iOS HealthKit |
| Monetisation | §F4 Subscription Model |
| Deploy / CI | §35 CI/CD |
| Glossary & decisions | §45 Glossary & ADRs |

---

## Table of Contents

### Part I — UI Design System
1. Design Philosophy
2. Project Structure
3. Design Tokens — Flutter ThemeData
4. Typography System
5. Motion & Animation
6. Surface & Depth System
7. Device Tier System
8. Universal Screen Rules
9. Scaffold Patterns
10. Shared Component Library
11. Screen Specifications — Deep UI/UX (ALL SCREENS)
12. Bottom Navigation Bar
13. Common UI Patterns
14. Accessibility & Bilingual Rules
15. Additional Screen Specifications
16. Low Data Mode
17. Dosha Quiz Implementation
18. Onboarding: Health Goals Setup
19. Onboarding: Permissions & Privacy
20. Complete pubspec.yaml
21. Code Generation Commands
22. Design System Quick Reference

### Part II — Technical Implementation
23–47. (Architecture, Appwrite, Drift, Riverpod, Sync, Auth, CI/CD, etc.)

### Part III — Enterprise Hardening
48–64. (Clean Architecture, Security, Testing, Observability, etc.)

### Part IV — Critical Fixes
65. §F1 Indian Food Database Integration
66. §F2 AI Insight Engine & LLM Coach
67. §F3 iOS HealthKit — Full Implementation
68. §F4 Subscription Model & Monetisation

---

# PART I — UI DESIGN SYSTEM

---

## 1. Design Philosophy

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
```

> **Rule of Two:** Each surface can have at most two visual effects simultaneously.
> Valid combos: `blur + border`, `glow + gradient`, `gradient + shadow`.
> Invalid: `blur + glow + gradient + animation`.

---

## 2. Project Structure

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
│       ├── streak_flame.dart           # Lottie/custom animated flame, amber
│       ├── bottom_nav_bar.dart         # 5-tab glass nav bar
│       ├── empty_state.dart            # Animated icon + message + CTA
│       ├── animation_widgets.dart      # ErrorRetryWidget, etc.
│       ├── level_up_animation.dart     # Full-screen XP burst overlay
│       ├── breathing_circle.dart       # Inhale/hold/exhale custom painter
│       ├── sync_status_banner.dart     # DLQAlertBanner
│       └── logo_reveal.dart            # Splash screen logo animation
├── features/
│   ├── onboarding/
│   ├── dashboard/
│   ├── food/
│   │   ├── data/
│   │   │   ├── food_database_service.dart
│   │   │   ├── open_food_facts_client.dart
│   │   │   └── indian_food_repository.dart
│   │   └── presentation/
│   ├── workout/
│   ├── steps/
│   ├── health/
│   ├── karma/
│   ├── social/
│   ├── reports/
│   ├── festival/
│   ├── wedding/
│   ├── ai_coach/
│   │   ├── ai_coach_screen.dart
│   │   └── ai_coach_provider.dart
│   └── settings/
│       └── subscription_screen.dart
└── main.dart
```

---

## 3. Design Tokens — Flutter ThemeData

> **Rule:** Never hardcode hex values in widget files. All colors must come from `AppColorsDark` / `AppColorsLight`.

### 3.1 Color Tokens

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
  static const primaryGlow    = Color(0x40FF6B35); // 25% opacity glow
  static const primaryMuted   = Color(0x30FF6B35); // 19% opacity fill for selections

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
  static const success        = Color(0xFF4ADE80); // Steps goal, healthy readings
  static const successGlow    = Color(0x334ADE80);
  static const warning        = Color(0xFFFBBF24); // Elevated readings, caution
  static const error          = Color(0xFFF87171); // Crisis readings, destructive
  static const rose           = Color(0xFFFB7185); // Period tracker
  static const purple         = Color(0xFFC084FC); // Active minutes ring

  // Text
  static const textPrimary    = Color(0xFFF1F0FF); // Primary content ≥7:1
  static const textSecondary  = Color(0xFF9B99CC); // Supporting content ≥5:1
  static const textMuted      = Color(0xFF6B68A0); // Hints, disabled states
  static const divider        = Color(0x14FFFFFF); // 8% white dividers
}

class AppColorsLight {
  AppColorsLight._();

  // Warm parchment backgrounds
  static const bg0            = Color(0xFFF7F0E8);
  static const bg1            = Color(0xFFFDF6EC); // Default scaffold
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

| Color | Token | Use Case |
|-------|-------|----------|
| Orange `#FF6B35` | `primary` | CTA buttons, active nav tab, hero metric glow |
| Amber `#FFB547` | `accent` | XP coins, streak flames, achievement highlights |
| Indigo `#7B6FF0` | `secondary` | Level badges, sleep screen gradient, meditation |
| Teal `#00D4B4` | `teal` | Water tracker, SpO2, medication, Ayurveda |
| Green `#4ADE80` | `success` | Steps goal achieved, healthy readings, habits done |
| Amber `#FBBF24` | `warning` | Elevated BP/glucose, moderate risk states |
| Red `#F87171` | `error` | Crisis readings, destructive actions, data errors |
| Rose `#FB7185` | `rose` | Period tracker, menstrual health |
| Purple `#C084FC` | `purple` | Active minutes ring, move goal |

### 3.2 Spacing & Radius Tokens

```dart
class AppSpacing {
  AppSpacing._();
  static const double screenH      = 20.0;  // Horizontal page padding
  static const double cardH        = 16.0;  // Card internal padding
  static const double fabClearance = 120.0; // Bottom scroll clearance for FAB
  static const double bentoGap     = 12.0;  // Gap between bento grid cells
}

class AppRadius {
  AppRadius._();
  static const double sm         = 10.0;  // Tags, chips
  static const double md         = 16.0;  // Standard cards
  static const double lg         = 20.0;  // Bottom sheets, large cards
  static const double xl         = 28.0;  // Hero cards, body panel
  static const double full       = 9999.0; // Pills, avatars
  static const double bentoInner = 14.0;  // Bento cell inner radius
  static const double bentoOuter = 20.0;  // Bento grid outer radius
  static const double bentoHero  = 28.0;  // Hero bento cell
}
```

### 3.3 ThemeData Builder

```dart
class AppTheme {
  AppTheme._();

  static ThemeData dark({String? overrideFont}) {
    const c = AppColorsDark;
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: c.bg1,
      colorScheme: const ColorScheme.dark(
        primary: c.primary,
        secondary: c.secondary,
        surface: c.surface0,
        error: c.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: c.textPrimary,
        onError: Colors.white,
      ),
      textTheme: AppTypography.darkTextTheme(overrideFont: overrideFont),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: c.textSecondary),
        titleTextStyle: TextStyle(
          color: c.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'PlusJakartaSans',
          letterSpacing: -0.3,
        ),
      ),
      dividerTheme: const DividerThemeData(color: c.divider, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: c.surface1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: c.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: c.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: c.textMuted),
      ),
    );
  }
}
```

### 3.4 Hero Gradients

```dart
class AppGradients {
  AppGradients._();

  // Dashboard, Karma, Profile, Workout detail hero panel
  static const heroDeep = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1040), Color(0xFF0F0F1A)],
  );

  // Sleep screen
  static const heroSleep = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A0F2E), Color(0xFF0F0F1A)],
  );

  // Steps / Active Workout (fire/energy feel)
  static const heroFire = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D0F00), Color(0xFF1A0800)],
  );

  // Ayurveda / Dosha
  static const heroAyurveda = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF003322), Color(0xFF001A11)],
  );

  // Festival banner
  static const heroFestival = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D1A00), Color(0xFF1A0F00)],
  );

  // Ring fill gradient (for ActivityRings sweep)
  static const ringPrimary = SweepGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFFB547)],
  );
}
```

---

## 4. Typography System

```dart
class AppTypography {
  AppTypography._();

  // Display scale (PlusJakartaSans Variable)
  static const heroDisplay  = TextStyle(fontSize: 72, fontWeight: FontWeight.w800, letterSpacing: -2.0, height: 0.95);
  static const metricXL     = TextStyle(fontSize: 56, fontWeight: FontWeight.w700, letterSpacing: -1.5, height: 1.0);
  static const metricLg     = TextStyle(fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -1.0, height: 1.1);
  static const displayLg    = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.8, height: 1.15);
  static const displayMd    = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.4, height: 1.2);

  // Heading scale
  static const h1           = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3, height: 1.25);
  static const h2           = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.3);
  static const h3           = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.1, height: 1.35);

  // Body scale
  static const bodyLg       = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.0, height: 1.5);
  static const bodyMd       = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1, height: 1.5);
  static const bodySm       = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.1, height: 1.5);

  // Label scale
  static const labelLg      = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.2, height: 1.4);
  static const labelMd      = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, height: 1.4);
  static const labelSm      = TextStyle(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.4, height: 1.4);

  // Mono scale (JetBrainsMono — metrics, counts, readings)
  static const monoXL       = TextStyle(fontFamily: 'JetBrainsMono', fontSize: 48, fontWeight: FontWeight.w700);
  static const monoLg       = TextStyle(fontFamily: 'JetBrainsMono', fontSize: 28, fontWeight: FontWeight.w600);
  static const monoMd       = TextStyle(fontFamily: 'JetBrainsMono', fontSize: 18, fontWeight: FontWeight.w500);
  static const monoSm       = TextStyle(fontFamily: 'JetBrainsMono', fontSize: 13, fontWeight: FontWeight.w400);

  // Devanagari (Noto Sans Devanagari — NEVER use PlusJakartaSans for Hindi)
  static TextStyle hindi({double size = 14, FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: size, fontWeight: weight, height: 1.6);
}
```

### Typography Usage Rules

| Context | Style to Use |
|---------|-------------|
| Hero step count, primary metric | `heroDisplay` or `metricXL` |
| BP reading, glucose value | `metricXL` with `JetBrainsMono` |
| Section heading | `h2` or `h3` |
| Card label above metric | `labelMd` in `textSecondary` |
| Meal calories in Food | `monoMd` |
| Time values, readings history | `monoSm` |
| Hindi category headers | `AppTypography.hindi(size: 13)` |
| Button text | `h3` weight 600 |

---

## 5. Motion & Animation

### Spring Presets

```dart
class AppSprings {
  AppSprings._();

  // Standard interactive response (tap, toggle)
  static const standard = SpringDescription(mass: 1.0, stiffness: 300.0, damping: 28.0);

  // Dramatic entrance (cards sliding in, overlays appearing)
  static const dramatic = SpringDescription(mass: 1.0, stiffness: 200.0, damping: 20.0);

  // Gentle (bottom sheets, toasts)
  static const gentle   = SpringDescription(mass: 1.0, stiffness: 150.0, damping: 22.0);

  // Bounce (FAB expand, achievement pop)
  static const bouncy   = SpringDescription(mass: 1.0, stiffness: 400.0, damping: 18.0);
}
```

### Animation Rules

| Rule | Detail |
|------|--------|
| **Touch to response** | ≤ 100ms. Opacity or scale feedback must start within 100ms of touch. |
| **No linear curves** | `Curves.linear` is banned. Use `Curves.easeOutCubic` as minimum, spring physics preferred. |
| **Entrance duration** | 250–400ms for screen transitions. 150–250ms for micro-interactions. |
| **Exit duration** | 200ms max. Exits are faster than entrances — don't make users wait. |
| **Stagger offset** | 60ms between list items. Never stagger more than 6 items. |
| **Device tier gates** | `DeviceTier.low` → replace spring with `easeOutCubic`. No backdrop blur animations. |
| **Reduced motion** | Respect `MediaQuery.disableAnimations`. All animations must have a static fallback. |
| **LevelUp burst** | Full-screen overlay. Duration 1.2s. Always show on karma level up. |

### Standard Page Transitions

```dart
// Horizontal slide (forward navigation)
SharedAxisTransition(
  transitionType: SharedAxisTransitionType.horizontal,
  animation: animation,
  secondaryAnimation: secondaryAnimation,
  child: child,
)

// Vertical slide (bottom sheets, modals)
// Use built-in showModalBottomSheet — spring curve built in.

// Fade-through (tab switching)
FadeThroughTransition(animation: animation, child: child)
```

---

## 6. Surface & Depth System

Three depth layers define every screen:

| Layer | Purpose | Visual Treatment |
|-------|---------|-----------------|
| **Background** (`bg0`/`bg1`) | Screen canvas, ambient blobs | No effects, pure deep color |
| **Mid-layer** (`surface0`/`surface1`) | Cards, sections | Optional blur (tier-aware), glassBorder |
| **Foreground** (`surface2`, overlays) | Active elements, FAB, nav bar | Strong blur, glow if active |

### GlassCard Widget

```dart
class GlassCard extends ConsumerWidget {
  final Widget child;
  final double radius;
  final EdgeInsets? padding;
  final Color? glowColor;         // Only provide for HERO card — Rule of Two
  final bool forceNoBlur;         // Calm Zone enforcement

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier    = ref.watch(deviceTierProvider);
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final useBlur = !forceNoBlur && tier != DeviceTier.low;
    final sigma   = tier == DeviceTier.high ? 16.0 : 12.0;

    if (!useBlur) {
      // Low-tier: solid surface without blur
      return Container(
        padding: padding ?? const EdgeInsets.all(AppSpacing.cardH),
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.surface1 : AppColorsLight.surface0,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder,
          ),
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
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardH),
          decoration: BoxDecoration(
            color: isDark ? AppColorsDark.glass : AppColorsLight.glass,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder,
            ),
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

### Ambient Background Blobs

```dart
class AmbientBlobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tier = context.watch<DeviceTier>();
    if (tier == DeviceTier.low) return const SizedBox.shrink();

    return Stack(children: [
      // Top-left orange blob
      Positioned(
        top: -80, left: -60,
        child: Container(
          width: 280, height: 280,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x18FF6B35), // 10% primary
          ),
        ),
      ),
      // Bottom-right indigo blob
      Positioned(
        bottom: -100, right: -80,
        child: Container(
          width: 320, height: 320,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x107B6FF0), // 6% secondary
          ),
        ),
      ),
    ]);
  }
}
```

---

## 7. Device Tier System

> Gates expensive visual effects based on RAM to maintain 60fps on ₹7,000–₹10,000 Android devices prevalent in India.

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
| Backdrop blur | ❌ solid `surface1` | ✅ `blur(12)` | ✅ `blur(16)` |
| Ambient glow | ❌ | ✅ Reduced (opacity 0.15) | ✅ Full (opacity 0.25) |
| Spring physics | ❌ `easeOutCubic` | ✅ Standard spring | ✅ Dramatic spring |
| Lottie animations | ❌ Static icon | ✅ | ✅ |
| Ambient blobs | ❌ | ✅ | ✅ |
| Sync interval | Every 6h | Every 30min | Every 15min |
| Image quality | Low (75%) | Medium (85%) | Full (100%) |

---

## 8. Universal Screen Rules

| Rule | Spec |
|------|------|
| Horizontal padding | 20px on ALL scroll content |
| Bottom padding | 120px to clear the Quick Log FAB |
| Safe area | `SafeArea` wraps ALL content on all screens |
| Hero rule | Exactly ONE `heroDisplay` or `metricXL` per visible scroll area |
| Write order | Write to Drift → update UI immediately → sync in background |
| First-load | `ShimmerLoader` for initial data fetch. Never skeleton text |
| Empty state | `EmptyState` widget with animated icon + bilingual message + CTA |
| Error state | `ErrorRetryWidget` with retry button — never just a red snackbar |
| Deletion UX | Soft delete + SnackBar with [Undo] visible for 4 seconds |
| Loading CTAs | Replace button text with `CircularProgressIndicator` (20px) during async |

---

## 9. Scaffold Patterns

### Pattern A — Standard Scroll
**Used by:** Dashboard, Food Home, Steps, Karma, Reports, Settings, Social, Water, Habits

```dart
Scaffold(
  backgroundColor: AppColorsDark.bg1,
  appBar: AppBar(/* transparent, no elevation, center title */),
  body: Stack(children: [
    const AmbientBlobs(), // Mid/High tier only
    SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH, 0,
          AppSpacing.screenH, AppSpacing.fabClearance,
        ),
        child: Column(children: [ /* content */ ]),
      ),
    ),
  ]),
  floatingActionButton: const QuickLogFab(),
  bottomNavigationBar: const FitKarmaBottomNavBar(),
)
```

### Pattern B — Hero + Overlapping Body
**Used by:** Profile, Blood Pressure, Glucose, Sleep, Workout Detail, Karma Hub, Festival Detail

```dart
Scaffold(
  extendBodyBehindAppBar: true,
  body: Stack(children: [
    // Full-bleed gradient hero (320px tall)
    Container(
      height: 320,
      decoration: const BoxDecoration(gradient: AppGradients.heroDeep),
    ),
    // Body panel slides up and overlaps the hero by 28px
    Positioned(
      top: 292, left: 0, right: 0, bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColorsDark.bg1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          child: Column(children: [ /* content */ ]),
        ),
      ),
    ),
    // AppBar overlaid on top
    Positioned(
      top: 0, left: 0, right: 0,
      child: AppBar(/* transparent */),
    ),
  ]),
  floatingActionButton: const QuickLogFab(),
)
```

### Pattern C — Full Bleed
**Used by:** Active Workout, Steps (active), Fasting Timer, Sleep Active Session, Breathing Exercise

```dart
Scaffold(
  backgroundColor: AppColorsDark.bg0,
  extendBodyBehindAppBar: true,
  body: Stack(children: [
    Container(
      decoration: const BoxDecoration(gradient: AppGradients.heroDeep),
    ),
    SafeArea(
      child: /* hero content fills viewport — no scroll */,
    ),
  ]),
  // NO bottom nav bar on full-bleed screens
)
```

### Calm Zone
**Used by:** Settings, Journal, Emergency Card, Lab Reports, Biometric-gated screens

Rules: **Zero blobs, zero glow, zero blur, zero spring animations on ANY device tier.** Uses `bg2` as background. Static `easeOutCubic` only. No `AmbientBlobs`.

---

## 10. Shared Component Library

### GlowingMetric

```dart
class GlowingMetric extends StatelessWidget {
  final String value;
  final String? unit;
  final String? label;
  final Color glowColor;

  // Usage: One per screen max. The single most important number.
  // Always use heroDisplay or metricXL from AppTypography.
}
```

### ActivityRings

Three concentric CustomPainter rings. Stroke width 10px each, gap 6px.

| Ring | Data | Color |
|------|------|-------|
| Outer | Steps / Move goal | `primary` (orange) |
| Middle | Calories burned | `accent` (amber) |
| Inner | Active minutes | `purple` |

Each ring has a subtle gradient fill (0° → 90° sweep). Ring cap is rounded. Background track is `surface2` at 40% opacity.

### QuickLogFab

Persistent FAB in bottom-right. 56px diameter. `primary` color with `primaryGlow` shadow.
On tap: spring scale 0.90 → 1.05 → 1.00 (150ms). Expands to bottom sheet with 3×2 grid.

```dart
// FAB grid options:
// Row 1: [🍽 Food] [💧 Water] [🏋️ Workout]
// Row 2: [💊 Medication] [😊 Mood] [❤️ BP]
```

### TrendChip

```dart
// Usage: Show delta from previous period
// ↑ 12% → success color
// ↓ 8% → error color
// → 0% → textMuted color
TrendChip(delta: 12, isPositiveGood: true) // green ↑
TrendChip(delta: -5, isPositiveGood: false) // green ↓ (e.g., calories down is good)
```

### InsightCard

```dart
// Orange-bordered glass card with 👍 / 👎 feedback
// Used on Dashboard for AI/rule-based insights
// Shows only if ≥ 7 days of data exists
// Feedback stored locally to avoid repetition
InsightCard(
  icon: '🔥',
  title: 'Streak insight',
  body: 'Your steps are 23% higher on days you log breakfast.',
  onFeedback: (positive) => ref.read(insightFeedbackProvider.notifier).record(id, positive),
)
```

---

## 11. Screen Specifications — Deep UI/UX

---

### 11.1 Splash Screen

**Route:** `/` (auto-redirects)
**Scaffold:** Full-bleed, `bg0` black
**Duration:** 2.0s total

#### Layout
```
Full-screen centered:

  [FitKarma Logo — animated reveal]
  72px × 72px logo mark
  Spring scale: 0 → 1.1 → 1.0 (400ms, bouncy spring)
  Fade in: 0 → 1 (300ms, easeOutCubic)

  Below logo, 12px gap:
  "FitKarma"
  AppTypography.displayLg, textPrimary
  Fade in delayed 200ms

  Below wordmark, 4px gap:
  "फिटकर्मा"
  AppTypography.hindi(size: 14), textSecondary
  Fade in delayed 350ms

  Bottom-center:
  "Built for India 🇮🇳"
  AppTypography.labelMd, textMuted
  Fade in at 500ms

  Progress indicator:
  LinearProgressIndicator (width 80px, height 2px)
  primary color, rounded ends
  Appears after 300ms, completes in 1.5s
```

#### Behavior
On appear: check auth state and onboarding completion.
- Auth = null + onboarding incomplete → `/onboarding/welcome`
- Auth = null + onboarding complete → `/auth/login`
- Auth = valid → `/home/dashboard`
Minimum 2.0s shown even if auth resolves faster (brand beat).

---

### 11.2 Onboarding — Welcome Screen

**Route:** `/onboarding/welcome`
**Scaffold:** Pattern C (full-bleed `heroDeep`)
**Step indicator:** None on first screen

#### Layout
```
Full-screen gradient: heroDeep (deep navy-to-black)

Top-right: [Skip] text button (textSecondary) — hidden on this screen

Center vertical stack:
  Animated logo (64px, spring reveal at 300ms)

  56px gap

  "Your health,
   your karma."
  AppTypography.heroDisplay (72sp, white, letterSpacing -2)
  Spring slide-up: translateY 40 → 0, fade 0 → 1, 400ms

  16px gap

  "Track steps, food, sleep, and vitals.
   Earn karma. Build habits that last."
  AppTypography.bodyLg, textSecondary
  Max 2 lines, center-aligned
  Fade in at 500ms

  48px gap

  [Get Started →]
  ElevatedButton, full width (horizontal 40px margins)
  primary color, 52px height, radius 16
  Spring bounce on render: scale 0 → 1.05 → 1.0 at 600ms

  16px gap

  [I already have an account]
  TextButton, textSecondary, 44px tap area

Bottom dots indicator (3 dots):
  Positioned 40px above safe area bottom
  Active: 24px wide pill, primary color
  Inactive: 8px circle, surface2
  Spring width transition on active change
```

#### Animation Sequence
| Delay | Element | Animation |
|-------|---------|-----------|
| 0ms | Gradient background | Instant |
| 200ms | Logo | Spring scale in |
| 350ms | Headline | Slide up + fade |
| 500ms | Subheadline | Fade in |
| 600ms | CTA button | Spring bounce in |
| 700ms | Secondary link | Fade in |
| 800ms | Dots indicator | Fade in |

---

### 11.3 Onboarding — Dosha Quiz Screen

**Route:** `/onboarding/dosha`
**Scaffold:** Pattern A (no blobs, calm gradient bg)
**Step:** 3 of 5 (shown in progress bar)

#### Layout
```
AppBar:
  Back arrow (left, textSecondary)
  "Step 3 of 5" (center, labelLg, textMuted)
  [Skip] (right, textSecondary)

Progress bar:
  Full-width LinearProgressIndicator
  Height 4px, rounded
  Value: 0.6 (3/5)
  primary color fill, surface2 track

12px gap

Question header:
  "🌿" emoji (32px)
  8px gap
  "What describes your body type?"
  AppTypography.h1, textPrimary
  8px gap
  "Ayurveda identifies three body types. Pick what fits you most."
  AppTypography.bodyMd, textSecondary

24px gap

Answer options (vertical list, 12px gap each):
  Each option = GlassCard (AppRadius.md, surface0)
  Inner: Row [ option letter chip | option text | selected indicator ]
  
  Option chip: 32×32 circle, surface2 bg
    Selected: primary bg, white text
  Option text: AppTypography.bodyLg, textPrimary
  
  Selected card state:
    Border: primaryGlow (1.5px)
    Background: primaryMuted (low opacity)
    Trailing: orange ✓ icon (20px)
  
  Tap spring: scale 0.97 → 1.00 (150ms, standard spring)

Sticky bottom (above safe area, 16px padding):
  [Next Question →] ElevatedButton
    Disabled (opacity 0.4) until selection made
    Enabled: spring scale 0.96 → 1.0 on appear
```

#### Quiz Questions (10 total)
The quiz runs question by question with spring slide transition (SharedAxis horizontal).

1. Body frame — Thin/Medium/Large
2. Skin type — Dry/Normal/Oily
3. Energy pattern — Variable/Moderate/Sustained
4. Sleep quality — Light/Sound/Deep (hard to wake)
5. Digestion — Irregular/Regular/Slow
6. Memory — Quick but forgetful/Sharp/Slow but permanent
7. Speech — Fast/Moderate/Deliberate
8. Emotional nature — Anxious/Passionate/Calm
9. Temperature preference — Cold avoidance/Neither/Heat avoidance
10. Appetite — Variable/Strong/Low

After Q10: Animated result reveal screen (3–5s processing animation, then dominant dosha displayed with teal/orange/indigo graphic).

---

### 11.4 Onboarding — Health Goals Setup

**Route:** `/onboarding/goals`
**Scaffold:** Pattern C (full-bleed `heroDeep`)
**Step:** 2 of 5

#### Layout
```
Top-right: [Skip] text button (textSecondary)

Step indicator: 5 dots, step 2 active

Header (top center, 60px from top of safe area):
  "🎯" (64px)
  12px gap
  "What's your goal?"
  AppTypography.h1, white
  8px gap
  "You can always change this later."
  AppTypography.bodyMd, textSecondary

24px gap

Goal grid (2 columns, 12px gap, 6 cells):
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

  Each cell: GlassCard, 1.1 aspect ratio
  Unselected: surface0 bg, glassBorder
  Selected: primaryMuted bg, primaryGlow border (1.5px), orange ✓ top-right (16px)
  Tap: spring scale 0.96 → 1.0 (150ms)
  4th selection attempt: micro-shake animation + SnackBar:
    "Max 3 goals — deselect one first"

Conditional metric slider (AnimatedSize 300ms spring):
  Appears below grid when relevant goal selected:

  "Lose Weight" selected:
    Label: "Daily calorie target"
    Slider: 1200–2800 kcal, step 50
    Value display: monoLg, primary color
    Preset chips: [Light −500 kcal] [Moderate −250 kcal] [Maintain]

  "Build Muscle" selected:
    Label: "Daily protein target"
    Slider: 80–220g, step 5g
    Hint: "~{weight × 1.6}g recommended for your weight"

  "Heart/BP/Glucose" selected:
    Label: "Daily steps goal"
    Slider: 4,000–15,000 steps, step 500
    Preset chips: [Easy 5k] [Active 8k] [Athletic 12k]

  "Stress/Energy" selected:
    Label: "Sleep target"
    Slider: 6h–9h, step 30 min
    Hint: "Adults need 7–8h"

Sticky bottom:
  [Continue →] ElevatedButton
    Disabled opacity 0.4 until ≥1 goal selected
    On tap: spring pulse + navigate
```

---

### 11.5 Onboarding — Permissions & Privacy

**Route:** `/onboarding/permissions`
**Scaffold:** Calm Zone (bg2 solid, ZERO decorations — no blobs, no blur, no glow)
**Step:** 5 of 5 (final)

#### Layout
```
AppBar: back arrow (left), "Step 5 of 5" (center, textMuted), no skip

Header:
  "🔒" icon (48px, teal color)
  8px gap
  "Your data, your rules"
  AppTypography.h1, textPrimary
  8px gap
  "FitKarma works fully offline. Permissions below make it smarter, but none are required."
  AppTypography.bodyMd, textSecondary, max 3 lines

24px gap

Permission cards (surface0, AppRadius.md, 1px glassBorder, 12px gap each):
  ┌────────────────────────────────────────────────────┐
  │ 🏃  Health Connect        Tap for info ⓘ   [ON ●] │
  │     Auto-sync steps & heart rate                   │
  └────────────────────────────────────────────────────┘
  ┌────────────────────────────────────────────────────┐
  │ 🔔  Notifications                          [ON ●] │
  │     Meal reminders, streak alerts                  │
  └────────────────────────────────────────────────────┘
  ┌────────────────────────────────────────────────────┐
  │ 📷  Camera                                 [OFF○] │
  │     Scan food barcodes                             │
  └────────────────────────────────────────────────────┘
  ┌────────────────────────────────────────────────────┐
  │ 🧬  Biometric Lock                         [ON ●] │
  │     Fingerprint / face for health screens          │
  └────────────────────────────────────────────────────┘

  Toggle: CupertinoSwitch
  ON: primary color track
  OFF: surface2 track
  Row tap area: 44px min height

  Biometric row: hidden if no hardware detected (LocalAuthentication.canCheckBiometrics = false)

16px gap

Privacy commitment card (surface1, 3px left border in teal — NOT a glow):
  Title: "🔐 Our privacy promise"
  AppTypography.h3, teal

  Bullet rows (12px gap each):
  · Encrypted on your device with AES-256
  · Never sold to advertisers — ever
  · Delete your account and all data anytime
  · Works fully offline — no cloud required

  EncryptionBadge at card bottom right

Sticky bottom (non-skippable):
  [Get Started →] ElevatedButton
  While requesting permissions: button shows CircularProgressIndicator (20px white)
  
  On permission denied:
    Silent — feature simply unavailable. No blocking error.
    If Health Connect denied → health sync features disabled gracefully
  
  On complete:
    1. Persist permission choices to Drift `users` table (syncStatus = 'pending')
    2. Set UXStage = firstWeek
    3. GoRouter.go('/home/dashboard') — replaces entire navigation stack
```

---

### 11.6 Dashboard Screen

**Route:** `/home/dashboard`
**Scaffold:** Pattern A
**Tab:** Home (active)

#### AppBar
```
Left: CircleAvatar (32px) — user photo or initials, tapping → /profile
Center: "Good morning, Arjun" (greeting changes: morning/afternoon/evening)
  AppTypography.h2, textPrimary
  [NOTE: First name only, never full name]
Right: Bell icon → /notifications
  If unread > 0: small orange dot badge (8px, no number)
```

#### Scroll Content

**Section 1 — Activity Rings Card**
```
GlassCard (AppRadius.bentoHero, primaryGlow border — ONLY card with glow)
Padding: 20px all

  Row:
  Left: ActivityRings widget (180px diameter)
    Outer ring: steps progress (primary/orange)
    Middle ring: calories progress (accent/amber)
    Inner ring: active minutes (purple)
    Center: column [
      "6,842" — AppTypography.metricLg, textPrimary
      "steps" — AppTypography.labelMd, textSecondary
    ]

  Right column (flex 1, left padding 20px):
    Row: [orange dot 6px] "Steps"    "6,842 / 8,000"
    Row: [amber dot 6px]  "Calories" "1,240 / 2,000"
    Row: [purple dot 6px] "Active"   "28 / 30 min"
    Each row: AppTypography.labelLg, textSecondary | monoSm, textPrimary

  Progress percentage below rings:
    "86%" in metricLg, primary, with glow
    "of daily goal" in labelMd, textMuted
```

**Section 2 — Bento Grid**
```
2-column grid, 12px gap, 4 cells (2 half, 2 full-width):

  [HALF] Calories card                [HALF] Water card
  ┌─────────────────┐ ┌─────────────────┐
  │ 🍽️             │ │ 💧             │
  │ Calories        │ │ पानी / Water   │
  │ "1,240"monoLg  │ │ "1.8L" monoLg  │
  │ of 2,000 kcal  │ │ of 2.5L        │
  │ [+] quick add  │ │ [+] 250ml      │
  └─────────────────┘ └─────────────────┘
  Tap → /food          Tap → /water

  [FULL WIDTH] Streak card
  ┌──────────────────────────────────────────────────┐
  │  StreakFlame widget (32px)     🔥 12-day Streak  │
  │  "Keep logging to protect your streak!"           │
  │  [Day row: Mon Tue Wed Thu Fri Sat Sun]           │
  │  Completed days: filled primary circle            │
  │  Today: pulsing ring                              │
  │  Future: empty circle surface2                    │
  └──────────────────────────────────────────────────┘

  [FULL WIDTH] Karma XP card → /karma
  ┌──────────────────────────────────────────────────┐
  │  ⚡ Level 8 Warrior           2,840 / 4,200 XP  │
  │  XP progress bar (primary fill, animated width)  │
  │  "Log a meal to earn +5 XP"  [→]                │
  └──────────────────────────────────────────────────┘
```

**Section 3 — Today's Meals**
```
Header: "Today's Meals" h3 | [See all →] labelLg, primary

Horizontal scroll (no clip, overflows naturally):
  Meal cards (120px wide, 140px tall, 8px gap):
  Each: GlassCard (radius md)
    emoji (28px)
    meal name (bodyMd, 1 line, ellipsis)
    kcal count (monoSm, textSecondary)

  If no meals yet:
    "No meals logged"
    EmptyState (small variant, no animation)
    [+ Log first meal] text button, primary
```

**Section 4 — AI Insight Card**
```
Visible if: ≥7 days data AND aiInsightsEnabled flag is ON
InsightCard (full width):
  Icon: dynamic (based on insight type — 🔥 🛌 🩸 💧)
  Title: "3-line insight headline"
  Body: 2-3 sentence insight
  Footer: [👍 Helpful] [👎 Not helpful]

If flag OFF (rule-based):
  Simple text insight without LLM backend
```

**Section 5 — Quick Health Stats**
```
Row of 3 GlassCards (no glow, surface0):

  [BP Card]           [Glucose Card]       [Sleep Card]
  "124/82"            "98 mg/dL"           "7h 12m"
  monoMd              monoMd               monoMd
  "Blood Pressure"    "Glucose"            "Last night"
  labelSm, secondary  labelSm, secondary   labelSm, secondary
  TrendChip (delta)   TrendChip (delta)    TrendChip (delta)

Each: tap → respective screen. 44px min tap target.
```

**Section 6 — Challenges**
```
Header: "Active Challenge" h3 | [View all →]

Single challenge card (GlassCard, accent/amber left border 3px):
  Challenge name h3
  "Day 4 of 21 — Core Strength"
  Progress bar (accent fill)
  Participants: 3 avatar chips + "+12 more"
  [Continue] secondary button
```

#### FAB
```
QuickLogFab — always visible, positioned 16px from bottom-right edge
Inside bottom nav bar safe area clearance
```

---

### 11.7 Food Home Screen

**Route:** `/home/food`
**Scaffold:** Pattern A
**Tab:** Food (active)

#### AppBar
```
"Food" — AppTypography.h1, textPrimary (center)
Right: 🔍 Search icon → opens food search sheet (§F1)
```

#### Macro Ring Card
```
GlassCard (AppRadius.xl, full width)
  Center: Donut chart (fl_chart PieChart, 140px, hole 70px)
    Segments: Protein (secondary/indigo) | Carbs (accent/amber) | Fat (rose/pink)
    Center text: "760" remaining kcal (metricLg, primary, glow)
              "kcal left" (labelMd, textMuted)

  Right of donut (flex 1):
    "● Protein   72 / 120g"
    "● Carbs    180 / 280g"
    "● Fat       45 / 65g"
    "● Fiber     18 / 30g"
    AppTypography.labelLg, each with respective color dot

  Date strip below chart:
    ← [Mon] [Tue] [Wed] [Thu] [Fri] [SAT] [Sun] →
    Today highlighted: primary filled pill, white text
    Other days: surface2 pill, textSecondary
    Tap → loads that day's food log
```

#### Meal Sections (4 sections: Breakfast, Lunch, Dinner, Snacks)
```
Each section:

  Header row:
    Left: meal icon + meal name (h3, textPrimary)
          "Breakfast" | "🌅 Breakfast"
    Center: total kcal for meal (monoSm, textSecondary)
    Right: [+ Add] text button (primary) → food search bottom sheet

  Food item rows (ListView, not scrollable — Column inside SingleChildScrollView):
    Each row (52px min height, 1px divider between):
      Left: food emoji or CachedNetworkImage (48×48, radius sm)
            Low data mode: emoji only
      Middle: food name (bodyMd, textPrimary, 1 line, ellipsis)
              portion text (labelMd, textSecondary) e.g. "2 roti (70g)"
      Right: calorie count (monoSm, textPrimary)
             Swipe-to-delete gesture → soft delete + undo SnackBar

  Empty state for section:
    "Add {meal name} →" in bodyMd, textMuted, center-aligned
    48px height, tappable → food search sheet
```

#### Daily Totals
```
GlassCard (surface1, no glow):
  "Daily Summary" h3 (left)

  Row of 6 metrics (equal width):
    [Cal] [Pro] [Carb] [Fat] [Fiber] [Water]
    Value: monoMd, textPrimary
    Label: labelSm, textMuted
    Color indicator dot (6px)
```

---

### 11.8 Food Search Screen (Bottom Sheet)

**Route:** Bottom sheet, slides up from `/food`
**Scaffold:** Bottom sheet (AppRadius.lg top corners, surface1 bg)

#### Layout
```
Handle bar (40×4px, surface2, centered, 8px from top)

Header:
  "🔍 Search food" h2 (left)
  [×] close icon (right, 44px tap)

Search input (12px below header):
  TextField (surface2 bg, radius md, primary focused border)
  Prefix: search icon (textMuted)
  Suffix: clear × if text present
  Hint: "Try 'roti', 'dal', or scan barcode"
  Autofocus: true on sheet open

  Below input (right-aligned):
  [📷 Scan Barcode] text button with camera icon (primary)
  → launches camera for barcode scan (Open Food Facts lookup)

Recent + Quick picks (before search text entered):
  "Recent" section header (labelLg, textMuted)
  Last 5 logged items: chip row (scrollable horizontal)
  Each chip: "Roti 🫓" surface2 pill, tap to add directly

  "Frequently used" section below:
  Last 10 unique foods as list rows (same as food item rows above)

Search results (when text entered, ≥2 chars, 300ms debounce):
  Loading: ShimmerLoader (3 rows)
  Results: food item rows
    Left: emoji or photo (40px)
    Middle: name (bodyMd) + nameHindi if available (labelMd, textMuted below)
    Right: kcal per serving (monoSm) | [+ Add] icon (primary)
  
  "From Open Food Facts" label at section bottom if showing barcode results
  No results: EmptyState("No matches — try Hindi name or scan barcode")

Add food sheet (appears on row tap):
  Expands sheet or opens nested sheet
  Food name + emoji header
  Portion selector:
    Preset serving sizes as chips (e.g., "1 roti (35g)" "2 roti (70g)")
    OR custom input with stepper +/−
  Macro preview: Protein | Carbs | Fat | Fiber (updates live)
  Meal selector: [Breakfast] [Lunch] [Dinner] [Snacks] — pill toggle
  [Log Food] primary button → writes to Drift → +5 XP SnackBar
```

---

### 11.9 Blood Pressure Screen

**Route:** `/blood-pressure`
**Scaffold:** Pattern B (heroDeep gradient)
**Biometric gate:** Required on first enter per session

#### Hero Panel (320px)
```
AppBar (transparent, overlaid):
  Back arrow | "Blood Pressure" | EncryptionBadge (right, teal lock)

Top-center of hero:
  Classification chip:
    "Normal ✓"  → success green bg
    "Elevated ⚠" → warning amber bg
    "Stage 1 ⚠" → warning amber bg
    "Stage 2 !" → error red bg
    "Hypertensive Crisis 🚨" → error red bg, pulsing
  AppTypography.labelLg, white text, 8px horizontal padding, radius full

16px gap

GlowingMetric:
  "124 / 82"
  AppTypography.metricXL, white, primaryGlow shadow
  Unit: "mmHg" labelLg, textSecondary (below, right-aligned)

12px gap

Pulse row:
  Heart icon (rose) + "72 bpm"
  AppTypography.monoLg, textSecondary

Last reading time:
  "Measured today, 8:42 AM"
  AppTypography.labelMd, textMuted
```

#### Body Panel (bg1, radius 28 top, slides over hero)
```
24px padding top

Section: 7-day chart
  "Last 7 Readings" h3 | [View history →] labelLg, primary
  fl_chart LineChart:
    Height: 180px
    Systolic line: primary (orange), 2px stroke
    Diastolic line: secondary (indigo), 2px stroke, dashed
    Normal range band: success fill at 20% opacity (80–120 region)
    X-axis: day abbreviations (labelSm, textMuted)
    Y-axis: values 60–180 (labelSm, textMuted)
    Interactive: tap point → tooltip with full reading
    Grid lines: surface2 horizontal only

24px gap

Section: Recent readings history
  "History" h3
  List of reading rows (8px gap):
    Row: [BP value monoMd] [classification chip] [date labelMd] [pulse labelMd]
    "124/82" | "Normal ✓" | "Today 8:42 AM" | "72 bpm"
    Swipe left: [Delete] red action → soft delete + undo SnackBar

24px gap

[Log Reading] primary button (full width):
  On tap → Log BP bottom sheet:
    Two numeric steppers: Systolic | Diastolic
    Each: +/− buttons, center value display (monoXL)
    Systolic range: 70–220, step 1
    Diastolic range: 40–130, step 1
    Pulse field: numeric input, optional
    Time picker: defaults to now (editable)
    Classification chip updates live as values change
    
    Crisis alert (systolic ≥180 or diastolic ≥120):
      Red banner: "Hypertensive Crisis — seek emergency care immediately"
      Phone icon button → 108 (Ambulance)
    
    [Save Reading] primary button → Drift write → +10 XP → sync

EncryptionBadge row:
  Left-aligned, teal
  "Your health data is encrypted on this device"
  AppTypography.labelMd, textMuted
```

#### BP Classification Table

| Systolic | Diastolic | Classification | Color |
|---------|----------|----------------|-------|
| < 120 | < 80 | Normal | `success` green |
| 120–129 | < 80 | Elevated | `warning` amber |
| 130–139 | 80–89 | Stage 1 Hypertension | `warning` amber |
| 140–179 | 90–119 | Stage 2 Hypertension | `error` red |
| ≥ 180 | ≥ 120 | Hypertensive Crisis | `error` + pulsing alert |

---

### 11.10 Blood Glucose Screen

**Route:** `/glucose`
**Scaffold:** Pattern B (heroDeep)
**Biometric gate:** Required on first enter per session

#### Hero Panel
```
AppBar: Back | "Blood Glucose" | EncryptionBadge

Reading type selector (top of hero, below AppBar):
  Pill toggle: [Fasting] [Post-meal] [Random]
  Active: primary bg, white text
  Inactive: surface2 bg, textSecondary

GlowingMetric:
  "98" AppTypography.metricXL, white
  "mg/dL" labelLg, textSecondary (right-aligned below)

Classification chip:
  "Normal ✓" success | "Pre-diabetic ⚠" warning | "Diabetic !" error
  Targets vary by reading type:
    Fasting: Normal < 100 | Pre: 100–125 | Diabetic ≥ 126
    Post-meal (2h): Normal < 140 | Pre: 140–199 | Diabetic ≥ 200

"Linked meal: Breakfast — 2h ago"
  labelMd, textMuted (shows if reading type is post-meal)
  Tap → navigates to linked food log
```

#### Body Panel
```
7-day chart (same structure as BP chart):
  Single line: teal color (glucose)
  Normal band shaded per reading type
  Reference lines: dashed for pre-diabetic threshold, solid for diabetic threshold

Linked meal correlation section:
  "Meals & Readings" h3
  Shows food log rows paired with post-meal readings
  Visual: meal card → arrow → glucose chip
  Helps user understand food impact

[Log Reading] bottom sheet:
  Reading type toggle (Fasting/Post-meal/Random)
  Numeric input (monoXL, centered, 60–500 range)
  If post-meal: link to recent food log (optional)
  Time picker
  [Save] → Drift → +10 XP

EncryptionBadge footer
```

---

### 11.11 Steps Screen

**Route:** `/home/steps`
**Scaffold:** Pattern C (full-bleed `heroFire`)
**Tab:** Steps (active)

#### Full-screen Layout
```
Background: heroFire gradient (deep brown-to-black)
AmbientBlobs: subtle warm-orange only (mid/high tier)

Top (safe area + 16px):
  Row: back-gesture hint (none) | "Steps" labelLg, white | settings icon (right)

Center vertical stack:
  "Today"
  AppTypography.labelLg, textMuted (center)

  8px gap

  GlowingMetric:
    "6,842"
    AppTypography.heroDisplay (72sp), white, primaryGlow
    Glow radius: 32px, animated pulse (2s sine, opacity 0.3–0.6)

  4px gap

  "of 8,000 steps"
  AppTypography.monoLg, textSecondary

  24px gap

  Progress arc (CustomPainter, 240px wide, semicircle):
    Background arc: surface2, stroke 12px
    Filled arc: primary → accent gradient, stroke 12px, rounded cap
    Fill: 6842/8000 = 85.5%
    Below arc center: percentage "86%" metricMd, primary

  24px gap

  Row (center, 32px gap each):
    [Distance]     [Calories]      [Active min]
    "4.8 km"       "312 kcal"      "42 min"
    monoMd, white  monoMd, white   monoMd, white
    labelSm, muted labelSm, muted  labelSm, muted

Bottom half — slide-up panel (bg1 rounded top, 28px radius):
  Drag handle (40×4px, surface2, centered, 8px from top)

  "Hourly steps" h3 (16px from top of panel)

  fl_chart BarChart (height 120px, last 12 hours):
    Bar color: primary (filled hours), surface2 (empty/future)
    X-axis: hour labels (labelSm)
    Y-axis: max steps (auto-scale)
    Interactive: tap bar → tooltip with exact count

  16px gap

  "Weekly overview" h3

  7-day bar chart or heatmap:
    Current day: primary color
    Other days: surface2 (empty) / teal (goal met)

  16px gap

  Goal setting row:
    "Daily goal: 8,000 steps"
    [Edit goal] text button → stepper sheet
      Range: 2,000–20,000, step 500
      Presets: [Easy 5k] [Active 8k] [Athletic 12k] [Custom]

  16px gap

  Health Connect sync indicator:
    "Synced with Google Health 2 min ago" (if connected)
    OR "Connect Health Connect" link (if not)
```

---

### 11.12 Sleep Screen

**Route:** `/sleep`
**Scaffold:** Pattern B (heroSleep — deep purple gradient)
**Biometric gate:** None

#### Hero Panel
```
AppBar: Back | "Sleep" | [+ Log] right icon

Center:
  "Last night"
  labelLg, textMuted

  GlowingMetric:
    "7h 24m"
    AppTypography.metricXL, white, secondaryGlow (indigo)

  "Sleep Score" row:
    Score ring (40px diameter, secondary fill) with "82" inside
    "Good sleep" — labelLg, success green

  Bedtime/Wake row:
    "🌙 10:30 PM → 🌅 5:54 AM"
    AppTypography.monoMd, textSecondary
```

#### Body Panel
```
Sleep stages chart:
  Custom horizontal bar chart (fl_chart or custom painter)
  Height: 140px
  Stages: Awake (error/red) | Light (secondary muted) | Deep (secondary) | REM (purple)
  Time axis: 10 PM → 6 AM
  Legend row below chart

SpO2 card:
  Row: "🫁 SpO2" h3 | "avg 97%" monoMd, success
  Sparkline (last night's SpO2 over time)
  "Normal range 95-100%"

Insights row (if ≥7 days data):
  "Based on your last 7 nights:"
  InsightCard variant (compact, no feedback buttons)
  e.g., "You sleep best on days you log dinner before 9 PM."

7-day trend:
  Bar chart: sleep duration per day
  Goal line: dashed, user's sleep target
  Color: below goal → warning | at/above → success

Log sleep bottom sheet:
  Bedtime picker (time wheel)
  Wake time picker (time wheel)
  Quality rating: 5 star tap (spring bounce on star tap)
  Notes field (optional, 140 char max)
  [Save] → Drift → +10 XP
```

---

### 11.13 Workout Home Screen

**Route:** `/home/workout`
**Scaffold:** Pattern A
**Tab:** Workout (active)

#### AppBar
```
"Workout" h1 (center)
Right: [+ New] icon button → workout type selection
```

#### Content
```
Active program card (if enrolled):
  GlassCard (primaryGlow border — hero of this screen)
  "💪 Week 3 — Push Day" h2, primary
  "Chest · Shoulders · Triceps"
  [Continue Workout →] primary button
  Progress: "Day 15 of 42"

OR (no program):
  EmptyState: "Start a program" with program suggestions

16px gap

"Quick Start" section:
  "Start a workout" h3
  4 workout type cards (2×2 bento grid):
    [🏃 Cardio] [💪 Strength] [🧘 Yoga] [🏊 Custom]
    GlassCard, icon 32px, name h3
    Tap → /workout/active/{type}

16px gap

"Recent workouts" section:
  "History" h3 | [See all →]
  List of workout rows:
    Row: workout type icon | name h3 + date labelMd | duration monoSm | volume monoSm
    "💪 Push Day — 3 days ago — 52 min — 4,800 kg"
    Tap → workout detail (Pattern B)
```

---

### 11.14 Active Workout Screen

**Route:** `/workout/active/{workoutId}`
**Scaffold:** Pattern C (full-bleed)

#### Layout
```
Top bar (no AppBar, custom):
  [✕ Stop] (left, error color, 44px) | Timer monoXL, white | [⏸ Pause] (right)

Exercise card (GlassCard, radius xl, center of screen):
  Exercise name h1, white
  Set counter: "Set 2 of 4" labelLg, textMuted

  Set input (centered):
    Reps: [−] "12" [+]  ×  Weight: [−] "60kg" [+]
    Reps/Weight: monoXL, primary
    Stepper buttons: 52×52, surface2, radius full

  [Complete Set ✓] primary button (full width, 56px, spring bounce on tap)

Rest timer (appears after completing a set):
  Full-screen overlay pulse:
    Countdown ring (primary, animated sweep)
    Time remaining monoXL, white
    "Rest — 90s" labelLg, textMuted
    [Skip rest] text button

Exercise list (bottom panel, draggable):
  Current exercise highlighted with primary border
  Completed exercises: checkmark, dimmed
  Upcoming: normal, tap to reorder
```

---

### 11.15 Karma Hub Screen

**Route:** `/karma`
**Scaffold:** Pattern B (heroDeep)
**Tab:** Karma (active)

#### Hero Panel
```
AppBar: "Karma" h1 (center), no back

Level badge:
  Pill: "⚡ Level 8 Warrior"
  Gradient bg: secondary → primary (diagonal)
  AppTypography.labelLg, white, radius full, shadow

32px gap

GlowingMetric:
  "8,420" — total XP
  AppTypography.metricXL, white, accentGlow (amber)

XP to next level:
  "1,580 XP to Level 9 Legend"
  labelMd, textSecondary

Progress bar:
  Width: full hero width minus 40px
  Height: 8px, radius full
  Fill: accent (amber), animated width
  Track: surface2 at 50% opacity
```

#### Body Panel
```
"Today's Karma" h3 (top of panel)

Karma events list (last 24h, stream from Drift):
  Each event row:
    Left: XP icon with color (primary for actions, accent for streaks)
    Middle: event description (bodyMd)
    Right: "+25 XP" (monoSm, accent)
  Events: "Logged breakfast +5", "Completed workout +30", "7-day streak +50"

16px gap

XP breakdown bento (2×2 grid):
  [Food XP: 85]    [Workout XP: 120]
  [Steps XP: 150]  [Health XP: 90]
  Each: labelMd header, monoLg value, color dot

16px gap

"Achievements" h3 | [See all →]
  Horizontal scroll, achievement cards:
    80×80px GlassCard
    Achievement icon (32px)
    Name (labelSm, 2 lines, center)
    Unlocked: full color | Locked: 40% opacity + lock icon

16px gap

"Challenges" tab | "Leaderboard" tab (TabBar, surface2 indicator)

Challenges tab:
  Active challenges as cards (GlassCard, accent left border):
    Challenge name h3
    Progress: "Day 4 of 21"
    Participants count
    [Continue] secondary button

Leaderboard tab:
  Top 10 users (among friends/group)
  Each row: rank number | avatar | name | XP value
  Current user row: primary border highlight
  "Invite friends" card at bottom → referral link
```

---

### 11.16 Journal Screen — Calm Zone

**Route:** `/journal`
**Scaffold:** Calm Zone (bg2 solid, zero glow/blur/animation)
**Biometric gate:** Required on first enter per session

#### Layout
```
AppBar:
  Back | "Journal" | [+ New entry] right icon
  EncryptionBadge inline in AppBar title area (teal lock, 16px)

Entry list:
  Date-grouped, sorted newest first
  Date header: "Monday, Jan 13" labelLg, textMuted (full-width divider below)

  Entry card (surface0, radius md, no glow, simple 1px glassBorder):
    Mood emoji (if logged) + "Feeling {mood}" labelMd, textSecondary
    Preview text (bodyMd, textPrimary, 2 lines, ellipsis)
    Tags row: tag chips (surface2, labelSm)
    Date + time (right-aligned, labelSm, textMuted)
    Tap → entry detail

  Swipe left: [Delete] action → soft delete + undo SnackBar (4s)

Empty state:
  "📔 No entries yet"
  BilingualLabel: "अपने विचार लिखें" / "Write your thoughts"
  [Write first entry →] primary button

New/Edit entry screen:
  TextField (full-screen, bodyLg, no border, transparent bg)
  Hint: "What's on your mind?"
  
  Bottom toolbar:
    [😊 Mood] [🏷 Tags] [🔐 Lock] [📅 Date]
    Mood picker: emoji grid (5×2) with spring pop on tap
    Tags: chip input (surface2 bg, return to add)
    [Save] primary button (top-right, 44px)

  Word count (bottom-right, labelSm, textMuted, live)
  
  Biometric lock badge (if locked entry):
    "🔐 This entry is locked" banner at top
```

---

### 11.17 Mental Health Hub

**Route:** `/mental-health`
**Scaffold:** Pattern A (calm variant — no ambient blobs)

#### Layout
```
AppBar: "Mental Health" | no right action

Crisis helpline banner (ALWAYS visible at top — never hidden):
  surface1 card, teal 3px left border
  "Need support right now?"
  iCall: 9152987821
  Vandrevala: 1860-2662-345
  NIMHANS: 080-46110007
  Phone icon buttons (44px each, teal)
  BilingualLabel: "सहायता के लिए कॉल करें"

24px gap

Mood check-in card (GlassCard, secondary/indigo left border):
  "How are you feeling today?" h3
  Mood slider: 😞 ─────●───── 😊 (1–10)
  [Log mood] secondary button → +10 XP

16px gap

"CBT Insights" section:
  InsightCard (rule-based or AI):
    Cognitive behavioral patterns based on journal + mood data
    Show only if ≥ 14 days of mood data

16px gap

Breathing exercises:
  "🫁 Breathing" h3
  3 exercise cards (horizontal scroll):

  [4-7-8 Breathing]
  "Inhale 4s · Hold 7s · Exhale 8s"
  labelMd, textSecondary
  [Start] teal button → BreathingCircle full-screen

  [Box Breathing]
  "4-4-4-4 equal sides"

  [2-1-4-1 Relaxing]
  "Quick reset breathing"

Burnout gauge:
  "Burnout Risk" h3
  Gauge (CustomPainter, semicircle):
    Low (success) → Moderate (warning) → High (error)
    Based on: sleep score + step count + mood data
    "Currently: Low risk" below gauge, success green
  Caveat: "This is informational only, not medical advice."
    labelSm, textMuted

16px gap

Resources section:
  "Guided resources" h3
  Cards linking to meditation, yoga (external or in-app content)
```

---

### 11.18 Profile Screen

**Route:** `/profile`
**Scaffold:** Pattern B (heroDeep)

#### Hero Panel
```
AppBar (transparent): Back | "Profile" | [Edit] right icon → /profile/edit

CircleAvatar (88px diameter):
  User photo (CachedNetworkImage) OR
  Initials in displayMd, white, on secondary gradient bg
  Edit badge: small camera icon overlay (primary bg, bottom-right of avatar)

12px gap

Name: AppTypography.displayMd, white, center
Email: AppTypography.bodyMd, textSecondary, center

12px gap

Level badge pill:
  "⚡ Level 8 Warrior"
  Gradient: secondary → primary, rounded pill
```

#### Body Panel
```
Dosha section:
  "Your Dosha" h3 | [Retake quiz →] labelLg, primary

  Dosha donut (fl_chart, 80px):
    Vata (secondary/indigo) | Pitta (primary/orange) | Kapha (teal)
    Center: dominant dosha emoji + name

  Dosha description (bodyMd, textSecondary, 2-3 lines)

16px gap

Stats row:
  [Member since] [Workouts] [Streak] [Total XP]
  Each: monoMd value, labelSm label

16px gap

Personal info section (surface0 card, list tiles):
  Age | Height | Weight | Activity level | Goal
  Each: 48px row, bodyMd (label, left), monoSm (value, right)
  Chevron icon → edit sheet for each

16px gap

Achievements section:
  "🏆 Achievements" h3 | [See all →]
  3-column grid of achievement badges (56px each)
  Locked achievements: 50% opacity, lock overlay

16px gap

Referral card (accent/amber border, GlassCard):
  "🎁 Refer a friend, earn 500 XP"
  "Your code: ARJUN42"
  [Share invite link] secondary button
  Referral count: "2 friends joined"

16px gap

Ayurveda card (teal border):
  "🌿 Your personalized tips"
  3 tips based on dosha
  labelMd each, teal text

[Sign out] — bottom of scroll, error color TextButton
[Delete account] — below sign out, textMuted TextButton
```

---

### 11.19 Lab Reports Screen — Calm Zone

**Route:** `/lab-reports`
**Scaffold:** Calm Zone
**Biometric gate:** Required on first enter per session

#### Layout
```
AppBar: Back | "Lab Reports" | EncryptionBadge | [+ Upload] right icon

Storage info bar:
  "Files stored encrypted on Appwrite" teal banner, teal left border
  EncryptionBadge inline

Report list (grouped by date):
  Each report card (surface0, radius md, simple border):
    Left: file type icon (PDF: red, Image: blue)
    Middle:
      Report name (bodyMd, textPrimary)
      Date + lab name (labelMd, textSecondary)
      Key values row: "HbA1c: 5.6% | Cholesterol: 180"
    Right: [↗ Share] icon → creates share token (24h expiry)
           [🗑] delete icon → soft delete + undo

Upload flow:
  [+ Upload Report] → file picker (PDF, JPG, PNG allowed)
  After file picked:
    Sheet: "Name this report" (TextField autofocus)
    Date picker (defaults to today)
    Key values input (optional, free-text)
    [Upload] → shows progress bar, then success ✓

Share flow:
  [Share →] → generates unique token via Appwrite Function
  Sheet shows: expiry time + shareable link
  [Copy link] | [Share via WhatsApp] | [Share via Gmail]
  "Link expires in 24 hours" — labelMd, warning amber
```

---

### 11.20 Medication & Water Tracking Screen

**Route:** `/medications` and `/water`

#### Medication Screen Layout
```
AppBar: Back | "Medications" | [+ Add] right icon

Today's schedule:
  Timeline view (left vertical line, surface2):
    Morning (8 AM): medication cards
    Afternoon (1 PM): medication cards
    Evening (8 PM): medication cards
    Night (10 PM): medication cards

  Each medication row:
    Pill emoji 💊 | medication name (bodyMd) | dosage (labelMd, textSecondary)
    Time scheduled (monoSm, textMuted)
    [Take ✓] button (44px, success green if taken, surface2 if not)
    Taken: shows green ✓ checkmark, timestamp

Add medication sheet:
  Name (TextField)
  Dosage (TextField with unit selector: mg/ml/tablets)
  Time picker (multi-time — can add multiple per day)
  [Save] → local notification scheduled → Drift write → +5 XP

Refill reminder:
  "⚠ Metformin — 5 days supply left"
  warning card with orange border
```

#### Water Tracking Screen Layout
```
AppBar: Back | "Water" | "💧 पानी"  (bilingual, strategic use)

Hero (Pattern B style, but smaller, 200px):
  GlowingMetric: "1.8 L" (metricXL, teal, tealGlow)
  "of 2.5 L goal" (labelLg, textSecondary)

  Animated water fill (CustomPainter):
    Wave animation in teal, fills up proportionally
    2.0s wave period, subtle sine wave motion

Log buttons (horizontal row):
  [+ 100ml] [+ 250ml] [+ 500ml] [+ Custom]
  surface2 pill buttons, teal on tap animation (spring scale)

Quick log: each tap → immediate Drift write → +1 XP → count animates up

Today's log timeline:
  Scrollable list: "8:00 AM — 250ml" rows
  Swipe to delete individual entries

7-day average card:
  "Average: 2.1L / day (last 7 days)"
  TrendChip vs previous 7 days

Goal setting:
  [Edit goal] → stepper sheet (500ml–5,000ml, step 250ml)
```

---

### 11.21 Festival & Wedding Screen

**Route:** `/festival` and `/wedding`

#### Festival Screen
```
AppBar: "Festivals & Events" h1 (center)

Upcoming festival banner (if festival within 7 days):
  GlassCard (heroFestival gradient bg — full width)
  Festival emoji (48px) + Festival name (displayMd, accent/amber)
  "3 days away" (labelLg, textSecondary)
  Health tip: "During Navratri fasting, try..." (bodyMd)

Festival calendar (monthly grid):
  Dates with festivals: highlighted with orange dot
  Tap → festival detail with food guide

Festival detail sheet:
  Festival name h1 | date labelLg
  "Fasting guidance" section:
    What to eat: green ✓ items
    What to avoid: red ✗ items
  Food suggestions linking to food search
  "Add to calendar" option
```

#### Wedding Mode Screen
```
Route: /wedding
Activated when: user.weddingDate set in profile

Countdown card (hero, Pattern B):
  "💒 {X} days to your wedding" displayLg, primary
  Date: monoLg, textSecondary

  Progress ring (primary → accent gradient):
    Shows weeks remaining vs total program duration

Body:
  "Wedding Fit Plan" h2
  Weekly targets (calories, workouts, steps, water)
  Week-by-week progress

  Milestones section:
    Weight goal (if set)
    Fitness milestones
    Habit streaks

  Community: "Join wedding fitness group" card
```

---

### 11.22 AI Coach Screen

**Route:** `/ai-coach`
**Scaffold:** Pattern A (calm variant — no blobs)
**Pro feature:** Gated behind subscription

#### Layout
```
AppBar: Back | "AI Coach 🤖" | [ⓘ] info icon (explains LLM usage)

Chat interface:
  Scrollable message list (bottom-anchored, latest at bottom)
  
  AI message bubble:
    Left-aligned, surface0 bg, radius xl (bottom-left stays square — chat pattern)
    Prefix: "🤖" avatar (32px, secondary bg)
    Text: bodyLg, textPrimary
    Timestamp: labelSm, textMuted (right-aligned below)

  User message bubble:
    Right-aligned, primary bg, white text, radius xl (bottom-right square)
    Timestamp: right-aligned below

  Typing indicator (while AI responding):
    3-dot pulse animation in surface2 bubble

Welcome state (first session):
  Centered card:
    "🤖 Your AI Health Coach"
    displayMd, textPrimary
    "Ask me about nutrition, workouts, health trends, or anything from your data."
    bodyMd, textSecondary
    3 starter prompts as tappable chips:
      "Analyze my last 7 days"
      "What should I eat today?"
      "How can I sleep better?"

Input bar (sticky bottom, above safe area):
  surface1 bg, border top 1px glassBorder
  TextField (surface2 bg, radius full):
    Hint: "Ask your coach..."
    Suffix: [Send →] icon button (primary, 36px circle)
  
  Context toggle (left of input):
    [📊 Share my data] chip — when ON, sends last 7 days of health data context
    Teal when active, surface2 when off
    Info tooltip: "Shares anonymized data with AI for personalized answers"

Rate limit indicator (Pro):
  "20 / 30 messages this month" (labelSm, textMuted, below input)
  If limit reached: "Upgrade to get unlimited messages" (primary)
```

---

### 11.23 Settings Screen — Calm Zone

**Route:** `/settings`
**Scaffold:** Calm Zone (bg2, no effects)

#### Layout
```
AppBar: Back | "Settings" h1

User header card (surface0, radius md):
  CircleAvatar (48px) | Name bodyLg | Email labelMd, textSecondary
  [Edit profile →] labelLg, primary (right)

Section: Account
  List tiles (48px min height, 1px dividers):
  · Profile & Personal Info
  · Goals & Targets
  · Notifications
  · Privacy & Security
  · Subscription & Billing

Section: App Preferences
  · Appearance (Dark / Light / System)
  · Language (English / हिंदी)
  · Units (Metric / Imperial)
  · Accessibility (Dyslexic font, font size)
  · Low Data Mode toggle (CupertinoSwitch)

Section: Health & Data
  · Health Connect / HealthKit (connect/disconnect)
  · Data & Sync (DLQ status, manual sync button)
  · Export data (JSON download)
  · Delete all data

Section: Support
  · Help & FAQ
  · Send feedback
  · Rate the app (links to store)
  · About FitKarma (version, licenses)

Sign out (error TextButton, centered, 48px, bottom of scroll)

DLQAlertBanner (if sync failures ≥3):
  Fixed at top of screen below AppBar
  Orange background, 🔴 icon
  "3 readings failed to sync — tap to resolve"
  Tap → Data & Sync screen with failed items listed
```

---

### 11.24 Subscription Screen

**Route:** `/settings/subscription`
**Scaffold:** Calm Zone (bg2)

#### Layout
```
AppBar: Back | "FitKarma Pro"

Hero card (gradient: secondary → primary, radius xl):
  "⚡ Go Pro"
  displayMd, white
  "Unlock AI Coach, advanced analytics, and unlimited logging."
  bodyMd, white at 80% opacity

Features comparison:
  Table (GlassCard):
  Feature                   | Free | Pro
  ─────────────────────────────────────────
  Basic health tracking     |  ✓   |  ✓
  Step & calorie logging    |  ✓   |  ✓
  Blood pressure & glucose  |  ✓   |  ✓
  AI Coach                  |  ✗   | ✓ Unlimited
  Advanced trend analysis   |  ✗   |  ✓
  Lab report storage        | 3 max| Unlimited
  Priority sync             |  ✗   |  ✓
  Wedding fit plan          |  ✗   |  ✓
  Custom karma badges       |  ✗   |  ✓

Pricing cards (2 options):
  [Monthly — ₹199/mo]      [Yearly — ₹1,499/yr] ← "Best value" badge
  GlassCard for each
  Yearly: accent border, "Save 37%" chip (success green)
  Selected: primaryGlow border, orange checkmark

[Start 7-day free trial] primary button (if eligible)
  OR [Subscribe now] if trial already used

"Cancel anytime · No questions asked" — labelMd, textMuted (center)
"Billed via App Store / Play Store" — labelSm, textMuted (center)

Terms links (labelSm, secondary, center):
  Terms of Service · Privacy Policy · Restore purchases
```

---

### 11.25 Notifications Screen

**Route:** `/notifications`
**Scaffold:** Calm Zone

#### Layout
```
AppBar: Back | "Notifications" | [Mark all read] right icon

Notification list (grouped by date):

  Date header: "Today" / "Yesterday" / "Jan 13" (labelLg, textMuted)
  
  Each notification row (surface0 card, 8px gap):
    Left: icon (emoji, 32px) with type-colored bg circle
    Middle:
      Title (bodyMd, textPrimary — bold if unread)
      Body preview (labelMd, textSecondary, 1 line, ellipsis)
      Time (labelSm, textMuted)
    Right: unread dot (8px, primary) if unread

  Notification types:
    🔥 Streak at risk → orange
    ⚡ XP earned → amber
    💧 Water reminder → teal
    💊 Medication due → purple
    🎉 Goal achieved → success green
    ❤️ BP reminder → rose
    🤖 AI insight ready → secondary/indigo

  Swipe left: [Delete] notification
  Tap: mark read + navigate to relevant screen

Empty state:
  "🔔 No notifications yet"
  "Start logging to get personalized insights."
  EmptyState widget (animated bell icon)

Notification settings link:
  "Manage notification preferences" → /settings/notifications
  labelMd, primary, bottom of screen
```

---

### 11.26 Emergency Card Screen — Calm Zone

**Route:** `/emergency`
**Scaffold:** Calm Zone (bg2 solid — NO effects, maximum legibility)

#### Layout
```
AppBar: Back | "Emergency Card" h1 | [Edit] right

CRITICAL: This screen must be readable without authentication.
App-level biometric does NOT gate this screen.

SOS Banner (error red bg, radius md):
  "🆘 Emergency Contacts"
  Large tap targets (72px min height per button)

Emergency contacts (top 4, always visible):
  ┌────────────────────────────────────────────────┐
  │  🚑  108  Ambulance          [📞 CALL]  72px   │
  ├────────────────────────────────────────────────┤
  │  🏥  AIIMS Emergency         [📞 CALL]  72px   │
  │      011-26588500                               │
  ├────────────────────────────────────────────────┤
  │  👤  {User Contact 1}        [📞 CALL]  72px   │
  │      {Name} — {Number}                          │
  ├────────────────────────────────────────────────┤
  │  👤  {User Contact 2}        [📞 CALL]  72px   │
  └────────────────────────────────────────────────┘

Medical info card (surface0, teal left border):
  "📋 Medical Information"
  Blood type: A+
  Allergies: Penicillin
  Conditions: Hypertension
  Medications: Metformin 500mg
  
  [Add medical info] → Drift-stored, locally encrypted

Share emergency card:
  [Share card as PDF] → generates summary PDF via Appwrite
  "72-hour expiring link"

Crisis helplines (always at bottom):
  BilingualLabel: "मानसिक स्वास्थ्य सहायता / Mental Health Support"
  iCall: 9152987821
  Vandrevala: 1860-2662-345
```

---

## 12. Bottom Navigation Bar

**5 tabs:** Home · Food · Workout · Steps · Karma

```dart
static const _tabs = [
  _NavTab(icon: Icons.home_outlined,          activeIcon: Icons.home_rounded,         label: 'Home'),
  _NavTab(icon: Icons.restaurant_menu_outlined, activeIcon: Icons.restaurant_menu,    label: 'Food'),
  _NavTab(icon: Icons.fitness_center_outlined, activeIcon: Icons.fitness_center,      label: 'Workout'),
  _NavTab(icon: Icons.directions_walk_outlined, activeIcon: Icons.directions_walk,    label: 'Steps'),
  _NavTab(icon: Icons.auto_awesome_outlined,   activeIcon: Icons.auto_awesome_rounded, label: 'Karma'),
];
```

#### Visual Spec
```
Height: 72px + bottom safe area
Background: GlassCard (blur 16px on high/mid tier, surface0 on low tier)
Top border: 1px glassBorder

Each tab (flex 1, min 44px tap target):
  Icon: 24px
  Label: labelSm, 4px below icon
  
  Inactive: textMuted icon + label
  Active:   primary icon + label + 4px dot below label (primary glow)
  
  Transition: spring scale 0.85 → 1.0 on select (150ms)
  Active tab icon: spring bounce 0.9 → 1.1 → 1.0 on first tap

Notification badge on Karma tab:
  If new XP earned since last visit: amber dot (8px)
```

---

## 13. Common UI Patterns

### Quick Log Bottom Sheet

```
Handle bar → 3×2 grid of options:

Row 1: [🍽 Food] [💧 Water] [🏋️ Workout]
Row 2: [💊 Medication] [😊 Mood] [❤️ BP/Glucose]

Each option:
  GlassCard (square, AppRadius.md)
  Icon 32px (emoji)
  Label h3 (center)
  Spring scale 0.93 → 1.0 on tap
  Tap → opens respective log sheet

Sheet background: surface1 (tier-aware blur)
Dismiss: swipe down or tap outside
```

### Bento Grid Layout

```dart
GridView(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: AppSpacing.bentoGap,   // 12px
    mainAxisSpacing: AppSpacing.bentoGap,    // 12px
    childAspectRatio: 1.1,
  ),
  children: [ /* bento cells */ ],
)

// Full-width cell: use Span or place in Column instead of grid
```

### Snackbar Standard

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(message, style: AppTypography.bodyMd),
    backgroundColor: AppColorsDark.surface1,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 4),
    action: showUndo ? SnackBarAction(
      label: 'Undo',
      textColor: AppColorsDark.primary,
      onPressed: undoCallback,
    ) : null,
  ),
);
```

### DLQ Alert Banner

```dart
// Appears at top of screen when syncStatus = 'dlq' for ≥1 record
DLQAlertBanner(
  // Orange background, full-width
  // "🔴 3 readings failed to sync — Tap to resolve"
  // Tap → /settings/sync
)
```

---

## 14. Accessibility & Bilingual Rules

### Accessibility Requirements

| Rule | Spec |
|------|------|
| Tap target | 44×44px minimum on ALL interactive elements |
| Text contrast | `textPrimary` ≥ 7:1, `textSecondary` ≥ 5:1 against bg |
| CustomPaint | All `CustomPainter` widgets must have `Semantics` wrapper |
| Screen reader | All icons must have `semanticsLabel` |
| Focus | Keyboard focus ring visible (Material default — don't override) |
| Font scale | Clamped to 0.85–1.3× (prevents layout breaks) |
| Dyslexic font | OpenDyslexic available via Settings toggle (replaces PlusJakartaSans) |
| Color-only info | Never communicate state via color alone — always add icon or text |
| Crisis lines | Always in text, never icon-only |

### Bilingual Label Rules

`BilingualLabel` renders English on top, Hindi below in smaller Devanagari.
**Use ONLY on:**
- Category section headers (e.g., "पानी / Water" for the water screen header)
- Empty state messages in health-critical sections
- Crisis helpline labels
- Festival and cultural event headers
- Onboarding goal selection cells (strategic emotional connection)

**Never use on:** Every card, every label, navigation items, form fields, charts.

```dart
// Hindi ALWAYS uses NotoSansDevanagari — NEVER PlusJakartaSans
BilingualLabel(
  english: 'Water',
  hindi: 'पानी',
  englishStyle: AppTypography.h3.copyWith(color: AppColorsDark.textPrimary),
  hindiStyle: AppTypography.hindi(size: 12).copyWith(color: AppColorsDark.textSecondary),
)
```

---

## 16. Low Data Mode

When enabled (toggle in Settings):
- Network images → replaced with emoji placeholders (no requests)
- Sync interval → forced to 6 hours minimum
- GlassCard blur → disabled (surface1 solid regardless of device tier)
- Background sync → paused while app not in foreground
- AI Coach → disabled (requires network)
- Food photo thumbnails → emoji only

```dart
Widget foodPhoto(String? url, String emoji, bool lowData) {
  if (lowData || url == null) {
    return Container(
      width: 60, height: 60,
      decoration: BoxDecoration(
        color: AppColorsDark.surface0,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
    );
  }
  return CachedNetworkImage(
    imageUrl: url,
    width: 60, height: 60,
    fit: BoxFit.cover,
    placeholder: (_, __) => ShimmerLoader(width: 60, height: 60, radius: AppRadius.sm),
    errorWidget: (_, __, ___) => Text(emoji, style: const TextStyle(fontSize: 28)),
  );
}
```

---

# PART II — TECHNICAL IMPLEMENTATION

---

## 21. Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Flutter App (Client)                          │
│                                                                       │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │   Presentation Layer                                           │  │
│  │   Screens → Riverpod Providers → UI Widgets                   │  │
│  └──────────────────────────┬────────────────────────────────────┘  │
│                              │                                        │
│  ┌───────────────────────────▼────────────────────────────────────┐  │
│  │   Domain Layer                                                  │  │
│  │   Use Cases · Entities · Repository Interfaces                 │  │
│  └──────────────────────────┬────────────────────────────────────┘  │
│                              │                                        │
│  ┌───────────────────────────▼────────────────────────────────────┐  │
│  │   Data Layer                                                    │  │
│  │   ┌──────────────────┐        ┌──────────────────────┐         │  │
│  │   │  Drift (SQLite)  │        │  Appwrite Remote SDK │         │  │
│  │   │  Local Source    │◄──────►│  Remote Source       │         │  │
│  │   │  AES-256         │        │  TLS 1.3             │         │  │
│  │   │  (SQLCipher)     │        │  Cert pinned         │         │  │
│  │   └──────────────────┘        └──────────────────────┘         │  │
│  │              ▲                                                   │  │
│  │              │  SyncWorker (priority queue)                      │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────▼──────────┐
                    │   Appwrite Cloud   │
                    │   fitkarma-db      │
                    │   fitkarma-vault   │
                    │   Functions (Node) │
                    │   Auth (Sessions)  │
                    └────────────────────┘
```

**Core principle: Write to Drift first. Always. The app is fully functional offline. Appwrite is a sync target, not a dependency.**

---

## 25. Database Schema (Appwrite + Drift)

| Collection ID | Purpose | Key Fields | Conflict Strategy |
|--------------|---------|-----------|------------------|
| `users` | Profile, karma level, dosha | `userId`, `karmaXP`, `karmaLevel`, `weddingDate`, `isPro` | lastWriteWins |
| `food_logs` | Meal tracking per day | `mealType`, `calories`, `loggedAt`, `foodItemId` | lastWriteWins |
| `food_database` | Indian food master (50k+ items) | `name`, `nameHindi`, `caloriesPer100g`, `barcode` | read-only |
| `bp_readings` | Blood pressure history | `systolic`, `diastolic`, `pulse`, `classification` | manualReview |
| `glucose_readings` | Blood glucose history | `valueMgDl`, `readingType`, `linkedFoodLogId` | manualReview |
| `sleep_logs` | Sleep sessions | `sleepStart`, `sleepEnd`, `qualityScore`, `spO2Avg` | lastWriteWins |
| `workouts` | Workout sessions | `workoutType`, `totalVolume`, `durationSecs` | lastWriteWins |
| `workout_sets` | Exercise sets detail | `exerciseName`, `reps`, `weight`, `setOrder` | lastWriteWins |
| `habits` | Habit definitions + streaks | `name`, `completedDates`, `currentStreak` | lastWriteWins |
| `journal` | Rich text entries | `body`, `moodScore`, `tags`, `isLocked` | lastWriteWins |
| `karma_events` | XP event log | `eventType`, `xpAwarded`, `occurredAt` | append-only |
| `festivals` | Indian calendar events | `name`, `date`, `type`, `fastingGuide` | read-only (server) |
| `medications` | Medication schedules | `name`, `dosage`, `schedule`, `refillDate` | manualReview |
| `water_logs` | Water intake entries | `amountMl`, `loggedAt` | lastWriteWins |
| `lab_reports` | Lab file metadata | `valuesJson`, `fileId`, `reportDate` | lastWriteWins |
| `social_posts` | Group posts | `content`, `groupId`, `reactions` | lastWriteWins |
| `groups` | Family/friend groups | `members`, `groupType`, `name` | lastWriteWins |
| `share_tokens` | Expiring share links | `reportId`, `token`, `expiresAt` | server-only |

**Every user-data collection has:** `localId` (UUID on device) · `userId` · `syncStatus` ('pending'/'synced'/'dlq') · `isDeleted` (bool) · `deletedAt` (nullable) · `updatedAt` (timestamp)

---

## 26. State Management — Riverpod 2.x

```dart
// Standard pattern for all mutations
@riverpod
class FoodLogNotifier extends _$FoodLogNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> logFood(FoodLogsCompanion entry) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // 1. Write to local Drift DB immediately
      await ref.read(appDatabaseProvider).into(db.foodLogs).insert(entry);
      // 2. Trigger background sync (non-blocking)
      unawaited(ref.read(syncWorkerProvider).syncTable('food_logs'));
      // 3. Award XP
      await ref.read(karmaNotifierProvider.notifier).awardXP(XPEvent.foodLog);
    });
  }
}

// Reactive stream provider for live UI
@riverpod
Stream<List<FoodLog>> todayFoodLogs(TodayFoodLogsRef ref) {
  final db = ref.watch(appDatabaseProvider);
  final now = DateTime.now();
  final startTs = DateTime(now.year, now.month, now.day)
      .millisecondsSinceEpoch ~/ 1000;
  return (db.select(db.foodLogs)
    ..where((t) => t.userId.equals(ref.watch(currentUserIdProvider)))
    ..where((t) => t.loggedAt.isBetweenValues(startTs, startTs + 86400))
    ..where((t) => t.isDeleted.equals(false))
    ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
    .watch();
}
```

---

## 27. Offline-First Architecture — Drift

### Sync Status Lifecycle

```
Device write → syncStatus = 'pending'
               ↓
    SyncWorker picks up pending records
    On connectivity (every 15/30min or 6h by tier)
               ↓
    Push to Appwrite → success → syncStatus = 'synced', remoteId stored
                    → failure → failedAttempts++
                    → failedAttempts ≥ 3 → syncStatus = 'dlq'
                                            → DLQAlertBanner shown
```

### Drift Schema (key excerpt)

```dart
@DriftDatabase(tables: [
  FoodLogs, BpReadings, GlucoseReadings, SleepLogs,
  Workouts, WorkoutSets, Habits, Journal, WaterLogs,
  Users, KarmaEvents, Medications, LabReports,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.addColumn(foodLogs, foodLogs.failedAttempts);
      if (from < 3) {
        await m.addColumn(foodLogs,   foodLogs.remoteId);
        await m.addColumn(bpReadings, bpReadings.remoteId);
      }
      if (from < 4) {
        await m.addColumn(users, users.isPro);
        await m.addColumn(users, users.weddingDate);
        await m.createTable(sleepLogs);
      }
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );
}

// Encrypted DB — AES-256 via SQLCipher
Future<AppDatabase> openEncryptedDatabase() async {
  final dir  = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'fitkarma.db');
  final key  = await _getOrCreateDbKey(); // Stored in platform keychain
  return AppDatabase(NativeDatabase.createInBackground(
    File(path),
    setup: (db) {
      db.execute("PRAGMA key = '$key'");
      db.execute("PRAGMA cipher_page_size = 4096");
    },
  ));
}
```

---

## 28. Sync Engine

```dart
class SyncWorker {
  Future<void> syncPending() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return;

    // Priority order — critical medical data first
    await _syncBpReadings();      // critical
    await _syncGlucoseReadings(); // critical
    await _syncMedications();     // critical
    await _syncWorkouts();        // high
    await _syncSleepLogs();       // high
    await _syncFoodLogs();        // medium
    await _syncHabits();          // medium
    await _syncWaterLogs();       // low
    await _syncJournalEntries();  // low
    await _syncSocialPosts();     // low
  }

  Future<void> _syncTable(
    String collectionId,
    List<SyncableRow> pendingRows,
    ConflictStrategy strategy,
  ) async {
    for (final row in pendingRows) {
      try {
        if (row.remoteId == null) {
          // Create
          final doc = await _databases.createDocument(
            databaseId: AppConfig.dbId,
            collectionId: collectionId,
            documentId: row.localId,
            data: row.toJson(),
            permissions: [
              Permission.read(Role.user(row.userId)),
              Permission.update(Role.user(row.userId)),
              Permission.delete(Role.user(row.userId)),
            ],
          );
          await _markSynced(row, doc.$id);
        } else {
          // Update
          if (strategy == ConflictStrategy.manualReview) {
            await _handleConflict(row, collectionId);
          } else {
            await _databases.updateDocument(
              databaseId: AppConfig.dbId,
              collectionId: collectionId,
              documentId: row.remoteId!,
              data: row.toJson(),
            );
            await _markSynced(row, row.remoteId!);
          }
        }
      } catch (e) {
        await _incrementFailedAttempts(row);
      }
    }
  }
}

Duration syncInterval(DeviceTier tier) => switch (tier) {
  DeviceTier.low  => const Duration(hours: 6),
  DeviceTier.mid  => const Duration(minutes: 30),
  DeviceTier.high => const Duration(minutes: 15),
};
```

---

## 29. Authentication

```dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    try {
      return await Account(ref.read(appwriteClientProvider)).get();
    } on AppwriteException {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    await Account(ref.read(appwriteClientProvider))
        .createEmailPasswordSession(email: email, password: password);
    ref.invalidateSelf();
  }

  Future<void> signUp(String email, String password, String name) async {
    final account = Account(ref.read(appwriteClientProvider));
    await account.create(userId: ID.unique(), email: email, password: password, name: name);
    await account.createEmailPasswordSession(email: email, password: password);
    ref.invalidateSelf();
  }

  Future<void> logout() async {
    await Account(ref.read(appwriteClientProvider))
        .deleteSession(sessionId: 'current');
    await ref.read(appDatabaseProvider).customStatement('DELETE FROM users WHERE 1=1');
    ref.invalidateSelf();
    GoRouter.of(navigatorKey.currentContext!).go('/auth/login');
  }
}

// Biometric gate — required for: Journal, Lab Reports, BP/Glucose, Period Tracker
class BiometricLock {
  static Future<bool> authenticate({String reason = 'Authenticate to view health data'}) async {
    final la = LocalAuthentication();
    final canAuth = await la.canCheckBiometrics;
    if (!canAuth) return true; // No hardware → grant access
    return la.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(stickyAuth: true, biometricOnly: false),
    );
  }
}
```

---

## 32. Security & Encryption

| Data Type | Local Storage | Remote Storage | Encryption |
|-----------|-------------|----------------|-----------|
| Health readings (BP, glucose, sleep) | SQLCipher (AES-256) | Appwrite Documents | AES-256 + TLS 1.3 |
| Journal entries | SQLCipher (AES-256) | Appwrite Documents | AES-256 + TLS 1.3 |
| Lab report files | — | Appwrite Storage | Server-side AES + antivirus scan |
| Auth tokens | Appwrite HTTP-only session cookie | HTTP-only cookie | TLS in transit |
| DB encryption key | Platform keychain (iOS Keychain, Android Keystore) | Never transmitted | Platform-level secure enclave |

**Permission model:** Every Appwrite document uses strict per-user permissions:
```dart
permissions: [
  Permission.read(Role.user(userId)),
  Permission.update(Role.user(userId)),
  Permission.delete(Role.user(userId)),
]
// NEVER: Permission.read(Role.any()) or Permission.read(Role.users())
```

---

## 33. Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Cold launch | < 2.5s | From tap to dashboard visible |
| Frame render | < 16ms | 60fps on mid-tier device |
| Drift date-range query | < 50ms | 90th percentile |
| Sync batch (50 records) | < 3s | On 4G network |
| Food search results | < 300ms | From keystroke debounce |
| Image load | < 500ms | With CachedNetworkImage |

### Performance Rules
- `CachedNetworkImage` always — never `Image.network`
- Drift `.watch()` for reactive queries — never poll
- `ListView.builder` for all lists — always lazy rendering
- `ref.watch(provider.select(...))` for narrow widget rebuilds
- `RepaintBoundary` on `ActivityRings`, `BreathingCircle`, all CustomPainters
- Parse large JSON (food database) in `compute()` isolates
- Image quality adapted per device tier: low=75%, mid=85%, high=100%

---

## 37. Karma & Gamification Engine

### XP Event Table

| Event | XP | Notes |
|-------|----|----|
| Log any food item | +5 | Max 20 XP/day from food logging |
| Complete all meals logged | +20 | All 4 meal types logged |
| Complete workout | +30 | Any workout type |
| Hit daily steps goal | +25 | Auto via Health Connect |
| Log sleep | +10 | Once per day |
| Log BP reading | +10 | Once per day |
| Log glucose reading | +10 | Once per day |
| Complete habit | +15 | Per habit, per day |
| Journal entry | +10 | Once per day |
| 7-day streak | +50 | Consecutive days of any activity |
| 30-day streak | +150 | Major milestone |
| Upload lab report | +20 | Per report |
| Refer a friend | +500 | After friend completes onboarding |

### Level Thresholds

| Level | Name | XP Required |
|-------|------|-------------|
| 1 | Newcomer | 0 |
| 2 | Beginner | 200 |
| 3 | Starter | 500 |
| 4 | Mover | 1,000 |
| 5 | Achiever | 1,800 |
| 6 | Consistent | 2,800 |
| 7 | Dedicated | 4,200 |
| 8 | Warrior | 6,000 |
| 9 | Legend | 8,500 |
| 10 | Champion | 12,000 |
| 11 | Master | 16,000 |
| 12 | Elite | 21,000 |

### Level Up UX
```
When level increases:
1. LevelUpAnimation widget: full-screen overlay, 1.2s
   - Particle burst (orange/amber)
   - Level badge scales in (bouncy spring)
   - "Level {N}" displayLg, white, center
   - New level name below
2. +XP SnackBar with new level name
3. Optional haptic feedback (HapticFeedback.heavyImpact)
```

---

## 40. Notification System

### Notification Types & Timing

| Notification | Trigger | Default Time | Channel |
|-------------|---------|-------------|---------|
| Meal reminder (Breakfast) | Daily if no log by time | 8:30 AM | meal_reminders |
| Meal reminder (Lunch) | Daily if no log by time | 1:30 PM | meal_reminders |
| Meal reminder (Dinner) | Daily if no log by time | 8:00 PM | meal_reminders |
| Water reminder | Every 2h if intake < 50% | 10 AM–8 PM | water_reminders |
| Medication due | Per schedule | User-defined | medication (high priority) |
| Streak at risk | 9 PM if no activity logged | 9:00 PM | streaks |
| Step goal milestone | When 80% goal reached | Real-time | activity |
| AI insight ready | When new insight computed | 8:00 AM | insights |
| XP milestone | On level up | Real-time | karma |

```dart
class NotificationService {
  static Future<void> init() async {
    await FlutterLocalNotificationsPlugin().initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false, // Request via onboarding screen
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  static Future<void> scheduleMealReminder(MealType meal, TimeOfDay time) async {
    await FlutterLocalNotificationsPlugin().zonedSchedule(
      meal.notificationId,
      'Time to log ${meal.name}! 🍽',
      'Track your meal to maintain your streak and earn XP.',
      tz.TZDateTime.now(tz.local).add(/* calculate next occurrence */),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_reminders', 'Meal Reminders',
          importance: Importance.defaultImportance,
          color: const Color(0xFFFF6B35),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
```

---

## 43. Error Handling & Observability

### Error Classification

| Error Type | User Impact | Handling |
|-----------|-------------|---------|
| Drift write failure | Data loss risk | Show ErrorRetryWidget, log to Sentry |
| Sync failure (1–2x) | Background, silent | Increment failedAttempts |
| Sync DLQ (≥3x) | DLQAlertBanner shown | User must resolve in Settings |
| Auth expired | Session lost | Navigate to /auth/login, persist local data |
| Network timeout | Background sync delayed | Silent, retry on next interval |
| Appwrite Function error | AI/XP feature down | Graceful degradation, local fallback |
| Biometric failure | Screen locked | Show PIN fallback if set |
| Critical (crash) | App crash | Sentry captures, stripped of PII |

```dart
// main.dart — Global error handlers
FlutterError.onError = (details) {
  FlutterError.presentError(details);
  Sentry.captureException(details.exception, stackTrace: details.stack);
};

// Sentry config — PII stripped
SentryFlutter.init((options) {
  options.dsn = const String.fromEnvironment('SENTRY_DSN');
  options.tracesSampleRate = 0.2;
  options.environment = const String.fromEnvironment('APP_ENV', defaultValue: 'production');
  options.beforeSend = (event, hint) => event.copyWith(user: null); // Strip user PII
});
```

---

# PART III — ENTERPRISE HARDENING

---

## 46. Clean Architecture — Layer Separation

```
features/blood_pressure/
├── data/
│   ├── datasources/
│   │   ├── bp_local_datasource.dart   # Drift reads/writes only
│   │   └── bp_remote_datasource.dart  # Appwrite reads/writes only
│   ├── models/
│   │   └── bp_reading_model.dart      # JSON ↔ Entity conversion
│   └── repositories/
│       └── bp_repository_impl.dart    # Implements domain interface
├── domain/
│   ├── entities/
│   │   └── bp_reading.dart            # Pure Dart, no Flutter imports
│   ├── repositories/
│   │   └── bp_repository.dart         # Abstract interface
│   └── usecases/
│       ├── log_bp_reading.dart
│       ├── get_bp_history.dart
│       └── classify_bp.dart
└── presentation/
    ├── providers/
    │   └── bp_providers.dart          # Riverpod notifiers/streams
    └── screens/
        └── blood_pressure_screen.dart
```

**Dependency rule:** Domain layer has zero dependencies on data or presentation layers. Data layer depends on domain. Presentation depends on domain only (via providers).

---

## 49. Soft Delete System

```dart
// Every user-deletable table gets these columns:
class FoodLogs extends Table {
  // ... other columns ...
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn  get deletedAt => integer().nullable()();
}

// EVERY query must filter deleted records:
(select(foodLogs)
  ..where((t) => t.isDeleted.equals(false))
  ..where((t) => t.loggedAt.isBetweenValues(start, end)))
.watch()

// Soft delete + undo pattern:
Future<void> deleteFood(FoodLog log) async {
  // 1. Soft-mark as deleted
  await _db.update(_db.foodLogs)
    ..where((t) => t.localId.equals(log.localId))
    ..write(FoodLogsCompanion(
      isDeleted: const Value(true),
      deletedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
      syncStatus: const Value('pending'),
    ));

  // 2. Show undo SnackBar for 4 seconds
  _scaffoldKey.currentState?.showSnackBar(
    SnackBar(
      content: const Text('Meal deleted'),
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => _undoDelete(log),
      ),
    ),
  );
}
```

---

## 52. Security Threat Model

| Threat Vector | Mitigation Strategy |
|--------------|-------------------|
| Rooted/jailbroken device | SQLCipher AES-256 at page level; DB unreadable without keychain key |
| MITM network attack | Certificate pinning + TLS 1.3 minimum |
| Session token theft | Appwrite HTTP-only cookies (not accessible to JS) |
| Screenshot leak (sensitive screens) | `FLAG_SECURE` + `WindowSecureFlag` on Journal, Lab Reports, BP, Glucose |
| Android backup exposure | `android:allowBackup="false"` in AndroidManifest |
| Binary reverse engineering | All secrets via `--dart-define` + server-side Appwrite Functions |
| Concurrent account access | Appwrite session per device, invalidate all on password change |
| DPDP Act (India) compliance | Data residency path via Appwrite self-host option; Privacy Policy linked |

---

# PART IV — CRITICAL FIXES

---

## §F1. Indian Food Database Integration

### Architecture
```
Food search flow:
1. User types → debounce 300ms → query local food_database Drift table
2. If < 5 local results → call food-search Appwrite Function → Appwrite food_database collection
3. If barcode scanned → call Open Food Facts API (via Appwrite Function proxy)
4. User selects food → log to food_logs table
```

### Local Drift Cache
```dart
class FoodDatabase extends Table {
  TextColumn  get id             => text()();
  TextColumn  get name           => text()();
  TextColumn  get nameHindi      => text().nullable()();
  TextColumn  get nameRegional   => text().nullable()();
  TextColumn  get category       => text()(); // 'dal', 'roti', 'sabzi', etc.
  TextColumn  get cuisine        => text()(); // 'north-indian', 'south-indian', etc.
  RealColumn  get caloriesPer100g => real()();
  RealColumn  get proteinPer100g => real()();
  RealColumn  get carbsPer100g   => real()();
  RealColumn  get fatPer100g     => real()();
  RealColumn  get fiberPer100g   => real()();
  TextColumn  get emoji          => text()();
  TextColumn  get barcode        => text().nullable()();
  TextColumn  get source         => text()(); // 'icmr', 'usda', 'manual', 'openfoodfacts'
  TextColumn  get servingSizesJson => text()(); // JSON array of serving options

  @override
  Set<Column> get primaryKey => {id};
}
```

### Seed Data Categories (minimum 5,000 items at launch)
- Dals & legumes: 20 varieties (toor, moong, masoor, chana, etc.)
- Breads: roti, paratha, puri, naan, bhatura, dosa, idli, uttapam, appam (15 varieties)
- Rice dishes: plain rice, biryani, khichdi, pulao (10 varieties)
- Sabzis & curries: aloo gobhi, palak paneer, rajma, etc. (30 varieties)
- Non-veg: chicken curry, mutton, fish, egg preparations (15 varieties)
- Snacks: samosa, vada, dhokla, poha, upma, namkeen (20 varieties)
- Sweets: gulab jamun, halwa, kheer, barfi, ladoo (20 varieties)
- Street food: pav bhaji, pani puri, bhel, biryani (15 varieties)
- South Indian: idli, dosa, sambhar, rasam, etc. (20 varieties)
- Beverages: chai, lassi, nimbu pani, buttermilk (10 varieties)
- Packaged foods with ICMR verified values (100+ items)

---

## §F2. AI Insight Engine & LLM Coach

### Rule-Based Insights (Free Tier — always available)

```dart
List<HealthInsight> generateRuleBasedInsights(HealthContext ctx) => [
  if (ctx.avgSleepHours < 6.5)
    HealthInsight(
      id: 'low-sleep',
      icon: '🛌',
      title: 'Prioritize sleep',
      body: 'You averaged ${ctx.avgSleepHours.toStringAsFixed(1)}h sleep '
            'this week. Under 7h is linked to higher hunger hormones '
            'and lower workout performance.',
    ),
  if (ctx.avgDailySteps < ctx.stepsGoal * 0.7)
    HealthInsight(
      id: 'low-steps',
      icon: '🚶',
      title: 'Close your step gap',
      body: 'You\'re hitting ${(ctx.avgDailySteps / ctx.stepsGoal * 100).round()}% '
            'of your goal. A 15-minute walk after lunch adds ~1,500 steps.',
    ),
  if (ctx.streakDays >= 7)
    HealthInsight(
      id: 'streak-celebrate',
      icon: '🔥',
      title: '${ctx.streakDays}-day streak! 🔥',
      body: 'You\'ve logged consistently for ${ctx.streakDays} days. '
            'Research shows 3-week habits become automatic.',
    ),
];
```

### LLM Coach (Pro Tier — Appwrite Function + Groq Llama-3)

```js
// functions/ai-coach/src/main.js
import Groq from 'groq-sdk';
const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

export default async ({ req, res, log }) => {
  const { userId, message, healthContext } = JSON.parse(req.body);

  // Rate limiting: 30 messages per user per month
  const usageKey = `ai_usage_${userId}_${new Date().toISOString().slice(0, 7)}`;
  const currentUsage = parseInt(await databases.getDocument('fitkarma-db', 'usage', usageKey)
    .then(d => d.count).catch(() => '0'));
  
  if (currentUsage >= 30) {
    return res.json({ error: 'Monthly limit reached', code: 'RATE_LIMITED' });
  }

  const systemPrompt = `You are FitKarma AI Coach, a friendly and knowledgeable health 
assistant specialized in Indian nutrition, fitness, and wellness. You have context about 
the user's recent health data. Be encouraging, specific, and actionable. Keep responses 
concise (max 3 paragraphs). Never provide medical diagnoses.

User health context (last 7 days):
${JSON.stringify(healthContext, null, 2)}`;

  const response = await groq.chat.completions.create({
    model: 'llama-3.1-8b-instant',
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: message },
    ],
    max_tokens: 512,
    temperature: 0.7,
  });

  // Increment usage counter
  await databases.updateDocument('fitkarma-db', 'usage', usageKey, {
    count: currentUsage + 1,
  }).catch(() => databases.createDocument('fitkarma-db', 'usage', usageKey, {
    count: 1, userId,
  }));

  return res.json({
    reply: response.choices[0].message.content,
    tokensUsed: response.usage.total_tokens,
    messagesRemaining: 30 - (currentUsage + 1),
  });
};
```

---

## §F3. iOS HealthKit — Full Implementation

```dart
// Required in ios/Runner/Info.plist:
// NSHealthShareUsageDescription → "FitKarma reads your health data to track fitness"
// NSHealthUpdateUsageDescription → "FitKarma writes workouts to Apple Health"

// Required entitlements: HealthKit capability in Xcode

class HealthKitService {
  static final _health = Health();

  static const _readTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.EXERCISE_TIME,
  ];

  static const _writeTypes = [
    HealthDataType.STEPS,
    HealthDataType.WORKOUT,
  ];

  static Future<bool> requestPermissions() async {
    if (!Platform.isIOS) return false;
    return _health.requestAuthorization(_readTypes, permissions: _writeTypes);
  }

  static Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final data = await _health.getHealthDataFromTypes(
      startTime: midnight, endTime: now,
      types: [HealthDataType.STEPS],
    );
    return data.fold<int>(0, (sum, p) =>
        sum + (p.value as NumericHealthValue).numericValue.toInt());
  }

  // Background delivery (iOS only — updates even when app is suspended)
  static Future<void> enableBackgroundDelivery() async {
    await _health.enableBackgroundDelivery(
      HealthDataType.STEPS,
      frequency: HealthWorkoutActivityType.values.first,
    );
  }
}
```

---

## §F4. Subscription Model & Monetisation

### Tiers

| Feature | Free | Pro (₹199/mo or ₹1,499/yr) |
|---------|------|---------------------------|
| Basic health tracking | ✓ | ✓ |
| Step & calorie logging | ✓ | ✓ |
| BP, glucose, sleep | ✓ | ✓ |
| Unlimited food logging | ✓ | ✓ |
| Lab report storage | 3 max | Unlimited |
| AI Coach | ✗ | ✓ (30 msg/mo) |
| Advanced trend analysis | ✗ | ✓ |
| Wedding fit plan | ✗ | ✓ |
| Priority sync (15min) | ✗ | ✓ |
| Custom karma badges | ✗ | ✓ |
| Early feature access | ✗ | ✓ |

### RevenueCat Integration

```dart
class SubscriptionService {
  static Future<void> init() async {
    await Purchases.configure(
      PurchasesConfiguration(
        Platform.isIOS
          ? const String.fromEnvironment('RC_IOS_KEY')
          : const String.fromEnvironment('RC_ANDROID_KEY'),
      ),
    );
  }

  static Future<bool> isPro() async {
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.active.containsKey('pro');
  }

  static Future<void> purchasePro(bool yearly) async {
    final offerings = await Purchases.getOfferings();
    final package = yearly
        ? offerings.current?.annual
        : offerings.current?.monthly;
    if (package != null) {
      await Purchases.purchasePackage(package);
    }
  }

  // 7-day free trial configured in App Store Connect + Google Play
  static Future<bool> isEligibleForTrial() async {
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.active.isEmpty &&
           info.allPurchaseDates.isEmpty;
  }
}
```

---

## 45. Glossary & Architecture Decisions

### Glossary

| Term | Definition |
|------|-----------|
| **DLQ** | Dead Letter Queue — records that failed to sync 3+ times. User must resolve in Settings → Data & Sync. |
| **Optimistic UI** | UI updates immediately from Drift write; Appwrite sync happens in background. App never blocks on network. |
| **Calm Zone** | Screens with sensitive content (Settings, Journal, Emergency, Lab Reports). Zero glow, blur, animations on ALL device tiers. |
| **syncStatus** | `pending` → `synced` → `dlq`. Drives all sync worker decisions. |
| **localId** | UUID generated on device before any network access. Never null. Prevents duplicate creation on retry. |
| **UX Stage** | `firstWeek / familiar / expert`. Controls onboarding tooltip density and coach card visibility. |
| **Single Hero Rule** | Exactly one `metricXL` or `heroDisplay` per visible scroll area. Two competing heroes = visual noise. |
| **Rule of Two** | No surface may have more than 2 simultaneous visual effects. |
| **Soft Delete** | `isDeleted = true` instead of hard DELETE. Enables undo, sync recovery, audit trails, and conflict resolution. |
| **Device Tier** | Low/Mid/High based on device RAM. Gates expensive visual effects to maintain 60fps on ₹7,000 phones. |
| **Bento Grid** | 2-column asymmetric card grid. Each cell is independently sized. Used on Dashboard and Karma screens. |
| **Pattern A/B/C** | Three scaffold archetypes. A = standard scroll. B = hero + overlapping body. C = full-bleed. |

### Architecture Decision Records

| ADR | Decision | Rationale |
|-----|---------|-----------|
| ADR-001 | **Drift over Hive** | SQL joins needed for date-range queries and glucose → food log relational links. |
| ADR-002 | **Riverpod over Bloc** | Simpler async composition, better `AsyncValue`, code generation reduces boilerplate. |
| ADR-003 | **Appwrite over Firebase** | Self-hostable (India data residency), open-source, no per-read billing, CLI-first workflow. |
| ADR-004 | **SQLCipher for encryption** | AES-256 at the SQLite page level. Key stored in platform keychain. Raw `.db` file is unreadable without the key. |
| ADR-005 | **Soft Delete** | Health data is irreplaceable. Undo support and cross-device conflict recovery require soft delete. |
| ADR-006 | **Pure Dart Animations** | Consistent with token system, zero-latency start, no third-party versioning risk. |
| ADR-007 | **`--dart-define` for secrets** | No secrets in source. Separate build targets for dev/staging/prod. |
| ADR-008 | **Sentry over Crashlytics** | Self-hostable option, no Google telemetry, avoids GCP lock-in. PII stripping enforced. |
| ADR-009 | **lastWriteWins + manualReview** | Clinical records (BP, glucose, medications) must never auto-overwrite. Food/habits use lastWriteWins. |
| ADR-010 | **Open Food Facts + Custom Indian DB** | OFF provides 3M+ global items (free, open-source). Custom Appwrite collection provides 50k+ Indian items with Hindi names and regional variants. |
| ADR-011 | **LLM via Appwrite Function** | Keeps Groq API key server-side. Enables rate limiting, logging, and model swapping without app release. |
| ADR-012 | **RevenueCat for subscriptions** | Handles App Store + Play Store receipts, entitlement management, and webhooks in one SDK. Avoids custom billing backend. |

---

## Master Checklist — Launch Readiness

### Pre-Launch (P0 — must complete before ship)

- [ ] §F1: Seed Indian food database (5,000+ items at launch target)
- [ ] §F1: Open Food Facts barcode scan integration tested on real device
- [ ] §F2: AI Coach Appwrite Function deployed with Groq API key set in env vars
- [ ] §F3: iOS HealthKit entitlements configured in Xcode + tested on physical iPhone
- [ ] §F4: RevenueCat configured with App Store + Play Store product IDs
- [ ] §F4: 7-day free trial configured and tested end-to-end
- [ ] All 17 Appwrite collections created via CLI commands
- [ ] Unified `fitkarma-cores` Appwrite Function deployed and activated
- [ ] Single `fitkarma-vault` storage bucket created with prefix-based organization
- [ ] All `--dart-define` environment variables set for all build flavors (dev/staging/prod)
- [ ] Biometric lock tested on physical device (Journal, Lab Reports, BP, Glucose)
- [ ] Offline → online sync round-trip tested on real device in Airplane mode
- [ ] DLQ alert banner appears correctly after 3 consecutive sync failures
- [ ] GlassCard blur disabled on DeviceTier.low devices (< 2GB RAM)
- [ ] Golden tests generated and passing for all 5 primary screens
- [ ] DPDP Act compliance: Privacy Policy written and linked in app
- [ ] All 5 onboarding screens functioning end-to-end on fresh install
- [ ] Level Up animation fires correctly on karma level change
- [ ] Crisis helplines visible and callable on Emergency Card screen
- [ ] EncryptionBadge visible on Journal, BP, Glucose, and Lab Reports

### Post-Launch (P1 — within 30 days)

- [ ] Indian food database expanded to 10,000+ items
- [ ] AI Coach rate limiting tuned based on real usage data
- [ ] HealthKit background delivery tested on iPhone for overnight sleep data
- [ ] Sentry error dashboard configured with PII stripping verified in production
- [ ] Home widget for iOS: today's steps + karma score
- [ ] Home widget for Android: today's steps + karma score
- [ ] Push notification open rates measured and meal reminder timing A/B tested
- [ ] Subscription conversion funnel analyzed (trial start → paid)
- [ ] Wedding mode end-to-end tested with synthetic user data

---

_FitKarma — Enhanced Complete Documentation_
_UI Design System · Screen-by-Screen UI/UX · Technical Implementation · Enterprise Hardening · Critical Fixes_
_Flutter 3.x · Riverpod 2.x · Drift · Appwrite CLI · RevenueCat · Open Food Facts · Groq Llama-3_
_Offline-first · AES-256 encrypted · Privacy-centric · Built for India_
_26 screens with full UI/UX specs · 28 shared components · 17 Appwrite collections · 5 Appwrite Functions_
_Complete design token system · Comprehensive color semantics · Animation spec · Device tier system_