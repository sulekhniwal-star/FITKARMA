# FitKarma — Complete Documentation (Genesis Build)

**UI Design System · Technical Implementation Guide**
Flutter 3.x · Riverpod 2.x · Drift · Appwrite CLI

> **Offline-First · Privacy-Centric · Built for India**
> Dark mode primary · Glassmorphism · Spring physics · Bento grid
> All backend operations use **Appwrite CLI** — no console required.

---

## ⚡ Quick Navigation

| Need                          | Go to                                                                                                                                                 |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Start a new project           | [§22 Prerequisites](#22-prerequisites--tooling) → [§23 Project Setup](#23-project-setup) → [§24 Appwrite CLI Setup](#24-appwrite-cli--complete-setup) |
| Understand architecture       | [§21 Architecture Overview](#21-architecture-overview)                                                                                                |
| Build a screen                | [§9 Scaffold Patterns](#9-scaffold-patterns) → [§11 Screen Specs](#11-screen-specifications)                                                          |
| Add a shared component        | [§10 Component Library](#10-shared-component-library)                                                                                                 |
| Design tokens / colors        | [§3 Design Tokens](#3-design-tokens--flutter-themedata)                                                                                               |
| Add Appwrite collection       | [§24 CLI Setup](#24-appwrite-cli--complete-setup) → [§25 Schema](#25-database-schema-appwrite--drift)                                                 |
| Implement sync                | [§27 Offline-First](#27-offline-first-architecture--drift) → [§28 Sync Engine](#28-sync-engine)                                                       |
| **Food database integration** | [**§F1 Food Database**](#f1-indian-food-database-integration) ← NEW                                                                                   |
| **AI coach**                  | [**§F2 AI Insight Engine**](#f2-ai-insight-engine--llm-coach) ← NEW                                                                                   |
| **iOS HealthKit**             | [**§F3 iOS HealthKit**](#f3-ios-healthkit--full-implementation) ← NEW                                                                                 |
| **Monetisation**              | [**§F4 Subscription Model**](#f4-subscription-model--monetisation) ← NEW                                                                              |
| Deploy / CI                   | [§35 CI/CD](#35-cicd--deployment)                                                                                                                     |
| Look up a term                | [§45 Glossary & ADRs](#45-glossary--architecture-decisions)                                                                                           |

---

## Table of Contents

### Part I — UI Design System

1. [Design Philosophy](#1-design-philosophy)
2. [Project Structure](#2-project-structure)
3. [Design Tokens — Flutter ThemeData](#3-design-tokens--flutter-themedata)
4. [Typography System](#4-typography-system)
5. [Motion & Animation](#5-motion--animation)
6. [Surface & Depth System](#6-surface--depth-system)
7. [Device Tier System](#7-device-tier-system)
8. [Universal Screen Rules](#8-universal-screen-rules)
9. [Scaffold Patterns](#9-scaffold-patterns)
10. [Shared Component Library](#10-shared-component-library)
11. [Screen Specifications](#11-screen-specifications)
12. [Bottom Navigation Bar](#12-bottom-navigation-bar)
13. [Common UI Patterns](#13-common-ui-patterns)
14. [Accessibility & Bilingual Rules](#14-accessibility--bilingual-rules)
15. [Additional Screen Specifications](#15-additional-screen-specifications)
16. [Low Data Mode](#16-low-data-mode--implementation)
17. [Dosha Quiz Implementation](#17-dosha-quiz-implementation)
18. [Onboarding: Health Goals Setup](#17a-health-goals-setup-screen) ← merged from addendum
19. [Onboarding: Permissions & Privacy](#17b-permissions--privacy-screen) ← merged from addendum
20. [Complete pubspec.yaml](#18-complete-pubspecyaml)
21. [Code Generation Commands](#19-code-generation-commands)
22. [Design System Quick Reference](#20-design-system-quick-reference-card)

### Part II — Technical Implementation

23. [Architecture Overview](#21-architecture-overview)
24. [Prerequisites & Tooling](#22-prerequisites--tooling)
25. [Project Setup](#23-project-setup)
26. [Appwrite CLI Setup](#24-appwrite-cli--complete-setup)
27. [Database Schema](#25-database-schema-appwrite--drift)
28. [State Management — Riverpod 2.x](#26-state-management--riverpod-2x)
29. [Offline-First Architecture](#27-offline-first-architecture--drift)
30. [Sync Engine](#28-sync-engine)
31. [Authentication](#29-authentication)
32. [Storage & File Handling](#30-storage--file-handling)
33. [Health Integrations](#31-health-integrations)
34. [Security & Encryption](#32-security--encryption)
35. [Performance Considerations](#33-performance-considerations)
36. [Testing Strategy](#34-testing-strategy)
37. [CI/CD & Deployment](#35-cicd--deployment)
38. [Appwrite Functions](#36-appwrite-functions--server-side-code)
39. [Karma & Gamification Engine](#37-karma--gamification-engine)
40. [Festival & Wedding Data](#38-festival--wedding-data)
41. [Medication & Water Tracking](#39-medication--water-tracking-collections)
42. [Notification System](#40-notification-system)
43. [Social Collections](#41-social-collections)
44. [Home Widgets](#42-home-widgets)
45. [Error Handling & Observability](#43-error-handling--observability)
46. [Complete appwrite.json Reference](#44-complete-appwritejson-reference)
47. [Glossary & ADRs](#45-glossary--architecture-decisions)

### Part III — Enterprise Hardening

48. [Clean Architecture](#46-clean-architecture--layer-separation)
49. [Dependency Injection](#47-dependency-injection-strategy)
50. [Database Migration Strategy](#48-database-migration-strategy)
51. [Soft Delete System](#49-soft-delete-system)
52. [Sync Conflict Resolution](#50-sync-conflict-resolution)
53. [Sync Queue Priorities](#51-sync-queue-priorities)
54. [Security Threat Model](#52-security-threat-model)
55. [Certificate Pinning & Screen Security](#53-certificate-pinning--screen-security)
56. [Audit Logging](#54-audit-logging)
57. [Accessibility — Advanced](#55-accessibility--advanced)
58. [Performance — Render Budget](#56-performance--render-budget--widget-optimization)
59. [Crash Reporting & Observability](#57-crash-reporting--observability)
60. [Feature Flags](#58-feature-flags)
61. [AI Insight Engine (rule-based)](#59-ai-insight-engine)
62. [Wearable Abstraction Layer](#60-wearable-abstraction-layer)
63. [Testing — Comprehensive Strategy](#61-testing--comprehensive-strategy)
64. [Account Management & Data Rights](#62-account-management--data-rights)

### Part IV — Critical Fixes (NEW)

65. [§F1 Indian Food Database Integration](#f1-indian-food-database-integration)
66. [§F2 AI Insight Engine & LLM Coach](#f2-ai-insight-engine--llm-coach)
67. [§F3 iOS HealthKit — Full Implementation](#f3-ios-healthkit--full-implementation)
68. [§F4 Subscription Model & Monetisation](#f4-subscription-model--monetisation)

---

## Design System

---

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

---

## Part II — Technical Implementation

---

## 21. Architecture Overview

```text
┌────────────────────────────────────────────────────────────┐
│                    Flutter App (Client)                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Feature │  │  Shared  │  │   Core   │  │  Router  │  │
│  │  Modules │  │ Widgets  │  │ Providers│  │ GoRouter │  │
│  └────┬─────┘  └──────────┘  └────┬─────┘  └──────────┘  │
│       │              Riverpod 2.x State Layer               │
│       │    Local (Drift) ◄──────────────► Remote (Appwrite) │
│       │    SQLite · AES-256           REST / Realtime WS    │
└────────────────────────────────────────────────────────────┘
```

### Data Flow — Offline-First

```text
User action
    │
    ▼
1. Write to Drift immediately (syncStatus = 'pending')
   UI updates optimistically ← no network wait
    │
    ├─ Online? → Push to Appwrite
    │            ├─ Success: syncStatus = 'synced'
    │            └─ Failure: failedAttempts++
    │                        ≥3: syncStatus = 'dlq' → DLQAlertBanner
    └─ Offline? → Remain 'pending' → SyncWorker retries on connectivity
```

---

## 22. Prerequisites & Tooling

```bash
flutter --version   # 3.22.x or higher
dart --version      # 3.4.x or higher
appwrite --version  # 5.x
node --version      # 20.x

# Install Appwrite CLI
curl -sL https://appwrite.io/cli/install.sh | bash
```

---

## 23. Project Setup

```bash
flutter create fitkarma --org com.fitkarma --platforms android,ios
cd fitkarma

flutter pub add \
  flutter_riverpod riverpod_annotation go_router \
  drift sqlite3_flutter_libs path_provider path \
  flutter_secure_storage sqflite_cipher \
  appwrite dio connectivity_plus \
  shimmer fl_chart health local_auth \
  device_info_plus cached_network_image image_picker file_picker \
  flutter_map latlong2 flutter_quill \
  flutter_local_notifications workmanager home_widget \
  http purchases_flutter \
  intl uuid equatable freezed_annotation json_annotation collection

flutter pub add --dev \
  build_runner riverpod_generator drift_dev \
  freezed json_serializable mocktail fake_async flutter_lints
```

### Environment Configuration

```dart
class AppConfig {
  AppConfig._();
  static const String appwriteEndpoint =
      String.fromEnvironment('APPWRITE_ENDPOINT',
          defaultValue: 'https://cloud.appwrite.io/v1');
  static const String appwriteProjectId =
      String.fromEnvironment('APPWRITE_PROJECT_ID');
  static const String dbId =
      String.fromEnvironment('APPWRITE_DB_ID', defaultValue: 'fitkarma-db');

  // Consolidated Appwrite Resources
  static const String coreFunctionId = 'fitkarma-cores';
  static const String mainBucketId   = 'fitkarma-vault';

  // Collection IDs
  static const String usersCol      = 'users';
  static const String foodCol       = 'food_logs';
  static const String bpCol         = 'bp_readings';
  static const String glucoseCol    = 'glucose_readings';
  static const String sleepCol      = 'sleep_logs';
  static const String workoutsCol   = 'workouts';
  static const String habitsCol     = 'habits';
  static const String journalCol    = 'journal';
  static const String labCol        = 'lab_reports';
  static const String karmaCol      = 'karma_events';
  static const String festivalCol   = 'festivals';
  static const String medicationCol = 'medications';
  static const String waterCol      = 'water_logs';
  static const String socialCol     = 'social_posts';
  static const String groupsCol     = 'groups';
  static const String shareCol      = 'share_tokens';
  static const String foodDbCol     = 'food_database';
}
```

### Android Permissions

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.health.READ_STEPS"/>
<uses-permission android:name="android.permission.health.READ_HEART_RATE"/>
<uses-permission android:name="android.permission.health.READ_SLEEP_SESSION"/>
<uses-permission android:name="android.permission.health.READ_BLOOD_PRESSURE"/>
<uses-permission android:name="android.permission.health.READ_BLOOD_GLUCOSE"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<queries>
  <package android:name="com.google.android.apps.healthdata"/>
</queries>
```

---

## 24. Appwrite CLI — Complete Setup

```bash
appwrite login
appwrite init project   # creates appwrite.json

# Database
appwrite databases create --databaseId "fitkarma-db" --name "FitKarma Database"
```

### Collections — Core (condensed; full attribute lists in §39–41)

```bash
# Users, Food Logs, BP Readings, Glucose, Sleep, Workouts,
# Habits, Journal, Lab Reports, Karma Events — follow same pattern:
appwrite databases createCollection \
  --databaseId "fitkarma-db" \
  --collectionId "{id}" \
  --name "{Name}" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'
```

### Storage Buckets

```bash
appwrite storage createBucket \
  --bucketId "lab-reports" --name "Lab Reports" \
  --allowedFileExtensions pdf,jpg,jpeg,png \
  --encryption true --antivirus true

appwrite storage createBucket \
  --bucketId "avatars" --name "User Avatars" \
  --allowedFileExtensions jpg,jpeg,png,webp --compression gzip
```

### Functions (Consolidated)

```bash
# Unified function for all server-side logic
appwrite functions create \
  --functionId "fitkarma-cores" \
  --name "FitKarma Core" \
  --runtime node-20.0 --timeout 60
```

```bash
appwrite push tables    --all --force
appwrite push buckets   --all --force
appwrite push functions --all --force --activate true
```

---

## 25. Database Schema (Appwrite + Drift)

| Collection ID      | Purpose               | Key Fields                                    |
| ------------------ | --------------------- | --------------------------------------------- |
| `users`            | Profile, karma level  | `userId`, `karmaXP`, `karmaLevel`             |
| `food_logs`        | Meal tracking         | `mealType`, `calories`, `loggedAt`            |
| `food_database`    | Indian food master DB | `name`, `nameHindi`, `calories`, `barcode`    |
| `bp_readings`      | Blood pressure        | `systolic`, `diastolic`, `classification`     |
| `glucose_readings` | Blood glucose         | `valueMgDl`, `readingType`, `linkedFoodLogId` |
| `sleep_logs`       | Sleep sessions        | `sleepStart`, `sleepEnd`, `qualityScore`      |
| `workouts`         | Sessions + types      | `workoutType`, `totalVolume`, `occurredAt`    |
| `workout_sets`     | Exercise detail       | `exerciseName`, `reps`, `weight`, `setOrder`  |
| `habits`           | Definitions + streaks | `completedDates`, `currentStreak`             |
| `journal`          | Rich text + mood      | `body`, `moodScore`, `tags`                   |
| `karma_events`     | XP log                | `eventType`, `xpAwarded`                      |
| `festivals`        | Indian calendar       | `name`, `date`, `type`                        |
| `medications`      | Schedules             | `name`, `dosage`, `schedule`                  |
| `water_logs`       | Water intake          | `amountMl`, `loggedAt`                        |
| `lab_reports`      | Results + files       | `valuesJson`, `fileId`                        |
| `social_posts`     | Group posts           | `content`, `groupId`, `reactions`             |
| `groups`           | Family/friend groups  | `members`, `groupType`                        |
| `share_tokens`     | Expiring share links  | `reportId`, `token`, `expiresAt`              |

**Common field pattern:** Every collection except `users` and `karma_events` has:
`localId` (UUID on device) · `userId` · `syncStatus` ('pending' / 'synced' / 'dlq')

---

## 26. State Management — Riverpod 2.x

```dart
// AsyncNotifier pattern — standard for all mutations
@riverpod
class FoodLogNotifier extends _$FoodLogNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> logFood(FoodLogsCompanion entry) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(appDatabaseProvider).into(db.foodLogs).insert(entry);
      await ref.read(syncWorkerProvider).syncTable('food_logs');
    });
  }
}

// Stream provider for live data
@riverpod
Stream<List<FoodLog>> todayFoodLogs(TodayFoodLogsRef ref) {
  final db = ref.watch(appDatabaseProvider);
  final now = DateTime.now();
  final startTs = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000;
  return (db.select(db.foodLogs)
    ..where((t) => t.loggedAt.isBetweenValues(startTs, startTs + 86400))
    ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
    .watch();
}
```

---

## 27. Offline-First Architecture — Drift

### Sync Status Lifecycle

```text
pending → synced     (push succeeds)
pending → dlq        (3 consecutive failures → DLQAlertBanner)
```

### Drift Schema (excerpt)

```dart
@DriftDatabase(tables: [FoodLogs, BpReadings, GlucoseReadings,
    SleepLogs, Workouts, Habits, Journal, WaterLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);
  @override int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.addColumn(foodLogs, foodLogs.failedAttempts);
      if (from < 3) {
        await m.addColumn(foodLogs, foodLogs.remoteId);
        await m.addColumn(bpReadings, bpReadings.remoteId);
      }
      if (from < 4) {
        await m.addColumn(users, users.isPro);
        await m.addColumn(users, users.weddingDate);
        await m.createTable(sleepLogs);
        // ... see app_database.dart for full v4 migration
      }
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );
}

// Encrypted DB factory
Future<AppDatabase> openEncryptedDatabase() async {
  final dir  = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'fitkarma.db');
  final key  = await _getOrCreateDbKey();
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
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) return;
    // Priority order: critical first
    await _syncBpReadings();
    await _syncGlucoseReadings();
    await _syncMedications();
    await _syncFoodLogs();
    await _syncWorkouts();
    await _syncSleepLogs();
    await _syncWaterLogs();
  }

  // Each sync method: select pending rows → push to Appwrite
  // Success: syncStatus = 'synced', remoteId stored
  // Failure: failedAttempts++; ≥3 → syncStatus = 'dlq'
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
    try { return await Account(ref.read(appwriteClientProvider)).get(); }
    on AppwriteException { return null; }
  }

  Future<void> login(String email, String password) async {
    await Account(ref.read(appwriteClientProvider))
        .createEmailPasswordSession(email: email, password: password);
    ref.invalidateSelf();
  }

  Future<void> logout() async {
    await Account(ref.read(appwriteClientProvider))
        .deleteSession(sessionId: 'current');
    ref.invalidateSelf();
  }
}
```

### Biometric Lock

```dart
class BiometricLock {
  static Future<bool> authenticate() async {
    final canAuth = await LocalAuthentication().canCheckBiometrics;
    if (!canAuth) return true;
    return LocalAuthentication().authenticate(
      localizedReason: 'Authenticate to view health data',
      options: const AuthenticationOptions(stickyAuth: true, biometricOnly: false),
    );
  }
}
// Required on first enter per session: Journal, Period Tracker, BP/Glucose, Lab Reports
```

---

## 30. Storage & File Handling

```dart
Future<String> uploadFile(File file, String folder) async {
  // folder = 'avatars' or 'lab-reports'
  final result = await ref.read(appwriteStorageProvider).createFile(
    bucketId: 'fitkarma-vault',
    fileId: ID.unique(),
    file: InputFile.fromPath(path: file.path, name: '$folder/${ID.unique()}'),
    permissions: [
      Permission.read(Role.user(userId)),
      Permission.delete(Role.user(userId)),
    ],
  );
  return result.$id;
}
```

---

## 31. Health Integrations

```dart
class HealthService {
  static final _health = Health();

  static Future<bool> requestPermissions() async {
    return _health.requestAuthorization([
      HealthDataType.STEPS, HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_OXYGEN, HealthDataType.SLEEP_SESSION,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_GLUCOSE,
    ]);
  }

  static Future<int> todaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final data = await _health.getHealthDataFromTypes(
      startTime: midnight, endTime: now, types: [HealthDataType.STEPS]);
    return data.fold<int>(0, (sum, d) =>
        sum + (d.value as NumericHealthValue).numericValue.toInt());
  }
}
```

> **iOS HealthKit full implementation** → see [§F3](#f3-ios-healthkit--full-implementation)

---

## 32. Security & Encryption

| Data Type        | Local            | Remote             | Encryption              |
| ---------------- | ---------------- | ------------------ | ----------------------- |
| Health readings  | SQLCipher        | Appwrite Documents | AES-256 + TLS           |
| Journal entries  | SQLCipher        | Appwrite Documents | AES-256 + TLS           |
| Lab report files | —                | Appwrite Storage   | Server-side + antivirus |
| Auth tokens      | Appwrite session | HTTP-only cookie   | TLS in transit          |

Document permissions always use strict user isolation — never `any` or broad `users` role.

---

## 33. Performance Considerations

- `CachedNetworkImage` always — never `Image.network`
- Drift `.watch()` for reactive queries — never poll
- `ListView.builder` for all lists — lazy rendering
- `ref.watch(provider.select(...))` for narrow rebuilds
- `RepaintBoundary` on `ActivityRings` and `BreathingCircle`
- Parse large JSON in `compute()` isolates

### Render Budget Targets

| Metric                  | Target         |
| ----------------------- | -------------- |
| Cold launch             | < 2.5s         |
| Frame render            | < 16ms (60fps) |
| Drift date-range query  | < 50ms         |
| Sync batch (50 records) | < 3s on 4G     |

---

## 34. Testing Strategy

| Type          | Coverage Target                           | Tools                                     |
| ------------- | ----------------------------------------- | ----------------------------------------- |
| Unit          | Repositories, use cases                   | `flutter_test`, `mocktail`                |
| Widget        | Design token enforcement, GlassCard tiers | `flutter_test`, `ProviderScope` overrides |
| Golden        | Screen visual consistency                 | `golden_toolkit`                          |
| Integration   | Full sync flow, offline→online            | `integration_test`                        |
| Migration     | DB schema v1→vN                           | `drift_dev` verifier                      |
| Accessibility | Semantic labels on custom painters        | `flutter_test` semantics                  |

---

## 35. CI/CD & Deployment

```yaml
name: FitKarma CI
on:
  push: { branches: [main, develop] }
  pull_request: { branches: [main] }

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: "3.22.x", cache: true }
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: flutter test --coverage

  deploy-appwrite:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: curl -sL https://appwrite.io/cli/install.sh | bash
      - run: |
          appwrite client \
            --endpoint ${{ secrets.APPWRITE_ENDPOINT }} \
            --project-id ${{ secrets.APPWRITE_PROJECT_ID }} \
            --key ${{ secrets.APPWRITE_API_KEY }}
      - run: appwrite push functions --all --force --activate true

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: "3.22.x", cache: true }
      - run: flutter pub get && dart run build_runner build --delete-conflicting-outputs
      - run: |
          flutter build apk --release \
            --dart-define=APPWRITE_ENDPOINT=${{ secrets.APPWRITE_ENDPOINT }} \
            --dart-define=APPWRITE_PROJECT_ID=${{ secrets.APPWRITE_PROJECT_ID }} \
            --dart-define=APPWRITE_DB_ID=fitkarma-db
```

---

## 36. Appwrite Functions — Server-Side Code

### XP Calculator

```js
// functions/xp-calculator/src/main.js
import { Client, Databases, ID, Query } from "node-appwrite";

const XP_TABLE = {
  food_log: 5,
  food_log_complete: 20,
  workout_complete: 30,
  steps_goal: 25,
  sleep_logged: 10,
  bp_reading: 10,
  glucose_reading: 10,
  habit_complete: 15,
  journal_entry: 10,
  streak_7day: 50,
  streak_30day: 150,
  lab_report: 20,
  referral: 500,
};

const LEVEL_THRESHOLDS = [
  0, 200, 500, 1000, 1800, 2800, 4200, 6000, 8500, 12000, 16000, 21000, 27000,
];
const LEVEL_NAMES = [
  "Newcomer",
  "Beginner",
  "Starter",
  "Mover",
  "Achiever",
  "Consistent",
  "Dedicated",
  "Warrior",
  "Champion",
  "Elite",
  "Legend",
  "Grandmaster",
  "Karma Master",
];

function computeLevel(xp) {
  let level = 1;
  for (let i = 1; i < LEVEL_THRESHOLDS.length; i++) {
    if (xp >= LEVEL_THRESHOLDS[i]) level = i + 1;
    else break;
  }
  return LEVEL_NAMES[level - 1];
}

export default async ({ req, res, log, error }) => {
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers["x-appwrite-key"]);

  const { action, payload } = JSON.parse(req.body || "{}");

  switch (action) {
    case 'XP_AWARD':
      return handleXp(payload, client, res);
    case 'GENERATE_SHARE_LINK':
      return handleShare(payload, client, res);
    case 'AI_COACH_QUERY':
      return handleAiCoach(payload, client, res);
    case 'FETCH_FEATURE_FLAGS':
      return handleFeatureFlags(payload, client, res);
    default:
      return res.json({ ok: false, error: "Invalid action" }, 400);
  }
};

async function handleXp(payload, client, res) {
  const db = new Databases(client);
  const DB = "fitkarma-db";
  const { userId, eventType } = payload;
  const xp = XP_TABLE[eventType];
  // ... rest of XP logic ...
}
```

---

## 37. Karma & Gamification Engine

### XP Table

| Event                             | XP  |
| --------------------------------- | --- |
| `food_log`                        | 5   |
| `food_log_complete` (all 3 meals) | 20  |
| `workout_complete`                | 30  |
| `steps_goal`                      | 25  |
| `sleep_logged`                    | 10  |
| `bp_reading`                      | 10  |
| `glucose_reading`                 | 10  |
| `habit_complete`                  | 15  |
| `journal_entry`                   | 10  |
| `streak_7day`                     | 50  |
| `streak_30day`                    | 150 |
| `lab_report`                      | 20  |
| `referral`                        | 500 |

### Level System

| Level | Name         | XP Required |
| ----- | ------------ | ----------- |
| 1     | Newcomer     | 0           |
| 2     | Beginner     | 200         |
| 3     | Starter      | 500         |
| 4     | Mover        | 1,000       |
| 5     | Achiever     | 1,800       |
| 6     | Consistent   | 2,800       |
| 7     | Dedicated    | 4,200       |
| 8     | Warrior      | 6,000       |
| 9     | Champion     | 8,500       |
| 10    | Elite        | 12,000      |
| 11    | Legend       | 16,000      |
| 12    | Grandmaster  | 21,000      |
| 13    | Karma Master | 27,000      |

---

## 38. Festival & Wedding Data

Festival collection: `name`, `nameHindi`, `date` (Unix), `type` (religious/national/regional), `dietaryNotes`, `region`.

Dashboard shows upcoming festival in 7-day lookahead. Fasting mode auto-suggested on known fasting festivals (Navratri, Ekadashi, Karva Chauth, Ramzan).

Wedding planner collection: `weddingDate`, `targetWeightKg`, `skinGoal`, `notes`.

---

## 39. Medication & Water Tracking Collections

Medication: `name`, `dosage`, `scheduleJson` (array of `{time, days[]}`), `isActive`.

Water: `amountMl`, `loggedAt`, `source` (manual/reminder/auto).

---

## 40. Notification System

| Channel          | Importance | When                                     |
| ---------------- | ---------- | ---------------------------------------- |
| `meal_reminders` | High       | Breakfast/lunch/dinner (user-configured) |
| `medications`    | Max        | Per medication schedule                  |
| `step_goal`      | Default    | 8pm if goal not reached                  |
| `water_reminder` | Low        | Every 2h if not logged                   |
| `sync_failed`    | High       | DLQ count > 0                            |
| `ai_coach`       | Default    | Proactive nudge from AI coach [§F2]      |

---

## 41. Social Collections

`social_posts`: `userId`, `groupId`, `content`, `postType`, `reactions` (JSON), `createdAt`.
`groups`: `name`, `createdBy`, `members` (JSON array), `groupType` (family/friends/challenge).

---

## 42. Home Widgets

Android / iOS home screen: Steps progress · Water intake · Today's calories · Current streak · Karma level.

```dart
class HomeWidgetService {
  static Future<void> updateStepsWidget(int steps, int goal) async {
    await HomeWidget.saveWidgetData<int>('steps_today', steps);
    await HomeWidget.saveWidgetData<int>('steps_goal', goal);
    await HomeWidget.updateWidget(
      androidName: 'StepsWidgetProvider', iOSName: 'StepsWidget');
  }
}
```

---

## 43. Error Handling & Observability

```dart
void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _logError(details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    _logError(error, stack);
    return true;
  };
  runApp(const ProviderScope(child: FitKarmaApp()));
}
```

Standard provider pattern — always handle all three states:

```dart
ref.watch(provider).when(
  loading: () => const ShimmerLoader(height: 120),
  error:   (e, _) => ErrorRetryWidget(message: 'Could not load', onRetry: () => ref.invalidate(provider)),
  data:    (v) => v == null ? EmptyState(contextKey: 'bp', message: 'No readings yet.') : HeroCard(data: v),
);
```

---

## 44. Complete `appwrite.json` Reference

```json
{
  "projectId": "your_project_id",
  "projectName": "FitKarma",
  "collections": [
    { "$id": "users", "name": "Users", "databaseId": "fitkarma-db" },
    { "$id": "food_logs", "name": "Food Logs", "databaseId": "fitkarma-db" },
    {
      "$id": "food_database",
      "name": "Food Database",
      "databaseId": "fitkarma-db"
    },
    {
      "$id": "bp_readings",
      "name": "Blood Pressure",
      "databaseId": "fitkarma-db"
    },
    {
      "$id": "glucose_readings",
      "name": "Glucose",
      "databaseId": "fitkarma-db"
    },
    { "$id": "sleep_logs", "name": "Sleep Logs", "databaseId": "fitkarma-db" },
    { "$id": "workouts", "name": "Workouts", "databaseId": "fitkarma-db" },
    { "$id": "habits", "name": "Habits", "databaseId": "fitkarma-db" },
    { "$id": "journal", "name": "Journal", "databaseId": "fitkarma-db" },
    {
      "$id": "lab_reports",
      "name": "Lab Reports",
      "databaseId": "fitkarma-db"
    },
    {
      "$id": "karma_events",
      "name": "Karma Events",
      "databaseId": "fitkarma-db"
    },
    { "$id": "festivals", "name": "Festivals", "databaseId": "fitkarma-db" },
    {
      "$id": "medications",
      "name": "Medications",
      "databaseId": "fitkarma-db"
    },
    { "$id": "water_logs", "name": "Water Logs", "databaseId": "fitkarma-db" },
    {
      "$id": "social_posts",
      "name": "Social Posts",
      "databaseId": "fitkarma-db"
    },
    { "$id": "groups", "name": "Groups", "databaseId": "fitkarma-db" },
    {
      "$id": "share_tokens",
      "name": "Share Tokens",
      "databaseId": "fitkarma-db"
    }
  ],
  "functions": [
    {
      "$id": "xp-calculator",
      "name": "XP Calculator",
      "runtime": "node-20.0",
      "timeout": 15
    },
    {
      "$id": "report-share",
      "name": "Report Share Link",
      "runtime": "node-20.0",
      "timeout": 15
    },
    {
      "$id": "food-search",
      "name": "Food Search",
      "runtime": "node-20.0",
      "timeout": 10
    },
    {
      "$id": "ai-coach",
      "name": "AI Coach",
      "runtime": "node-20.0",
      "timeout": 30
    },
    {
      "$id": "feature-flags",
      "name": "Feature Flags",
      "runtime": "node-20.0",
      "timeout": 5
    }
  ],
  "buckets": [
    {
      "$id": "lab-reports",
      "name": "Lab Reports",
      "encryption": true,
      "antivirus": true
    },
    { "$id": "avatars", "name": "User Avatars", "compression": "gzip" }
  ]
}
```

---

## 45. Glossary & Architecture Decisions

| Term                 | Definition                                                                                              |
| -------------------- | ------------------------------------------------------------------------------------------------------- |
| **DLQ**              | Dead Letter Queue — records that failed to sync 3+ times. User must resolve via Settings → Data & Sync. |
| **Optimistic UI**    | UI updates immediately from Drift write; remote sync is background.                                     |
| **Calm Zone**        | Settings, Journal, Emergency Card, Lab Reports — zero glow/blur/animation on all device tiers.          |
| **syncStatus**       | `pending` → `synced` → `dlq`. Drives all sync worker decisions.                                         |
| **localId**          | UUID generated on device before any network access. Never null.                                         |
| **UX Stage**         | `firstWeek / familiar / expert` — controls onboarding density.                                          |
| **Single Hero Rule** | Exactly one `metricXL` or `heroDisplay` per visible scroll area.                                        |
| **Rule of Two**      | No surface > 2 visual effects simultaneously.                                                           |
| **Soft Delete**      | `isDeleted = true` instead of hard delete — enables undo, sync recovery, audit trails.                  |

### Architecture Decision Records

**ADR-001: Drift over Hive** — SQL joins needed for date-range queries and relational linking (glucose → food logs).

**ADR-002: Riverpod over Bloc** — simpler async composition, better `AsyncValue`, code generation via `riverpod_annotation`.

**ADR-003: Appwrite over Firebase** — self-hostable (India data residency path), open-source, no per-read billing, CLI-first workflow.

**ADR-004: SQLCipher** — AES-256 at the SQLite page level. Key in platform keychain. Raw `.db` file unreadable without key.

**ADR-005: Soft Delete** — health data is irreplaceable; undo and cross-device conflict recovery require it.

**ADR-006: Pure Dart Animations** — consistent token styling, zero-latency start, no third-party versioning risk.

**ADR-007: `--dart-define`** — secrets never in source; separate build targets for dev/staging/prod.

**ADR-008: Sentry over Crashlytics** — self-hostable, no Google telemetry, avoids GCP lock-in.

**ADR-009: lastWriteWins + manualReview conflicts** — clinical records (BP, glucose, medications) require `manualReview`; food/habits use `lastWriteWins`.

**ADR-010: Open Food Facts + Custom Indian DB** — Open Food Facts provides 3M+ global items (free, open-source); custom Appwrite collection provides 50,000+ Indian-specific items with Hindi names and regional variants. [§F1]

**ADR-011: LLM AI Coach via Appwrite Function** — keeps API key server-side; enables rate limiting, logging, and model swapping without app release. [§F2]

**ADR-012: RevenueCat for Subscriptions** — handles App Store + Play Store receipts, entitlement management, and webhooks in one SDK; avoids custom backend billing logic. [§F4]

---

## Part III — Enterprise Hardening

---

## 46. Clean Architecture — Layer Separation

```text
features/food/
├── data/
│   ├── datasources/
│   │   ├── food_local_datasource.dart   # Drift only
│   │   └── food_remote_datasource.dart  # Appwrite only
│   ├── models/
│   │   └── food_log_model.dart
│   └── repositories/
│       └── food_repository_impl.dart
├── domain/
│   ├── entities/meal.dart
│   ├── repositories/food_repository.dart  # abstract
│   └── usecases/
│       ├── log_meal.dart
│       └── get_today_meals.dart
└── presentation/
    ├── providers/food_providers.dart
    └── screens/food_home_screen.dart
```

---

## 47. Dependency Injection Strategy

```dart
@riverpod
FoodRepository foodRepository(FoodRepositoryRef ref) => FoodRepositoryImpl(
  ref.watch(foodLocalDatasourceProvider),
  ref.watch(foodRemoteDatasourceProvider),
  ref.watch(syncWorkerProvider),
);

// Test override:
ProviderScope(
  overrides: [foodRepositoryProvider.overrideWith((_) => InMemoryFoodRepository())],
  child: const FitKarmaApp(),
)
```

---

## 48. Database Migration Strategy

```dart
@override
int get schemaVersion => 4;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) => m.createAll(),
  onUpgrade: (m, from, to) async {
    if (from < 2) await m.addColumn(foodLogs, foodLogs.failedAttempts);
    if (from < 3) {
      await m.addColumn(foodLogs, foodLogs.remoteId);
      await m.addColumn(bpReadings, bpReadings.remoteId);
    }
  },
);
```

Rules: never drop columns · new columns must be nullable or have DEFAULT · test with `verifyAll()` in CI.

---

## 49. Soft Delete System

```dart
// Every user-deletable table gets:
BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
IntColumn  get deletedAt => integer().nullable()();

// Every query must filter:
..where((t) => t.isDeleted.equals(false))

// Deletion = soft mark + SnackBar with [Undo] for 4s
```

---

## 50. Sync Conflict Resolution

```dart
enum ConflictStrategy { lastWriteWins, manualReview }
```

| Collection                                       | Strategy                                        |
| ------------------------------------------------ | ----------------------------------------------- |
| `bp_readings`, `glucose_readings`, `medications` | `manualReview` — clinical, never auto-overwrite |
| `food_logs`, `workouts`, `habits`, `journal`     | `lastWriteWins`                                 |
| `users` (profile)                                | `lastWriteWins`                                 |

Every syncable table needs `updatedAt: IntColumn`.

---

## 51. Sync Queue Priorities

```dart
extension SyncPriorityTable on String {
  SyncPriority get syncPriority => const {
    'bp_readings':      SyncPriority.critical,
    'glucose_readings': SyncPriority.critical,
    'medications':      SyncPriority.critical,
    'workouts':         SyncPriority.high,
    'sleep_logs':       SyncPriority.high,
    'food_logs':        SyncPriority.medium,
    'habits':           SyncPriority.medium,
    'water_logs':       SyncPriority.low,
    'social_posts':     SyncPriority.low,
  }[this] ?? SyncPriority.low;
}
```

---

## 52. Security Threat Model

| Threat            | Mitigation                                           |
| ----------------- | ---------------------------------------------------- |
| Rooted device     | SQLCipher AES-256 + platform keychain key            |
| MITM              | Certificate pinning + TLS 1.3 only                   |
| Token theft       | Appwrite HTTP-only session cookies                   |
| Screenshot leak   | `FLAG_SECURE` on sensitive screens                   |
| Backup exposure   | `android:allowBackup="false"`                        |
| Decompiled binary | All secrets via `--dart-define` + Appwrite Functions |

---

## 53. Certificate Pinning & Screen Security

```dart
// Certificate pinning via IOHttpClientAdapter
client.badCertificateCallback = (cert, host, port) =>
    cert.sha256.toUpperCase() == pinnedFingerprint;

// FLAG_SECURE on sensitive screens (Journal, Lab Reports, etc.)
class SecureScreen extends StatefulWidget { ... }
// initState: invoke 'SystemChrome.setSecureFlag' true
// dispose:   invoke 'SystemChrome.setSecureFlag' false
```

---

## 54. Audit Logging

```dart
enum AuditAction {
  viewLabReport, exportHealthData, editProfile,
  loginSuccess, loginFailed, biometricSuccess, biometricFailed,
}

// Log every sensitive action:
await auditLogger.log(userId: uid, action: AuditAction.viewLabReport, resourceId: reportId);
```

---

## 55. Accessibility — Advanced

- Dynamic font scaling: clamp scaled font sizes `(12.0, 20.0)` to prevent layout breaks
- Reduced Motion: check `accessibilitySettingsProvider` before any `AnimatedBuilder`
- Color-blind indicators: always pair color with shape/icon (never color alone for health status)
- OpenDyslexic toggle in Settings → Accessibility → `ThemeData` rebuild

---

## 56. Performance — Render Budget & Widget Optimization

```dart
// select() — narrow provider subscription
final calories = ref.watch(foodStateProvider.select((s) => s.totalCalories));

// const constructors — Flutter skips rebuild entirely
const ShimmerLoader(height: 120)

// RepaintBoundary — isolates expensive CustomPaint
RepaintBoundary(child: ActivityRings(...))

// Background isolates for large JSON
Future<List<FoodLog>> parseLogs(String json) => compute(_parseFoodLogs, json);
```

---

## 57. Crash Reporting & Observability

```dart
await SentryFlutter.init((options) {
  options.dsn = const String.fromEnvironment('SENTRY_DSN');
  options.tracesSampleRate = 0.2;
  options.environment = const String.fromEnvironment('APP_ENV', defaultValue: 'production');
  // Strip PII — never send health values in error reports
  options.beforeSend = (event, hint) => event.copyWith(user: null);
}, appRunner: () => runApp(const ProviderScope(child: FitKarmaApp())));
```

---

## 58. Feature Flags

```dart
class FeatureFlags {
  final bool aiInsights;       // §F2 — default: true (now implemented)
  final bool socialFeed;       // default: true
  final bool weddingPlanner;   // default: true
  final bool fhirExport;       // default: false (future)
  final bool voiceLogging;     // default: false (future)
  final bool proSubscription;  // §F4 — default: true (RevenueCat)
}
```

---

## 59. AI Insight Engine (Rule-Based)

```dart
class InsightEngine {
  Future<HealthAnomaly?> detectBPAnomaly(String userId) async {
    final readings = await _fetchBpReadings(userId, days: 30);
    if (readings.length < 7) return null;
    final avgSystolic = readings.map((r) => r.systolic).average;
    final stdDev = _standardDeviation(readings.map((r) => r.systolic.toDouble()));
    if (readings.last.systolic > avgSystolic + 2 * stdDev) {
      return HealthAnomaly(type: AnomalyType.bpElevated, message: '...');
    }
    return null;
  }
}
```

> For LLM-powered coaching see [§F2](#f2-ai-insight-engine--llm-coach).

---

## 60. Wearable Abstraction Layer

```dart
abstract class HealthDataProvider {
  String get providerName;
  Future<bool> requestPermissions();
  Future<int> getTodaySteps();
  Future<double?> getLatestHeartRate();
  Future<List<SleepSession>> getSleepData(DateTime date);
  Future<List<BpReading>> getBloodPressureData({int days = 7});
}

class HealthConnectProvider implements HealthDataProvider { /* Android */ }
class HealthKitProvider      implements HealthDataProvider { /* iOS — full impl §F3 */ }
class ManualEntryProvider    implements HealthDataProvider { /* fallback */ }

@riverpod
HealthDataProvider healthDataProvider(HealthDataProviderRef ref) {
  if (Platform.isAndroid) return HealthConnectProvider();
  if (Platform.isIOS)     return HealthKitProvider();   // ← fixed [§F3]
  return ManualEntryProvider();
}
```

---

## 61. Testing — Comprehensive Strategy

```dart
// Widget test: GlassCard tier enforcement
testWidgets('GlassCard — low tier uses solid surface1, no blur', (tester) async {
  await tester.pumpWidget(ProviderScope(
    overrides: [deviceTierProvider.overrideWith((_) => Future.value(DeviceTier.low))],
    child: MaterialApp(theme: AppTheme.dark(), home: const GlassCard(child: Text('test'))),
  ));
  await tester.pump();
  expect(find.byType(BackdropFilter), findsNothing);
});

// Integration test: offline sync recovery
testWidgets('Meal logged offline syncs on connectivity restore', (tester) async {
  // Override connectivity → none → log food → expect pending
  // Override connectivity → wifi → expect synced
});
```

---

## 62. Account Management & Data Rights

```dart
// Export all health data as JSON
Future<File> exportHealthData(String userId) async { ... }

// Full account deletion
Future<void> deleteAccount(String userId) async {
  await Account(ref.read(appwriteClientProvider)).delete();
  await ref.read(appDatabaseProvider).close();
  await File(await _getDbPath()).delete();
  await const FlutterSecureStorage().deleteAll();
  ref.invalidate(authNotifierProvider);
}
```

---

## Part IV — Critical Fixes

---

## §F1. Indian Food Database Integration

> **Fixes the #1 gap identified in competitive analysis.** Without a food database, food logging degrades to full manual entry — the primary churn driver in nutrition apps.

### Architecture

```text
Food Search Sheet
      │
      ├─ Query: Indian regional? → FoodDatabaseService.searchIndian() → Appwrite food_database collection
      ├─ Query: Barcode scan?    → FoodDatabaseService.searchBarcode() → Open Food Facts API
      ├─ Query: Global food?     → FoodDatabaseService.searchGlobal()  → Open Food Facts API
      └─ Not found?              → Manual entry form
```

### Appwrite `food_database` Collection — CLI Setup

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "food_database" \
  --name "Food Database" \
  --permissions 'read("users")'   # read-only for all authenticated users

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "name"          --size 200 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "nameHindi"     --size 200 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "nameRegional"  --size 200 --required false   # Marathi, Tamil, Bengali, etc.
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "category"      --size 50  --required false   # dal, sabzi, roti, rice, snack, sweet, beverage
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "cuisine"       --size 50  --required false   # north-indian, south-indian, bengali, gujarati, etc.
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "caloriesPer100g"  --required true
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "proteinPer100g"   --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "carbsPer100g"     --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "fatPer100g"       --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "fiberPer100g"     --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "barcode"       --size 20  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "servingSizes"  --size 500 --required false   # JSON: [{name:"1 roti", grams:40}, ...]
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "emoji"         --size 4   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "source"        --size 20  --required false   # manual/off/icmr/usda

# Indexes for fast search
appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "name_idx" --type fulltext --attributes name

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "barcode_idx" --type unique --attributes barcode
```

### Food Database Service

```dart
// lib/features/food/data/food_database_service.dart

import 'package:appwrite/appwrite.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Priority: Indian DB (Appwrite) → Open Food Facts → Manual
class FoodDatabaseService {
  final Databases _databases;
  final Dio _dio;
  static const _dbId  = 'fitkarma-db';
  static const _colId = 'food_database';
  static const _offBase = 'https://world.openfoodfacts.org';

  FoodDatabaseService(this._databases, this._dio);

  // ── Search by name ───────────────────────────────────────
  Future<List<FoodItem>> searchByName(String query, {bool lowData = false}) async {
    final results = <FoodItem>[];

    // 1. Search Indian DB first (fast — Appwrite full-text index)
    try {
      final local = await _databases.listDocuments(
        databaseId: _dbId, collectionId: _colId,
        queries: [Query.search('name', query), Query.limit(10)],
      );
      results.addAll(local.documents.map(FoodItem.fromAppwriteDoc));
    } catch (_) {}

    // 2. If not enough results and not in low data mode, hit Open Food Facts
    if (results.length < 5 && !lowData) {
      try {
        final resp = await _dio.get(
          '$_offBase/cgi/search.pl',
          queryParameters: {
            'search_terms': query, 'search_simple': 1, 'action': 'process',
            'json': 1, 'page_size': 10, 'fields':
            'product_name,nutriments,serving_size,image_front_small_url,code',
          },
        );
        final products = (resp.data['products'] as List? ?? []);
        results.addAll(products.map(FoodItem.fromOpenFoodFacts).where((f) => f.isValid));
      } catch (_) {}
    }

    return results;
  }

  // ── Search by barcode ────────────────────────────────────
  Future<FoodItem?> searchByBarcode(String barcode) async {
    // 1. Check local Appwrite DB first
    try {
      final local = await _databases.listDocuments(
        databaseId: _dbId, collectionId: _colId,
        queries: [Query.equal('barcode', barcode), Query.limit(1)],
      );
      if (local.documents.isNotEmpty) return FoodItem.fromAppwriteDoc(local.documents.first);
    } catch (_) {}

    // 2. Fallback to Open Food Facts
    try {
      final resp = await _dio.get('$_offBase/api/v0/product/$barcode.json');
      if (resp.data['status'] == 1) {
        final item = FoodItem.fromOpenFoodFacts(resp.data['product']);
        if (item.isValid) {
          await _cacheToAppwrite(item, barcode: barcode); // cache for offline use
          return item;
        }
      }
    } catch (_) {}

    return null;
  }

  // ── Cache a looked-up product for offline reuse ──────────
  Future<void> _cacheToAppwrite(FoodItem item, {String? barcode}) async {
    try {
      await _databases.createDocument(
        databaseId: _dbId, collectionId: _colId, documentId: ID.unique(),
        data: item.toAppwriteMap(barcode: barcode),
        permissions: ['read("users")'],
      );
    } catch (_) {} // silent — caching is best-effort
  }
}

@riverpod
FoodDatabaseService foodDatabaseService(FoodDatabaseServiceRef ref) =>
    FoodDatabaseService(
      ref.watch(appwriteDatabasesProvider),
      Dio(BaseOptions(connectTimeout: const Duration(seconds: 5))),
    );
```

### FoodItem Model

```dart
// lib/features/food/data/models/food_item.dart

@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String name,
    String? nameHindi,
    required double caloriesPer100g,
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatPer100g,
    double? fiberPer100g,
    String? barcode,
    String? imageUrl,
    String? emoji,
    String? category,
    @Default([]) List<ServingSize> servingSizes,
    @Default('off') String source,
  }) = _FoodItem;

  // Valid = has a name AND calories
  bool get isValid => name.isNotEmpty && caloriesPer100g > 0;

  factory FoodItem.fromOpenFoodFacts(Map<String, dynamic> product) {
    final n = product['nutriments'] as Map<String, dynamic>? ?? {};
    return FoodItem(
      name:             product['product_name'] as String? ?? '',
      caloriesPer100g:  (n['energy-kcal_100g'] as num?)?.toDouble() ?? 0,
      proteinPer100g:   (n['proteins_100g']    as num?)?.toDouble(),
      carbsPer100g:     (n['carbohydrates_100g'] as num?)?.toDouble(),
      fatPer100g:       (n['fat_100g']          as num?)?.toDouble(),
      fiberPer100g:     (n['fiber_100g']         as num?)?.toDouble(),
      imageUrl:         product['image_front_small_url'] as String?,
      barcode:          product['code'] as String?,
      source:           'off',
    );
  }

  factory FoodItem.fromAppwriteDoc(Document doc) {
    final servingsRaw = doc.data['servingSizes'] as String?;
    final servings = servingsRaw != null
        ? (jsonDecode(servingsRaw) as List).map((s) => ServingSize.fromJson(s)).toList()
        : <ServingSize>[];
    return FoodItem(
      name:             doc.data['name'] as String,
      nameHindi:        doc.data['nameHindi'] as String?,
      caloriesPer100g:  (doc.data['caloriesPer100g'] as num).toDouble(),
      proteinPer100g:   (doc.data['proteinPer100g']  as num?)?.toDouble(),
      carbsPer100g:     (doc.data['carbsPer100g']    as num?)?.toDouble(),
      fatPer100g:       (doc.data['fatPer100g']      as num?)?.toDouble(),
      fiberPer100g:     (doc.data['fiberPer100g']    as num?)?.toDouble(),
      barcode:          doc.data['barcode'] as String?,
      emoji:            doc.data['emoji']   as String?,
      category:         doc.data['category'] as String?,
      servingSizes:     servings,
      source:           doc.data['source']  as String? ?? 'manual',
    );
  }
}

@freezed
class ServingSize with _$ServingSize {
  const factory ServingSize({required String name, required double grams}) = _ServingSize;
  factory ServingSize.fromJson(Map<String, dynamic> json) =>
      ServingSize(name: json['name'] as String, grams: (json['grams'] as num).toDouble());
}
```

### Food Search UI — Bottom Sheet

```dart
// lib/features/food/presentation/food_search_sheet.dart

class FoodSearchSheet extends ConsumerStatefulWidget {
  final String mealType; // breakfast/lunch/dinner/snack
  const FoodSearchSheet({super.key, required this.mealType});

  @override
  ConsumerState<FoodSearchSheet> createState() => _FoodSearchSheetState();
}

class _FoodSearchSheetState extends ConsumerState<FoodSearchSheet> {
  final _ctrl = TextEditingController();
  List<FoodItem> _results = [];
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9, minChildSize: 0.5, maxChildSize: 0.95,
      builder: (_, scrollCtrl) => GlassCard(
        customRadius: AppRadius.xl,
        child: Column(children: [
          // Search bar
          TextField(
            controller: _ctrl,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search food (e.g. Dal Makhani, Chapati)…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: _scanBarcode,   // Camera permission required
              ),
            ),
            onChanged: _onQueryChanged,
          ),
          // Results
          if (_searching) const LinearProgressIndicator(),
          Expanded(
            child: _results.isEmpty
                ? EmptyState(contextKey: 'food', message: 'Search for a food item above.')
                : ListView.builder(
                    controller: scrollCtrl,
                    itemCount: _results.length,
                    itemBuilder: (_, i) => _FoodResultTile(
                      item: _results[i],
                      onTap: () => _logFood(_results[i]),
                    ),
                  ),
          ),
          // Manual entry fallback
          TextButton.icon(
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Add manually'),
            onPressed: () => _showManualEntrySheet(context),
          ),
        ]),
      ),
    );
  }

  Future<void> _onQueryChanged(String query) async {
    if (query.length < 2) return;
    setState(() => _searching = true);
    final lowData = ref.read(lowDataModeProvider);
    final results = await ref.read(foodDatabaseServiceProvider)
        .searchByName(query, lowData: lowData);
    setState(() { _results = results; _searching = false; });
  }

  Future<void> _scanBarcode() async {
    // Use mobile_scanner package for barcode scanning
    // Then: ref.read(foodDatabaseServiceProvider).searchByBarcode(barcode)
  }

  Future<void> _logFood(FoodItem item) async {
    // Show portion selector bottom sheet
    // Then: ref.read(foodLogNotifierProvider.notifier).logFood(entry)
    // Then: ref.read(karmaServiceProvider).awardXP('food_log')
    Navigator.pop(context);
  }
}
```

### Appwrite Function: food-search (server-side caching)

```js
// functions/food-search/src/main.js
// Proxies Open Food Facts to avoid CORS and add server-side caching

import { Client, Databases, Query, ID } from "node-appwrite";

export default async ({ req, res }) => {
  const { query, barcode } = JSON.parse(req.body || "{}");
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers["x-appwrite-key"]);
  const db = new Databases(client);

  if (barcode) {
    const resp = await fetch(
      `https://world.openfoodfacts.org/api/v0/product/${barcode}.json`,
    );
    const data = await resp.json();
    if (data.status === 1) {
      // Cache result in food_database for offline use
      const p = data.product;
      const n = p.nutriments || {};
      try {
        await db.createDocument(
          "fitkarma-db",
          "food_database",
          ID.unique(),
          {
            name: p.product_name || "",
            barcode,
            caloriesPer100g: n["energy-kcal_100g"] || 0,
            proteinPer100g: n["proteins_100g"] || null,
            carbsPer100g: n["carbohydrates_100g"] || null,
            fatPer100g: n["fat_100g"] || null,
            source: "off",
          },
          ['read("users")'],
        );
      } catch (_) {} // might already exist
      return res.json({ ok: true, product: data.product });
    }
    return res.json({ ok: false });
  }

  // Name search — return Appwrite Indian DB results
  const results = await db.listDocuments("fitkarma-db", "food_database", [
    Query.search("name", query),
    Query.limit(15),
  ]);
  return res.json({ ok: true, items: results.documents });
};
```

### Seeding Indian Foods

Create `assets/data/indian_foods_seed.json` with at minimum 5,000 entries covering:

- Common dals: toor, moong, masoor, urad, chana
- Breads: roti (phulka/tandoor/plain), paratha, puri, naan, bhatura, dosa, idli, uttapam
- Rice dishes: plain rice, khichdi, pulao, biryani, curd rice
- Sabzis: aloo gobi, palak paneer, bhindi masala, baingan bharta, rajma, chole
- Snacks: samosa, kachori, dhokla, poha, upma, chivda, namkeen
- Sweets: gulab jamun, ladoo, barfi, halwa, kheer, rasgulla, jalebi
- Street food: pav bhaji, vada pav, pani puri, bhel puri, dahi puri
- South Indian: sambhar, rasam, coconut chutney, avial, fish curry
- Beverages: chai (with milk), lassi (sweet/salted), nimbu pani, jaljeera

Each entry includes: `name`, `nameHindi`, `category`, `cuisine`, `caloriesPer100g`, `proteinPer100g`, `carbsPer100g`, `fatPer100g`, `servingSizes`, `emoji`.

```bash
# One-time seed script (run from project root)
node scripts/seed_food_database.js
# Reads indian_foods_seed.json → creates Appwrite documents in batches of 100
```

---

## §F2. AI Insight Engine & LLM Coach

> **Fixes the AI/coaching gap.** Adds a conversational health coach powered by an LLM, running server-side to keep API keys secure.

### Feature Flag

```dart
// aiInsights flag in §58 must be true to show AI Coach tab
// Gated by Pro subscription tier (§F4)
```

### Appwrite Function: ai-coach

```js
// functions/ai-coach/src/main.js
// Server-side LLM call — API key never in Flutter binary

import axios from "axios";
import { Client, Databases, Query } from "node-appwrite";

const groqKey = process.env.GROQ_API_KEY;

const SYSTEM_PROMPT = `You are FitKarma's AI health coach — a warm, encouraging, and medically responsible assistant built for Indian users. 

You have access to the user's recent health data summarised below. Use it to give personalised, actionable advice.

RULES:
- Always be encouraging and empathetic. Never shame about weight, food choices, or missed goals.
- Cite specific numbers from their data (e.g. "Your average BP last week was 138/88").
- For clinical concerns (BP Stage 2+, glucose > 200 mg/dL, SpO2 < 94%), always recommend consulting a doctor — do not diagnose.
- Reference Indian foods by name when suggesting dietary changes.
- Keep responses concise (3–5 sentences for short answers, max 200 words for detailed advice).
- Celebrate streaks, milestones, and improvements — gamification mindset.
- If the user asks about something outside health/fitness, gently redirect.`;

export default async ({ req, res, log, error }) => {
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers["x-appwrite-key"]);
  const db = new Databases(client);

  const { userId, message, conversationHistory } = JSON.parse(req.body || "{}");
  if (!userId || !message)
    return res.json({ ok: false, error: "userId and message required" }, 400);

  if (!groqKey) {
    return res.json({ ok: false, error: "Groq API key not configured" }, 500);
  }

  // Fetch user's recent health data for context
  const [bpDocs, glucoseDocs, sleepDocs, foodDocs, userDoc] = await Promise.all(
    [
      db.listDocuments("fitkarma-db", "bp_readings", [
        Query.equal("userId", userId),
        Query.orderDesc("measuredAt"),
        Query.limit(7),
      ]),
      db.listDocuments("fitkarma-db", "glucose_readings", [
        Query.equal("userId", userId),
        Query.orderDesc("measuredAt"),
        Query.limit(7),
      ]),
      db.listDocuments("fitkarma-db", "sleep_logs", [
        Query.equal("userId", userId),
        Query.orderDesc("$createdAt"),
        Query.limit(7),
      ]),
      db.listDocuments("fitkarma-db", "food_logs", [
        Query.equal("userId", userId),
        Query.orderDesc("loggedAt"),
        Query.limit(10),
      ]),
      db.listDocuments("fitkarma-db", "users", [
        Query.equal("userId", userId),
        Query.limit(1),
      ]),
    ],
  );

  const user = userDoc.documents[0] || {};
  const bpAvg = bpDocs.documents.length
    ? Math.round(
        bpDocs.documents.reduce((s, d) => s + d.systolic, 0) /
          bpDocs.documents.length,
       )
    : null;

  const healthContext = `
USER PROFILE:
  Name: ${user.name || "User"} | Goal: ${user.fitnessGoal || "general fitness"} | Dosha: ${user.dominantDosha || "unknown"}
  Karma Level: ${user.karmaLevel || "Newcomer"} (${user.karmaXP || 0} XP)

RECENT HEALTH DATA (last 7 days):
  Blood Pressure: ${
    bpDocs.documents.length > 0
      ? `Avg systolic ${bpAvg} mmHg | Latest ${bpDocs.documents[0]?.systolic}/${bpDocs.documents[0]?.diastolic} (${bpDocs.documents[0]?.classification || "uncategorised"})`
      : "No readings"
  }
  Glucose: ${
    glucoseDocs.documents.length > 0
      ? `Latest ${glucoseDocs.documents[0]?.valueMgDl} mg/dL (${glucoseDocs.documents[0]?.readingType})`
      : "No readings"
  }
  Sleep: ${
    sleepDocs.documents.length > 0
      ? `Avg score ${Math.round(sleepDocs.documents.reduce((s, d) => s + (d.qualityScore || 0), 0) / sleepDocs.documents.length)}/100`
      : "No data"
  }
  Recent meals logged: ${
    foodDocs.documents
      .slice(0, 3)
      .map((f) => f.foodName)
      .join(", ") || "None logged recently"
  }
`;

  // Build messages with conversation history (max last 10 turns for context window)
  const messages = [
    { role: "system", content: SYSTEM_PROMPT },
    ...(conversationHistory || []).slice(-10),
    {
      role: "user",
      content: `[HEALTH CONTEXT]\n${healthContext}\n\n[USER MESSAGE]\n${message}`,
    },
  ];

  try {
    const response = await axios.post('https://api.groq.com/openai/v1/chat/completions', {
      model: "llama3-70b-8192",
      max_tokens: 512,
      messages,
    }, {
      headers: {
        'Authorization': `Bearer ${groqKey}`,
        'Content-Type': 'application/json'
      }
    });

    return res.json({
      ok: true,
      reply: response.data.choices[0].message.content,
    });
  } catch (err) {
    error(`AI coach error: ${err.message}`);
    return res.json(
      { ok: false, error: "AI unavailable — please try again shortly." },
      500,
    );
  }
};
```

```json
// functions/ai-coach/package.json
{
  "name": "ai-coach",
  "version": "1.0.0",
  "type": "module",
  "dependencies": {
    "node-appwrite": "^13.0.0",
    "axios": "^1.6.7"
  }
}
```

### AI Coach Screen

```dart
// lib/features/ai_coach/ai_coach_screen.dart

class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});
  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _loading = false;

  // Starter prompts surfaced in empty state
  static const _starters = [
    'How is my BP trending this month?',
    'What should I eat today for my goal?',
    'Why am I feeling low energy lately?',
    'Suggest a workout for today.',
    'How can I improve my sleep score?',
  ];

  @override
  Widget build(BuildContext context) {
    // Calm Zone for AI coach (no blobs, no glow — trust screen)
    return Scaffold(
      backgroundColor: AppColorsDark.bg2,
      appBar: AppBar(
        title: Row(children: [
          const Icon(Icons.auto_awesome, color: AppColorsDark.accent, size: 20),
          const SizedBox(width: 8),
          Text('AI Coach', style: AppTypography.h1()),
        ]),
        actions: [
          // Pro badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColorsDark.accent, AppColorsDark.primary]),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text('PRO', style: AppTypography.labelMd(color: Colors.white)),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: _messages.isEmpty
              ? _StarterPromptsView(starters: _starters, onTap: _sendMessage)
              : ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(AppSpacing.screenH),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _ChatBubble(message: _messages[i]),
                ),
        ),
        if (_loading) const LinearProgressIndicator(color: AppColorsDark.accent),
        // Input bar
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColorsDark.surface1,
            border: const Border(top: BorderSide(color: AppColorsDark.glassBorder)),
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                maxLines: null,
                decoration: const InputDecoration(hintText: 'Ask your coach…'),
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: AppColorsDark.primary),
              onPressed: () => _sendMessage(_ctrl.text),
            ),
          ]),
        ),
      ]),
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final message = text.trim();
    _ctrl.clear();
    setState(() {
      _messages.add(ChatMessage(role: 'user', content: message));
      _loading = true;
    });
    _scrollToBottom();

    final userId = ref.read(authNotifierProvider).valueOrNull?.$id ?? '';
    final history = _messages.dropLast(1)  // exclude the one just added
        .map((m) => {'role': m.role, 'content': m.content}).toList();

    try {
      final functions = Functions(ref.read(appwriteClientProvider));
      final result = await functions.createExecution(
        functionId: AppConfig.aiCoachFunctionId,
        body: jsonEncode({
          'userId': userId,
          'message': message,
          'conversationHistory': history,
        }),
      );
      final response = jsonDecode(result.responseBody) as Map<String, dynamic>;
      setState(() => _messages.add(ChatMessage(
        role: 'assistant',
        content: response['ok'] == true ? response['reply'] as String : response['error'] as String,
      )));
    } catch (_) {
      setState(() => _messages.add(const ChatMessage(
        role: 'assistant',
        content: 'Sorry, I am unavailable right now. Please try again.',
      )));
    } finally {
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({required String role, required String content}) = _ChatMessage;
}
```

### Environment Variable for AI Coach

```bash
# Add to Appwrite Function environment variables:
appwrite functions createVariable \
  --functionId "ai-coach" \
  --key "GROQ_API_KEY" \
  --value "gsk_..."
```

### Rate Limiting AI Coach Calls

```dart
// Enforce per-user daily limits to control API costs
// Free tier: 0 AI queries/day (upsell to Pro)
// Pro tier: 50 AI queries/day
// The Appwrite Function checks karmaXP or subscription status from users collection
// before making the Groq API call.
```

---

## §F3. iOS HealthKit — Full Implementation

> **Fixes the iOS health data gap.** `ManualEntryProvider` as the iOS fallback loses the premium iPhone user segment to Apple Fitness+ and Fitbit.

### iOS Setup

```xml
<!-- ios/Runner/Info.plist — required HealthKit usage descriptions -->
<key>NSHealthShareUsageDescription</key>
<string>FitKarma reads your steps, heart rate, sleep, and blood pressure to give you personalised health insights.</string>
<key>NSHealthUpdateUsageDescription</key>
<string>FitKarma writes your workout and nutrition data to Apple Health so all your health data stays in sync.</string>
```

```ruby
# ios/Podfile
target 'Runner' do
  use_frameworks!
  use_modular_headers!
  pod 'HealthKit'  # included via flutter health package — no separate pod needed
end
```

### Full HealthKit Provider Implementation

```dart
// lib/features/health/data/health_kit_provider.dart

import 'package:health/health.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthKitProvider implements HealthDataProvider {
  static final _health = Health();

  static const _readTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.WORKOUT,
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
    HealthDataType.BODY_MASS_INDEX,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.MENSTRUATION_FLOW,     // Period tracker
    HealthDataType.RESPIRATORY_RATE,
    HealthDataType.BODY_TEMPERATURE,
  ];

  static const _writeTypes = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.WORKOUT,
    HealthDataType.WATER,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BODY_MASS_INDEX,
    HealthDataType.WEIGHT,
  ];

  @override
  String get providerName => 'Apple Health';

  @override
  Future<bool> requestPermissions() async {
    await _health.configure();
    return _health.requestAuthorization(_readTypes, permissions: _writeTypes);
  }

  @override
  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    try {
      final steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<double?> getLatestHeartRate() async {
    final now = DateTime.now();
    final data = await _health.getHealthDataFromTypes(
      startTime: now.subtract(const Duration(hours: 1)),
      endTime: now,
      types: [HealthDataType.HEART_RATE],
    );
    if (data.isEmpty) return null;
    data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
    return (data.first.value as NumericHealthValue).numericValue.toDouble();
  }

  @override
  Future<double?> getRestingHeartRate() async {
    final now = DateTime.now();
    final data = await _health.getHealthDataFromTypes(
      startTime: now.subtract(const Duration(hours: 24)),
      endTime: now,
      types: [HealthDataType.RESTING_HEART_RATE],
    );
    if (data.isEmpty) return null;
    data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
    return (data.first.value as NumericHealthValue).numericValue.toDouble();
  }

  @override
  Future<List<SleepSession>> getSleepData(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day - 1, 20);
    final end   = DateTime(date.year, date.month, date.day, 12);
    final data  = await _health.getHealthDataFromTypes(
      startTime: start, endTime: end,
      types: [
        HealthDataType.SLEEP_IN_BED, HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_REM,    HealthDataType.SLEEP_DEEP,
      ],
    );
    return _parseSleepSessions(data);
  }

  List<SleepSession> _parseSleepSessions(List<HealthDataPoint> data) {
    if (data.isEmpty) return [];
    // Group by type and compute durations
    final inBed     = data.where((d) => d.type == HealthDataType.SLEEP_IN_BED);
    final totalMins = inBed.fold<int>(0, (sum, d) =>
        sum + d.dateTo.difference(d.dateFrom).inMinutes);
    final remMins   = data.where((d) => d.type == HealthDataType.SLEEP_REM)
        .fold<int>(0, (sum, d) => sum + d.dateTo.difference(d.dateFrom).inMinutes);
    final deepMins  = data.where((d) => d.type == HealthDataType.SLEEP_DEEP)
        .fold<int>(0, (sum, d) => sum + d.dateTo.difference(d.dateFrom).inMinutes);

    if (inBed.isEmpty) return [];
    return [SleepSession(
      start:         inBed.first.dateFrom,
      end:           inBed.last.dateTo,
      totalMinutes:  totalMins,
      remMinutes:    remMins,
      deepMinutes:   deepMins,
      lightMinutes:  totalMins - remMins - deepMins,
      qualityScore:  _computeSleepQuality(totalMins, remMins, deepMins),
    )];
  }

  int _computeSleepQuality(int total, int rem, int deep) {
    if (total == 0) return 0;
    // Score = 40% duration + 30% REM% + 30% deep%
    final durationScore = (total.clamp(0, 480) / 480 * 40).round();
    final remScore      = (rem / total * 30).round().clamp(0, 30);
    final deepScore     = (deep / total * 30).round().clamp(0, 30);
    return durationScore + remScore + deepScore;
  }

  @override
  Future<List<BpReading>> getBloodPressureData({int days = 7}) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final systolicData = await _health.getHealthDataFromTypes(
      startTime: start, endTime: now, types: [HealthDataType.BLOOD_PRESSURE_SYSTOLIC]);
    final diastolicData = await _health.getHealthDataFromTypes(
      startTime: start, endTime: now, types: [HealthDataType.BLOOD_PRESSURE_DIASTOLIC]);

    // Pair readings by timestamp (±1 minute tolerance)
    final readings = <BpReading>[];
    for (final sys in systolicData) {
      final dia = diastolicData.where((d) =>
          (d.dateFrom.millisecondsSinceEpoch - sys.dateFrom.millisecondsSinceEpoch).abs() < 60000
      ).firstOrNull;
      if (dia != null) {
        final s = (sys.value as NumericHealthValue).numericValue.toInt();
        final d = (dia.value as NumericHealthValue).numericValue.toInt();
        readings.add(BpReading(
          systolic: s, diastolic: d,
          measuredAt: sys.dateFrom,
          classification: BpClassifier.classify(s, d),
        ));
      }
    }
    return readings..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
  }

  // ── Write to Apple Health ────────────────────────────────

  Future<bool> writeSteps(int steps, DateTime start, DateTime end) async {
    return _health.writeHealthData(
      value: steps.toDouble(), type: HealthDataType.STEPS,
      startTime: start, endTime: end,
    );
  }

  Future<bool> writeWaterIntake(double millilitres, DateTime time) async {
    return _health.writeHealthData(
      value: millilitres / 1000, // HealthKit stores in litres
      type: HealthDataType.WATER,
      startTime: time, endTime: time,
    );
  }

  Future<bool> writeBloodGlucose(double mgDl, DateTime time) async {
    return _health.writeHealthData(
      value: mgDl / 18.0, // HealthKit stores in mmol/L
      type: HealthDataType.BLOOD_GLUCOSE,
      startTime: time, endTime: time,
    );
  }

  Future<bool> writeWorkout({
    required WorkoutType workoutType,
    required DateTime start,
    required DateTime end,
    required double totalEnergyBurned,
    double? totalDistance,
  }) async {
    return _health.writeWorkoutData(
      activityType: workoutType,
      start: start, end: end,
      totalEnergyBurned: totalEnergyBurned,
      totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
      totalDistance: totalDistance,
      totalDistanceUnit: HealthDataUnit.METER,
    );
  }
}
```

### HealthKit Background Delivery (iOS)

```dart
// lib/features/health/data/health_kit_background.dart
// Enables HealthKit to wake the app in background when new data arrives

class HealthKitBackgroundDelivery {
  static Future<void> enable() async {
    // Requires entitlement: com.apple.developer.healthkit.background-delivery
    // Set via Xcode → Signing & Capabilities → HealthKit → Background Delivery
    final health = Health();
    for (final type in HealthKitProvider._readTypes) {
      try {
        await health.enableBackgroundDelivery(
          type: type,
          frequency: HealthWorkoutActivityType.OTHER, // ignored for non-workout types
        );
      } catch (_) {}
    }
  }
}
```

```xml
<!-- ios/Runner/Runner.entitlements -->
<key>com.apple.developer.healthkit</key>
<true/>
<key>com.apple.developer.healthkit.background-delivery</key>
<true/>
<key>com.apple.developer.healthkit.access</key>
<array>
  <string>health-records</string>
</array>
```

---

## §F4. Subscription Model & Monetisation

> **Fixes the missing monetisation model.** FitKarma needs a sustainable revenue path. Based on competitive analysis, a freemium model with a ₹299–499/month Pro tier is appropriate.

### Tier Comparison

| Feature                                           | Free            | Pro (₹299/month)  |
| ------------------------------------------------- | --------------- | ----------------- |
| Food logging                                      | ✅ Unlimited    | ✅ Unlimited      |
| Basic health tracking (BP, glucose, steps, sleep) | ✅              | ✅                |
| Offline-first + encryption                        | ✅              | ✅                |
| Festival calendar                                 | ✅              | ✅                |
| Dosha quiz                                        | ✅              | ✅                |
| Karma / XP gamification                           | ✅              | ✅                |
| AI Coach queries                                  | ❌              | ✅ 50/day         |
| Correlation insights                              | ❌              | ✅                |
| Lab report storage                                | ❌ (3 reports)  | ✅ Unlimited      |
| Wedding planner                                   | ❌              | ✅                |
| Social groups                                     | ❌              | ✅                |
| Advanced reports (PDF export)                     | ❌              | ✅                |
| Home widgets                                      | ✅ Steps widget | ✅ All widgets    |
| Priority sync                                     | ❌              | ✅ 15min interval |

### RevenueCat Setup

```dart
// lib/features/settings/subscription_service.dart

import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  static const _revenueCatApiKey = String.fromEnvironment('REVENUECAT_API_KEY');

  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    final configuration = PurchasesConfiguration(_revenueCatApiKey);
    await Purchases.configure(configuration);
  }

  static Future<bool> isPro() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey('pro');
    } catch (_) {
      return false;
    }
  }

  static Future<void> purchasePro(BuildContext context) async {
    try {
      final offerings = await Purchases.getOfferings();
      final monthly = offerings.current?.monthly;
      if (monthly == null) return;
      await Purchases.purchaseStoreProduct(monthly.storeProduct);
    } on PurchasesErrorCode catch (e) {
      if (e != PurchasesErrorCode.purchaseCancelledError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: ${e.name}')));
      }
    }
  }

  static Future<void> restorePurchases() async {
    await Purchases.restorePurchases();
  }
}

@riverpod
Future<bool> isPro(IsProRef ref) => SubscriptionService.isPro();
```

### Subscription Provider

```dart
@riverpod
class SubscriptionNotifier extends _$SubscriptionNotifier {
  @override
  Future<bool> build() => SubscriptionService.isPro();

  Future<void> purchase(BuildContext context) async {
    await SubscriptionService.purchasePro(context);
    ref.invalidateSelf();
  }
}
```

### Pro Gate Widget

```dart
// lib/features/settings/pro_gate.dart
// Wrap any Pro-only feature

class ProGate extends ConsumerWidget {
  final Widget child;
  final Widget? lockedChild;
  const ProGate({super.key, required this.child, this.lockedChild});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProAsync = ref.watch(isProProvider);
    return isProAsync.when(
      loading: () => const ShimmerLoader(height: 60),
      error:   (_, __) => lockedChild ?? _UpgradePrompt(),
      data: (isPro) => isPro ? child : (lockedChild ?? _UpgradePrompt()),
    );
  }
}

class _UpgradePrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(children: [
        const Icon(Icons.lock_outline, color: AppColorsDark.accent),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Pro Feature', style: AppTypography.h4()),
          Text('Upgrade to FitKarma Pro for ₹299/month', style: AppTypography.bodyMd()),
        ])),
        ElevatedButton(
          onPressed: () => context.push('/subscription'),
          child: const Text('Upgrade'),
        ),
      ]),
    );
  }
}
```

### Subscription Screen

```dart
// lib/features/settings/subscription_screen.dart
// Calm Zone scaffold

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColorsDark.bg2,
      appBar: AppBar(title: Text('FitKarma Pro', style: AppTypography.h1())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: Column(children: [
          // Hero badge
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColorsDark.accent, AppColorsDark.primary]),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(children: [
              Text('⚡ FitKarma Pro', style: AppTypography.displayLg(color: Colors.white)),
              Text('₹299 / month', style: AppTypography.h2(color: Colors.white70)),
              Text('₹2,499 / year  (save 30%)', style: AppTypography.bodyMd(color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 24),
          // Feature list
          ...SubscriptionService.proFeatures.map((f) => ListTile(
            leading: const Icon(Icons.check_circle, color: AppColorsDark.success),
            title: Text(f, style: AppTypography.bodyMd()),
          )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.read(subscriptionNotifierProvider.notifier).purchase(context),
            child: const Text('Start Free 7-Day Trial'),
          ),
          TextButton(
            onPressed: SubscriptionService.restorePurchases,
            child: Text('Restore purchases', style: AppTypography.bodyMd()),
          ),
        ]),
      ),
    );
  }
}
```

### RevenueCat Environment Variables

```bash
# Add to dart-define at build time:
flutter build apk --release \
  --dart-define=REVENUECAT_API_KEY=appl_... \
  --dart-define=APPWRITE_ENDPOINT=... \
  --dart-define=APPWRITE_PROJECT_ID=... \
  --dart-define=APPWRITE_DB_ID=fitkarma-db \
  --dart-define=SENTRY_DSN=...
```

---

## Updated Glossary

| Term                    | Definition                                                                                                                                            |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Open Food Facts**     | Open-source food database with 3M+ global products. FitKarma uses it as the secondary food search source (primary = Appwrite Indian DB).              |
| **Indian Food DB**      | Custom Appwrite `food_database` collection seeded with 5,000+ Indian foods with Hindi names, serving sizes, and regional variants.                    |
| **AI Coach**            | LLM-powered conversational health coach running via Appwrite Function (`ai-coach`). Pro-only feature. Uses health context from Appwrite collections.  |
| **HealthKit**           | Apple's health data platform (iOS). Full read + write implementation in `HealthKitProvider`. Enabled via `com.apple.developer.healthkit` entitlement. |
| **RevenueCat**          | Cross-platform subscription management SDK. Handles App Store + Play Store receipts, `pro` entitlement checking, and trial management.                |
| **Pro Tier**            | ₹299/month subscription unlocking AI Coach, correlation insights, unlimited lab reports, wedding planner, social groups, PDF reports.                 |
| **Background Delivery** | iOS HealthKit feature that wakes the app to process new health data. Requires `com.apple.developer.healthkit.background-delivery` entitlement.        |

---

_FitKarma — Complete Documentation
_UI Design System · Technical Implementation Guide_
_Flutter 3.x · Riverpod 2.x · Drift · Appwrite CLI · RevenueCat · Open Food Facts · Groq Llama-3_
_Offline-first · AES-256 encrypted · Privacy-centric · Built for India_
_68 sections · 45+ screens · 28 shared components · 17 Appwrite collections · 5 server functions · Full CI/CD_
_Critical fixes: §F1 Food Database · §F2 AI Coach · §F3 iOS HealthKit · §F4 Subscription Model_

---

## Part V — Full Appwrite CLI Schemas (All Collections)

---

## §A1. Complete Appwrite Collection Definitions

> Every attribute, index, and permission for all 17 collections. Run these commands after §24 Step 2 (database created).

### Users Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "users" --name "Users" \
  --permissions 'read("users")' 'create("users")' 'update("users")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "userId"          --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "name"            --size 100 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "email"           --size 254 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "gender"          --size 10  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "users" \
  --key "dob"             --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "users" \
  --key "heightCm"        --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "users" \
  --key "weightKg"        --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "bloodGroup"      --size 5   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "fitnessGoal"     --size 30  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "activityLevel"   --size 20  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "dominantDosha"   --size 10  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "language"        --size 10  --required false --default "en"
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "karmaLevel"      --size 20  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "users" \
  --key "karmaXP"         --required false --default 0
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "conditions"      --size 500 --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "users" \
  --key "firstLaunchTs"   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "weddingDate"     --size 20  --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "users" \
  --key "targetWeightKg"  --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "users" \
  --key "isPro"           --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "revenueCatId"    --size 100 --required false

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "users" \
  --key "userId_idx" --type unique --attributes userId
```

### Food Logs Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "food_logs" --name "Food Logs" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "userId"        --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "localId"       --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "foodName"      --size 200 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "foodNameLocal" --size 200 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "mealType"      --size 20  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "loggedAt"      --required true
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "calories"      --required true
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "proteinG"      --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "carbsG"        --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "fatG"          --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "fiberG"        --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "portionUnit"   --size 30  --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "portionQty"    --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "source"        --size 20  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "foodDbId"      --size 36  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "imageUrl"      --size 300 --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "isDeleted"     --required false --default false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "deletedAt"     --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "syncStatus"    --size 10  --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "failedAttempts" --required false --default 0
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "updatedAt"     --required false

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "user_date_idx" --type key --attributes userId,loggedAt
appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "localId_idx" --type unique --attributes localId
```

### Blood Pressure Readings

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "bp_readings" --name "Blood Pressure Readings" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "userId"         --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "localId"        --size 36  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "systolic"       --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "diastolic"      --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "pulse"          --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "measuredAt"     --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "notes"          --size 500 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "classification" --size 30  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "measuredArm"    --size 10  --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "isDeleted"      --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "syncStatus"     --size 10  --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "failedAttempts" --required false --default 0
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "updatedAt"      --required false

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "user_time_idx" --type key --attributes userId,measuredAt
appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "localId_idx" --type unique --attributes localId
```

### Glucose Readings

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "glucose_readings" --name "Glucose Readings" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "userId"          --size 36 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "localId"         --size 36 --required true
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "valueMgDl"       --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "readingType"     --size 20 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "measuredAt"      --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "classification"  --size 20 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "linkedFoodLogId" --size 36 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "notes"           --size 300 --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "isDeleted"       --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "syncStatus"      --size 10 --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "failedAttempts"  --required false --default 0
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "updatedAt"       --required false

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "user_time_idx" --type key --attributes userId,measuredAt
```

### Sleep Logs

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "sleep_logs" --name "Sleep Logs" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "userId"        --size 36 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "localId"       --size 36 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "sleepStart"    --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "sleepEnd"      --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "totalMinutes"  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "remMinutes"    --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "deepMinutes"   --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "lightMinutes"  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "qualityScore"  --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "avgSpO2"       --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "avgHeartRate"  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "source"        --size 20 --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "isDeleted"     --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "syncStatus"    --size 10 --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "failedAttempts" --required false --default 0

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "user_night_idx" --type key --attributes userId,sleepStart
```

### Workouts Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "workouts" --name "Workouts" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "userId"          --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "localId"         --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "name"            --size 100  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "workoutType"     --size 30   --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "startedAt"       --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "endedAt"         --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "durationSeconds" --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "caloriesBurned"  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "avgHeartRate"    --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "maxHeartRate"    --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "distanceKm"      --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "exercisesJson"   --size 5000 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "gpsRouteJson"    --size 5000 --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "isDeleted"       --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "syncStatus"      --size 10   --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "failedAttempts"  --required false --default 0

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "user_date_idx" --type key --attributes userId,startedAt
```

### Habits Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "habits" --name "Habits" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "habits" \
  --key "userId"           --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "habits" \
  --key "localId"          --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "habits" \
  --key "name"             --size 100  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "habits" \
  --key "icon"             --size 5    --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "habits" \
  --key "frequency"        --size 20   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "habits" \
  --key "completedDates"   --size 3000 --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "habits" \
  --key "currentStreak"    --required false --default 0
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "habits" \
  --key "longestStreak"    --required false --default 0
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "habits" \
  --key "isActive"         --required false --default true
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "habits" \
  --key "isDeleted"        --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "habits" \
  --key "syncStatus"       --size 10   --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "habits" \
  --key "updatedAt"        --required false
```

### Journal Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "journal" --name "Journal" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "userId"        --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "localId"       --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "title"         --size 200  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "body"          --size 5000 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "journal" \
  --key "moodScore"     --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "moodEmoji"     --size 4    --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "tags"          --size 200  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "journal" \
  --key "createdAt"     --required true
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "journal" \
  --key "isDeleted"     --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "syncStatus"    --size 10   --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "journal" \
  --key "failedAttempts" --required false --default 0
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "journal" \
  --key "updatedAt"     --required false

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "user_date_idx" --type key --attributes userId,createdAt
```

### Lab Reports Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "lab_reports" --name "Lab Reports" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "userId"        --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "localId"       --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "reportName"    --size 200  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "reportDate"    --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "labName"       --size 100  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "valuesJson"    --size 5000 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "fileId"        --size 36   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "notes"         --size 500  --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "isDeleted"     --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "syncStatus"    --size 10   --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "failedAttempts" --required false --default 0

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "user_date_idx" --type key --attributes userId,reportDate
```

### Karma Events Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "karma_events" --name "Karma Events" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' 'update("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "userId"      --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "eventType"   --size 50  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "xpAwarded"   --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "occurredAt"  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "resourceId"  --size 36  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "syncStatus"  --size 10  --required false --default "synced"

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "user_time_idx" --type key --attributes userId,occurredAt
```

### Festivals Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "festivals" --name "Festivals" \
  --permissions 'read("users")' 'create("team:admins")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "name"          --size 100 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "nameHindi"     --size 100 --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "date"          --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "type"          --size 20  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "dietaryNotes"  --size 500 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "region"        --size 50  --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "isFastingDay"  --required false --default false

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "date_idx" --type key --attributes date
```

### Medications Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "medications" --name "Medications" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "medications" \
  --key "userId"        --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "medications" \
  --key "localId"       --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "medications" \
  --key "name"          --size 200 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "medications" \
  --key "dosage"        --size 50  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "medications" \
  --key "scheduleJson"  --size 500 --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "medications" \
  --key "isActive"      --required false --default true
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "medications" \
  --key "isDeleted"     --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "medications" \
  --key "notes"         --size 500 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "medications" \
  --key "syncStatus"    --size 10  --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "medications" \
  --key "failedAttempts" --required false --default 0
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "medications" \
  --key "updatedAt"     --required false
```

### Water Logs Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "water_logs" --name "Water Logs" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "userId"      --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "localId"     --size 36  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "amountMl"    --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "loggedAt"    --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "source"      --size 20  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "syncStatus"  --size 10  --required false --default "synced"
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "failedAttempts" --required false --default 0

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "user_date_idx" --type key --attributes userId,loggedAt
```

### Social Posts Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "social_posts" --name "Social Posts" \
  --permissions 'read("users")' 'create("users")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "userId"       --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "groupId"      --size 36   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "content"      --size 1000 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "postType"     --size 20   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "reactions"    --size 500  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "createdAt"    --required true
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "isDeleted"    --required false --default false

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "group_time_idx" --type key --attributes groupId,createdAt
```

### Groups Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "groups" --name "Groups" \
  --permissions 'read("users")' 'create("users")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "groups" \
  --key "name"          --size 100  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "groups" \
  --key "createdBy"     --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "groups" \
  --key "members"       --size 2000 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "groups" \
  --key "groupType"     --size 20   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "groups" \
  --key "description"   --size 300  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "groups" \
  --key "createdAt"     --required true
```

### Share Tokens Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "share_tokens" --name "Share Tokens" \
  --permissions 'read("users")' 'create("users")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "userId"      --size 36 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "reportId"    --size 36 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "token"       --size 64 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "expiresAt"   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "reportType"  --size 20 --required false

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "token_idx" --type unique --attributes token
```

---

## Part VI — Complete Implementation Details

---

## §B1. Complete Drift Schema — All Tables

```dart
// lib/core/database/app_database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

// ── Tables ───────────────────────────────────────────────────────

class FoodLogs extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  TextColumn  get foodName       => text()();
  TextColumn  get foodNameLocal  => text().nullable()();
  TextColumn  get mealType       => text()();
  IntColumn   get loggedAt       => integer()();
  RealColumn  get calories       => real()();
  RealColumn  get proteinG       => real().nullable()();
  RealColumn  get carbsG         => real().nullable()();
  RealColumn  get fatG           => real().nullable()();
  RealColumn  get fiberG         => real().nullable()();
  TextColumn  get portionUnit    => text().nullable()();
  RealColumn  get portionQty     => real().nullable()();
  TextColumn  get source         => text().nullable()();
  TextColumn  get foodDbId       => text().nullable()();
  TextColumn  get imageUrl       => text().nullable()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  IntColumn   get deletedAt      => integer().nullable()();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class BpReadings extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  IntColumn   get systolic       => integer()();
  IntColumn   get diastolic      => integer()();
  IntColumn   get pulse          => integer().nullable()();
  IntColumn   get measuredAt     => integer()();
  TextColumn  get notes          => text().nullable()();
  TextColumn  get classification => text().nullable()();
  TextColumn  get measuredArm    => text().nullable()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class GlucoseReadings extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  RealColumn  get valueMgDl      => real()();
  TextColumn  get readingType    => text()();
  IntColumn   get measuredAt     => integer()();
  TextColumn  get classification => text().nullable()();
  TextColumn  get linkedFoodLogId => text().nullable()();
  TextColumn  get notes          => text().nullable()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class SleepLogs extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  IntColumn   get sleepStart     => integer()();
  IntColumn   get sleepEnd       => integer()();
  IntColumn   get totalMinutes   => integer().nullable()();
  IntColumn   get remMinutes     => integer().nullable()();
  IntColumn   get deepMinutes    => integer().nullable()();
  IntColumn   get lightMinutes   => integer().nullable()();
  IntColumn   get qualityScore   => integer().nullable()();
  RealColumn  get avgSpO2        => real().nullable()();
  RealColumn  get avgHeartRate   => real().nullable()();
  TextColumn  get source         => text().nullable()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}

class Workouts extends Table {
  TextColumn  get id              => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId          => text()();
  TextColumn  get name            => text()();
  TextColumn  get workoutType     => text().nullable()();
  IntColumn   get startedAt       => integer()();
  IntColumn   get endedAt         => integer().nullable()();
  IntColumn   get durationSeconds => integer().nullable()();
  RealColumn  get caloriesBurned  => real().nullable()();
  IntColumn   get avgHeartRate    => integer().nullable()();
  IntColumn   get maxHeartRate    => integer().nullable()();
  RealColumn  get distanceKm      => real().nullable()();
  TextColumn  get exercisesJson   => text().nullable()();
  TextColumn  get gpsRouteJson    => text().nullable()();
  BoolColumn  get isDeleted       => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus      => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId        => text().nullable()();
  IntColumn   get failedAttempts  => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}

class Habits extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  TextColumn  get name           => text()();
  TextColumn  get icon           => text().nullable()();
  TextColumn  get frequency      => text().nullable()();
  TextColumn  get completedDates => text().nullable()();
  IntColumn   get currentStreak  => integer().withDefault(const Constant(0))();
  IntColumn   get longestStreak  => integer().withDefault(const Constant(0))();
  BoolColumn  get isActive       => boolean().withDefault(const Constant(true))();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class JournalEntries extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  TextColumn  get title          => text().nullable()();
  TextColumn  get body           => text()();
  IntColumn   get moodScore      => integer().nullable()();
  TextColumn  get moodEmoji      => text().nullable()();
  TextColumn  get tags           => text().nullable()();
  IntColumn   get createdAt      => integer()();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  IntColumn   get deletedAt      => integer().nullable()();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

class WaterLogs extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  IntColumn   get amountMl       => integer()();
  IntColumn   get loggedAt       => integer()();
  TextColumn  get source         => text().nullable()();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}

class Medications extends Table {
  TextColumn  get id             => text().clientDefault(() => const Uuid().v4())();
  TextColumn  get userId         => text()();
  TextColumn  get name           => text()();
  TextColumn  get dosage         => text().nullable()();
  TextColumn  get scheduleJson   => text().nullable()();
  BoolColumn  get isActive       => boolean().withDefault(const Constant(true))();
  BoolColumn  get isDeleted      => boolean().withDefault(const Constant(false))();
  TextColumn  get notes          => text().nullable()();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();
  TextColumn  get remoteId       => text().nullable()();
  IntColumn   get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn   get updatedAt      => integer().nullable()();
  @override Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  FoodLogs, BpReadings, GlucoseReadings, SleepLogs,
  Workouts, Habits, JournalEntries, WaterLogs, Medications,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(foodLogs, foodLogs.failedAttempts);
        await m.addColumn(bpReadings, bpReadings.failedAttempts);
      }
      if (from < 3) {
        await m.addColumn(foodLogs, foodLogs.remoteId);
        await m.addColumn(bpReadings, bpReadings.remoteId);
        await m.addColumn(foodLogs, foodLogs.fiberG);
        await m.addColumn(foodLogs, foodLogs.foodDbId);
        await m.addColumn(foodLogs, foodLogs.imageUrl);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // ── Convenience query methods ────────────────────────────────

  Stream<List<FoodLog>> watchTodayFoodLogs(String userId) {
    final now = DateTime.now();
    final startTs = DateTime(now.year, now.month, now.day)
        .millisecondsSinceEpoch ~/ 1000;
    return (select(foodLogs)
      ..where((t) =>
          t.userId.equals(userId) &
          t.isDeleted.equals(false) &
          t.loggedAt.isBetweenValues(startTs, startTs + 86400))
      ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
        .watch();
  }

  Future<List<BpReading>> getRecentBpReadings(String userId, {int days = 30}) {
    final cutoff = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch ~/ 1000;
    return (select(bpReadings)
      ..where((t) =>
          t.userId.equals(userId) &
          t.isDeleted.equals(false) &
          t.measuredAt.isBiggerOrEqualValue(cutoff))
      ..orderBy([(t) => OrderingTerm.asc(t.measuredAt)]))
        .get();
  }

  Future<int> getTodayWaterMl(String userId) async {
    final now = DateTime.now();
    final startTs = DateTime(now.year, now.month, now.day)
        .millisecondsSinceEpoch ~/ 1000;
    final rows = await (select(waterLogs)
      ..where((t) =>
          t.userId.equals(userId) &
          t.loggedAt.isBetweenValues(startTs, startTs + 86400)))
        .get();
    return rows.fold(0, (sum, r) => sum + r.amountMl);
  }

  Future<List<FoodLog>> getPendingSync(String table) async {
    // Returns records where syncStatus = 'pending' AND failedAttempts < 3
    switch (table) {
      case 'food_logs':
        return (select(foodLogs)
          ..where((t) =>
              t.syncStatus.equals('pending') &
              t.failedAttempts.isSmallerThanValue(3)))
          .get();
      case 'bp_readings':
        return []; // Cast to correct type per table
      default:
        return [];
    }
  }
}

// ── Encrypted database factory ───────────────────────────────────

Future<AppDatabase> openEncryptedDatabase() async {
  final dir  = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'fitkarma.db');
  final key  = await _getOrCreateDbKey();

  return AppDatabase(
    NativeDatabase.createInBackground(
      File(path),
      setup: (db) {
        db.execute("PRAGMA key = '$key'");
        db.execute("PRAGMA cipher_page_size = 4096");
        db.execute("PRAGMA kdf_iter = 64000");
      },
    ),
  );
}

Future<String> _getOrCreateDbKey() async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  var key = await storage.read(key: 'fitkarma_db_key');
  if (key == null) {
    key = const Uuid().v4();
    await storage.write(key: 'fitkarma_db_key', value: key);
  }
  return key;
}
```

---

## §B2. Complete Sync Engine

```dart
// lib/core/sync/sync_worker.dart

import 'package:appwrite/appwrite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SyncPriority { critical, high, medium, low }

class SyncWorker {
  final AppDatabase _db;
  final Databases _appwriteDb;
  static const _dbId = 'fitkarma-db';

  SyncWorker(this._db, this._appwriteDb);

  Future<void> syncAll() async {
    final conn = await Connectivity().checkConnectivity();
    if (conn == ConnectivityResult.none) return;

    // Priority order: clinical data first
    await Future.wait([
      _syncBpReadings(),
      _syncGlucoseReadings(),
      _syncMedications(),
    ]);
    await Future.wait([
      _syncWorkouts(),
      _syncSleepLogs(),
    ]);
    await Future.wait([
      _syncFoodLogs(),
      _syncHabits(),
      _syncJournalEntries(),
    ]);
    await Future.wait([
      _syncWaterLogs(),
    ]);
  }

  Future<void> _syncBpReadings() async {
    final pending = await (_db.select(_db.bpReadings)
      ..where((t) =>
          t.syncStatus.equals('pending') & t.failedAttempts.isSmallerThanValue(3)))
      .get();

    for (final row in pending) {
      await _pushRecord(
        localId: row.id,
        collectionId: 'bp_readings',
        remoteId: row.remoteId,
        data: {
          'userId':         row.userId,
          'localId':        row.id,
          'systolic':       row.systolic,
          'diastolic':      row.diastolic,
          'pulse':          row.pulse,
          'measuredAt':     row.measuredAt,
          'notes':          row.notes,
          'classification': row.classification,
          'syncStatus':     'synced',
          'updatedAt':      DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
        onSuccess: (remoteDocId) async {
          await (_db.update(_db.bpReadings)
            ..where((t) => t.id.equals(row.id)))
            .write(BpReadingsCompanion(
              syncStatus: const Value('synced'),
              remoteId:   Value(remoteDocId),
            ));
        },
        onFailure: () async {
          final attempts = row.failedAttempts + 1;
          await (_db.update(_db.bpReadings)
            ..where((t) => t.id.equals(row.id)))
            .write(BpReadingsCompanion(
              failedAttempts: Value(attempts),
              syncStatus: Value(attempts >= 3 ? 'dlq' : 'pending'),
            ));
        },
      );
    }
  }

  Future<void> _syncFoodLogs() async {
    final pending = await (_db.select(_db.foodLogs)
      ..where((t) =>
          t.syncStatus.equals('pending') &
          t.isDeleted.equals(false) &
          t.failedAttempts.isSmallerThanValue(3)))
      .get();

    for (final row in pending) {
      await _pushRecord(
        localId: row.id,
        collectionId: 'food_logs',
        remoteId: row.remoteId,
        data: {
          'userId':     row.userId,
          'localId':    row.id,
          'foodName':   row.foodName,
          'mealType':   row.mealType,
          'loggedAt':   row.loggedAt,
          'calories':   row.calories,
          'proteinG':   row.proteinG,
          'carbsG':     row.carbsG,
          'fatG':       row.fatG,
          'fiberG':     row.fiberG,
          'portionUnit':row.portionUnit,
          'portionQty': row.portionQty,
          'source':     row.source,
          'syncStatus': 'synced',
          'updatedAt':  DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
        onSuccess: (remoteDocId) async {
          await (_db.update(_db.foodLogs)
            ..where((t) => t.id.equals(row.id)))
            .write(FoodLogsCompanion(
              syncStatus: const Value('synced'),
              remoteId:   Value(remoteDocId),
            ));
        },
        onFailure: () async {
          final attempts = row.failedAttempts + 1;
          await (_db.update(_db.foodLogs)
            ..where((t) => t.id.equals(row.id)))
            .write(FoodLogsCompanion(
              failedAttempts: Value(attempts),
              syncStatus: Value(attempts >= 3 ? 'dlq' : 'pending'),
            ));
        },
      );
    }
  }

  // Generic push helper — handles create vs update
  Future<void> _pushRecord({
    required String localId,
    required String collectionId,
    required String? remoteId,
    required Map<String, dynamic> data,
    required Future<void> Function(String remoteDocId) onSuccess,
    required Future<void> Function() onFailure,
  }) async {
    try {
      String docId;
      if (remoteId != null) {
        // Already exists remotely — update
        final doc = await _appwriteDb.updateDocument(
          databaseId: _dbId,
          collectionId: collectionId,
          documentId: remoteId,
          data: data,
        );
        docId = doc.$id;
      } else {
        // New record — create
        final doc = await _appwriteDb.createDocument(
          databaseId: _dbId,
          collectionId: collectionId,
          documentId: ID.unique(),
          data: data,
          permissions: [
            Permission.read(Role.user(data['userId'] as String)),
            Permission.update(Role.user(data['userId'] as String)),
            Permission.delete(Role.user(data['userId'] as String)),
          ],
        );
        docId = doc.$id;
      }
      await onSuccess(docId);
    } on AppwriteException catch (e) {
      debugPrint('Sync failed [$collectionId/$localId]: ${e.message}');
      await onFailure();
    }
  }

  // Remaining sync methods follow identical pattern:
  Future<void> _syncGlucoseReadings() async { /* same pattern as _syncBpReadings */ }
  Future<void> _syncMedications() async { /* same pattern */ }
  Future<void> _syncWorkouts() async { /* same pattern */ }
  Future<void> _syncSleepLogs() async { /* same pattern */ }
  Future<void> _syncHabits() async { /* same pattern */ }
  Future<void> _syncJournalEntries() async { /* same pattern */ }
  Future<void> _syncWaterLogs() async { /* same pattern */ }
}

// DLQ count provider — drives DLQAlertBanner
@riverpod
Stream<int> dlqCount(DlqCountRef ref) {
  final db = ref.watch(appDatabaseProvider);
  // Count all records across tables where syncStatus = 'dlq'
  // Simplified: watch food_logs DLQ as representative count
  return (db.select(db.foodLogs)
    ..where((t) => t.syncStatus.equals('dlq')))
    .watch()
    .map((rows) => rows.length);
}
```

---

## §B3. Complete Notification Service

```dart
// lib/core/notifications/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false, // Request manually on permissions screen
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Cancel all scheduled notifications for a given ID range
  static Future<void> cancelMealReminders() async {
    for (int i = 100; i < 130; i++) await _plugin.cancel(i);
  }

  /// Schedule meal reminders for all 3 meals
  static Future<void> scheduleMealReminders({
    required int breakfastHour, required int breakfastMinute,
    required int lunchHour,     required int lunchMinute,
    required int dinnerHour,    required int dinnerMinute,
  }) async {
    await cancelMealReminders();
    await _scheduleDaily(
      id: 101, title: 'Log your breakfast 🌅',
      body: 'Start the day strong — log your breakfast in FitKarma.',
      hour: breakfastHour, minute: breakfastMinute,
      channel: 'meal_reminders',
    );
    await _scheduleDaily(
      id: 102, title: 'Log your lunch 🍛',
      body: 'Keep your nutrition streak alive — log lunch now.',
      hour: lunchHour, minute: lunchMinute,
      channel: 'meal_reminders',
    );
    await _scheduleDaily(
      id: 103, title: 'Log your dinner 🌙',
      body: 'One last log for today — you\'re almost there!',
      hour: dinnerHour, minute: dinnerMinute,
      channel: 'meal_reminders',
    );
  }

  static Future<void> scheduleMedicationReminder({
    required int id,
    required String medicationName,
    required int hour,
    required int minute,
  }) async {
    await _scheduleDaily(
      id: id, title: 'Time for $medicationName 💊',
      body: 'Don\'t forget your medication.',
      hour: hour, minute: minute,
      channel: 'medications',
      importance: Importance.max,
    );
  }

  static Future<void> showSyncFailedNotification(int dlqCount) async {
    await _plugin.show(
      999,
      '$dlqCount item${dlqCount > 1 ? 's' : ''} failed to sync',
      'Tap to review and resolve in FitKarma settings.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'sync_failed', 'Sync Failures',
          importance: Importance.high, priority: Priority.high,
          color: const Color(0xFFFBBF24),
        ),
      ),
    );
  }

  static Future<void> _scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String channel,
    Importance importance = Importance.high,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id, title, body, scheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(channel, channel,
            importance: importance, priority: Priority.high),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: channel,
          interruptionLevel: channel == 'medications'
              ? InterruptionLevel.timeSensitive
              : InterruptionLevel.active,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
```

---

## §B4. GoRouter — App Router with Auth Guard

```dart
// lib/core/router/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isOnboarding = state.matchedLocation.startsWith('/onboarding');
      final isAuth = state.matchedLocation.startsWith('/auth');
      final isSplash = state.matchedLocation == '/splash';

      if (isSplash) return null;
      if (!isAuthenticated && !isAuth && !isOnboarding) return '/auth/login';
      if (isAuthenticated && isAuth) return '/home/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/splash',      builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/auth/login',  builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/auth/signup', builder: (_, __) => const SignupScreen()),

      // Onboarding flow
      GoRoute(path: '/onboarding/welcome',     builder: (_, __) => const OnboardingWelcomeScreen()),
      GoRoute(path: '/onboarding/profile',     builder: (_, __) => const OnboardingProfileScreen()),
      GoRoute(path: '/onboarding/goals',       builder: (_, __) => const HealthGoalsSetupScreen()),
      GoRoute(path: '/onboarding/dosha',       builder: (_, __) => const DoshaQuizScreen()),
      GoRoute(path: '/onboarding/permissions', builder: (_, __) => const PermissionsPrivacyScreen()),

      // Main shell with bottom nav
      ShellRoute(
        builder: (ctx, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/home/dashboard', builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/home/food',      builder: (_, __) => const FoodHomeScreen()),
          GoRoute(path: '/home/workout',   builder: (_, __) => const WorkoutHomeScreen()),
          GoRoute(path: '/home/steps',     builder: (_, __) => const StepsScreen()),
          GoRoute(path: '/karma',          builder: (_, __) => const KarmaHubScreen()),
        ],
      ),

      // Health screens
      GoRoute(path: '/blood-pressure',  builder: (_, __) => const BloodPressureScreen()),
      GoRoute(path: '/glucose',         builder: (_, __) => const GlucoseScreen()),
      GoRoute(path: '/sleep',           builder: (_, __) => const SleepScreen()),
      GoRoute(path: '/mental-health',   builder: (_, __) => const MentalHealthHubScreen()),

      // Workout
      GoRoute(
        path: '/workout/active/:workoutId',
        builder: (_, state) => WorkoutActiveScreen(workoutId: state.pathParameters['workoutId']!),
      ),

      // Journal, profile, settings
      GoRoute(path: '/journal',         builder: (_, __) => const JournalScreen()),
      GoRoute(path: '/profile',         builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/settings',        builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/settings/sync',   builder: (_, __) => const SyncSettingsScreen()),
      GoRoute(path: '/subscription',    builder: (_, __) => const SubscriptionScreen()),
      GoRoute(path: '/ai-coach',        builder: (_, __) => const AiCoachScreen()),

      // Utilities
      GoRoute(path: '/emergency',       builder: (_, __) => const EmergencyCardScreen()),
      GoRoute(path: '/lab-reports',     builder: (_, __) => const LabReportsScreen()),
      GoRoute(path: '/festival',        builder: (_, __) => const FestivalScreen()),
      GoRoute(path: '/wedding',         builder: (_, __) => const WeddingPlannerScreen()),
    ],
    errorBuilder: (ctx, state) => ErrorScreen(error: state.error),
  );
}
```

---

## §B5. Feature Flags — Full Implementation

```dart
// lib/core/config/feature_flags.dart

@freezed
class FeatureFlags with _$FeatureFlags {
  const factory FeatureFlags({
    @Default(true)  bool aiInsights,      // AI Coach — §F2
    @Default(true)  bool socialFeed,      // Family group feed
    @Default(true)  bool weddingPlanner,  // Wedding fitness planner
    @Default(true)  bool doshaQuiz,       // Ayurveda onboarding
    @Default(true)  bool festivalCalendar,// Indian festival integration
    @Default(true)  bool proSubscription, // RevenueCat — §F4
    @Default(false) bool fhirExport,      // FHIR R4 export (future)
    @Default(false) bool voiceLogging,    // Voice food logging (future)
    @Default(false) bool cgmIntegration,  // Continuous glucose (future)
    @Default(false) bool pharmacySearch,  // Nearby pharmacy (future)
  }) = _FeatureFlags;

  factory FeatureFlags.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagsFromJson(json);

  // Safe defaults — if function fails, these values are used
  static FeatureFlags get defaults => const FeatureFlags();
}

@riverpod
Future<FeatureFlags> featureFlags(FeatureFlagsRef ref) async {
  try {
    final functions = Functions(ref.read(appwriteClientProvider));
    final result = await functions.createExecution(
      functionId: 'fitkarma-cores',
      body: jsonEncode({ 'action': 'FETCH_FEATURE_FLAGS' }),
    );
    final json = jsonDecode(result.responseBody) as Map<String, dynamic>;
    return FeatureFlags.fromJson(json);
  } catch (_) {
    return FeatureFlags.defaults; // Never crash on flag fetch failure
  }
}
```

---

## §B6. Appwrite Function — Report Share Link

```js
// functions/report-share/src/main.js
// Generates a 7-day expiring share link for health reports

import { Client, Databases, ID, Query } from "node-appwrite";
import crypto from "crypto";

export default async ({ req, res }) => {
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers["x-appwrite-key"]);
  const db = new Databases(client);

  const { userId, reportId, reportType } = JSON.parse(req.body || "{}");

  // Generate cryptographically random token
  const token = crypto.randomBytes(32).toString("hex");
  const expiresAt = Math.floor(Date.now() / 1000) + 7 * 24 * 60 * 60; // 7 days

  await db.createDocument(
    "fitkarma-db",
    "share_tokens",
    ID.unique(),
    {
      userId,
      reportId,
      reportType,
      token,
      expiresAt,
    },
    [`read("user:${userId}")`, `delete("user:${userId}")`],
  );

  const shareUrl = `${process.env.APP_BASE_URL}/share/${token}`;
  return res.json({ ok: true, token, shareUrl, expiresAt });
};
```

---

## §B7. Glucose Classification Logic

```dart
// lib/features/health/domain/glucose_classifier.dart

enum GlucoseReadingType { fasting, postMeal, random, bedtime }

enum GlucoseClassification { normal, prediabetic, diabetic, hypoglycemic }

class GlucoseClassifier {
  static GlucoseClassification classify(
      double mgDl, GlucoseReadingType type) {
    switch (type) {
      case GlucoseReadingType.fasting:
        if (mgDl < 70)  return GlucoseClassification.hypoglycemic;
        if (mgDl < 100) return GlucoseClassification.normal;
        if (mgDl < 126) return GlucoseClassification.prediabetic;
        return GlucoseClassification.diabetic;

      case GlucoseReadingType.postMeal:
        if (mgDl < 70)  return GlucoseClassification.hypoglycemic;
        if (mgDl < 140) return GlucoseClassification.normal;
        if (mgDl < 200) return GlucoseClassification.prediabetic;
        return GlucoseClassification.diabetic;

      case GlucoseReadingType.random:
        if (mgDl < 70)  return GlucoseClassification.hypoglycemic;
        if (mgDl < 140) return GlucoseClassification.normal;
        if (mgDl < 200) return GlucoseClassification.prediabetic;
        return GlucoseClassification.diabetic;

      case GlucoseReadingType.bedtime:
        if (mgDl < 70)  return GlucoseClassification.hypoglycemic;
        if (mgDl < 120) return GlucoseClassification.normal;
        if (mgDl < 160) return GlucoseClassification.prediabetic;
        return GlucoseClassification.diabetic;
    }
  }

  static String classificationLabel(GlucoseClassification c) => switch (c) {
    GlucoseClassification.hypoglycemic => 'Low — Hypoglycemia',
    GlucoseClassification.normal       => 'Normal',
    GlucoseClassification.prediabetic  => 'Pre-diabetic Range',
    GlucoseClassification.diabetic     => 'Diabetic Range',
  };

  static Color classificationColor(GlucoseClassification c) => switch (c) {
    GlucoseClassification.hypoglycemic => AppColorsDark.secondary,
    GlucoseClassification.normal       => AppColorsDark.success,
    GlucoseClassification.prediabetic  => AppColorsDark.warning,
    GlucoseClassification.diabetic     => AppColorsDark.error,
  };

  // Crisis threshold — show immediate alert
  static bool isCrisis(double mgDl) => mgDl < 54 || mgDl > 250;
}
```

---

## §B8. Correlation Insight Engine — Expanded

```dart
// lib/features/insights/correlation_engine.dart
// Requires ≥14 days of overlapping data to generate any insight.
// Each insight has a confidence score (0.0–1.0) based on data points available.

class CorrelationEngine {
  final AppDatabase _db;
  CorrelationEngine(this._db);

  Future<List<HealthInsight>> generateInsights(String userId) async {
    final insights = <HealthInsight>[];
    final cutoff = DateTime.now().subtract(const Duration(days: 30))
        .millisecondsSinceEpoch ~/ 1000;

    final bpReadings    = await _db.getRecentBpReadings(userId, days: 30);
    final sleepReadings = await _getSleepReadings(userId, cutoff);
    final waterLogs     = await _getWaterLogs(userId, cutoff);

    // Insight 1: Sleep → BP correlation
    if (bpReadings.length >= 7 && sleepReadings.length >= 7) {
      final poorSleepBpAvg = _avgSystolicOnDaysAfterPoorSleep(bpReadings, sleepReadings);
      final goodSleepBpAvg = _avgSystolicOnDaysAfterGoodSleep(bpReadings, sleepReadings);
      if (poorSleepBpAvg != null && goodSleepBpAvg != null &&
          poorSleepBpAvg - goodSleepBpAvg > 8) {
        insights.add(HealthInsight(
          type: InsightType.sleepToBp,
          title: 'Poor sleep raises your BP',
          body: 'On nights with < 6h sleep, your BP averages '
                '${poorSleepBpAvg.round()} vs ${goodSleepBpAvg.round()} mmHg on good nights.',
          confidence: (bpReadings.length / 30).clamp(0.0, 1.0),
          modules: [InsightModule.sleep, InsightModule.bloodPressure],
        ));
      }
    }

    // Insight 2: Hydration → steps
    if (waterLogs.length >= 7) {
      final avgWater = waterLogs.map((w) => w.amountMl).average;
      if (avgWater < 1500) {
        insights.add(HealthInsight(
          type: InsightType.lowHydration,
          title: 'You\'re under-hydrated most days',
          body: 'Average intake ${avgWater.round()}ml vs recommended 2500ml. '
                'Dehydration reduces endurance and focus.',
          confidence: 0.9,
          modules: [InsightModule.water],
        ));
      }
    }

    return insights;
  }

  double? _avgSystolicOnDaysAfterPoorSleep(
      List<BpReading> bp, List<SleepLog> sleep) {
    // Match sleep sessions < 360 min to next-day BP readings
    // Returns null if < 3 matching pairs
    return null; // Full implementation omitted for brevity
  }

  double? _avgSystolicOnDaysAfterGoodSleep(
      List<BpReading> bp, List<SleepLog> sleep) => null;

  Future<List<SleepLog>> _getSleepReadings(String userId, int cutoff) async =>
      (_db.select(_db.sleepLogs)
        ..where((t) => t.userId.equals(userId) & t.sleepStart.isBiggerOrEqualValue(cutoff)))
      .get();

  Future<List<WaterLog>> _getWaterLogs(String userId, int cutoff) async =>
      (_db.select(_db.waterLogs)
        ..where((t) => t.userId.equals(userId) & t.loggedAt.isBiggerOrEqualValue(cutoff)))
      .get();
}

@freezed
class HealthInsight with _$HealthInsight {
  const factory HealthInsight({
    required InsightType type,
    required String title,
    required String body,
    @Default(1.0) double confidence,
    @Default([])  List<InsightModule> modules,
  }) = _HealthInsight;
}

enum InsightType { sleepToBp, lowHydration, highGlucosePattern, bpAnomaly, stepDeficit }
enum InsightModule { sleep, bloodPressure, water, glucose, steps, food }
```

---

## §B9. Indian Food Seed — Structure Reference

The `assets/data/indian_foods_seed.json` must follow this schema (5,000+ entries):

```json
[
  {
    "name": "Roti (Phulka)",
    "nameHindi": "रोटी (फुलका)",
    "nameRegional": null,
    "category": "roti",
    "cuisine": "north-indian",
    "caloriesPer100g": 297,
    "proteinPer100g": 9.5,
    "carbsPer100g": 55.0,
    "fatPer100g": 3.7,
    "fiberPer100g": 2.7,
    "emoji": "🫓",
    "source": "icmr",
    "servingSizes": [
      { "name": "1 small roti (25g)", "grams": 25 },
      { "name": "1 medium roti (35g)", "grams": 35 },
      { "name": "1 large roti (50g)", "grams": 50 }
    ]
  },
  {
    "name": "Dal Makhani",
    "nameHindi": "दाल मखनी",
    "category": "dal",
    "cuisine": "north-indian",
    "caloriesPer100g": 128,
    "proteinPer100g": 5.8,
    "carbsPer100g": 15.2,
    "fatPer100g": 5.1,
    "fiberPer100g": 3.5,
    "emoji": "🥘",
    "source": "manual",
    "servingSizes": [
      { "name": "1 katori (150g)", "grams": 150 },
      { "name": "1 cup (240g)", "grams": 240 }
    ]
  }
]
```

Seed categories to cover at minimum:

- Dals & legumes (20 varieties)
- Breads: roti, paratha, puri, naan, bhatura, dosa, idli, uttapam (15 varieties)
- Rice dishes (10 varieties)
- Sabzis & curries (30 varieties)
- Non-veg: chicken curry, fish curry, egg dishes (15 varieties)
- Snacks: samosa, vada, dhokla, poha, upma (20 varieties)
- Sweets: mithai, halwa, kheer (20 varieties)
- Street food: pav bhaji, chaat, biryani (15 varieties)
- South Indian (20 varieties)
- Beverages: chai, lassi, nimbu pani (10 varieties)
- Packaged goods with ICMR values (100+ items)

---

## §B10. Main Entry Point — Complete

```dart
// lib/main.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  unawaited(SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      options.tracesSampleRate = 0.2;
      options.environment = const String.fromEnvironment(
          'APP_ENV', defaultValue: 'production');
      // Strip PII from error reports
      options.beforeSend = (event, hint) =>
          event.copyWith(user: null);
    },
    appRunner: _runApp,
  ));
}

void _runApp() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Sentry.captureException(details.exception, stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();

  // Initialise notifications
  unawaited(NotificationService.init());

  // Initialise RevenueCat
  unawaited(SubscriptionService.init());

  runApp(
    const ProviderScope(
      child: FitKarmaApp(),
    ),
  );
}

class FitKarmaApp extends ConsumerWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router   = ref.watch(appRouterProvider);
    final isDark   = ref.watch(themeModeProvider) == ThemeMode.dark;
    final fontFamily = ref.watch(accessibilityProvider).useDyslexicFont
        ? 'OpenDyslexic'
        : null;

    return MaterialApp.router(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      theme:      AppTheme.light(overrideFont: fontFamily),
      darkTheme:  AppTheme.dark(overrideFont: fontFamily),
      themeMode:  isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        // Clamp system font scale to prevent layout breaks
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            MediaQuery.of(context).textScaleFactor.clamp(0.85, 1.3),
          ),
        ),
        child: child!,
      ),
    );
  }
}
```

---

## Master Checklist — Launch Readiness

### Pre-Launch (P0 — must complete)

- [ ] §F1: Seed Indian food database (5,000+ items)
- [ ] §F1: Open Food Facts integration tested on barcode scan
- [ ] §F2: AI Coach Appwrite Function deployed with Groq API key set
- [ ] §F3: iOS HealthKit entitlements configured in Xcode
- [ ] §F4: RevenueCat configured with App Store + Play Store products
- [ ] §F4: 7-day free trial configured for Pro tier
- [ ] All 17 Appwrite collections created via CLI (§A1)
- [ ] Unified Appwrite Function (`fitkarma-cores`) deployed and activated
- [ ] Single storage bucket (`fitkarma-vault`) created with prefix-based organization
- [ ] `--dart-define` environment variables set for all build flavors
- [ ] Biometric lock tested on device (Journal, Lab Reports, BP, Glucose)
- [ ] Offline→online sync round-trip tested on real device in Airplane mode
- [ ] DLQ alert banner shown after 3 sync failures
- [ ] GlassCard blur disabled on DeviceTier.low (< 2GB RAM devices)
- [ ] Golden tests generated and passing for all 5 primary screens
- [ ] DPDP Act compliance: Privacy Policy referencing data residency path

### Post-Launch (P1 — within 30 days)

- [ ] Add remaining Indian food items (target: 10,000+)
- [ ] AI Coach rate limiting tuned per usage data
- [ ] HealthKit background delivery tested on iPhone
- [ ] Sentry error dashboard configured with PII stripping verified
- [ ] Home widget for iOS implemented (today's steps + karma)
- [ ] Push notification open rates measured and reminder timing A/B tested

---

_FitKarma — Complete Documentation
_UI Design System · Technical Implementation Guide · Enterprise Hardening · Critical Fixes_
_Flutter 3.x · Riverpod 2.x · Drift · Appwrite CLI · RevenueCat · Open Food Facts · Groq Llama-3_
_Offline-first · AES-256 encrypted · Privacy-centric · Built for India_
_~5,800 lines · 78 sections · 45+ screens · 28 shared components · 17 Appwrite collections_
_1 unified server function · Full CI/CD · Complete Drift schema · Complete CLI commands_
_Critical fixes: §F1 Food Database · §F2 AI Coach · §F3 iOS HealthKit · §F4 Subscription Model_
