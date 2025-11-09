import 'package:interval_timer/core/constants/app_constants.dart';

/// Configuration for an interval workout
/// 
/// This class defines the structure of a workout with work/rest intervals
/// and multiple rounds. It's immutable to ensure configuration doesn't
/// change during a workout.
/// 
/// Example:
/// ```dart
/// final config = IntervalConfig(
///   workDuration: 30,      // 30 seconds of work
///   restDuration: 10,      // 10 seconds of rest
///   rounds: 8,             // 8 rounds total (Tabata style)
///   preparationTime: 5,    // 5 seconds to get ready
/// );
/// ```
class IntervalConfig {
  /// Duration of work intervals in seconds
  /// This is the active exercise time (e.g., 30 seconds of burpees)
  final int workDuration;
  
  /// Duration of rest intervals in seconds
  /// This is the recovery time between work intervals (e.g., 10 seconds)
  final int restDuration;
  
  /// Number of work/rest cycles to complete
  /// Example: 8 rounds = 8 work intervals + 8 rest intervals
  final int rounds;
  
  /// Preparation time before workout starts in seconds
  /// Gives user time to get ready before first work interval begins
  final int preparationTime;
  
  /// Creates an interval configuration
  /// 
  /// All parameters have default values from AppConstants.
  /// Values are validated on construction.
  /// 
  /// Throws [ArgumentError] if any value is invalid.
  const IntervalConfig({
    this.workDuration = AppConstants.defaultWorkDuration,
    this.restDuration = AppConstants.defaultRestDuration,
    this.rounds = AppConstants.defaultRounds,
    this.preparationTime = AppConstants.defaultPrepDuration,
  }) : assert(workDuration > 0, 'Work duration must be greater than 0'),
       assert(restDuration > 0, 'Rest duration must be greater than 0'),
       assert(rounds > 0, 'Rounds must be greater than 0'),
       assert(preparationTime >= 0, 'Preparation time cannot be negative');
  
  /// Validates the configuration values
  /// 
  /// Returns true if all values are within acceptable ranges.
  /// Uses limits from AppConstants.
  bool get isValid {
    return workDuration >= AppConstants.minIntervalDuration &&
           workDuration <= AppConstants.maxIntervalDuration &&
           restDuration >= AppConstants.minIntervalDuration &&
           restDuration <= AppConstants.maxIntervalDuration &&
           rounds >= AppConstants.minRounds &&
           rounds <= AppConstants.maxRounds &&
           preparationTime >= 0 &&
           preparationTime <= AppConstants.maxIntervalDuration;
  }
  
  /// Calculates total workout duration in seconds
  /// 
  /// Formula: preparation + (work + rest) × rounds
  /// Note: The last rest interval is included in this calculation
  int get totalDuration {
    return preparationTime + ((workDuration + restDuration) * rounds);
  }
  
  /// Calculates total workout duration excluding preparation time
  /// 
  /// Formula: (work + rest) × rounds
  int get workoutDuration {
    return (workDuration + restDuration) * rounds;
  }
  
  /// Total number of intervals in the workout
  /// 
  /// Calculation:
  /// - 1 preparation interval (if prep time > 0)
  /// - rounds × work intervals
  /// - rounds × rest intervals
  int get totalIntervals {
    final prepIntervals = preparationTime > 0 ? 1 : 0;
    return prepIntervals + (rounds * 2); // 2 = work + rest per round
  }
  
  /// Creates a copy of this configuration with some fields replaced
  /// 
  /// This allows creating modified versions while keeping original immutable.
  /// 
  /// Example:
  /// ```dart
  /// final newConfig = config.copyWith(rounds: 10);
  /// ```
  IntervalConfig copyWith({
    int? workDuration,
    int? restDuration,
    int? rounds,
    int? preparationTime,
  }) {
    return IntervalConfig(
      workDuration: workDuration ?? this.workDuration,
      restDuration: restDuration ?? this.restDuration,
      rounds: rounds ?? this.rounds,
      preparationTime: preparationTime ?? this.preparationTime,
    );
  }
  
  /// String representation for debugging
  @override
  String toString() {
    return 'IntervalConfig('
        'work: ${workDuration}s, '
        'rest: ${restDuration}s, '
        'rounds: $rounds, '
        'prep: ${preparationTime}s, '
        'total: ${totalDuration}s)';
  }
  
  /// Equality comparison based on all fields
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is IntervalConfig &&
        other.workDuration == workDuration &&
        other.restDuration == restDuration &&
        other.rounds == rounds &&
        other.preparationTime == preparationTime;
  }
  
  /// Hash code based on all fields
  @override
  int get hashCode {
    return Object.hash(
      workDuration,
      restDuration,
      rounds,
      preparationTime,
    );
  }
}
