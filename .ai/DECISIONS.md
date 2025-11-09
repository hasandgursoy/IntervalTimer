# Technical Decisions

This document tracks all technical decisions made during development. Each decision includes the reasoning to help future contributors (human or AI) understand the context.

---

## Framework & Platform

### ✅ Decision: Use Flutter
**Date**: October 30, 2025
**Status**: Confirmed

**Why Flutter?**
1. **Cross-platform**: Single codebase for iOS and Android
2. **Performance**: Compiled to native code, important for timer accuracy
3. **UI flexibility**: Easy to create custom timer displays
4. **AI-friendly**: Clean, readable Dart code structure
5. **Hot reload**: Fast development iteration
6. **Strong ecosystem**: Good packages for audio, notifications, storage

**Alternatives Considered**:
- React Native: Good, but Flutter has better performance for UI-heavy apps
- Native (Swift/Kotlin): Best performance, but 2x development time
- PWA: Limited access to native features (background execution, notifications)

**Trade-offs**:
- ✅ Fast development
- ✅ Good performance
- ⚠️ App size larger than native (acceptable for this use case)

---

## State Management

### 🟡 Decision: [TO BE DECIDED]
**Date**: Pending
**Status**: Needs decision in Phase 1

**Recommended: Riverpod**

**Why Riverpod?**
1. **Modern**: Latest evolution of Provider pattern
2. **Type-safe**: Compile-time safety reduces bugs
3. **Testable**: Easy to unit test without widget tree
4. **Beginner-friendly**: Clear patterns and good documentation
5. **No BuildContext needed**: More flexible than Provider
6. **Good for timers**: StreamProvider perfect for timer ticks

**Alternative Options**:

| Solution | Pros | Cons | Best For |
|----------|------|------|----------|
| **Provider** | Simple, official | Requires BuildContext | Very simple apps |
| **Bloc** | Structured, testable | More boilerplate | Large enterprise apps |
| **GetX** | Minimal code | Controversial patterns | Rapid prototyping |
| **MobX** | Reactive, minimal boilerplate | Smaller community | React developers |

**For This App**:
- Timer needs reactive state updates (every second)
- Not complex enough to need Bloc's structure
- Want good testing support
- **Recommendation: Start with Riverpod**

**Action Item**: Confirm choice at start of Phase 1.1

---

## Architecture & Folder Structure

### ✅ Decision: Feature-First Clean Architecture
**Date**: October 30, 2025
**Status**: Confirmed

**Structure**:
```
lib/
├── main.dart                          # App entry point
├── core/                              # App-wide concerns
│   ├── constants/
│   │   └── app_constants.dart        # Colors, durations, defaults
│   ├── theme/
│   │   └── app_theme.dart            # Theme configuration
│   └── utils/
│       └── time_formatter.dart       # Shared utilities
├── features/                          # Feature modules
│   ├── timer/
│   │   ├── data/
│   │   │   ├── models/               # Data models
│   │   │   └── repositories/         # Data access
│   │   ├── domain/
│   │   │   ├── entities/             # Business objects
│   │   │   └── usecases/             # Business logic
│   │   └── presentation/
│   │       ├── providers/            # State management
│   │       ├── screens/              # Full screens
│   │       └── widgets/              # Feature-specific widgets
│   └── presets/                       # (Phase 4)
│       └── [similar structure]
└── shared/                            # Shared across features
    └── widgets/
        ├── custom_button.dart
        └── time_picker.dart
```

**Why This Structure?**
1. **Scalability**: Easy to add new features (history, statistics, etc.)
2. **Clear separation**: Each layer has one responsibility
3. **Testability**: Can test business logic without UI
4. **AI-friendly**: Clear file locations help AI navigation
5. **Team-ready**: Multiple developers can work on different features

**For Beginners**:
- `domain/` = What the app does (business rules)
- `data/` = Where data comes from (storage, APIs)
- `presentation/` = What users see (UI)

**Trade-offs**:
- More folders initially (worth it as app grows)
- Slightly more boilerplate (clearer code)

---

## Timer Implementation

### ✅ Decision: Use Dart's Timer.periodic()
**Date**: October 30, 2025
**Status**: Confirmed

**Why?**
1. **Built-in**: No additional dependencies
2. **Accurate**: Sufficient for 1-second intervals
3. **Simple**: Easy to understand and maintain
4. **Cancellable**: Easy to pause/resume

**Code Pattern**:
```dart
Timer.periodic(Duration(seconds: 1), (timer) {
  // Update countdown
  // Check if interval complete
  // Emit new state
});
```

**Alternative Considered**:
- Ticker: Better for animations, overkill for 1-second timer
- Stream: Works, but Timer is more intuitive

---

## Data Persistence

### 🟡 Decision: [TO BE DECIDED - Phase 4]
**Date**: Pending
**Status**: Needs decision when implementing presets

**Recommended: shared_preferences**

**Why?**
1. **Simple**: Key-value storage, perfect for presets
2. **Lightweight**: No database overhead
3. **Cross-platform**: Works on all platforms
4. **Fast**: Synchronous reads

**Data to Store**:
- Saved workout presets
- User settings (sound on/off, theme, defaults)
- (Optional) Workout history

**Alternatives**:
- Hive: If we need complex queries later
- SQLite: Overkill for this app
- Firebase: Not needed (offline-first app)

---

## Audio System

### 🟡 Decision: [TO BE DECIDED - Phase 3]
**Date**: Pending
**Status**: Needs decision at Phase 3.1

**Recommended: just_audio**

**Why?**
1. **Modern**: Well-maintained
2. **Full-featured**: Play local assets
3. **Cross-platform**: iOS + Android support
4. **Background**: Supports background playback
5. **Low latency**: Important for interval changes

**Alternatives**:
- `audioplayers`: Also good, simpler API
- `soundpool`: Lower latency but Android-only

---

## Navigation

### ✅ Decision: Use Navigator 2.0 (go_router)
**Date**: October 30, 2025
**Status**: Recommended for Phase 2

**Why?**
1. **URL-based**: Clear navigation structure
2. **Deep linking**: Easier to add later
3. **Type-safe**: Compile-time route checking
4. **Modern**: Best practice for new Flutter apps

**For This App**:
```
/ → Setup Screen
/timer → Timer Screen  
/presets → Presets List (Phase 4)
/settings → Settings (Phase 4)
```

**Alternative**: Basic Navigator.push() works fine for simple app, but go_router is not much harder

---

## Testing Strategy

### ✅ Decision: Unit Tests First, Widget Tests Second
**Date**: October 30, 2025
**Status**: Confirmed

**Priority**:
1. **Unit tests**: Timer logic, models (Phase 1.4)
2. **Widget tests**: Custom widgets (Phase 2.5)
3. **Integration tests**: Full user flows (if time permits)

**Why?**
- Timer accuracy is critical → test business logic thoroughly
- UI can be validated manually during development
- Unit tests are fastest to write and run

---

## Code Style

### ✅ Decision: Follow Effective Dart + Flutter Lints
**Date**: October 30, 2025
**Status**: Confirmed

**Rules**:
- Use `flutter_lints` package (already in default project)
- Follow Dart naming conventions
  - `UpperCamelCase` for classes
  - `lowerCamelCase` for variables/functions
  - `snake_case` for file names
- Prefer `const` constructors where possible
- Add comments for complex logic

**Why?**
- AI assistants understand standard conventions
- Easier for beginners to read
- IDE auto-formatting works better

---

## Platform Decisions

### ✅ Decision: Target Mobile Only (iOS + Android)
**Date**: October 30, 2025
**Status**: Confirmed

**Why?**
- Interval timer is primarily used during workouts (mobile context)
- Simplifies testing and development
- Can add desktop/web later if needed

**Action**: Can remove web/desktop folders after Phase 1

---

## Performance Targets

### ✅ Decision: Timer Accuracy ±500ms Acceptable
**Date**: October 30, 2025
**Status**: Confirmed

**Target**:
- Timer should be accurate within 0.5 seconds over 30 minutes
- UI should update every second without lag

**Why This Is Reasonable**:
- Human perception of timing is ~200ms
- Perfect accuracy requires platform-specific code
- For workout intervals, ±500ms is negligible

**How to Achieve**:
- Use `Timer.periodic()` with drift correction
- Avoid heavy computation in timer callback
- Test on real devices (especially older ones)

---

## 📝 Decision Log Template

Use this template when adding new decisions:

```markdown
### 🟡 Decision: [Title]
**Date**: [Date]
**Status**: [Confirmed/Pending/Changed]

**Why [Choice]?**
1. Reason 1
2. Reason 2

**Alternatives Considered**:
- Option A: [Pros/Cons]
- Option B: [Pros/Cons]

**Trade-offs**:
- ✅ Advantage
- ⚠️ Consideration
- ❌ Disadvantage

**For AI Assistants**: [Special notes for implementation]
```

---

## Status Legend
- ✅ **Confirmed**: Decision made and implemented
- 🟡 **Pending**: Needs decision before implementation
- 🔄 **Changed**: Decision was revised (keep old decision for history)
