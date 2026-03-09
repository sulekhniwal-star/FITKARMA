# Phase 02: Theming & Brand Identity - Research

## 1. Ayurvedic Visual Language (Dosha-Based Design)
The "Cultural Premium" aesthetic is driven by balancing the three Ayurvedic Doshas. Each Dosha has a distinct color theory:

- **Vata (Air/Space)**: Needs grounding.
  - *Palette*: Terracotta, Sage Green, Warm Beige, Charcoal.
  - *UI Feel*: Soft, light, airy, but grounded by heavy borders or shadows.
- **Pitta (Fire/Water)**: Needs cooling.
  - *Palette*: Sky Blue, Mint, Lavender, Pearl White.
  - *UI Feel*: Sharp, organized, clear, spacious.
- **Kapha (Earth/Water)**: Needs stimulation.
  - *Palette*: Mango/Golden Yellow, Coral, Turquoise, Vibrant Magenta.
  - *UI Feel*: Dynamic, punchy, bold typography, high contrast.

## 2. Modern Glassmorphism (2025 Flutter Stacks)
For a premium "Glass" look in Flutter without killing FPS:
- **Core Component**: `BackdropFilter` + `ImageFilter.blur(sigmaX: 10, sigmaY: 10)`.
- **Performance Layer**: Must wrap glass components in `RepaintBoundary` to avoid full-screen repaints.
- **Visual Polish**: Use `LinearGradient` with very low opacity white (10-20%) and a subtle 1px border.

## 3. Typography: Heritage meets Precision
- **Primary (App Shell)**: `Outfit` (Modern, geometric sans-serif that feels premium).
- **Secondary (Content/Indic)**: `Noto Sans Devanagari` for regional language support and traditional context.
- **Fallback Strategy**: Standard Flutter fallback to system fonts to ensure 100% text coverage.

## 4. State-Driven Theming (Riverpod 3.0)
- **Theme Switcher**: Use a `Notifier<DoshaType>` where `DoshaType` is an enum.
- **Dynamic ColorScheme**: Map each `DoshaType` to a custom `ColorScheme`.
- **Material 3 Integration**: Use `ThemeData.from(colorScheme: ...)` to ensure the entire widget tree respects the Dosha.

## 5. Summary Implementation Path
1.  Define **DoshaDesignSystem** in `packages/fitkarma_ui`.
2.  Create **GlassCard** and **GlassButton** primitives.
3.  Setup `GoogleFonts` and custom text themes.
4.  Implement `DoshaThemeNotifier` in the main app core.
