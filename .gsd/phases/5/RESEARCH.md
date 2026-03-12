# Phase 5 Research: Ayurveda & Gamification

## Ayurvedic Profile (ADR-11)
- **Model**: `DoshaProfile`
  - Fields: `vataScore`, `pittaScore`, `kaphaScore`.
- **Quiz Questions**: 
  1. Digestion Speed? (Variable/Fast/Slow)
  2. Frame/Build? (Thin/Medium/Large)
  3. Sleep Pattern? (Light/Deep/Heavy)
  4. Response to stress? (Anxiety/Anger/Calm)
- **UI**: A dedicated "Ayurveda" card on the dashboard with a custom Donut Chart Segment Painter.

## Gamification Engine (ADR-12)
- **XP Triggers**:
  - `log_meal`: 20 XP
  - `log_water`: 5 XP
  - `completion_ring`: 50 XP
- **Level Titles**:
  - Lvl 1: **Sadhaka** (Practitioner)
  - Lvl 3: **Yoddha** (Warrior)
  - Lvl 5: **Rishi** (Sage)
  - Lvl 10: **Paramatma** (Supreme)
- **State**: `ProgressRepository` to handle Hive storage of total XP.

## Challenges (ADR-13)
- **Joinable Mechanism**: When a challenge is joined, it adds a "Overlay Goal" to the dashboard.
- **Example**: "7-Day Satvik Challenge" -> Adds a specific check for "Purely Veg Items" in logs to earn bonus XP.
- **Carousel**: Horizontally scrolling cards with vibrant Indian colors (Saffron, Teal, Indigo).
