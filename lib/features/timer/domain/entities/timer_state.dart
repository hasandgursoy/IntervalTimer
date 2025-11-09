import 'package:interval_timer/features/timer/domain/entities/interval_type.dart';
import 'package:interval_timer/features/timer/domain/entities/timer_status.dart';

/// Represents the current state of the timer during a workout
/// 
/// This class is immutable and represents a snapshot of the timer at a
/// specific moment. Updates to the timer create new TimerState instances.
/// 
/// The timer progresses through:
/// 1. Preparation interval
/// 2. Work interval (round 1)
/// 3. Rest interval (round 1)
/// 4. Work interval (round 2)
/// 5. ...continues for all rounds...
/// 6. Completed
class TimerState {
  /// Current status of the timer (ready, running, paused, completed)
  final TimerStatus status;
  
  /// Current round number (1-based)
  /// Example: Round 3 of 8 rounds
  final int currentRound;
  
  /// Current interval type (preparation, work, or rest)
  final IntervalType currentInterval;
  
  /// Seconds remaining in the current interval
  /// Counts down from interval duration to 0
  /// Example: 25 means 25 seconds left in this interval
  final int remainingSeconds;
  
  /// Total elapsed time in the workout (in seconds)
  /// Starts at 0 and increments every second
  /// Does not include paused time
  final int totalElapsedSeconds;
  
  /// Creates a new timer state
  /// 
  /// All fields are required for complete state representation.
  const TimerState({
    required this.status,
    required this.currentRound,
    required this.currentInterval,
    required this.remainingSeconds,
    required this.totalElapsedSeconds,
  });
  
  /// Creates the initial timer state (ready to start)
  /// 
  /// Used when creating a new workout session.
  /// 
  /// Parameters:
  /// - [preparationTime]: Duration of prep interval (0 if no prep)
  factory TimerState.initial({required int preparationTime}) {
    return TimerState(
      status: TimerStatus.ready,
      currentRound: 1,
      currentInterval: preparationTime > 0 
          ? IntervalType.preparation 
          : IntervalType.work,
      remainingSeconds: preparationTime > 0 
          ? preparationTime 
          : 0, // Will be set properly when starting
      totalElapsedSeconds: 0,
    );
  }
  
  /// Creates a completed timer state
  /// 
  /// Used when workout finishes all rounds.
  factory TimerState.completed({required int totalElapsedSeconds}) {
    return TimerState(
      status: TimerStatus.completed,
      currentRound: 0,
      currentInterval: IntervalType.rest, // Arbitrary, workout is done
      remainingSeconds: 0,
      totalElapsedSeconds: totalElapsedSeconds,
    );
  }
  
  /// Returns true if timer is currently in preparation phase
  bool get isPreparation => currentInterval.isPreparation;
  
  /// Returns true if timer is currently in work phase
  bool get isWork => currentInterval.isWork;
  
  /// Returns true if timer is currently in rest phase
  bool get isRest => currentInterval.isRest;
  
  /// Returns true if timer can be paused (running and not completed)
  bool get canPause => status.canPause;
  
  /// Returns true if timer can be resumed (paused)
  bool get canResume => status.canResume;
  
  /// Returns true if timer can be started (ready)
  bool get canStart => status.canStart;
  
  /// Creates a copy of this state with some fields replaced
  /// 
  /// This is the primary way to update the timer state while
  /// maintaining immutability.
  /// 
  /// Example:
  /// ```dart
  /// final newState = currentState.copyWith(
  ///   remainingSeconds: 29,
  ///   totalElapsedSeconds: currentState.totalElapsedSeconds + 1,
  /// );
  /// ```
  TimerState copyWith({
    TimerStatus? status,
    int? currentRound,
    IntervalType? currentInterval,
    int? remainingSeconds,
    int? totalElapsedSeconds,
  }) {
    return TimerState(
      status: status ?? this.status,
      currentRound: currentRound ?? this.currentRound,
      currentInterval: currentInterval ?? this.currentInterval,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
    );
  }
  
  /// String representation for debugging
  @override
  String toString() {
    return 'TimerState('
        'status: ${status.name}, '
        'round: $currentRound, '
        'interval: ${currentInterval.displayName}, '
        'remaining: ${remainingSeconds}s, '
        'elapsed: ${totalElapsedSeconds}s)';
  }
  
  /// Equality comparison based on all fields
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is TimerState &&
        other.status == status &&
        other.currentRound == currentRound &&
        other.currentInterval == currentInterval &&
        other.remainingSeconds == remainingSeconds &&
        other.totalElapsedSeconds == totalElapsedSeconds;
  }
  
  /// Hash code based on all fields
  @override
  int get hashCode {
    return Object.hash(
      status,
      currentRound,
      currentInterval,
      remainingSeconds,
      totalElapsedSeconds,
    );
  }
}
