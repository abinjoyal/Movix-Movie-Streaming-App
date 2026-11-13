# Movix

Movix is a cross-platform movie streaming and exploration application built using Flutter. The application provides movie discovery, media details, user authentication, subscription workflows, and offline management using a clean, scalable architecture.

---

## Overview

Movix delivers a modern entertainment tracking and streaming UI/UX experience. Powered by Supabase for backend services and authentication, Dio for network communications, and Riverpod for reactive state management, the application is designed to be performant, modular, and easy to maintain.

---

## Key Features

- **Authentication & Security**: Email/password authentication, OTP verification, password reset flows, and session management handled via Supabase.
- **Onboarding & Splash**: Responsive onboarding flows introducing core platform features.
- **Movie Discovery & Exploration**: Browse trending, popular, and top-rated movies with search and category filters.
- **Detailed Media Views**: In-depth movie overviews, cast information, filmographies, and user reviews/comments.
- **Personal Watchlist**: Save and organize movies to a personal watchlist.
- **Offline Downloads**: Download manager and local storage settings for offline playback.
- **Subscription & Payment Processing**: Multi-tier subscription plans, payment method selection, card registration, and checkout summary screens.
- **Profile & Preference Settings**: User profile management, language preferences, notification settings, download settings, security settings, and dark/light theme switching.

---

## Architecture

The project adheres to Feature-First Clean Architecture principles, ensuring separation of concerns:

- **Presentation Layer**: UI screens, reusable widgets, and state controllers/notifiers.
- **Domain Layer**: Business logic, use cases, and entity definitions.
- **Data Layer**: Data sources (remote APIs, local databases), repository implementations, and data models.
- **Core Layer**: Application-wide configurations, constants, theme definitions, network clients, utilities, and routing configuration.

---

## Tech Stack

- **Framework**: Flutter (Dart SDK `^3.12.2`)
- **State Management**: Flutter Riverpod (`^2.6.1`)
- **Navigation & Routing**: GoRouter (`^14.8.1`)
- **Backend & Authentication**: Supabase Flutter SDK (`^2.8.4`)
- **Networking**: Dio (`^5.8.0+1`)
- **Image Caching**: Cached Network Image (`^3.4.1`)
- **Design System**: Material Design 3 with custom dark and light themes

---

## Directory Structure

```text
lib/
├── app.dart                  # Application root widget configuration
├── main.dart                 # Application entry point and initialization
├── core/                     # Shared cross-feature utilities
│   ├── config/               # Environment and runtime configurations
│   ├── constants/            # Application constants and asset paths
│   ├── network/              # Dio client and network interceptors
│   ├── router/               # GoRouter configuration, route names, and paths
│   ├── supabase/             # Supabase client service and initialization
│   ├── theme/                # Light/Dark themes and theme providers
│   └── utils/                # Helper utilities and validators
└── features/                 # Modular feature-first architecture
    ├── authentication/       # Sign-in, sign-up, OTP, password recovery
    ├── downloads/            # Offline media management
    ├── explore/              # Search and category exploration
    ├── home/                 # Dashboard, banners, and curated lists
    ├── movie_details/        # Cast info, reviews, recommendations
    ├── notifications/        # User alerts and system updates
    ├── onboarding/           # Introduction walkthrough
    ├── profile/              # Account settings, security, and preferences
    ├── splash/               # Splash screen and session validation
    ├── subscription/         # Subscription plans and payment processing
    └── watchlist/            # Saved items management
```

---

## Prerequisites

Before running the application, ensure the following are installed:

- Flutter SDK (version 3.12.2 or higher)
- Dart SDK (matching Flutter installation)
- Android Studio / Xcode (for mobile emulator or physical device deployment)
- Git

---

## Environment Configuration

Create a `.env` file in the root directory and configure the necessary credentials:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
TMDB_API_KEY=your_tmdb_api_key_if_applicable
```

Ensure `.env` is declared under the `assets` section in `pubspec.yaml` (already configured).

---

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/movix.git
   cd movix
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify setup**:
   ```bash
   flutter doctor
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## State Management & Routing

- State is managed reactively using **Riverpod** providers (`ref.watch`, `ref.read`, and state notifiers).
- Routing is defined declaratively using **GoRouter** in `lib/core/router/app_router.dart`, supporting deep linking and programmatic navigation.

---

## License

This project is proprietary and intended for private development. All rights reserved.
