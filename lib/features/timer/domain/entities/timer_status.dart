/// Enum representing the current status of the timer
/// 
/// The timer progresses through these states:
/// ready → running → paused → running → ... → completed
enum TimerStatus {
  /// Timer is ready to start but not yet running
  /// Initial state when workout is configured
  ready,
  
  /// Timer is actively counting down
  /// Updates every second until interval completes
  running,
  
  /// Timer is paused by user
  /// Can be resumed to continue from current position
  paused,
  
  /// Workout is complete
  /// All rounds and intervals finished
  completed,
}

/// Extension methods for TimerStatus
extension TimerStatusExtension on TimerStatus {
  /// Returns true if timer is actively running
  bool get isRunning => this == TimerStatus.running;
  
  /// Returns true if timer is paused
  bool get isPaused => this == TimerStatus.paused;
  
  /// Returns true if timer is ready to start
  bool get isReady => this == TimerStatus.ready;
  
  /// Returns true if workout is completed
  bool get isCompleted => this == TimerStatus.completed;
  
  /// Returns true if timer can be paused (only when running)
  bool get canPause => isRunning;
  
  /// Returns true if timer can be resumed (only when paused)
  bool get canResume => isPaused;
  
  /// Returns true if timer can be started (only when ready)
  bool get canStart => isReady;
}
