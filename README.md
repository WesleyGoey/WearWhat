<div align="center">

# 👕 WearWhat

**A wardrobe and outfit planner: photograph your clothes, put together outfits, and plan what to wear on a calendar.**

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=flat&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white)

</div>

> DEPD course project at **Universitas Ciputra Surabaya** · Nov 2026 – present · Team Walisongo (6 members) · 🚧 MVP in progress

## Overview

WearWhat helps people decide what to wear with the clothes they already own. Users save each item with a photo, combine items into outfits, and assign outfits to days on a calendar. The onboarding also records basic info and skin tone.

## Features

| Feature | Status |
| --- | --- |
| Sign up, log in, and log out with email and password | ✅ Supabase Auth |
| Onboarding: name, age, gender, selfie step, and skin tone | ✅ `profiles` table |
| Wardrobe: add clothes with a photo from the camera or gallery | ✅ `clothing_items` table and `clothes` storage bucket |
| Outfits, calendar plans, and **Mark as Worn** with undo | ✅ `outfits` and `plans` tables |
| AI clothing detection, AI outfit suggestions, and weather | 🚧 Planned (sample data for now) |
| Sign in with Google | 🚧 Not active yet |

Every table and the photo bucket use row-level security, so each user can only read and change their own data.

## Tech Stack

| | |
| --- | --- |
| App | Flutter (Dart), Material Design, Google Fonts |
| Backend | Supabase: Auth, PostgreSQL, Storage |
| Device | `image_picker` for camera and gallery |
| Platforms | Android and iOS |

## Getting Started

Requires Flutter 3.47 or newer and a Supabase project.

```bash
git clone https://github.com/WesleyGoey/WearWhat.git
cd WearWhat
flutter pub get
```

**1. Set up Supabase (once).** In the Supabase dashboard, open **SQL Editor → New query**, paste the contents of `supabase/schema.sql`, and click **Run**. For testing without confirmation emails, turn off **Confirm email** under **Authentication → Sign In / Providers → Email**.

**2. Add your keys.** Copy `env.example.json` to `env.json` in the project root (next to `pubspec.yaml`) and fill in:

| Key | Where to find it |
| --- | --- |
| `SUPABASE_URL` | Project Settings → API → Project URL |
| `SUPABASE_PUBLISHABLE_KEY` | Project Settings → API Keys → publishable key (or the anon key on older projects) |

`env.json` is git-ignored. Team members can ask Wesley for the shared one.

**3. Run the app:**

```bash
flutter run --dart-define-from-file=env.json
```

Without `env.json` the app still opens, but login shows "Supabase is not set up".

**Checks:**

```bash
flutter analyze
flutter test
```

## Project Structure

```text
lib/
├── app/        # Routes, router, and session
├── data/       # Supabase config, auth service, repositories, models
├── screens/    # auth, setup (onboarding), home, wardrobe, add, calendar, profile
├── theme/      # Colors and text styles
└── widgets/    # Shared UI components
supabase/
└── schema.sql  # Tables, row-level security policies, and storage bucket
```

## Team Walisongo

[@Kenn-jpg](https://github.com/Kenn-jpg) · [@WesleyGoey](https://github.com/WesleyGoey) · [@TanggaRusakk](https://github.com/TanggaRusakk) · [@Sean-230](https://github.com/Sean-230) · [@nikiwoi](https://github.com/nikiwoi) · [@fenrir871](https://github.com/fenrir871)
