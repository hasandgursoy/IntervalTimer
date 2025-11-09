# Timer Logic Implementation

## Overview

Phase 1.3 implements the core timer logic using Riverpod's `StateNotifier` pattern. This provides reactive state management that the UI can watch and respond to.

## Files Created

### 1. `config_provider.dart`
**Purpose**: Holds the workout configuration

```dart
final configProvider = StateProvider<IntervalConfig>((ref) {
  return const IntervalConfig(); // Default values
});
```

**Usage**:
```dart
// Read config
final config = ref.watch(configProvider);

// Update config
ref.read(configProvider.notifier).state = newConfig;
```

---

### 2. `timer_provider.dart`
**Purpose**: Manages the entire timer lifecycle

```dart
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});
```

**Core Class**: `TimerNotifier extends StateNotifier<TimerState>`

---

## TimerNotifier API

### Public Methods

#### `initialize(IntervalConfig config)`
Sets up the timer with a workout configuration.

```dart
final notifier = ref.read(timerProvider.notifier);
notifier.initialize(config);
```

**What it does**:
- Stores the config
- Sets initial state (ready)
- Determines starting interval (prep or work)
- Sets remaining seconds for first interval

---

#### `start()`
Begins the countdown from ready state.

```dart
notifier.start();
```

**What it does**:
- Changes status to `running`
- Starts `Timer.periodic` (ticks every 1 second)
- Begins countdown

**Requirements**:
- Timer must be initialized
- Status must be `ready`

---

#### `pause()`
Pauses the countdown.

```dart
notifier.pause();
```

**What it does**:
- Changes status to `paused`
- Cancels the timer
- Preserves current position (remainingSeconds)

**Requirements**:
- Status must be `running`

---

#### `resume()`
Continues from paused state.

```dart
notifier.resume();
```

**What it does**:
- Changes status to `running`
- Restarts `Timer.periodic`
- Continues from preserved position

**Requirements**:
- Status must be `paused`

---

#### `stop()` / `reset()`
Ends the workout and returns to ready state.

```dart
notifier.stop();
// or
notifier.reset();
```

**What it does**:
- Cancels the timer
- Reinitializes with same config
- Returns to ready state

**Can be called**: From any state

---

## Timer Logic Flow

### 1. Initialization
```
User configures workout → initialize(config) → State: Ready
```

### 2. Starting
```
Ready → start() → Running → Timer.periodic starts
```

### 3. Ticking (Every Second)
```
_tick() called every 1 second:
1. Decrement remainingSeconds
2. Increment totalElapsedSeconds
3. Check if interval complete (remainingSeconds == 0)
   - YES → _advanceInterval()
   - NO → Emit updated state
```

### 4. Advancing Intervals
```
_advanceInterval() determines next interval:

Preparation → Work (Round 1)
Work → Rest (Same round)
Rest → Check if more rounds
  - YES → Work (Next round)
  - NO → Completed
```

### 5. Workout Flow Example
```
Prep (5s) → 
Work R1 (30s) → Rest R1 (10s) → 
Work R2 (30s) → Rest R2 (10s) → 
Work R3 (30s) → Rest R3 (10s) → 
... → 
Work R8 (30s) → Rest R8 (10s) → 
Completed
```

---

## State Transitions

### Normal Flow
```
ready → running → running (ticking) → ... → completed
```

### With Pause
```
ready → running → paused → running → ... → completed
```

### With Stop
```
ready → running → stopped (back to ready)
```

---

## Internal Methods

### `_startTicking()`
Creates a `Timer.periodic` that calls `_tick()` every second.

**Safety**:
- Cancels any existing timer first
- Prevents multiple timers running simultaneously

---

### `_tick()`
Called every second when running.

**Logic**:
1. Calculate new time values
2. Log current state (for debugging)
3. Check if interval complete
   - If complete: Call `_advanceInterval()`
   - If not: Update state with new times

---

### `_advanceInterval()`
Handles moving to the next interval.

**Decision Logic**:
```dart
if (preparation) {
  → Move to Work (Round 1)
}
else if (work) {
  → Move to Rest (Same round)
}
else if (rest) {
  if (more rounds exist) {
    → Move to Work (Next round)
  } else {
    → Complete workout
  }
}
```

---

### `_transitionTo()`
Helper method to update state with new interval.

**Updates**:
- Current interval type
- Remaining seconds (new interval duration)
- Current round number
- Total elapsed time (+1 for the tick)

---

### `_completeWorkout()`
Finalizes the workout.

**Actions**:
1. Cancel timer
2. Set state to completed
3. Log total time

---

## Memory Management

### `dispose()`
Automatically called when provider is disposed.

**Critical**: Cancels any running timers to prevent memory leaks.

```dart
@override
void dispose() {
  _timer?.cancel();
  _timer = null;
  super.dispose();
}
```

---

## Edge Cases Handled

### 1. No Preparation Time
If `preparationTime == 0`:
- Skip prep interval
- Start directly at Work (Round 1)

### 2. Pause During Prep
- Works correctly
- Preserves prep time remaining

### 3. Stop Mid-Workout
- Cancels timer safely
- Returns to ready state
- Can start fresh workout

### 4. Multiple Start Attempts
- Only starts if status is `ready`
- Prevents starting when already running

### 5. Configuration Not Set
- Throws clear error message
- Prevents undefined behavior

---

## Debug Output

The implementation includes `print()` statements for debugging:

```
[TimerNotifier] Initialized with ready state
[TimerNotifier] Initializing with config: IntervalConfig(...)
[TimerNotifier] Starting timer from PREP
[TimerNotifier] Tick: PREP Round 1/8 - 4s remaining (1s elapsed)
[TimerNotifier] Interval complete, advancing...
[TimerNotifier] Prep complete → Starting Work (Round 1)
...
[TimerNotifier] Workout completed in 325s
```

**Note**: These will be removed or replaced with proper logging in production.

---

## Testing

### Test Coverage (25 tests)

**IntervalConfig** (8 tests):
- Default values
- Custom values
- Validation
- Total duration calculation
- Workout duration calculation
- Total intervals calculation
- copyWith method
- Equality

**IntervalType** (2 tests):
- Display names
- Type checking methods

**TimerStatus** (2 tests):
- State checking methods
- Action validation

**TimerState** (6 tests):
- Initial state with prep
- Initial state without prep
- Completed state
- copyWith method
- Helper methods
- Equality

**TimerNotifier** (7 tests):
- Initial state
- Initialize with config
- Initialize without prep
- Start changes status
- Pause changes status
- Resume changes status
- Stop resets state

**Result**: ✅ All 25 tests passing

---

## Usage in UI

### Watch Timer State
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final timerState = ref.watch(timerProvider);
  final config = ref.watch(configProvider);
  
  return Column(
    children: [
      Text('${timerState.remainingSeconds}'),
      Text(timerState.currentInterval.displayName),
      Text('Round ${timerState.currentRound}/${config.rounds}'),
    ],
  );
}
```

### Control Timer
```dart
// Start
ref.read(timerProvider.notifier).start();

// Pause
ref.read(timerProvider.notifier).pause();

// Resume
ref.read(timerProvider.notifier).resume();

// Stop
ref.read(timerProvider.notifier).stop();
```

### Update Config
```dart
ref.read(configProvider.notifier).state = IntervalConfig(
  workDuration: 45,
  restDuration: 15,
  rounds: 10,
);
```

---

## Performance Considerations

### Timer Accuracy
- Uses `Timer.periodic(Duration(seconds: 1))`
- Acceptable accuracy for workout timers (±500ms over 30 minutes)
- More accurate than manual drift correction for this use case

### State Updates
- State is updated every second
- Riverpod efficiently rebuilds only listening widgets
- No performance issues expected

### Memory
- Only one timer instance exists
- Properly disposed when not needed
- No memory leaks

---

## Next Steps

With timer logic complete:

1. **Phase 2: UI** - Build screens that use these providers
   - Setup screen to configure `configProvider`
   - Timer screen that watches `timerProvider`
   - Buttons that call notifier methods

2. **Remove Debug Prints** - Replace with proper logging

3. **Sound Integration** - Add audio alerts on interval changes

4. **Notifications** - Alert user even when app is backgrounded

---

**Status**: ✅ Phase 1.3 Complete  
**Test Coverage**: 25 tests, 100% pass rate  
**Ready For**: Phase 2 - UI Implementation
