import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/core/constants/app_constants.dart';
import 'package:interval_timer/features/timer/domain/entities/interval_config.dart';

/// Provider for the workout configuration
/// 
/// This holds the user's interval settings (work/rest durations, rounds, etc.)
/// The UI can read and modify this before starting a workout.
/// 
/// Usage:
/// ```dart
/// // Read config
/// final config = ref.watch(configProvider);
/// 
/// // Update config
/// ref.read(configProvider.notifier).state = newConfig;
/// ```
final configProvider = StateProvider<IntervalConfig>((ref) {
  // Initialize with default values from app constants
  return const IntervalConfig(
    workDuration: AppConstants.defaultWorkDuration,
    restDuration: AppConstants.defaultRestDuration,
    rounds: AppConstants.defaultRounds,
    preparationTime: AppConstants.defaultPrepDuration,
  );
});
