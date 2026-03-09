# Research Dimension: UI & Brand (2025)

## Design Philosophy: "Cultural Premium"
FitKarma should feel like a high-end, modern fitness app that is deeply rooted in Indian culture. It avoids the "utilitarian" look of many local apps in favor of a sleek, "Glassmorphic" interface inspired by modern Indian digital brands (like CRED or Zomato) but with a wellness focus.

## 1. Color Palettes (The Dosha-Adaptive System)

| Palette | Usage | Primary Colors | Rationale |
|---------|-------|----------------|-----------|
| **Vata (Air)** | Calming/Grounding | Warm Earth (Terracotta #E2725B), Soft Gold (#D4AF37) | Vata types need warmth and stability to balance their airy nature. |
| **Pitta (Fire)** | Cooling/Focus | Peacock Blue (#005F69), Mint Green (#98FF98) | Pitta types need cooling, soothing colors to balance their inner fire. |
| **Kapha (Earth)** | Energizing/Vibrant | Saffron Orange (#FF9933), Royal Purple (#7851A9) | Kapha types need stimulation and heat to balance their heavy nature. |
| **Neutral Premium** | Dashboard/Core | Charcoal Black (#121212), Pearl White (#F8F9FA) | High-contrast background for a premium, clean look. |

## 2. Typography
- **Primary (Headings)**: *Outfit* or *Inter* (Geometric Sans-Serif) – Modern, clean, and highly legible.
- **Secondary (Body)**: *Noto Sans Indic* – Essential for multilingual support (Hindi, Bengali, Tamil, etc.) with high readability.
- **Accent (Cultural)**: *Playfair Display* (Serif) – Used sparingly for Ayurvedic titles to add a "heritage" feel.

## 3. UI Trends & Techniques
- **Glassmorphism**: Use `BackdropFilter` with blur (10-20px) for cards and app bars. This creates a "premium" depth effect.
- **Micro-Animations (Rive)**: Use Rive for the "Karma" point earning animations (e.g., a glowing diya or a floating golden seed that blooms).
- **Material 3**: Leverage dynamic color schemes where the app theme shifts slightly based on the user's current "Dosha" or time of day.
- **Motif Integration**: Use subtle, geometric patterns inspired by Indian mandalas or textiles as backgrounds for cards (low opacity < 5%).

## 4. Gamification Visuals (The Karma System)
- **Points**: Represented as "Karma Seeds" or a "Vitality Meter." 
- **Rewards**: High-fidelity 3D-style icons for virtual rewards (using Lottie or Rive).
- **Leaderboards**: Use high-contrast gradients (Saffron to Gold) for the top 3 users to emphasize prestige.

## 5. Accessibility for India
- **Visual Cues**: Use high-contrast icons for older demographics (parents/family accounts).
- **Haptic Feedback**: Add "crisp" haptics for "Karma" earning actions to make the rewards feel "physical."
- **Low-Connectivity States**: Shimmer effects that look premium even when images haven't loaded.

## Next Steps: UI/UX Implementation
1.  Develop a Flutter `ThemeData` factory that switches between Vata/Pitta/Kapha color schemes.
2.  Implement a Glassmorphic `BaseCard` component for all dashboard widgets.
3.  Create a custom `KarmaCounter` widget with smooth Rive animations.
