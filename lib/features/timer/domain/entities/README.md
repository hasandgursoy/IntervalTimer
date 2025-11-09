# Domain Layer - Entity Models

This document explains the domain entities created for the timer feature.

## Overview

The domain layer contains the core business logic and entities. These are pure Dart classes with no dependencies on Flutter or external packages (except app_constants).

## Created Entities

### 1. `interval_type.dart`
**Purpose**: Defines the types of intervals in a workout

```dart
enum IntervalType {
  preparation,  // Get ready countdown
  work,        // Active exercise
  rest,        // Recovery between work
}
```

**Features**:
- Extension methods for display names (`PREP`, `WORK`, `REST`)
- Boolean helpers (`isWork`, `isRest`, `isPreparation`)

**Usage**:
```dart
final type = IntervalType.work;
print(type.displayName); // "WORK"
if (type.isWork) { /* ... */ }
```

---

### 2. `timer_status.dart`
**Purpose**: Represents the current state of the timer

```dart
enum TimerStatus {
  ready,      // Not started yet
  running,    // Actively counting down
  paused,     // Temporarily stopped
  completed,  // Workout finished
}
```

**Features**:
- Extension methods for state checking (`isRunning`, `isPaused`, etc.)
- Action validation (`canPause`, `canResume`, `canStart`)

**Usage**:
```dart
final status = TimerStatus.running;
if (status.canPause) {
  // Show pause button
}
```

---

### 3. `interval_config.dart`
**Purpose**: Configuration for a workout session

**Fields**:
- `workDuration` - Seconds of exercise per round
- `restDuration` - Seconds of recovery per round
- `rounds` - Number of work/rest cycles
- `preparationTime` - Countdown before workout starts

**Features**:
- Default values from `AppConstants`
- Validation (all values > 0)
- Calculated properties:
  - `totalDuration` - Complete workout time including prep
  - `workoutDuration` - Workout time excluding prep
  - `totalIntervals` - Number of interval transitions
  - `isValid` - Validates against min/max limits
- Immutable with `copyWith()`
- Equality comparison

**Usage**:
```dart
// Create config with defaults
final config = IntervalConfig();

// Create custom config (Tabata style)
final tabata = IntervalConfig(
  workDuration: 20,
  restDuration: 10,
  rounds: 8,
  preparationTime: 10,
);

print(tabata.totalDuration); // 250 seconds (4:10)

// Modify config
final longer = tabata.copyWith(rounds: 10);
```

---

### 4. `timer_state.dart`
**Purpose**: Snapshot of the timer at a specific moment

**Fields**:
- `status` - Current timer status (ready/running/paused/completed)
- `currentRound` - Which round (1-based)
- `currentInterval` - What type of interval (prep/work/rest)
- `remainingSeconds` - Time left in current interval
- `totalElapsedSeconds` - Total workout time elapsed

**Features**:
- Factory constructors:
  - `TimerState.initial()` - Creates starting state
  - `TimerState.completed()` - Creates finished state
- Boolean helpers (`isWork`, `isRest`, `isPreparation`)
- Action validators (`canPause`, `canResume`, `canStart`)
- Immutable with `copyWith()`
- Equality comparison

**Usage**:
```dart
// Create initial state
final state = TimerState.initial(preparationTime: 5);

// Tick the timer (reduce remaining time)
final newState = state.copyWith(
  remainingSeconds: state.remainingSeconds - 1,
  totalElapsedSeconds: state.totalElapsedSeconds + 1,
);

// Check state
if (newState.isWork && newState.canPause) {
  // Currently working and can be paused
}

// Debug output
print(state); 
// TimerState(status: ready, round: 1, interval: PREP, remaining: 5s, elapsed: 0s)
```

---

## Design Principles

### Immutability
All entities are immutable (final fields). State changes create new instances.

**Why?**
- Prevents bugs from unintended state mutations
- Makes state changes explicit and traceable
- Works well with reactive state management (Riverpod)
- Easier to test

### Pure Dart
No Flutter dependencies in domain layer.

**Why?**
- Can be tested without Flutter test framework
- Business logic independent of UI framework
- Could be reused in other platforms (CLI, web backend, etc.)

### Rich Models
Entities include business logic (validation, calculations).

**Why?**
- Keeps related logic together
- Prevents invalid states
- Self-documenting (methods explain what's valid)

### Documentation
Every class, method, and field has documentation comments.

**Why?**
- Makes code understandable for humans and AI assistants
- IDE tooltips show explanations
- Beginner-friendly

---

## Validation Rules

### IntervalConfig
- `workDuration`: 1 - 3600 seconds
- `restDuration`: 1 - 3600 seconds
- `rounds`: 1 - 100
- `preparationTime`: 0 - 3600 seconds (0 means no prep)

### TimerState
- `currentRound`: Must be ≥ 1 (or 0 for completed)
- `remainingSeconds`: Must be ≥ 0
- `totalElapsedSeconds`: Must be ≥ 0

---

## State Transitions

### Normal Workout Flow
```
1. Initial State
   status: ready
   interval: preparation (if prep > 0, else work)
   round: 1
   
2. Start → Running
   status: running
   interval: preparation
   
3. Prep Complete → First Work
   interval: work
   remainingSeconds: workDuration
   
4. Work Complete → First Rest
   interval: rest
   remainingSeconds: restDuration
   
5. Rest Complete → Next Work
   round: 2
   interval: work
   
6. ... continues for all rounds ...

7. Last Rest Complete → Completed
   status: completed
   round: 0
```

### Pause/Resume Flow
```
Running → Pause
  status: paused
  (remainingSeconds preserved)

Paused → Resume
  status: running
  (continues from same position)
```

---

## Next Steps

With domain entities complete, next steps are:

1. **Phase 1.3**: Create `TimerController` (use case)
   - Manages timer lifecycle
   - Handles state transitions
   - Emits state updates

2. **Phase 1.4**: Write unit tests
   - Test all models
   - Test validation
   - Test state transitions

3. **Phase 2**: Build UI
   - Connect to TimerController
   - Display timer state
   - Handle user actions

---

## Testing Examples

```dart
// Test IntervalConfig validation
test('IntervalConfig validates durations', () {
  final config = IntervalConfig(
    workDuration: 30,
    restDuration: 10,
    rounds: 8,
  );
  
  expect(config.isValid, true);
  expect(config.totalDuration, 325); // 5 prep + 320 workout
});

// Test TimerState immutability
test('TimerState copyWith creates new instance', () {
  final state1 = TimerState.initial(preparationTime: 5);
  final state2 = state1.copyWith(remainingSeconds: 4);
  
  expect(state1.remainingSeconds, 5);
  expect(state2.remainingSeconds, 4);
  expect(identical(state1, state2), false);
});

// Test IntervalType extensions
test('IntervalType has correct display names', () {
  expect(IntervalType.work.displayName, 'WORK');
  expect(IntervalType.rest.displayName, 'REST');
  expect(IntervalType.preparation.displayName, 'PREP');
});
```

---

**Status**: ✅ Phase 1.2 Complete  
**Files Created**: 4 entity classes, 0 errors  
**Next**: Phase 1.3 - Timer Controller
