# FitKarma — UI Design System
## Applied Across All 35+ Screens

> **Offline-First · Privacy-Centric · Built for India**
> Flutter 3.x · Riverpod 2.x · Hive · Appwrite

---

## Table of Contents

1. [Design Principles](#1-design-principles)
2. [Global Design Tokens](#2-global-design-tokens)
3. [Typography Scale](#3-typography-scale)
4. [Universal Screen Rules](#4-universal-screen-rules)
5. [Two Base Scaffold Patterns](#5-two-base-scaffold-patterns)
6. [Shared Component Library](#6-shared-component-library)
7. [Screen-by-Screen UI Specifications](#7-screen-by-screen-ui-specifications)
   - [Onboarding & Auth](#71-onboarding--auth-screens)
   - [Core Dashboard & Karma](#72-core-dashboard--karma)
   - [Food & Nutrition](#73-food--nutrition-screens)
   - [Workout](#74-workout-screens)
   - [Steps & Activity](#75-steps--activity)
   - [Health Monitoring](#76-health-monitoring-screens)
   - [Lifestyle Trackers](#77-lifestyle-tracker-screens)
   - [Wellness](#78-wellness-screens)
   - [Social & Community](#79-social--community-screens)
   - [Reports & Wearables](#710-reports--wearables)
   - [Family & Emergency](#711-family--emergency)
   - [Settings & Profile](#712-settings--profile-screens)
8. [Bottom Navigation Bar](#8-bottom-navigation-bar)
9. [Common UI Patterns](#9-common-ui-patterns)
10. [Accessibility & Bilingual Rules](#10-accessibility--bilingual-rules)

---

## 1. Design Principles

Every screen in FitKarma must follow these five core UI principles without exception:

| Principle | What it means in practice |
|---|---|
| **Offline-first feel** | No skeleton screens on core actions. UI updates from Hive immediately. Shimmer only for background async loads. |
| **Warm and Indian** | Background always `#FDF6EC` (warm off-white). Every screen has at least one culturally contextual element — Indian food units, Hindi sub-labels, Ayurvedic tips, or festival context. |
| **Orange drives action** | Every primary CTA, active state, FAB, and ring is Deep Orange `#FF5722`. Users learn that orange = act. |
| **Dark hero, warm body** | Screens with a strong metric to lead with (BP, Sleep, Fasting, Karma) use a dark indigo gradient hero section that transitions into the warm `#FDF6EC` body below. |
| **Privacy visible** | Any screen that stores encrypted data shows a visible 🔒 AES-256 badge near the relevant fields. Users must never wonder whether their data is protected. |

---

## 2. Global Design Tokens

These tokens apply to **every single screen** in the app. No hardcoded hex values anywhere else.

### Colour Palette

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#FF5722` | CTAs, FAB, active nav icons, active ring, focused borders |
| `primaryLight` | `#FF8A65` | Hover/pressed states, gradient end |
| `primarySurface` | `#FFF3EF` | Selected chip background, insight card tint |
| `secondary` | `#3F3D8F` | Hero sections, level badges, dark card gradients |
| `secondaryDark` | `#2C2A6B` | Gradient bottom stop for hero headers |
| `secondarySurface` | `#E8E7F6` | Light tint for secondary-accented chips |
| `accent` | `#FFC107` | Karma XP coins, insight card bg, recommended badge, streak reward |
| `accentLight` | `#FFEcB3` | Insight card container background |
| `accentDark` | `#FF8F00` | XP text on amber bg |
| `background` | `#FDF6EC` | **All screen scaffold backgrounds** |
| `surface` | `#FFFFFF` | Cards, bottom sheets, modals, input fields |
| `surfaceVariant` | `#F5F5F5` | Settings list backgrounds |
| `divider` | `#EEE8E4` | Card borders, list separators, input borders, shimmer base |
| `success` | `#4CAF50` | Steps ring, completed habits, normal health readings, on-track nutrition |
| `teal` | `#009688` | Water ring, SpO2 accent, ayurveda tips, medication category |
| `purple` | `#9C27B0` | Active minutes ring |
| `warning` | `#FF9800` | Moderate risk readings, elevated BP |
| `error` | `#F44336` | Crisis readings, destructive actions, Stage 2 hypertension |
| `rose` | `#E91E63` | Period cycle days, menstrual accent |
| `textPrimary` | `#1A1A2E` | All body copy, titles |
| `textSecondary` | `#6B6B8A` | Subtitles, labels, captions |
| `textMuted` | `#B0AECB` | Placeholder text, inactive nav, disabled states |

### Gradients

| Name | Direction | Colours | Used on |
|---|---|---|---|
| `heroGradient` | Top-left → Bottom-right | `#3F3D8F` → `#2C2A6B` | All dark hero sections |
| `orangeGradient` | Top-left → Bottom-right | `#FF5722` → `#FF8A65` | Streak banners, CTA shimmer |
| `amberGradient` | Top-left → Bottom-right | `#FFC107` → `#FFD54F` | Referral hero, subscription recommended |
| `sleepGradient` | Top → Bottom (3-stop) | `#1A1A3E` → `#2C2A6B` → `#FDF6EC` | Sleep screen top section |

### Shape & Elevation

| Token | Value | Used on |
|---|---|---|
| Card border radius | `12px` | All surface cards |
| Chip / pill border radius | `20px` | All filter chips, category pills |
| Bottom sheet border radius | `20px` top corners | All modal bottom sheets |
| Button border radius | `12px` | Primary and outlined buttons |
| Card elevation | `2dp`, shadow `#0000001A` | Standard cards |
| FAB shadow | `4dp` | QuickLogFAB |
| Input focus border | `2px solid #FF5722` | All focused TextField inputs |
| Input default border | `1px solid #EEE8E4` | All unfocused TextField inputs |

---

## 3. Typography Scale

All text uses system fonts: **Roboto** on Android, **SF Pro** on iOS. Devanagari script is supported via the device system font automatically on both platforms.

| Style name | Size | Weight | Colour | Used for |
|---|---|---|---|---|
| `displayLarge` | 32sp | Bold 700 | `textPrimary` | Large metric numbers (timer, BP reading) |
| `displayMedium` | 28sp | Bold 700 | `textPrimary` | Level titles (Warrior, Guru) |
| `h1` | 24sp | Bold 700 | `textPrimary` | Screen titles in hero sections |
| `h2` | 20sp | Bold 700 | `textPrimary` | Card headings |
| `h3` | 18sp | SemiBold 600 | `textPrimary` | App bar titles, card section heads |
| `h4` | 16sp | SemiBold 600 | `textPrimary` | List item titles |
| `sectionHeader` | 14sp | Bold 700 | `textPrimary` | Section headings throughout app |
| `sectionHeaderHindi` | 11sp | Medium 500 | `textSecondary` | Hindi subtitle below section header |
| `bodyLarge` | 16sp | Regular 400 | `textPrimary` | Main body paragraphs |
| `bodyMedium` | 14sp | Regular 400 | `textPrimary` | List subtitles, descriptions |
| `bodySmall` | 12sp | Regular 400 | `textSecondary` | Meta text, timestamps |
| `labelLarge` | 14sp | SemiBold 600 | `textPrimary` | Card titles, bold item names |
| `labelMedium` | 12sp | SemiBold 600 | `textPrimary` | Chip text, tab labels |
| `labelSmall` | 11sp | Medium 500 | `textSecondary` | Badges, category tags |
| `caption` | 10sp | Regular 400 | `textMuted` | Timestamps, fine print |
| `statLarge` | 22sp | Bold 700 | `textPrimary` | Dashboard ring stats |
| `statMedium` | 18sp | Bold 700 | `textPrimary` | Metric card values |
| `statSmall` | 14sp | Bold 700 | `textPrimary` | Mini stat card values |
| `statUnit` | 11sp | Regular 400 | `textSecondary` | Unit labels below stats (kcal, steps) |
| `navLabelEn` | 10sp | SemiBold 600 | `primary` | Active bottom nav English label |
| `navLabelHi` | 9sp | Regular 400 | `primary` | Active bottom nav Hindi sub-label |
| `buttonLarge` | 16sp | Bold 700 | `white` | Primary button text |
| `h1OnDark` | 24sp | Bold 700 | `white` | Titles inside hero gradient sections |
| `bodyOnDark` | 14sp | Regular 400 | `white70` | Body text inside hero gradient sections |
| `captionOnDark` | 11sp | Regular 400 | `white54` | Fine print inside hero gradient sections |

---

## 4. Universal Screen Rules

These rules apply to **every screen** without exception. No deviations.

### Layout
- Scaffold background is always `#FDF6EC` unless the screen uses a dark hero pattern (then the hero uses the gradient and the body below returns to `#FDF6EC`)
- Bottom FAB clearance: minimum `100px` padding at the bottom of all scrollable bodies so content is never hidden behind the FAB + bottom nav
- Safe area insets respected on all screens — no content bleeds under the status bar or home indicator

### App Bar
- Standard app bar: white/`#FDF6EC` background, `textPrimary` icons, `h3` title style, elevation 0
- Dark hero app bar: transparent, white icons and title, overlaid on the gradient hero
- All app bar titles render bilingual where applicable — English title on top, Hindi sub-label at 11sp below
- Back arrow uses the system default icon, never a custom one

### Async States (Non-negotiable)
- **Loading**: Always `ShimmerLoader` — never a blank screen or a `CircularProgressIndicator` in the centre of the screen
- **Error**: Always `FKErrorWidget` with a retry button — orange icon, grey message text
- **Empty**: Always `EmptyState` with an emoji, title, Hindi subtitle, and an orange CTA button — never a blank list

### Forms & Input
- Every `TextField` has an orange focus border (`2px solid #FF5722`)
- Every `TextField` that relates to Indian measurements or food shows a bilingual `labelText` (English above, Hindi below in `helperText`)
- Password fields always have a visibility toggle icon
- Every form's primary submit action is a `PrimaryButton` — full-width, orange, 52px height, 12px border radius

### Cards
- All surface cards: `#FFFFFF` fill, `12px` border radius, `2dp` elevation with `#0000001A` shadow, `EdgeInsets.all(16)` internal padding
- Card borders: `1px solid #EEE8E4` for secondary/list cards; no border on primary feature cards (they use shadow only)
- Card margins: `16px` horizontal page padding consistently

### Section Headers
- Every section header uses the `SectionHeader` widget — English title + Hindi subtitle stacked, orange `3px` left-border accent
- Section header top padding: `20px`; bottom padding: `12px`
- "See all" / action links appear as `TextButton` right-aligned in the same row as the section header

### Sensitivity & Encryption
- Any screen that handles AES-256 encrypted data (Period, Journal, BP, Glucose, Doctor Appointments) shows an `EncryptionBadge` (🔒 green badge) near the data entry point
- Log sheets (bottom sheets) for encrypted data always have the `EncryptionBadge` visible at the bottom before the submit button

### Pull-to-Refresh
- All list screens and dashboards support pull-to-refresh with `RefreshIndicator` in primary orange

---

## 5. Two Base Scaffold Patterns

Every screen in the app uses one of exactly two layout patterns.

### Pattern A — Standard Light Scaffold
**Used by:** Food screens, Workout screens, Habits, Mood, Medications, Settings, Profile, Referral, Community, Reports, Wearables, Subscription

```
┌─────────────────────────────────────┐
│ App Bar (white bg, dark icons)      │
│ [← Back]  Screen Title / हिंदी  [⋮] │
├─────────────────────────────────────┤
│                                     │
│  #FDF6EC background                 │
│  ┌─────────────────────────────┐    │
│  │  White surface cards        │    │
│  │  Section headers w/ border  │    │
│  │  Lists, grids, charts       │    │
│  └─────────────────────────────┘    │
│                                     │
└──────────────────── [FAB] ──────────┘
│ Bottom Navigation Bar (white)       │
└─────────────────────────────────────┘
```

### Pattern B — Dark Hero Scaffold
**Used by:** Dashboard, Karma Hub, Blood Pressure, Glucose, Sleep, Fasting, SpO2, Workout Player, Login

```
┌─────────────────────────────────────┐
│ Transparent App Bar (white icons)   │
├─────────────────────────────────────┤
│  ┌───────────────────────────────┐  │
│  │  Indigo Gradient Hero         │  │
│  │  #3F3D8F → #2C2A6B           │  │
│  │  (key metric, badge, stats)   │  │
│  └───────────────────────────────┘  │
│  #FDF6EC body begins here           │
│  ┌─────────────────────────────┐    │
│  │  White cards, charts,       │    │
│  │  insight cards, lists       │    │
│  └─────────────────────────────┘    │
└──────────────────── [FAB] ──────────┘
│ Bottom Navigation Bar               │
└─────────────────────────────────────┘
```

---

## 6. Shared Component Library

All components live in `lib/shared/widgets/`. **Never re-implement these per screen.**

### `ActivityRingsWidget`
Four concentric rings, outermost to innermost: Calories (orange), Steps (green), Water (teal), Active minutes (purple). Ring stroke width 10px, `lineCap: round`. Stats row below each ring shows current/goal values. Accepts progress values `0.0–1.0` per ring.

### `InsightCard`
Amber `#FFEcB3` background, `1px` border at `#FFC10750`, 12px radius, internal padding 14px. Lightbulb icon in an amber-filled `8px` radius square. Message text in `bodyMedium` bold. Thumbs-up / Thumbs-down rating row at bottom-right. Dismiss `✕` button top-right. Max 2 shown per day on dashboard.

### `KarmaLevelCard`
Dark indigo gradient (`#3F3D8F → #2C2A6B`), 16px radius. Shows: "Karma Level" label in `captionOnDark`, XP badge (amber coin + number), linear progress bar in amber on white-20% track, XP needed subtitle, large level title in `displayMedium` white. Compact variant (`compact: true`) for use in dashboard header row.

### `FoodItemCard`
**Grid variant** (default): food photo 16:9 aspect ratio, rounded top corners. Below: food name in `labelMedium`, Hindi name in `caption`, portion in `labelSmall` grey, kcal in `labelSmall` orange, orange circle `+` button bottom-right.
**List/compact variant**: 52×52px rounded thumbnail on left, name + portion·kcal text on right, smaller `+` button. Triggered with `compact: true`.

### `MealTypeTabBar`
Horizontal scroll row of four tabs: Breakfast, Lunch, Dinner, Snacks. Each tab: icon + English label. Selected state: `primarySurface` background, orange border, orange icon and text. Unselected: white background, `divider` border. Animated transition 200ms.

### `QuickLogFAB`
Orange circle FAB with `+` icon. Tapping rotates icon 45° and reveals speed-dial sub-actions expanding upward. Each sub-action: small FAB (colour-coded per action type) + white label pill on left. Sub-actions: Log Food, Log Water (teal), Log Mood (purple), Log Workout, Log BP (red), Log Glucose. Tapping any sub-action closes the dial and fires the action.

### `ShimmerLoader`
Animated shimmer using a `LinearGradient` shader mask oscillating left-to-right on a 1400ms loop. Base colour `#EEE8E4`, highlight `#F8F5F0`. Presets: `ShimmerFoodGrid` (2-column grid of 4 cards), `ShimmerListTiles` (N rows of 68px height).

### `BilingualLabel`
Stacks English text over Hindi text in a `Column`. `.navLabel` constructor centres both. `.sectionHeader` constructor adds the 3px orange left-border accent. English at `sectionHeader` style, Hindi at `sectionHeaderHindi` style.

### `SectionHeader`
Padding `fromLTRB(16, 20, 16, 12)`. Left: `BilingualLabel.sectionHeader`. Right: optional trailing widget (usually a `TextButton` for "See all"). Orange 3px left-border on the bilingual label.

### `StatMiniCard`
White card, 12px padding, 12px radius, divider border. Vertically stacks: icon (optional, colour-coded), stat value in `statSmall` in accent colour, label in `caption`. Used in groups of 3 in a `Row` for summary stat rows.

### `EmptyState`
Centred column: large emoji (56sp), `h3` title, `bodyMedium` subtitle in `textSecondary`, optional orange `ElevatedButton` CTA. 32px padding. Used in all empty list/data states.

### `FKErrorWidget`
Centred column: `cloud_off` icon in `textMuted`, `bodyMedium` message in `textSecondary`, orange `Retry` `TextButton`. Used in all async error states.

### `EncryptionBadge`
Small green pill (`#E8F5E9` bg, `#A5D6A7` border): 🔒 icon + "AES-256 Encrypted" text in `#2E7D32`, 10sp SemiBold. Displayed near data entry on Period, Journal, BP, Glucose, Appointments, Doctor screens.

### `HeroHeader`
Container with `heroGradient` decoration (or custom gradient). Minimum height 140px. Padding `fromLTRB(16, 16, 16, 24)`. Wraps any hero content.

### `CategoryChipRow`
Horizontal scrollable row of pill-shaped chips. Selected: `#FF5722` fill, white text. Unselected: white fill, `divider` border, `textSecondary` text. Animated background switch 180ms. 16px horizontal page padding.

### `ChallengeCarouselCard`
220px wide white card (scrollable row). Shows: challenge title (2 lines max), thin linear progress bar in `primary`, "Day X/Y" caption, 🎁 `+XP` amber text. Used in Karma Hub and Me tab.

### `PrimaryButton`
Full-width (width `double.infinity`), 52px height, `#FF5722` fill, white text `buttonLarge`, 12px radius. Optional leading icon. Optional Hindi sub-label below English text in `caption white70`. Loading state shows `CircularProgressIndicator`. Disabled state: `primaryLight` fill.

### `SecondaryButton`
Same dimensions as `PrimaryButton`. Transparent fill, `1.5px solid #FF5722` border, `#FF5722` text. Optional leading icon.

---

## 7. Screen-by-Screen UI Specifications

---

### 7.1 Onboarding & Auth Screens

#### Splash Screen
**Route:** `/`
**Scaffold:** Full-screen, no app bar
**Background:** Indigo gradient `#3F3D8F → #2C2A6B` (full screen)

**Layout (top to bottom):**
- Centred column, Alignment.center
- FitKarma logo wordmark — white, 28sp Bold
- Tagline "India's Most Affordable Fitness App" — amber `#FFC107`, 14sp
- 4-ring animated activity rings (brand colours, rings animate in with 300ms stagger)
- Version text at very bottom — white 50% opacity, 11sp

**Motion:** Rings animate in sequence. Logo fades in at 600ms after rings start.

---

#### Onboarding Flow
**Route:** `/onboarding`
**Scaffold:** Full-screen, no app bar
**Background:** `#FDF6EC` with decorative illustration per step

**Layout (all steps):**
- Step progress indicator: 5 dots at top. Active = filled orange pill. Inactive = hollow circle with `divider` border
- Full-bleed illustration (top 45% of screen) — unique per step
- Step title: `h1` bold `textPrimary`, centred
- Subtitle: `bodyMedium textSecondary`, centred, max 2 lines
- Step-specific content (inputs/selectors) in white card
- Primary CTA: full-width orange "अगला / Next" at bottom
- Skip link (steps 1–3 only): `textSecondary` TextButton

**Step-specific content:**

| Step | Content |
|---|---|
| 1 | Name `TextField` + language selector: 8 chip pills (EN / HI / TA / TE / KN / MR / BN / GU), multi-select, orange active |
| 2 | Gender selector: 4 illustrated cards (Male / Female / Other / Prefer not to say). DOB date picker below |
| 3 | Height slider (cm) + Weight slider (kg) side-by-side, orange thumb and active track |
| 4 | Goal selector: 4 large illustrated cards with icon + title + Hindi subtitle. Single select, orange border when active |
| 5 | Dosha Quiz: 12 sequential questions, each with 3 option cards. After Q12: animated reveal of `DoshaDonutChart` with percentage breakdown |

**Karma reward:** +50 XP badge shown on completion before navigating to dashboard.

---

#### Login Screen
**Route:** `/login`
**Scaffold:** No app bar, full screen
**Background:** Split — top 35% indigo hero gradient, bottom 65% `#FFFFFF`

**Layout:**
- **Hero section (dark):** FitKarma logo white, tagline amber, decorative 4-ring motif at reduced opacity
- **White card section** (rounded top `24px`): slides up over the hero
  - "नमस्ते! / Welcome Back" bilingual heading — `h2` bold
  - Email `TextField` with mail icon prefix
  - Password `TextField` with lock icon prefix + visibility toggle
  - "Forgot Password?" — right-aligned, `accentDark` TextButton
  - Primary orange login button — "Login / लॉगिन"
  - Divider row: `— or continue with —` in `textMuted`
  - Google OAuth2 button: outlined, Google logo + "Continue with Google"
  - "New here? Create Account" link centred at bottom

---

#### Register Screen
**Route:** `/register`
**Scaffold:** Standard light scaffold
**Title:** "Create Account / खाता बनाएं"
**Background:** `#FDF6EC`

**Layout:**
- White card form, all input fields stacked: Name, Email, Password, Confirm Password
- All fields: orange focus border, bilingual `labelText`
- Terms & Conditions checkbox (orange when checked) + linked text
- Primary CTA: "Create Account / खाता बनाएं"
- Google OAuth2 button
- "Already have an account? Login" TextButton at bottom

---

### 7.2 Core Dashboard & Karma

#### Dashboard Screen
**Route:** `/home/dashboard`
**Scaffold:** Standard light, custom header (no app bar widget — header is part of scroll body)
**Background:** `#FDF6EC`

**Layout (top to bottom):**

1. **Custom Header Row** (16px horizontal padding, 16px top padding):
   - Left: CircleAvatar (40px). Level badge overlaid bottom-left: dark indigo pill "Lv.12"
   - Centre: "Namaste, [Name] 🙏" in `h3`, "Level 12 Warrior" in `bodySmall textSecondary`
   - Right: XP badge — amber `#FFEcB3` rounded pill, ⚡ icon + "1,250 XP" in `accentDark labelSmall`

2. **ActivityRingsWidget** — centred, 200px size, 20px vertical padding

3. **InsightCard** — 16px horizontal padding

4. **SectionHeader** — "Today's Meals / आज का भोजन" + "See all" TextButton

5. **MealTypeTabBar** — horizontal scroll

6. **Meal Summary Cards** — one per logged meal type. Each: icon in `primarySurface` square, meal name `labelLarge`, item count + kcal `bodySmall`, "+ Add" TextButton right

7. **SectionHeader** — "Latest Activity / नवीनतम"

8. **Summary cards row:** Latest workout card + Sleep recovery card side by side in `Row`

9. **100px bottom clearance** for FAB

**FAB:** `QuickLogFAB` with 6 sub-actions (Food, Water, Mood, Workout, BP, Glucose)

---

#### Karma Hub Screen
**Route:** `/karma`
**Scaffold:** Dark Hero (Pattern B)
**Hero gradient:** `heroGradient`

**Hero content:**
- "Karma Level" caption in `captionOnDark`
- Level title in `displayMedium white` (e.g. "Warrior")
- XP progress bar (amber on white-20% track)
- XP badge (amber coin + number)
- "Level X" subtitle in `bodyOnDark`

**Body content (below hero):**
1. **Karma Store CTA card** — amber gradient card, "Redeem XP for rewards" heading, arrow icon, tappable → Karma Store
2. **SectionHeader** — "Leaderboard / लीडरबोर्ड"
3. **Leaderboard tabs** — Friends · City · National. Horizontal `TabBar`, orange active indicator
4. **Leaderboard list** — ranked rows: rank number (gold/silver/bronze for 1–3), avatar, name, XP badge. Current user row highlighted with `primarySurface` background
5. **SectionHeader** — "Active Challenges / सक्रिय चुनौतियाँ"
6. **ChallengeCarouselCard** horizontal scroll
7. **SectionHeader** — "XP History / XP इतिहास"
8. **XP transaction list** — icon (green `+` or red `-`), action label, XP amount right-aligned in green/red, date in `caption`
9. **Streak multiplier banner** — orange gradient, 🔥 icon, "7-day streak active — earning 1.5× XP"

---

### 7.3 Food & Nutrition Screens

#### Food Home Screen
**Route:** `/home/food`
**Scaffold:** Standard light
**Title:** "Food / खाना"

**Layout:**
1. **Daily nutrition summary card** — white card: donut/ring chart (cal/protein/carbs/fat 4-colour), traffic light status chips (🟢 On track / 🟡 Slightly over / 🔴 Exceeded), macro gram breakdown
2. **MealTypeTabBar** — orange active tab
3. **Per-meal section** (for selected tab): logged `FoodItemCard` rows + calorie subtotal in `labelMedium primary` right-aligned
4. **Empty meal state** — illustrated plate emoji, "Nothing logged yet / अभी तक कुछ नहीं", orange "+ Add Breakfast" button
5. **Sticky calorie budget pill** — floats above FAB: "[consumed] / [goal] kcal" orange pill

**FAB:** Orange circle, `+` icon → Food search screen

---

#### Food Search Screen (Log Meal)
**Route:** `/home/food/search`
**Scaffold:** Standard light
**Title:** "Log Breakfast / नाश्ता लॉग करें" (dynamic by meal type)
**Background:** `#FFFFFF`

**Layout:**
1. **Bilingual search bar** — grey fill, mic icon right, barcode icon far right. Placeholder: "Search food, or tap the mic... / खाना खोजें / स्कैन करें"
2. **Quick-action chips row** — three outlined pills: 📷 Scan Label · 🍽 Upload Plate Photo · ✏ Manual Entry. Orange border + icon.
3. **SectionHeader** — "Frequent Indian Portions / अक्सर खाया जाने वाला"
4. **2-column FoodItemCard grid** — grid variant with katori/piece portions
5. **SectionHeader** — "Recent Logs / हाल के लॉग"
6. **FoodItemCard list** — compact variant

**When search active:** Grid replaces with full-width `FoodItemCard` compact list of results. `ShimmerListTiles` while loading.

**Portion Bottom Sheet** (appears on food card tap):
- Drag handle, food name + Hindi name
- Portion chip selector: Katori / Piece / Cup / Custom (grams slider)
- Nutrition preview: kcal + macros update live as portion changes
- Primary orange "Add to Log / लॉग में जोड़ें" button
- Meal type selector row above button if opened from FAB (not from meal tab)

---

#### Food Detail Screen
**Route:** `/home/food/detail/:id`
**Scaffold:** Standard light
**Title:** Food name

**Layout:**
1. **Hero image** — 200px, full width, rounded bottom `16px` corners. Grey placeholder with food icon.
2. **Food name** — `h2 textPrimary`
3. **Hindi name** — `bodySmall textSecondary`
4. **Macro pills row** — 4 colour-coded pills: Kcal (orange) · Protein (green) · Carbs (amber) · Fat (purple). Each shows value + unit.
5. **Portion selector** — chip row (Katori / Piece / Cup / g), custom gram slider below. Values update macro pills live.
6. **Nutrition details** — expandable list: all micronutrients (Iron, Calcium, B12, Vit D etc.) with linear progress bars showing % of daily goal
7. **Meal type dropdown** — "Adding to: Breakfast" selector
8. **Primary orange CTA** — "Add to Breakfast / नाश्ते में जोड़ें"

---

#### Recipe Browser Screen
**Route:** `/home/food/recipes`
**Scaffold:** Standard light
**Title:** "Recipes / रेसिपी"

**Layout:**
1. **CategoryChipRow** — North Indian · South Indian · Bengali · Gujarati · My Recipes · Public
2. **FoodItemCard grid** — recipe cards (image, name, total kcal per serving, prep time chip, servings)
3. **Community section** — "Shared by community" with verified-badge support on community recipes
4. **FAB** — "+ New Recipe" → Recipe Builder

---

#### Recipe Builder Screen
**Route:** `/home/food/recipes/new`
**Scaffold:** Standard light
**Title:** "New Recipe / नई रेसिपी"
**Background:** `#FDF6EC`

**Layout:**
1. **Recipe name TextField** — prominent, `h2` size hint text
2. **Cuisine type chips** — horizontal scroll: North Indian · South Indian · Bengali · Gujarati · Other. Single select, orange active.
3. **SectionHeader** — "Ingredients / सामग्री"
4. **Ingredient search bar** — mini food search, compact `FoodItemCard` rows added below
5. **Added ingredients list** — each row: food name + quantity input (grams) + delete icon. Reorderable.
6. **Live macro summary card** — white card, updates as ingredients added. Shows total cal/protein/carbs/fat. Highlights in orange when a value changes.
7. **Servings stepper** — `−` `[2]` `+` in orange
8. **Per-serving macros** — auto-calculated below stepper
9. **"Share with community" toggle** — indigo `Switch`
10. **Primary CTA** — "Save Recipe / रेसिपी सहेजें"

---

#### Meal Planner Screen
**Route:** `/home/food/planner`
**Scaffold:** Standard light
**Title:** "Meal Planner / भोजन योजना"

**Layout:**
1. **Week selector header** — `←` [Mon 10 – Sun 16 Mar] `→`. Today's date pill highlighted in orange.
2. **AI Suggest card** — amber `InsightCard` style: ✨ icon, "Suggest this week's plan based on your goals" text, orange "Generate" button
3. **7-day list** — each day is an expandable/collapsible row. Day name + calorie total right-aligned.
   - Expanded: 4 meal slots (Breakfast / Lunch / Dinner / Snack)
   - Filled slot: `FoodItemCard` compact + kcal + edit/delete icons
   - Empty slot: dashed orange border, `+` icon centred, "Add [Meal]" text
4. **Bottom bar** — sticky: "Generate Grocery List" full-width outlined orange button

---

### 7.4 Workout Screens

#### Workout Home Screen
**Route:** `/home/workout`
**Scaffold:** Standard light
**Title:** "Workouts / वर्कआउट"

**Layout:**
1. **Featured workout banner** — full-width card: thumbnail image, title overlay (white bold), duration + difficulty badge. Tappable → Workout Detail
2. **CategoryChipRow** — Yoga · HIIT · Strength · Cardio · Dance · Bollywood · Cricket · Kabaddi · Pranayama
3. **Active program card** — white card with indigo left-accent border: program name, "Day 12/30", progress bar, next workout title, orange "Resume" button
4. **SectionHeader** — "All Workouts / सभी वर्कआउट"
5. **2-column workout grid** — each card: thumbnail, title, duration chip, difficulty badge (Beginner/Intermediate/Advanced in coloured pill), 🔒 premium lock icon if locked
6. **"Build Custom Workout"** — outlined dashed card at bottom, `+` icon

---

#### Workout Detail Screen
**Route:** `/home/workout/:id`
**Scaffold:** Dark Hero (Pattern B) — hero is the workout thumbnail with gradient overlay
**Title:** (transparent, overlaid on image)

**Hero content:** Workout title `h1 white`, duration + difficulty chips, instructor name

**Body content:**
1. **Tag pills row** — category, equipment needed, body part targeted
2. **Description** — expandable `bodyMedium` text
3. **Exercise list** — numbered rows: exercise name, sets × reps, muscle group icon, rest time
4. **Stats row** — estimated calories burn + equipment chips
5. **Sticky bottom CTA** — orange "Start Workout / शुरू करें" (full-width, floats above safe area bottom)
6. **Premium locked state** — blurred exercise list + amber "Unlock with Premium" overlay card

---

#### Video Player Screen
**Route:** `/home/workout/:id/play`
**Scaffold:** Custom — black top, `#FDF6EC` controls panel
**Title:** Minimal, transparent

**Layout:**
1. **YouTube player embed** — top, 16:9 ratio
2. **Controls panel** below:
   - Workout title `labelLarge`, instructor `bodySmall`
   - HR zone badge — coloured bar Zone 1–5 (green → yellow → orange → red → dark red)
   - Progress bar: elapsed / total duration
   - **Structured workout mode:** Set/rep counter. Exercise name bold, `[Set 2 of 4]` subtitle, rep checkbox row
   - **Orange "Log Workout" CTA** — sticky bottom

---

#### Workout Calendar Screen
**Route:** `/home/workout/calendar`
**Scaffold:** Standard light
**Title:** "Calendar / कैलेंडर"

**Layout:**
1. **Month calendar** — grid: orange dot on workout days, green dot on rest days, amber dot on scheduled future days
2. **Selected day detail** — card below calendar: workout name, duration, calories burned if completed; or scheduled workout with "Start" CTA
3. **SectionHeader** — "This Week / इस सप्ताह"
4. **Week summary row** — 7 day circles (coloured by completion), total workouts count, total minutes

---

### 7.5 Steps & Activity

#### Steps Home Screen
**Route:** `/home/steps`
**Scaffold:** Standard light
**Title:** "Steps / कदम"

**Layout:**
1. **Large ring widget** (centred, 180px): today's steps count large in centre (green colour), goal below in `statUnit`, percentage label
2. **Stats cards row** — Distance km · Calories burned · Active minutes (3 `StatMiniCard` in green accent)
3. **Inactivity nudge banner** (conditional) — teal background, 🚶 emoji, "You've been sitting for 90 min. Time for a quick walk!" with dismiss
4. **SectionHeader** — "This Week / इस सप्ताह"
5. **7-day bar chart** — bars in green if goal met, orange if below goal. Goal line dashed.
6. **Adaptive goal card** — amber `InsightCard` style: "Based on your 7-day average, your new goal is 9,500 steps"
7. **SectionHeader** — "History / इतिहास"
8. **30-day calendar heatmap** — 5-column grid, green intensity gradient based on step count. Below-goal days in `#FFE8E0`.

---

#### Personal Records Screen
**Route:** `/personal-records`
**Scaffold:** Standard light
**Title:** "Personal Records / पर्सनल रिकॉर्ड"

**Layout:**
1. **Latest PR hero banner** — amber gradient card: 🏆 icon, "New PR!" badge, exercise name, record value large, date
2. **CategoryChipRow** — Max Lift · 5K Run · Longest Run · Best Streak · Most Steps
3. **PR cards list** — each: exercise name `labelLarge`, record value in `statMedium primary`, date achieved `caption`, sparkline trend chart (progress over time), "New!" amber badge if achieved in last 7 days
4. **FAB** — "+ Log PR manually"

**New PR celebration overlay:** Full-screen confetti animation with `KarmaLevelCard` mini showing "+100 XP"

---

### 7.6 Health Monitoring Screens

#### Blood Pressure Tracker
**Route:** `/blood-pressure`
**Scaffold:** Dark Hero (Pattern B)
**Title:** "Blood Pressure / रक्तचाप"

**Hero content:**
- 🔒 "Latest Reading" caption in `captionOnDark`
- Systolic / Diastolic in `displayLarge white` (e.g. "122 / 80")
- AHA classification badge (colour-coded pill) — "Normal" in green
- "mmHg · Pulse: 72 bpm" in `bodyOnDark`
- Classification legend row: Normal (green) · Elevated (amber) · Stage 1 (orange) · Stage 2 (red) · Crisis (deep red) — small coloured pills

**Body content:**
1. **SectionHeader** — "Trend / प्रवृत्ति"
2. **BP trend chart** — dual line (systolic/diastolic), 30-day default. AHA reference bands as coloured background areas. Range selector: 7d / 30d / 90d chips
3. **InsightCard** — conditional: "Your BP has been elevated 3 days. Consider logging daily and consulting your doctor."
4. **Morning/Evening reminder toggles** — two `ListTile` rows with `Switch`
5. **SectionHeader** — "History / इतिहास"
6. **History list** — each row: heart icon in `errorLight` square, "SYS/DIA mmHg" `labelLarge`, date `bodySmall`, classification badge right

**Log BP Bottom Sheet:**
- Two fields side by side: Systolic (mmHg) + Diastolic (mmHg)
- Pulse bpm field (optional)
- Notes optional
- Source selector chips: Manual · Wearable · Health Connect
- Primary orange "Log Reading" CTA
- `EncryptionBadge` below button

---

#### Blood Glucose Tracker
**Route:** `/glucose`
**Scaffold:** Dark Hero (Pattern B)
**Title:** "Glucose / ग्लूकोज"

**Hero content:**
- Reading type badge + latest value in `displayLarge white`
- Classification badge (Normal/Pre-diabetic/Diabetic colour-coded)
- Reading type + time in `bodyOnDark`

**Body content:**
1. **HbA1c estimator card** — amber `InsightCard`: "90-day avg → Estimated HbA1c: 5.8%"
2. **Reading type tabs** — Fasting · Post-meal · Random · Bedtime. Orange active.
3. **Glucose trend chart** — scatter plot with configurable target bands per reading type
4. **Meal correlation row** — for post-meal readings: linked food log entry with food name + time
5. **SectionHeader** — "History"
6. **History list** — glucose value, reading type badge, date, classification badge

**Log Glucose Bottom Sheet:**
- Glucose value input (mg/dL)
- Reading type chip selector
- Link to food log (for post-meal)
- Notes
- Primary orange CTA + `EncryptionBadge`

---

#### SpO2 Tracker
**Route:** `/spo2`
**Scaffold:** Standard light (teal accent)
**Title:** "SpO2 / ऑक्सीजन"

**Layout:**
1. **Latest reading card** — white card with teal left accent border: SpO2 % large `statLarge teal`, Pulse bpm beside it. Status chip: ✅ Normal / ⚠️ Consult doctor (red if < 95%)
2. **Post-COVID awareness card** — amber InsightCard: "SpO2 below 95% may need medical attention"
3. **SectionHeader** — "30-Day Trend"
4. **SpO2 trend chart** — teal line, 95% dashed reference line labelled "Consult below this"
5. **FAB** — teal-tinted "Log SpO2"

---

#### Chronic Disease Hub
**Route:** `/chronic-disease`
**Scaffold:** Standard light
**Title:** "Health Hub / स्वास्थ्य केंद्र"

**Layout:**
1. **Active conditions list** — one management card per condition. Card structure:
   - Condition icon + name `labelLarge` + management mode badge
   - Key metric row (e.g. "Latest Glucose: 118 mg/dL · Normal")
   - Quick-log button (small orange outlined)
   - "View details →" TextButton
2. **Specialist referral card** (conditional) — amber InsightCard when metrics out of range
3. **FAB** — "+ Add Condition"

**Condition card accent colours:**
- Diabetes: green accent
- Hypertension: red accent
- PCOD/PCOS: rose accent
- Hypothyroidism: teal accent
- Asthma: purple accent

---

#### Doctor Appointments
**Route:** `/doctor-appointments`
**Scaffold:** Standard light
**Title:** "Appointments / अपॉइंटमेंट"

**Layout:**
1. **Upcoming appointment hero card** — white card, teal left accent: doctor name `h3`, specialty `labelSmall teal`, date/time `labelLarge primary`, "in X days" countdown badge amber. "Add to Calendar" outlined teal button.
2. **SectionHeader** — "Upcoming / आगामी"
3. **Appointment list** — expandable rows: doctor name, specialty badge, date. Expanded: notes preview (encrypted — shows "🔒 Tap to view") + prescription photo placeholder.
4. **Past appointments** — collapsible section
5. **FAB** — "+ Add Appointment"
6. **Log Sheet** — doctor name, specialty, date/time picker, notes `TextField` (AES-256 label), reminder toggle, `EncryptionBadge`

---

### 7.7 Lifestyle Tracker Screens

#### Sleep Tracker
**Route:** `/sleep`
**Scaffold:** Dark Hero (Pattern B)
**Hero gradient:** `sleepGradient` (dark indigo → `#FDF6EC`)
**Title:** "Sleep / नींद"

**Hero content:**
- "Last Night" caption + streak badge (🔥 "5-day streak")
- Duration large `displayLarge white` (e.g. "7h 30m")
- Bedtime → Wake time in `bodyOnDark`
- Emoji quality badge + Deep sleep duration chip

**Body content:**
1. **SectionHeader** — "This Week / इस सप्ताह"
2. **7-day bar chart** — indigo/purple bars, 7–9h recommended green band
3. **Sleep debt card** — amber `InsightCard` if debt > 2h: "You owe 1h 20m sleep this week"
4. **Ayurvedic tip card** — teal left-border card: dosha-personalised tip (e.g. "Drink warm milk with ashwagandha at 21:30 for better Vata sleep")
5. **Burnout detection banner** (conditional) — orange warning card with "Open Mental Health module"
6. **SectionHeader** — "Log Tonight / आज की नींद"
7. **Log sleep card** — bedtime picker, wake time picker (both as outlined orange buttons), 5-emoji quality selector, Notes `TextField`, orange "Log Sleep" primary button

---

#### Mood Tracker
**Route:** `/mood`
**Scaffold:** Standard light
**Title:** "Mood / मनोदशा"

**Layout:**
1. **Quick log card** — white card with `divider` border:
   - "How are you feeling?" `h3` + Hindi subtitle
   - 5-emoji row (😞😕😐😊😄), selected has orange dot below
   - "Energy Level" label + orange `Slider` (1–10)
   - "Stress Level" label + orange `Slider` (1–10)
   - Tag chips (multi-select): anxious · calm · focused · tired · motivated · irritable
   - Mic button row: "Add voice note (stored locally)" with 🔒 label
   - Primary orange "Log Mood / मनोदशा लॉग करें" button
2. **SectionHeader** — "This Month / इस महीने"
3. **Mood heatmap** — 6-column grid (30 days), colour intensity = mood score (deep green = 5, light = 1, grey = not logged)
4. **Stats cards row** — Avg Mood (green) · Avg Energy (amber) · Avg Stress (orange) in 3 `StatMiniCard`
5. **InsightCard** — workout-mood correlation insight

---

#### Habit Tracker
**Route:** `/habits`
**Scaffold:** Standard light
**Title:** "Habits / आदतें"

**Layout:**
1. **Streak banner** — orange gradient card: 🔥 large emoji, "14-day streak!" `h3 white`, "7 more for 1.5× XP" `bodyOnDark`
2. **SectionHeader** — "Today's Habits / आज की आदतें"
3. **Habit rows list** — for each habit:
   - Emoji icon (24sp)
   - Habit name `labelMedium` + Hindi name `caption`
   - Current/target progress text `bodySmall`
   - Linear progress bar (4px height, green if done, orange if in-progress)
   - 🔥 streak number (orange, only if streak > 0)
   - Circle completion button: orange `+` (incomplete) or green ✓ (done)
   - Full row background turns `#E8F5E9` when habit is complete for the day
4. **SectionHeader** — "This Week / इस सप्ताह"
5. **Week heatmap card** — white card: rows = habits, columns = 7 days. Each cell: 20×20px green square if done, `divider` if not
6. **InsightCard** — "You break habits most on Mondays. Plan ahead for tomorrow!"
7. **FAB** — orange `+` → Add habit bottom sheet

---

#### Body Measurements
**Route:** `/body-metrics`
**Scaffold:** Standard light
**Title:** "Body Metrics / शरीर माप"

**Layout:**
1. **Latest metrics card** — white card: Weight, BMI, Body Fat % in 3-column stat layout. BMI coloured by range (green = normal, amber = borderline, red = obese).
2. **BMI gauge** — semi-circle arc, coloured bands (Underweight / Normal / Overweight / Obese), needle pointer at current BMI
3. **Measurements grid** — 2×3 white mini cards: Waist · Chest · Hips · Arms · Thighs · (add if available)
4. **Trend period chips** — 30d · 90d · 180d
5. **Weight trend chart** — line chart, dashed goal weight line in orange
6. **Before/After slider** (only if 2+ progress photos added) — horizontal slider reveals before/after side by side
7. **Privacy note** — "📷 Progress photos stored on your device only · Never uploaded"
8. **FAB** — "Log Measurements"

---

#### Fasting Tracker
**Route:** `/fasting`
**Scaffold:** Dark Hero (Pattern B)
**Hero gradient:** `heroGradient`
**Title:** "Fasting / उपवास"

**Hero content:**
- Large circular progress ring (160px): countdown timer `displayMedium white` in centre, "remaining" caption
- Ring colour transitions by stage: grey (fed) → orange (early) → amber (fat burning) → teal (ketosis) → indigo (deep)
- Fasting stage pill badge: coloured border, stage name + icon
- Protocol + start time in `captionOnDark`

**Body content:**
1. **Eating window card** — "Start eating [time] → Stop eating [time]" with clock icons
2. **Hydration InsightCard** — "Stay hydrated! Drink 500ml water during your fasting window"
3. **Stats row** — Day streak · Total fasts · Protocol (`StatMiniCard` × 3)
4. **Break fast button** — full-width red outlined button "Break Fast" (not `PrimaryButton` — destructive action uses red)
5. **Not fasting state:** Protocol selector cards (16:8 · 18:6 · 5:2 · OMAD · Custom), eating window time pickers, orange "Start Fast / उपवास शुरू करें" CTA, Ramadan mode toggle

---

#### Period Tracker
**Route:** `/period`
**Scaffold:** Standard light, soft rose tint overlay
**Title:** "Cycle Tracker / चक्र ट्रैकर"
**Background:** `#FDF6EC` with `#FCE4EC` at 15% overlay

**Privacy notice:** `EncryptionBadge` visible in app bar subtitle row

**Layout:**
1. **Cycle calendar** — monthly view. Period days: rose `#E91E63` fill. Ovulation: teal. Fertile window: light teal. Predicted next cycle: dashed rose outline.
2. **Current phase card** — white card: phase name `h3` (Menstrual / Follicular / Ovulatory / Luteal), phase description, personalised workout suggestion (linked to workout screen), personalised nutrition tip
3. **Cycle stats row** — Avg cycle length · Avg period length · Next predicted date (3 `StatMiniCard` in rose accent)
4. **PCOD/PCOS mode banner** (if enabled) — amber `InsightCard` with management tips
5. **Privacy guarantee banner** — bottom of screen: 🔒 "Period data is encrypted and stored only on your device by default. Never used for ads."
6. **FAB** — "Log Period"

**Log period bottom sheet:**
- Start / End date pickers
- Flow intensity: 5-drop selector (light → heavy)
- Symptom chips: cramps · bloating · mood swings · headache · fatigue · spotting
- Notes (encrypted)
- `EncryptionBadge`
- Sync toggle (off by default, with explanation)

---

#### Medications
**Route:** `/medications`
**Scaffold:** Standard light
**Title:** "Medications / दवाइयाँ"

**Layout:**
1. **Today's schedule** — timeline view (Morning / Afternoon / Evening / Night grouped sections). Each med row: med name `labelLarge`, dosage `bodySmall`, time, category badge (teal for Prescription, green for Supplement, amber for Ayurvedic), checkbox. Taken = green ✓ fill. Overdue = pulsing orange dot.
2. **Refill alert card** — amber `InsightCard`: "3 days until [Metformin] refill. Order now."
3. **SectionHeader** — "Active Medications / सक्रिय दवाइयाँ"
4. **Active meds list** — card per med: name, dosage, frequency, category chip, next reminder time, edit icon
5. **Drug interaction warning** (conditional) — orange warning card if interaction detected
6. **"These meds are on your Emergency Card" note** — teal info row at bottom
7. **FAB** — "+ Add Medication"

---

### 7.8 Wellness Screens

#### Ayurveda Hub
**Route:** `/ayurveda`
**Scaffold:** Standard light
**Title:** "Ayurveda / आयुर्वेद"
**Background:** `#F1F8E9` (light green-tint, earthy feel)

**Layout:**
1. **DoshaDonutChart card** — large (200px), three-segment donut: Vata (green), Pitta (orange), Kapha (earth brown). Percentage legend beside chart. "Your Dosha: 🌿 Vata-Pitta" heading. "Retake Quiz" outlined green button.
2. **"View Seasonal Guidelines (Ritucharya)" outlined button** — full width, green border
3. **SectionHeader** — "Daily Rituals / दिनचर्या"
4. **Dinacharya checklist** — each row: checkbox (orange when ticked) + ritual name + Hindi name. Completed rituals get a green ✓ indicator.
5. **SectionHeader** — "Seasonal Food Guide / ऋतुचर्या"
6. **Current season card** — illustrated, food recommendations for current Indian season
7. **SectionHeader** — "Herbal Remedies / जड़ी-बूटियाँ"
8. **Herbal remedies grid** — 2-column: herb image, name, key benefit, "Evidence-based" green chip or "Traditional" amber chip

---

#### Guided Meditation & Pranayama
**Route:** `/meditation`
**Scaffold:** Standard light
**Title:** "Meditation / ध्यान"
**Background:** `#EEEEF8` (soft indigo-tint)

**Layout:**
1. **Toggle tabs** — Guided | Pranayama. Pill-shaped toggle, indigo active state.
2. **Duration chips** — 5 min · 10 min · 15 min · 20 min. Orange active chip.
3. **Stress-mode card** (conditional if stress > 7 last log) — amber `InsightCard`: "Your stress was high. Try the 3-min quick calm session."
4. **Session grid** — 2-column cards: emoji (large), session title, duration, dosha tag chip
5. **Pranayama list** — each `ListTile`: technique emoji, name + Hindi name, duration, "Start" button in `secondarySurface`

**Active session screen** (full-screen overlay):
- Dark indigo background
- Breathing circle — animated: expands on inhale, holds, contracts on exhale. Teal colour.
- Breathing cue text: "Inhale / श्वास लें" → "Hold / रोकें" → "Exhale / छोड़ें" in `h2 white`
- Session name + remaining time at top
- Circular progress ring around breathing circle
- "End session" TextButton bottom

---

#### Journal
**Route:** `/journal`
**Scaffold:** Standard light
**Title:** "Journal / डायरी"
**Background:** `#FDF6EC` (parchment feel)

**Layout:**
1. **Encryption status row** — `EncryptionBadge` + sync toggle (off by default)
2. **Weekly prompt card** — amber `InsightCard`: italic prompt question "What made you feel strong this week?" with ✏ icon
3. **SectionHeader** — "Entries / प्रविष्टियाँ"
4. **Journal entry list** — each row: date heading in `labelLarge primary`, first 2 lines of entry preview in `bodySmall`, mood dot (coloured by mood score), word count `caption`. Tapping → full entry editor.
5. **Monthly summary card** — word cloud image + mood trend sparkline
6. **FAB** — orange quill/pencil icon, "+ New Entry"

**Entry editor screen:**
- Full screen, `flutter_quill` rich text editor
- Toolbar: Bold · Italic · Bullet list · Numbered list
- Auto-filled date header
- Bottom bar: mood picker (5 emoji, optional) + tag chips + "Save / सहेजें" orange button
- `EncryptionBadge` in bottom bar

---

#### Mental Health Hub
**Route:** `/mental-health`
**Scaffold:** Standard light
**Title:** "Mental Health / मानसिक स्वास्थ्य"

**Layout:**
1. **Wellness check-in card** — white card: "How are you today?" 3-tap quick selector (😔 Struggling · 😐 Okay · 😊 Good), CTA to full mood log
2. **Burnout meter** — coloured gauge (green / amber / red) based on 7-day aggregated mood + sleep + energy. "You may be experiencing burnout" orange card if red.
3. **SectionHeader** — "Programs / कार्यक्रम"
4. **Program cards** — 7-Day CBT Techniques · Progressive Muscle Relaxation · each with progress bar, days completed, "Continue" orange button
5. **Breathing quick-access card** — teal card, "3-min quick calm", start button
6. **SectionHeader** — "Resources / संसाधन"
7. **Helpline cards** — each: org name `labelLarge`, description `bodySmall`, phone number, orange "Call" button
8. **Professional help prompt** (conditional after 14-day low mood) — gentle indigo card: "Talking to a professional can help" + "Find a therapist near you"

---

### 7.9 Social & Community Screens

#### Social Feed
**Route:** `/home/social`
**Scaffold:** Standard light
**Title:** "Community / समुदाय"
**Background:** `#F5F5F5` (slightly grey for card contrast)

**Layout:**
1. **Stories row** — horizontal scroll. Each: 40px circle avatar with orange ring if new story. "+" Add your story first. Tap to view (full-screen story viewer).
2. **Post cards** (infinite scroll, `ListView.builder`):
   - Avatar + username row. Verified badge (orange ✓ on nutritionist/trainer). Follow button (outlined, small).
   - Post type chip: 🏋️ Workout · 🥗 Meal · 🏆 Milestone — coloured left border on card per type
   - Content text `bodyMedium`
   - Media image (if any, 16:9 rounded)
   - Reaction row: ❤️ Like (count), 💬 Comment (count), ↗ Share. Heart fills red on tap with animation.
3. **Create post FAB** — orange, camera+pen icon

---

#### Community Groups
**Route:** `/home/social/groups`
**Scaffold:** Standard light
**Title:** "Groups / ग्रुप"

**Layout:**
1. **"My Groups" horizontal scroll** — avatar cards (60px), group name, member count
2. **SectionHeader** — "Discover / खोजें"
3. **CategoryChipRow** — Diet · Location · Sport · Challenge · Support
4. **Group cards grid** — 2-column: group avatar, name, member count, group type badge (colour-coded), Join/Open button

**Group type badge colours:** diet=green · location=teal · sport=orange · challenge=indigo · support=rose

---

#### Direct Messages
**Route:** `/home/social/dm/:userId`
**Scaffold:** Standard light
**Title:** Recipient name + avatar
**Background:** `#F5F5F5`

**Layout:**
- Sent messages: right-aligned, orange bubble, white text
- Received messages: left-aligned, white card bubble, `textPrimary`
- Timestamp in `caption textMuted` between message groups
- Input row at bottom: text field + send button (orange)

---

### 7.10 Reports & Wearables

#### Health Reports
**Route:** `/reports`
**Scaffold:** Standard light
**Title:** "Reports / रिपोर्ट"

**Layout:**
1. **Period selector** — Weekly | Monthly toggle (pill-shaped, indigo active)
2. **Report summary hero card** — white card: date range, overall health score ring (green/amber/red), "Overall: Good" label
3. **Report section cards** (collapsible, one per metric):
   - Section title + sparkline mini chart right-aligned
   - Key stat `statMedium` + assessment badge (✅ Excellent / 🟡 Good / ⚠️ Needs Work)
   - Sections: Steps · Calories · Sleep · Mood · BP/Glucose · Workouts · Karma
4. **Export CTA** — "Export as PDF for your next appointment" full-width outlined orange button
5. **Generate PDF** — orange primary button with `CircularProgressIndicator` while generating (< 3s)

---

#### Wearable Connections
**Route:** `/wearables`
**Scaffold:** Standard light
**Title:** "Wearables / वियरेबल"

**Layout:**
1. **Health platform cards** (large, 2 tappable cards):
   - Health Connect (Android) — green badge if connected
   - HealthKit (iOS) — green badge if connected
2. **SectionHeader** — "Devices / उपकरण"
3. **Device cards** — each: device logo/image, device name, connection status dot (green=connected, grey=not connected, amber=syncing), last sync timestamp, "Connect" / "Disconnect" button
4. **Per-device data permissions** — expandable list of what data is synced
5. **Low Data Mode note** — "In Low Data Mode, sync interval is 6 hours"

---

### 7.11 Family & Emergency

#### Family Profiles
**Route:** `/family`
**Scaffold:** Standard light
**Title:** "Family / परिवार"

**Layout:**
1. **Family members grid** — 6-slot grid (2 columns, 3 rows): each slot is a 60px circle avatar + name + "Crown" icon on admin. Empty slots show `+` dashed circle → Invite member
2. **Weekly leaderboard** — ranked list: member rank + avatar + step count + horizontal bar (colour per member). Current user row highlighted.
3. **Active family challenge card** — `ChallengeCarouselCard` style, wider (full-width), group progress bar
4. **Nudge history** — "Fun nudges sent" list: "Papa hasn't logged meals today 🙁" with timestamp

---

#### Emergency Card
**Route:** `/emergency`
**Scaffold:** Standard light
**Title:** "Emergency Card / आपातकालीन कार्ड"
**Background:** `#FFFFFF` (card prints as PDF — white base)

**Layout:**
1. **Red header band** — `#F44336` background, rounded top `16px`: "EMERGENCY HEALTH CARD" white text + Hindi subtitle. Blood group in large white text in a white-bg box right-side (e.g. "A+")
2. **Info card** (white, rounded bottom `16px`, shadow) — stacked info rows:
   - Name · DOB + Age · Blood Group (red text)
   - Allergies · Chronic Conditions
   - Divider
   - Current Medications (auto-pulled) — bulleted
   - Divider
   - Emergency Contact (name + phone, tap-to-call icon)
   - Doctor (name + specialty + phone, tap-to-call icon)
   - Insurance policy number
3. **QR code card** — white, green border: QR encodes all fields for quick scan by medical staff
4. **Action buttons row** — "Export PDF" outlined + "Share" outlined (side by side)
5. **Footer note** — 📶 "No internet required · Stored locally only · Never uploaded"

---

#### Festival Calendar
**Route:** `/festival`
**Scaffold:** Standard light
**Title:** "Festivals / त्योहार"
**Background:** `#FDF6EC` with subtle confetti dot pattern

**Layout:**
1. **Upcoming festivals scroll** — horizontal: festival illustration cards with festival name, date, "X days away" orange pill
2. **Active festival banner** (if festival is active) — full-width immersive card with illustration, festival name `h1`, festival-specific content below:
   - **Navratri:** 9-day fasting progress bar (Day 4/9), Garba calorie tracker CTA
   - **Ramadan:** Sehri time + Iftar time display cards, fasting log link
   - **Diwali:** Sweet calorie tracker, "Healthy alternatives" orange button
3. **Meal planner note** — teal info card: "Your meal plan has been adjusted for Navratri"

---

### 7.12 Settings & Profile Screens

#### Profile Screen
**Route:** `/profile`
**Scaffold:** Dark Hero (Pattern B)
**Hero gradient:** `heroGradient`
**Title:** "Profile / प्रोफाइल"

**Hero content:**
- Avatar (80px circle, edit pencil overlay), Name `h1 white`, email `captionOnDark`
- `KarmaLevelCard` compact variant (indigo bg within indigo hero, slightly lighter)
- Stats row: Workouts this month · Current streak · Steps (30d) — white mini stats

**Body content:**
1. **DoshaDonutChart** mini card (smaller, 120px) alongside dosha percentage legend
2. **Personal info** — editable card rows: Goal · Height/Weight · DOB · Blood Group · Language
3. **SectionHeader** — "Achievements / उपलब्धियाँ"
4. **Achievements grid** — badge icons: earned = coloured, unearned = grey outline with lock
5. **Referral card** — amber gradient: "Refer friends, earn 500 XP each!" + referral code + share button

---

#### Settings Screen
**Route:** `/settings`
**Scaffold:** Standard light
**Title:** "Settings / सेटिंग्स"
**Background:** `#F5F5F5` (section-grouped list pattern)

**Section groups:**

| Section | Settings inside |
|---|---|
| Account | Edit Profile link · Subscription status badge · Change Password · Linked accounts |
| Preferences | Language (8 options) · Theme (Light/Dark/Auto) · Font size slider |
| Notifications | Per-module toggle rows: Meal reminders · Step nudges · BP/Glucose reminders · Social activity · Challenges · Morning briefing |
| Privacy & Security | Biometric lock toggle · Data Export JSON button · Account Deletion (red text) |
| Data & Sync | Low Data Mode toggle · Sync interval selector · Wearable connections link |
| Health Permissions | Permission status rows per sensor: Step counter · Heart rate · Sleep · Location (GPS workouts) |
| About | App version · Privacy Policy link · Terms link · Contact support |

**Logout button** — red text, centred, at very bottom, separated from list by `Divider`

---

#### Subscription Plans
**Route:** `/subscription`
**Scaffold:** Standard light
**Title:** "Premium / प्रीमियम"
**Background:** `#FDF6EC` with subtle star/sparkle decoration

**Layout:**
1. **Hero banner** — amber gradient, star icon, "Unlock Full FitKarma" `h1`, 3 key features in white bullets
2. **Plan cards** (vertical stack of 4):
   - Monthly ₹99 · Quarterly ₹249 · Yearly ₹899 · Family ₹1,499
   - Each: plan name `h3`, price `displayMedium primary`, per-day price `caption`, key difference bullet
   - "Best Value" amber ribbon on Quarterly
   - "Most Popular" indigo badge on Yearly
   - Orange "Start [Plan]" button per card
3. **Feature comparison table** — 2 columns: Free vs Premium. Checkmark (orange) or ✗ (grey) per feature row
4. **Restore purchase** TextButton
5. **"7-day free trial, cancel anytime"** + "Your data is always safe" note in `caption textSecondary`

---

#### Referral Program
**Route:** `/referral`
**Scaffold:** Standard light
**Title:** "Refer & Earn / रेफर करें"

**Layout:**
1. **Hero card** — amber gradient: "Invite friends, earn 500 XP each!" `h1 white`
2. **Referral code box** — white card, large monospace code (`DM Mono` or system monospace), copy icon button, share icon button
3. **How it works** — 3-step numbered illustration row (orange numbered circles): Share → Friend signs up → Both earn XP
4. **Your earnings card** — "You've referred 3 friends · Earned 1,500 XP" in `statMedium`
5. **Share via row** — WhatsApp · Instagram · Copy link — icon buttons in coloured circles
6. **Leaderboard teaser** — "Top referrers this month" — top 3 with avatar, name, referral count

---

## 8. Bottom Navigation Bar

Applies to all `/home/*` routes. 5 tabs, white background, 8dp elevation.

| Tab | Icon | English label | Hindi label | Route |
|---|---|---|---|---|
| 1 | `home_outlined` / `home` (filled active) | Home | मुख्यपृष्ठ | `/home/dashboard` |
| 2 | `restaurant_outlined` / filled | Food | खाना | `/home/food` |
| 3 | `fitness_center_outlined` / filled | Workout | वर्कआउट | `/home/workout` |
| 4 | `directions_walk_outlined` / filled | Steps | कदम | `/home/steps` |
| 5 | `person_outline` / `person` (filled) | Me | मैं | `/profile` |

**Label rendering:** Two-line `Text` widget. English: `navLabelEn` (10sp, SemiBold, `primary`). Hindi: `navLabelHi` (9sp, Regular, `primary`). Inactive: both lines in `textMuted navLabelInactive`.

---

## 9. Common UI Patterns

### Log Bottom Sheet
All "Log [metric]" actions open a bottom sheet (not a new screen). Consistent structure:
1. Drag handle — 36px wide, 4px tall, `divider` colour, centred
2. Screen-level title (English) `h3` + Hindi subtitle `sectionHeaderHindi`
3. Form fields — stacked, orange focus
4. `EncryptionBadge` (on sensitive screens only)
5. Primary orange CTA button — full-width

### Inline Metric Cards
All health metric screens show a summary card at the top with:
- Latest value in `statLarge` or `displayMedium`
- Classification badge (colour-coded pill)
- Trend indicator (▲ rising / ▼ falling / → stable) in grey

### Streak & Gamification Elements
- Streak banners: orange gradient, 🔥 emoji, bold white text
- XP earned animations: amber "+XP" text floats upward and fades (200ms)
- Level up: full-screen indigo overlay with confetti + new level title
- Challenge completion: celebratory card with `+XP` badge

### Navigation Pattern for Detail Screens
- Always accessible via back arrow (never bottom nav switch)
- Breadcrumb hint in app bar subtitle for nested screens
- Bottom safe-area respected — no CTAs hidden behind home indicator

---

## 10. Accessibility & Bilingual Rules

### Bilingual Requirements

| Location | Requirement |
|---|---|
| Bottom navigation labels | English primary (10sp bold) + Hindi secondary (9sp regular) in two-line layout |
| Screen titles (app bar) | English `h3` title + Hindi `sectionHeaderHindi` sub-label when route is primary navigation |
| All section headers | English `sectionHeader` + Hindi `sectionHeaderHindi` stacked, with orange left border |
| Food names in database | Must include `name` (English) and `name_hi` (Devanagari) — both shown on `FoodItemCard` |
| Primary CTA buttons | English label + optional Hindi sub-label in smaller caption style below |
| Search bar placeholders | Bilingual placeholder text on all food-related search bars |

### Accessibility Standards
- Minimum tap target: 44×44px for all interactive elements
- Colour contrast: all text meets WCAG AA (4.5:1 minimum)
- Screen reader: all `IconButton` widgets have `Semantics` labels; all images have `Semantics` descriptions
- Font scaling: all text respects system font size settings — no hardcoded pixel sizes on `Text` widgets that contain user-critical information
- High contrast mode: accessible via Settings → Preferences → Theme. High contrast mode uses black/white with orange accents only (no gradients)

### Low Data Mode UI Adaptations
When Low Data Mode is enabled (toggle in Settings):
- All network images replaced with `#EEE8E4` placeholder squares
- Social feed switches to text-only cards (no media loaded)
- Food card thumbnails show food emoji placeholder instead of `Image.network`
- No video thumbnails in workout grid — text cards only
- A persistent teal "Low Data Mode" banner at the top of the app

---

*FitKarma UI Design System — v1.0*
*Flutter 3.x · Riverpod 2.x · Hive · Appwrite*
*Offline-first · Privacy-centric · Built for India*
*All 35+ screens · Full bilingual UI · 10 shared components*
