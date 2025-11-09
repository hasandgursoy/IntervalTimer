# Architecture Setup - README

This document explains the folder structure created for the Interval Timer app.

## Folder Structure

```
lib/
├── core/                              # Core app-wide utilities
│   ├── constants/
│   │   └── app_constants.dart        # Default values, colors, limits
│   ├── theme/
│   │   └── app_theme.dart            # Light and dark theme definitions
│   └── utils/                        # Shared utility functions (future)
│
├── features/                          # Feature-based modules
│   └── timer/                        # Timer feature (main feature)
│       ├── data/                     # Data layer
│       │   ├── models/              # Data models (JSON serialization)
│       │   └── repositories/        # Data access logic
│       ├── domain/                   # Business logic layer
│       │   ├── entities/            # Business objects (pure Dart)
│       │   └── usecases/            # Business logic operations
│       └── presentation/             # UI layer
│           ├── providers/           # Riverpod state providers
│           ├── screens/             # Full-page screens
│           └── widgets/             # Reusable UI components
│
└── shared/                            # Shared across features
    └── widgets/                      # Common widgets used by multiple features
```

## What Each Layer Does

### 📁 `core/`
App-wide utilities that are used everywhere:
- **constants/** - Configuration values (colors, defaults, limits)
- **theme/** - Visual styling (light/dark themes)
- **utils/** - Helper functions (formatters, validators, etc.)

### 📁 `features/timer/`
The main timer functionality, organized in layers:

#### `data/` - Where data comes from
- **models/** - Classes that represent data (can be serialized to/from JSON)
- **repositories/** - Handle data storage and retrieval

#### `domain/` - What the app does (business rules)
- **entities/** - Core business objects (TimerState, IntervalConfig)
- **usecases/** - Business logic operations (start timer, pause timer, etc.)

#### `presentation/` - What users see
- **providers/** - Riverpod state management (connects UI to business logic)
- **screens/** - Full-page UI (Timer Screen, Setup Screen)
- **widgets/** - Reusable UI components specific to timer feature

### 📁 `shared/`
Components used by multiple features:
- **widgets/** - Common UI elements (custom buttons, time pickers, etc.)

## Why This Structure?

1. **Easy to find things** - Each file has a clear, logical location
2. **Easy to add features** - Just add a new folder under `features/`
3. **Testable** - Can test business logic without UI
4. **AI-friendly** - Clear organization helps AI assistants navigate code
5. **Scalable** - Can grow from simple timer to full fitness app

## Next Steps

1. Create domain models (TimerState, IntervalConfig) ✅
2. Implement timer business logic (TimerController)
3. Create Riverpod providers
4. Build UI screens

## Files Created in Phase 1.1

✅ `pubspec.yaml` - Added flutter_riverpod dependency
✅ `core/constants/app_constants.dart` - Default values and colors
✅ `core/theme/app_theme.dart` - Light and dark themes
✅ Complete folder structure for clean architecture

Ready for Phase 1.2: Domain Layer implementation!
