import 'package:interval_timer/features/timer/domain/entities/interval_config.dart';

/// Represents a saved workout preset
/// 
/// A preset contains a complete workout configuration that can be:
/// - Saved for quick access
/// - Loaded to start a workout
/// - Shared or exported
/// - Modified and re-saved
class WorkoutPreset {
  /// Unique identifier for this preset
  final String id;
  
  /// Display name of the preset (e.g., "Tabata", "My Morning Workout")
  final String name;
  
  /// The workout configuration (work/rest/rounds/prep durations)
  final IntervalConfig config;
  
  /// When this preset was created
  final DateTime createdAt;
  
  /// Whether this is a built-in default preset (cannot be deleted)
  final bool isDefault;
  
  /// Creates a workout preset
  const WorkoutPreset({
    required this.id,
    required this.name,
    required this.config,
    required this.createdAt,
    this.isDefault = false,
  });
  
  /// Creates a copy with some fields updated
  WorkoutPreset copyWith({
    String? id,
    String? name,
    IntervalConfig? config,
    DateTime? createdAt,
    bool? isDefault,
  }) {
    return WorkoutPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      config: config ?? this.config,
      createdAt: createdAt ?? this.createdAt,
      isDefault: isDefault ?? this.isDefault,
    );
  }
  
  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'config': {
        'workDuration': config.workDuration,
        'restDuration': config.restDuration,
        'rounds': config.rounds,
        'preparationTime': config.preparationTime,
      },
      'createdAt': createdAt.toIso8601String(),
      'isDefault': isDefault,
    };
  }
  
  /// Create from JSON
  factory WorkoutPreset.fromJson(Map<String, dynamic> json) {
    return WorkoutPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      config: IntervalConfig(
        workDuration: json['config']['workDuration'] as int,
        restDuration: json['config']['restDuration'] as int,
        rounds: json['config']['rounds'] as int,
        preparationTime: json['config']['preparationTime'] as int,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }
  
  /// Default Tabata preset (20s work, 10s rest, 8 rounds)
  static WorkoutPreset get tabata => WorkoutPreset(
    id: 'default_tabata',
    name: 'Tabata',
    config: const IntervalConfig(
      workDuration: 20,
      restDuration: 10,
      rounds: 8,
      preparationTime: 5,
    ),
    createdAt: DateTime.now(),
    isDefault: true,
  );
  
  /// Default HIIT preset (30s work, 15s rest, 10 rounds)
  static WorkoutPreset get hiit => WorkoutPreset(
    id: 'default_hiit',
    name: 'HIIT',
    config: const IntervalConfig(
      workDuration: 30,
      restDuration: 15,
      rounds: 10,
      preparationTime: 10,
    ),
    createdAt: DateTime.now(),
    isDefault: true,
  );
  
  /// Default Quick preset (45s work, 15s rest, 5 rounds)
  static WorkoutPreset get quick => WorkoutPreset(
    id: 'default_quick',
    name: 'Quick Workout',
    config: const IntervalConfig(
      workDuration: 45,
      restDuration: 15,
      rounds: 5,
      preparationTime: 5,
    ),
    createdAt: DateTime.now(),
    isDefault: true,
  );
  
  @override
  String toString() {
    return 'WorkoutPreset(name: $name, work: ${config.workDuration}s, '
           'rest: ${config.restDuration}s, rounds: ${config.rounds})';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is WorkoutPreset &&
        other.id == id &&
        other.name == name &&
        other.config == config &&
        other.createdAt == createdAt &&
        other.isDefault == isDefault;
  }
  
  @override
  int get hashCode {
    return Object.hash(id, name, config, createdAt, isDefault);
  }
}
