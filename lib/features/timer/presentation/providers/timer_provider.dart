import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/core/services/audio_provider.dart';
import 'package:interval_timer/features/timer/domain/entities/interval_config.dart';
import 'package:interval_timer/features/timer/domain/entities/interval_type.dart';
import 'package:interval_timer/features/timer/domain/entities/timer_state.dart';
import 'package:interval_timer/features/timer/domain/entities/timer_status.dart';

/// Provider for the timer state
/// 
/// This is the main provider that manages the entire timer lifecycle.
/// The UI listens to this provider to display current timer state.
/// 
/// Usage:
/// ```dart
/// // Watch timer state in UI
/// final timerState = ref.watch(timerProvider);
/// 
/// // Control timer
/// ref.read(timerProvider.notifier).start();
/// ref.read(timerProvider.notifier).pause();
/// ```
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return TimerNotifier(audioService);
});

/// Timer state manager using Riverpod's StateNotifier
/// 
/// This class handles all timer logic including:
/// - Starting and stopping the timer
/// - Counting down each second
/// - Transitioning between intervals (prep → work → rest)
/// - Progressing through rounds
/// - Detecting workout completion
/// - Playing audio cues for interval changes
class TimerNotifier extends StateNotifier<TimerState> {
  /// Internal timer that ticks every second
  Timer? _timer;
  
  /// Current workout configuration
  IntervalConfig? _config;
  
  /// Audio service for playing sounds
  final dynamic _audioService;
  
  /// Constructor - initializes with ready state
  TimerNotifier(this._audioService) : super(
    TimerState.initial(preparationTime: 0),
  ) {
    print('[TimerNotifier] Initialized with ready state');
  }
  
  // ============================================
  // Public Methods (Called by UI)
  // ============================================
  
  /// Initialize the timer with a workout configuration
  /// 
  /// This must be called before starting the timer.
  /// Sets up the initial state based on the config.
  /// 
  /// Parameters:
  /// - [config]: The workout configuration (durations, rounds, etc.)
  void initialize(IntervalConfig config) {
    print('[TimerNotifier] Initializing with config: $config');
    
    // Store config for later use
    _config = config;
    
    // Determine starting interval and duration
    final hasPrep = config.preparationTime > 0;
    final startingInterval = hasPrep ? IntervalType.preparation : IntervalType.work;
    final startingDuration = hasPrep ? config.preparationTime : config.workDuration;
    
    // Set initial state
    state = TimerState(
      status: TimerStatus.ready,
      currentRound: 1,
      currentInterval: startingInterval,
      remainingSeconds: startingDuration,
      totalElapsedSeconds: 0,
    );
    
    print('[TimerNotifier] Initialized: ${state.currentInterval.displayName} for ${state.remainingSeconds}s');
  }
  
  /// Start the timer from ready state
  /// 
  /// Begins the countdown. Can only be called when status is 'ready'.
  /// Throws if configuration is not set or timer is already running.
  void start() {
    if (_config == null) {
      print('[TimerNotifier] ERROR: Cannot start - config not initialized');
      throw StateError('Timer must be initialized before starting');
    }
    
    if (!state.canStart) {
      print('[TimerNotifier] ERROR: Cannot start from state: ${state.status.name}');
      return;
    }
    
    print('[TimerNotifier] Starting timer from ${state.currentInterval.displayName}');
    
    // Play start sound
    _audioService?.playStartSound();
    
    // Update state to running
    state = state.copyWith(status: TimerStatus.running);
    
    // Start the periodic timer
    _startTicking();
  }
  
  /// Pause the timer
  /// 
  /// Stops the countdown but preserves current position.
  /// Can be resumed later from the same point.
  void pause() {
    if (!state.canPause) {
      print('[TimerNotifier] Cannot pause from state: ${state.status.name}');
      return;
    }
    
    print('[TimerNotifier] Pausing at ${state.currentInterval.displayName} - ${state.remainingSeconds}s remaining');
    
    // Cancel the timer
    _timer?.cancel();
    _timer = null;
    
    // Update state to paused
    state = state.copyWith(status: TimerStatus.paused);
  }
  
  /// Resume the timer from paused state
  /// 
  /// Continues countdown from where it was paused.
  void resume() {
    if (!state.canResume) {
      print('[TimerNotifier] Cannot resume from state: ${state.status.name}');
      return;
    }
    
    print('[TimerNotifier] Resuming from ${state.currentInterval.displayName} - ${state.remainingSeconds}s remaining');
    
    // Update state to running
    state = state.copyWith(status: TimerStatus.running);
    
    // Restart the ticker
    _startTicking();
  }
  
  /// Stop the workout and return to ready state
  /// 
  /// Ends the workout early and resets to initial configuration.
  /// Different from pause - this cannot be resumed.
  void stop() {
    print('[TimerNotifier] Stopping workout');
    
    // Cancel the timer
    _timer?.cancel();
    _timer = null;
    
    // Reset to initial state with current config
    if (_config != null) {
      initialize(_config!);
    } else {
      // Fallback if config somehow got lost
      state = TimerState.initial(preparationTime: 0);
    }
  }
  
  /// Reset the timer to initial ready state
  /// 
  /// Alias for stop() - both return to ready state.
  void reset() {
    stop();
  }
  
  // ============================================
  // Private Methods (Internal Logic)
  // ============================================
  
  /// Starts the periodic timer that ticks every second
  void _startTicking() {
    // Cancel any existing timer first
    _timer?.cancel();
    
    // Create new timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tick();
    });
    
    print('[TimerNotifier] Timer started, ticking every 1 second');
  }
  
  /// Called every second when timer is running
  /// 
  /// This is the heart of the timer logic:
  /// 1. Decrements remaining seconds
  /// 2. Increments total elapsed time
  /// 3. Checks if interval is complete
  /// 4. Advances to next interval/round if needed
  void _tick() {
    // Defensive check - should never happen
    if (_config == null) {
      print('[TimerNotifier] ERROR: Config is null during tick');
      stop();
      return;
    }
    
    // Calculate new time values
    final newRemaining = state.remainingSeconds - 1;
    final newElapsed = state.totalElapsedSeconds + 1;
    
    print('[TimerNotifier] Tick: ${state.currentInterval.displayName} '
          'Round ${state.currentRound}/${_config!.rounds} - '
          '${newRemaining}s remaining (${newElapsed}s elapsed)');
    
    // Check if current interval is complete
    if (newRemaining <= 0) {
      print('[TimerNotifier] Interval complete, advancing...');
      _advanceInterval();
    } else {
      // Update state with decremented time
      state = state.copyWith(
        remainingSeconds: newRemaining,
        totalElapsedSeconds: newElapsed,
      );
    }
  }
  
  /// Advances to the next interval or completes the workout
  /// 
  /// Handles the state transitions:
  /// - Preparation → Work (round 1)
  /// - Work → Rest
  /// - Rest → Work (next round)
  /// - Final rest → Completed
  void _advanceInterval() {
    if (_config == null) return;
    
    final currentInterval = state.currentInterval;
    final currentRound = state.currentRound;
    final totalRounds = _config!.rounds;
    
    // Determine what comes next based on current interval
    if (currentInterval.isPreparation) {
      // Prep → Work (Round 1)
      print('[TimerNotifier] Prep complete → Starting Work (Round 1)');
      _transitionTo(
        interval: IntervalType.work,
        duration: _config!.workDuration,
        round: 1,
      );
    } 
    else if (currentInterval.isWork) {
      // Work → Rest (same round)
      print('[TimerNotifier] Work complete → Starting Rest (Round $currentRound)');
      _transitionTo(
        interval: IntervalType.rest,
        duration: _config!.restDuration,
        round: currentRound,
      );
    } 
    else if (currentInterval.isRest) {
      // Rest → Check if more rounds remain
      if (currentRound < totalRounds) {
        // More rounds → Start next work interval
        final nextRound = currentRound + 1;
        print('[TimerNotifier] Rest complete → Starting Work (Round $nextRound)');
        _transitionTo(
          interval: IntervalType.work,
          duration: _config!.workDuration,
          round: nextRound,
        );
      } else {
        // All rounds complete → Workout finished!
        print('[TimerNotifier] All rounds complete → Workout finished!');
        _completeWorkout();
      }
    }
  }
  
  /// Transitions to a new interval
  /// 
  /// Updates the state with new interval type, duration, and round.
  /// Increments elapsed time by 1 second (for the tick that triggered this).
  /// Plays appropriate sound for the new interval.
  void _transitionTo({
    required IntervalType interval,
    required int duration,
    required int round,
  }) {
    // Play appropriate sound for the new interval
    if (interval.isPreparation) {
      _audioService?.playPrepSound();
    } else if (interval.isWork) {
      _audioService?.playWorkSound();
    } else if (interval.isRest) {
      _audioService?.playRestSound();
    }
    
    state = state.copyWith(
      currentInterval: interval,
      remainingSeconds: duration,
      currentRound: round,
      totalElapsedSeconds: state.totalElapsedSeconds + 1,
    );
  }
  
  /// Completes the workout
  /// 
  /// Stops the timer and sets state to completed.
  /// Plays completion sound.
  void _completeWorkout() {
    // Cancel timer
    _timer?.cancel();
    _timer = null;
    
    // Play completion sound
    _audioService?.playCompleteSound();
    
    // Set to completed state
    state = TimerState.completed(
      totalElapsedSeconds: state.totalElapsedSeconds + 1,
    );
    
    print('[TimerNotifier] Workout completed in ${state.totalElapsedSeconds}s');
  }
  
  // ============================================
  // Lifecycle Management
  // ============================================
  
  /// Clean up when provider is disposed
  /// 
  /// Cancels any running timers to prevent memory leaks.
  @override
  void dispose() {
    print('[TimerNotifier] Disposing - cancelling timer');
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
