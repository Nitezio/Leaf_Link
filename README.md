# 🌿 LeafLink — PlantCare Pro

> **A premium plant care companion app built with Flutter.**
> Track your plants, get AI-powered disease detection, weather-smart watering alerts, and join a community of plant lovers.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots & App Flow](#screenshots--app-flow)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Design System](#design-system)
- [Tech Stack & Dependencies](#tech-stack--dependencies)
- [Getting Started](#getting-started)
- [Team Roles](#team-roles)
- [Contributing Guidelines](#contributing-guidelines)
- [Current Status](#current-status)
- [Roadmap](#roadmap)
- [License](#license)

---

## Overview

**LeafLink** (user-facing brand name: **PlantCare Pro**) is a mobile-first Flutter application designed to help plant enthusiasts manage, monitor, and grow their indoor and outdoor plants. The app combines smart watering schedules, AI-driven disease scanning, a social community feed, a local marketplace, and a gamification system to keep users engaged.

The UI is being ported from a **Figma/React design reference** (`Plant Care App/`) into a production-ready Flutter codebase. The design reference is located at the project root and must **never be modified** — it is read-only.

| Item | Value |
|---|---|
| **Internal Name** | `leaf_link` |
| **Display Name** | PlantCare Pro |
| **Platform** | Flutter (Android, iOS, Web, Desktop) |
| **Min SDK** | Dart `^3.11.5` |
| **Version** | `1.0.0+1` |
| **Design Reference** | `Plant Care App/` (React/TSX — read-only) |

---

## Features

### 🏠 Home Dashboard
- Personalized greeting with logo, search, and notification bell (with unread dot indicator)
- Stat cards: Total Plants count, Day Streak, Current Level
- Weather panel with 5-day forecast and smart watering alerts
- Featured plant cards with health status, level badges, and quick actions
- Quick Actions grid (AR Preview, Growth Predictor)

### 🌱 My Garden
- Full list of all owned plants
- Each plant card shows health status, species, level, next watering time
- One-tap watering and scan actions per plant

### 📷 Scan & AI Tools
- **Disease Detection** — Upload or capture a photo for AI-powered plant disease analysis
- **AR Plant Placement** — Augmented reality preview for placing plants in your space
- **Growth Predictor** — AI-based growth trajectory visualization

### 👥 Community / Social Feed
- Post composition with image support
- Community posts with likes, comments, and plant tips
- User avatars and timestamps

### 🛒 Marketplace
- Search bar with filter chips (All, Seeds, Tools, Pots, Fertilizer)
- Product listings with images, prices, seller info, and ratings
- Grid layout for browsing

### 👤 Profile
- User avatar with border accent, display name, and title badge ("Plant Whisperer")
- Gamification panel (level ring, XP, streak, badge collection)
- Activity links: Watering History, Saved Plants, Friends

### ⚙️ Settings
- Toggle switches: Push Notifications, Watering Reminders, Dark Mode
- Account actions: Edit Profile, Privacy & Security, Data Export
- Support links: Help Center, About
- Log Out button

### 🎮 Gamification System
- XP points with circular progress ring (gradient stroke: gold → green)
- Level tracking with progress bar
- Day streak counter
- 8 collectible badges with lock/unlock states and checkmark indicators

### 🌤️ Weather Integration
- Dynamic gradient backgrounds based on weather conditions (Rain, Sunny, Cloudy)
- Temperature display with condition icon
- Humidity percentage
- 5-day forecast with per-day icons and rainfall amounts
- Smart watering alert when rain is forecast

---

## Screenshots & App Flow

```
Welcome Screen → Login Screen → Main Shell (Bottom Navigation)
                                    ├── Home (Dashboard)
                                    ├── Community (Social Feed)
                                    ├── Scan (Center FAB — Camera)
                                    ├── Marketplace
                                    └── Profile → Settings
```

The app starts at the **Welcome Screen** with a hero plant image, gradient title text, and feature highlights. The user proceeds to the **Login Screen** (with Sign In / Sign Up toggle and Google/GitHub OAuth). After authentication, the **Main Shell** loads with a 5-tab bottom navigation bar featuring a raised center FAB for the Camera/Scan feature.

---

## Architecture

```
lib/
├── main.dart                    # App entry point, MaterialApp + theme + routing
├── core/
│   └── theme/
│       ├── app_colors.dart      # All color tokens (primary, semantic, weather, health)
│       └── app_typography.dart  # Google Fonts setup (Poppins + Inter) & ThemeData
├── models/
│   ├── plant.dart               # Plant data model with health enum & mock data
│   ├── user_stats.dart          # User stats model (points, level, streak)
│   └── badge.dart               # Badge model (id, name, icon, unlock state)
├── widgets/
│   ├── plant_card.dart          # Reusable plant card with hero image & actions
│   ├── weather_panel.dart       # Weather display with dynamic gradients & forecast
│   ├── gamification_panel.dart  # XP ring, stats, badge grid with CustomPainter
│   └── quick_action_card.dart   # Small action cards for AR/Growth features
└── screens/
    ├── welcome_screen.dart      # Onboarding screen with hero image & CTA
    ├── login_screen.dart        # Sign In / Sign Up with OAuth buttons
    ├── main_shell.dart          # Bottom nav wrapper with center FAB
    ├── home_screen.dart         # Dashboard: stats, weather, plants, quick actions
    ├── my_garden_screen.dart    # Full plant list view
    ├── scan_screen.dart         # Disease detection, AR, growth predictor
    ├── social_feed_screen.dart  # Community posts feed
    ├── marketplace_screen.dart  # Product browsing & search
    ├── profile_screen.dart      # User profile & gamification display
    └── settings_screen.dart     # App preferences & account management
```

### Key Architectural Decisions

| Decision | Rationale |
|---|---|
| **No state management library yet** | The current phase is UI-only. State management (Riverpod, Bloc, etc.) will be introduced when backend integration begins. |
| **Mock data in models** | Each model has a static `mockPlants` / `mockStats` getter so screens render immediately without a backend. |
| **Centralized theme** | All colors and typography are in `core/theme/` — no hardcoded colors in widgets. Any design token change propagates app-wide. |
| **Mobile-first (375px)** | Matches the Figma reference. The design assumes a 375px-wide viewport with `SafeArea` and `SingleChildScrollView` throughout. |

---

## Design System

### Color Palette

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#1B4332` | Dark green — buttons, nav, headings |
| `secondary` | `#52B788` | Light green — accents, badges, active states |
| `background` | `#F8F4E3` | Warm cream — scaffold background |
| `card` | `#FFFFFF` | White — card surfaces |
| `foreground` | `#1B4332` | Dark green — body text |
| `mutedForeground` | `#2D6A4F` | Medium green — secondary text, hints |
| `muted` | `#D8E4DD` | Pale green — disabled, borders |
| `destructive` | `#E76F51` | Coral — errors, logout |
| `gold` | `#FFD700` | Gold — gamification accents |
| `healthExcellent` | `#52B788` | Thriving status |
| `healthGood` | `#74C69D` | Healthy status |
| `healthWarning` | `#F4A261` | Needs care status |
| `healthCritical` | `#E76F51` | Critical status |
| `weatherRain` | `#3B82F6` | Blue — rainy conditions |
| `weatherSunny` | `#F59E0B` | Amber — sunny conditions |
| `weatherCloudy` | `#6B7280` | Gray — cloudy conditions |

### Typography

| Role | Font | Size | Weight |
|---|---|---|---|
| Hero Title | Poppins | 32px | Bold (700) |
| Screen Title | Poppins | 24px | Bold (700) |
| Section Title | Poppins | 18px | SemiBold (600) |
| Body Large | Inter | 16px | Regular (400) |
| Body Medium | Inter | 14px | Regular (400) |
| Label | Inter | 12px | Medium (500) |
| Tiny | Inter | 10px | Regular (400) |

### Design Tokens

| Token | Value |
|---|---|
| Card border radius | `24px` |
| Button border radius | `999px` (fully rounded) |
| Input border radius | `16px` (theme default) / `20px` (login screen override) |
| Button height | `56px` |
| FAB size | `56×56px` |
| Bottom nav height | `80px` |
| Shadow (cards) | `0 2px 8px rgba(27,67,50,0.08)` |
| Shadow (buttons) | `0 4px 12px rgba(27,67,50,0.15)` |
| Shadow (hero elements) | `0 8px 24px rgba(27,67,50,0.2)` |

---

## Tech Stack & Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | Core framework |
| `google_fonts` | `^6.1.0` | Poppins and Inter font loading |
| `cached_network_image` | `^3.3.0` | Efficient network image caching with placeholders |
| `flutter_svg` | `^2.0.10` | SVG rendering for icons and illustrations |
| `lucide_icons` | `^0.257.0` | Consistent icon set matching the Figma reference |
| `cupertino_icons` | `^1.0.8` | iOS-style icons fallback |
| `flutter_lints` | `^6.0.0` | Static analysis and lint rules (dev) |

---

## Getting Started

### Prerequisites

- **Flutter SDK** `>=3.11.5` — [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** `>=3.11.5` (bundled with Flutter)
- A physical device or emulator (Android/iOS) or Chrome for web

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/Nitezio/Leaf_Link.git
cd Leaf_Link

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# 4. Run on a specific device
flutter run -d chrome       # Web
flutter run -d emulator-id  # Android emulator
flutter run -d ios           # iOS simulator (macOS only)
```

### Verify Code Quality

```bash
# Run static analysis (should report 0 issues)
flutter analyze

# Run tests (when available)
flutter test
```

---

## Team Roles

| Role | Responsibility |
|---|---|
| **Project Manager (Team Leader)** | Oversees implementation, ensures alignment with Figma UI, approves PRs, maintains the progress log (`GEMINI.md`). |
| **DevSecOps Architect** | Ensures infrastructure setup (`pubspec.yaml`, CI/CD, configs) is secure and correct. Manages dependencies and build pipelines. |
| **Security & Integration Auditor** | Audits code for best practices, security flaws, and design compliance. Reviews all PRs before merge. |

---

## Contributing Guidelines

### Golden Rules

1. **NEVER edit files in `Plant Care App/`** — This is the Figma design reference. It is **read-only**.
2. **ALL code changes go in `leaf_link/`** — This is the active Flutter project.
3. **The app name displayed to users is "PlantCare Pro"**, not "LeafLink". LeafLink is the internal project name only.
4. **No hardcoded colors or font sizes** — Always use `AppColors` and `AppTypography` from `lib/core/theme/`.
5. **Follow the existing architecture** — Screens in `lib/screens/`, reusable widgets in `lib/widgets/`, data models in `lib/models/`.

### Branch Strategy

```
master          ← stable, deployable
├── feature/*   ← new features (e.g., feature/dark-mode)
├── fix/*       ← bug fixes (e.g., fix/card-overflow)
└── ui/*        ← design adjustments (e.g., ui/login-polish)
```

### Commit Message Format

```
<type>: <short description>

Types: feat, fix, ui, refactor, docs, chore, test
Examples:
  feat: Add plant detail screen with care history
  ui: Fix welcome screen gradient to match Figma
  fix: Resolve card overflow on small screens
  docs: Update README with design system section
```

---

## Current Status

### ✅ Completed (UI Phase)
- [x] Core design system (colors, typography, ThemeData)
- [x] Data models with mock data (Plant, UserStats, Badge)
- [x] All 4 reusable widgets (PlantCard, WeatherPanel, GamificationPanel, QuickActionCard)
- [x] All 10 screens (Welcome, Login, Home, MyGarden, Scan, Social, Marketplace, Profile, Settings, MainShell)
- [x] App entry point (`main.dart`) with theme and routing
- [x] Static analysis passing with 0 issues
- [x] Pushed to GitHub

### ⚠️ Known UI Discrepancies (vs. Figma Reference)
- Welcome screen text copy doesn't exactly match React reference
- Login input fields need height/radius adjustments (56px / 20px radius)
- Gamification panel progress ring uses solid color instead of gradient stroke
- Some badge unlock checkmark overlays are simplified

### 🔲 Not Yet Started
- [ ] Backend integration (API, authentication, real data)
- [ ] State management setup (Riverpod / Bloc)
- [ ] Push notification system
- [ ] Camera/AR integration for scanning
- [ ] Dark mode theme variant
- [ ] Unit and widget tests
- [ ] CI/CD pipeline setup
- [ ] App Store / Play Store deployment

---

## Roadmap

| Phase | Description | Status |
|---|---|---|
| **Phase 1 — UI Port** | Port all Figma screens to Flutter with exact design fidelity | 🟡 In Progress |
| **Phase 2 — State & Data** | Add state management, local storage, mock API layer | 🔲 Not Started |
| **Phase 3 — Backend** | Firebase/Supabase integration, auth, real-time data | 🔲 Not Started |
| **Phase 4 — AI Features** | Disease detection ML model, growth prediction | 🔲 Not Started |
| **Phase 5 — Social & Marketplace** | Real community feed, marketplace transactions | 🔲 Not Started |
| **Phase 6 — Polish & Deploy** | Performance optimization, testing, store deployment | 🔲 Not Started |

---

## License

This project is private and proprietary. All rights reserved.

---

<p align="center">
  <strong>🌿 PlantCare Pro — Your Plants, Thriving Together 🌿</strong>
</p>
