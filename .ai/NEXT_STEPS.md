# Next Steps

**Priority Order**: Top to bottom

---

## 🔴 Phase 1: Core Timer Functionality
*Goal: Working timer logic without fancy UI*

### 1.1 Set Up Architecture ✅ COMPLETED
- [x] Choose and add state management dependency to `pubspec.yaml`
- [x] Create folder structure (`lib/core/`, `lib/features/timer/`)
- [x] Set up basic theme and constants file

### 1.2 Domain Layer (Business Logic) ✅ COMPLETED
- [x] Create `TimerStatus` enum (ready, running, paused, completed)
- [x] Create `IntervalType` enum (preparation, work, rest)
- [x] Create `IntervalConfig` model class
  - Work duration (seconds)
  - Rest duration (seconds)
  - Number of rounds
  - Preparation time (countdown before start)
  - Validation and calculations
- [x] Create `TimerState` model
  - Current status, round, interval type
  - Time remaining in current interval
  - Total elapsed time
  - Immutable with copyWith and factory methods

### 1.3 Timer Logic ✅ COMPLETED
- [x] Implement `TimerNotifier` with StateNotifier (Riverpod)
  - `start()` - Begin timer
  - `pause()` - Pause countdown
  - `resume()` - Continue from pause
  - `reset()` - Return to initial state
  - `stop()` - End workout early
- [x] Implement countdown logic using `Timer.periodic()`
- [x] Handle state transitions between intervals
- [x] Add interval completion detection
- [x] Add workout completion detection
- [x] Created ConfigProvider for workout configuration
- [x] Proper timer disposal to prevent memory leaks

### 1.4 Basic Testing ✅ COMPLETED
- [x] Write unit tests for `IntervalConfig` model
- [x] Write unit tests for `IntervalType` enum
- [x] Write unit tests for `TimerStatus` enum
- [x] Write unit tests for `TimerState` model
- [x] Write unit tests for `TimerNotifier` logic
- [x] Test edge cases (pause/resume, early stop, initialization)
- [x] 25 tests total, 100% pass rate

**Estimated Time**: 1-2 sessions
**Success Criteria**: Timer logic works in console/tests without UI

---

## 🟡 Phase 2: UI Implementation
*Goal: Beautiful, functional interface*

### 2.1 Screen Architecture
- [ ] Create `TimerScreen` (main timer display)
- [ ] Create `SetupScreen` (configure intervals)
- [ ] Set up navigation between screens

### 2.2 Timer Display Screen
- [ ] Large countdown display (current interval time)
- [ ] Progress indicator (circular or linear)
- [ ] Current interval indicator (WORK/REST/PREP)
- [ ] Round counter (e.g., "Round 3/5")
- [ ] Control buttons (Start, Pause, Resume, Stop)

### 2.3 Setup Screen
- [ ] Input fields for work duration
- [ ] Input fields for rest duration
- [ ] Input field for number of rounds
- [ ] Input field for preparation time
- [ ] Preview of total workout time
- [ ] "Start Workout" button

### 2.4 Visual Polish
- [ ] Choose color scheme (high contrast for workout visibility)
- [ ] Add animations for state transitions
- [ ] Implement progress animations
- [ ] Add haptic feedback (vibration on interval changes)
- [ ] Design app icon

### 2.5 UI Testing
- [ ] Widget tests for custom components
- [ ] Integration tests for navigation
- [ ] Test on different screen sizes

**Estimated Time**: 2-3 sessions
**Success Criteria**: Fully functional timer UI on one device

---

## 🟢 Phase 3: Sound & Notifications
*Goal: Audio/visual feedback without looking at screen*

### 3.1 Audio Implementation
- [ ] Add audio player dependency (`audioplayers` or `just_audio`)
- [ ] Find/create sound files
  - Start sound
  - Work interval start sound
  - Rest interval start sound
  - Workout complete sound
  - 3-second warning sound (optional)
- [ ] Implement audio service/controller
- [ ] Add volume control settings
- [ ] Add option to enable/disable sounds

### 3.2 Notifications
- [ ] Add local notifications dependency (`flutter_local_notifications`)
- [ ] Request notification permissions
- [ ] Send notification on interval change (if app in background)
- [ ] Send notification on workout completion

### 3.3 Background Execution
- [ ] Add background execution dependency (if needed)
- [ ] Ensure timer continues when app is backgrounded
- [ ] Test on both iOS and Android

**Estimated Time**: 1-2 sessions
**Success Criteria**: Timer provides feedback without looking at screen

---

## 🔵 Phase 4: Customization & Quality of Life
*Goal: Make app convenient for regular use*

### 4.1 Preset Workouts
- [ ] Create `Preset` model
- [ ] Implement preset storage (local database or shared preferences)
- [ ] Create presets list screen
- [ ] Add ability to save current configuration as preset
- [ ] Add ability to load preset
- [ ] Include default presets (Tabata, HIIT, etc.)

### 4.2 Settings Screen
- [ ] Sound on/off toggle
- [ ] Volume control
- [ ] Theme selection (light/dark)
- [ ] Keep screen awake during workout toggle
- [ ] Default values for quick start

### 4.3 History/Statistics (Optional)
- [ ] Save completed workouts
- [ ] Show workout history
- [ ] Basic statistics (total workouts, total time)

### 4.4 Polish & Optimization
- [ ] Add loading states
- [ ] Add error handling
- [ ] Optimize battery usage
- [ ] Test on multiple devices
- [ ] Fix any reported bugs

**Estimated Time**: 2-4 sessions
**Success Criteria**: App feels complete and professional

---

## 🟣 Phase 5: Release Preparation
*Goal: Ship to app stores*

### 5.1 Testing
- [ ] Full manual testing on iOS device
- [ ] Full manual testing on Android device
- [ ] Test all edge cases
- [ ] Beta testing with friends/family

### 5.2 Store Assets
- [ ] App store screenshots
- [ ] App store description
- [ ] Privacy policy (if needed)
- [ ] App icon finalized

### 5.3 Platform Setup
- [ ] Configure iOS bundle ID and signing
- [ ] Configure Android package name and signing
- [ ] Set up app store accounts

### 5.4 Deployment
- [ ] Build release APK/App Bundle (Android)
- [ ] Build release IPA (iOS)
- [ ] Submit to Google Play Store
- [ ] Submit to Apple App Store

**Estimated Time**: 1-2 sessions + store review time
**Success Criteria**: App live on both stores

---

## 📝 Notes for AI Assistants

### Working Through Phases
- Complete Phase 1 fully before moving to Phase 2
- Each checkbox can be one or multiple prompts
- Update `CURRENT_STATE.md` after completing each phase
- Document any new decisions in `DECISIONS.md`

### Prompt Template
```
"Let's work on [Phase X.Y: Task Name]. 
Context: [Brief description of what's needed]
Please implement [specific items from checklist]"
```

### When to Ask for Input
- State management choice (Phase 1.1)
- Design preferences (Phase 2.4)
- Which optional features to include (Phase 4.3)
