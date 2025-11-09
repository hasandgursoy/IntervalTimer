/// Enum representing the type of interval in a workout
/// 
/// Used to distinguish between different phases of the workout:
/// - preparation: Countdown before workout starts (get ready)
/// - work: Active exercise interval
/// - rest: Recovery interval between work periods
enum IntervalType {
  /// Preparation phase before the workout begins
  /// Gives user time to get ready (default: 5 seconds)
  preparation,
  
  /// Active work interval where user exercises
  /// Example: 30 seconds of burpees
  work,
  
  /// Rest interval for recovery between work periods
  /// Example: 10 seconds of rest
  rest,
}

/// Extension methods for IntervalType to provide additional functionality
extension IntervalTypeExtension on IntervalType {
  /// Human-readable name for the interval type
  /// Used for display in UI (e.g., "WORK", "REST", "PREP")
  String get displayName {
    switch (this) {
      case IntervalType.preparation:
        return 'PREP';
      case IntervalType.work:
        return 'WORK';
      case IntervalType.rest:
        return 'REST';
    }
  }
  
  /// Returns true if this is a work interval
  bool get isWork => this == IntervalType.work;
  
  /// Returns true if this is a rest interval
  bool get isRest => this == IntervalType.rest;
  
  /// Returns true if this is a preparation interval
  bool get isPreparation => this == IntervalType.preparation;
}
