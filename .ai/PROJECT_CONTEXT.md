# Project Context

## App Purpose
**Interval Timer** is a workout timer app designed for fitness enthusiasts who need to track work and rest intervals during their training sessions. The app helps users set up custom interval patterns (e.g., 30 seconds work, 10 seconds rest) and provides visual and audio feedback during workouts.

### Target Platforms
- iOS
- Android

### Core Features (Planned)
- Configurable work/rest intervals
- Multiple rounds support
- Visual countdown display
- Audio alerts for interval changes
- Pause/resume functionality
- Preset workout templates
- Workout history tracking

## Tech Stack

### Framework
- **Flutter 3.x+**: Google's UI toolkit for building natively compiled applications
- **Dart**: Programming language optimized for UI development

### Key Dependencies (Planned)
- State management solution (see DECISIONS.md)
- Audio player package for interval alerts
- Local storage for saving presets
- Background execution support

## Architecture Approach

### Design Philosophy
The app follows a **clean architecture** pattern to ensure:
- Easy feature additions
- Testable code
- Clear separation of concerns
- AI-assistant-friendly code structure

### Layer Structure
```
lib/
├── main.dart                 # App entry point
├── core/                     # Core utilities, constants, themes
├── features/                 # Feature-based modules
│   ├── timer/               # Timer feature
│   │   ├── data/           # Data sources, repositories
│   │   ├── domain/         # Business logic, entities
│   │   └── presentation/   # UI, state management
│   └── presets/            # Preset management feature
└── shared/                  # Shared widgets, utilities
```

### Key Architectural Decisions
1. **Feature-first organization**: Each major feature lives in its own module
2. **State management**: Centralized state for timer logic, local state for UI
3. **Reusable components**: Shared widgets extracted to `/shared` folder
4. **Dependency injection**: Easy testing and swapping of implementations

## Key Decisions Made

### Why This Approach?
1. **Modular structure**: Makes it easy to add new features (history, statistics, etc.)
2. **AI-friendly**: Clear file organization helps AI assistants navigate and modify code
3. **Beginner-friendly**: Logical grouping makes code easier to understand
4. **Scalable**: Can grow from simple timer to full fitness tracking app

### Development Strategy
- Start with core timer logic (domain layer)
- Build minimal UI to test functionality
- Add polish (sounds, animations) incrementally
- User testing at each phase

## Getting Started (For AI Assistants)
When working on this project:
1. Check `CURRENT_STATE.md` to understand what's implemented
2. Review `NEXT_STEPS.md` for prioritized tasks
3. Consult `DECISIONS.md` for technical choices
4. Use `PROMPTS.md` templates for consistent communication

## Project Goals
- ✅ Cross-platform mobile app (iOS + Android)
- ✅ Offline-first functionality
- ✅ Intuitive, distraction-free UI
- ✅ Reliable timer accuracy
- ✅ Battery-efficient operation
