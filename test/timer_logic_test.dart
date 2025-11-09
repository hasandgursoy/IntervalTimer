import 'package:flutter_test/flutter_test.dart';
import 'package:interval_timer/core/constants/app_constants.dart';
import 'package:interval_timer/features/timer/domain/entities/interval_config.dart';
import 'package:interval_timer/features/timer/domain/entities/interval_type.dart';
import 'package:interval_timer/features/timer/domain/entities/timer_state.dart';
import 'package:interval_timer/features/timer/domain/entities/timer_status.dart';
import 'package:interval_timer/features/timer/presentation/providers/timer_provider.dart';

/// Unit tests for timer domain models and logic
/// 
/// These tests verify the core business logic without UI dependencies.
void main() {
  group('IntervalConfig', () {
    test('creates config with default values', () {
      const config = IntervalConfig();
      
      expect(config.workDuration, AppConstants.defaultWorkDuration);
      expect(config.restDuration, AppConstants.defaultRestDuration);
      expect(config.rounds, AppConstants.defaultRounds);
      expect(config.preparationTime, AppConstants.defaultPrepDuration);
    });
    
    test('creates config with custom values', () {
      const config = IntervalConfig(
        workDuration: 20,
        restDuration: 10,
        rounds: 8,
        preparationTime: 10,
      );
      
      expect(config.workDuration, 20);
      expect(config.restDuration, 10);
      expect(config.rounds, 8);
      expect(config.preparationTime, 10);
    });
    
    test('validates config correctly', () {
      const validConfig = IntervalConfig(
        workDuration: 30,
        restDuration: 15,
        rounds: 5,
        preparationTime: 5,
      );
      
      expect(validConfig.isValid, true);
    });
    
    test('calculates total duration correctly', () {
      const config = IntervalConfig(
        workDuration: 30,
        restDuration: 10,
        rounds: 8,
        preparationTime: 5,
      );
      
      // Formula: prep + (work + rest) × rounds
      // 5 + (30 + 10) × 8 = 5 + 320 = 325 seconds
      expect(config.totalDuration, 325);
    });
    
    test('calculates workout duration correctly', () {
      const config = IntervalConfig(
        workDuration: 30,
        restDuration: 10,
        rounds: 8,
        preparationTime: 5,
      );
      
      // Formula: (work + rest) × rounds
      // (30 + 10) × 8 = 320 seconds
      expect(config.workoutDuration, 320);
    });
    
    test('calculates total intervals correctly', () {
      const config = IntervalConfig(
        workDuration: 30,
        restDuration: 10,
        rounds: 8,
        preparationTime: 5,
      );
      
      // 1 prep + (8 × 2) work/rest = 17 intervals
      expect(config.totalIntervals, 17);
    });
    
    test('calculates total intervals without prep', () {
      const config = IntervalConfig(
        workDuration: 30,
        restDuration: 10,
        rounds: 8,
        preparationTime: 0,
      );
      
      // 0 prep + (8 × 2) work/rest = 16 intervals
      expect(config.totalIntervals, 16);
    });
    
    test('copyWith creates new instance with updated values', () {
      const config1 = IntervalConfig(rounds: 5);
      final config2 = config1.copyWith(rounds: 10);
      
      expect(config1.rounds, 5);
      expect(config2.rounds, 10);
      expect(config1.workDuration, config2.workDuration); // Unchanged
    });
    
    test('equality works correctly', () {
      const config1 = IntervalConfig(
        workDuration: 30,
        restDuration: 10,
        rounds: 8,
      );
      const config2 = IntervalConfig(
        workDuration: 30,
        restDuration: 10,
        rounds: 8,
      );
      const config3 = IntervalConfig(
        workDuration: 20,
        restDuration: 10,
        rounds: 8,
      );
      
      expect(config1, config2);
      expect(config1 == config3, false);
    });
  });
  
  group('IntervalType', () {
    test('has correct display names', () {
      expect(IntervalType.preparation.displayName, 'PREP');
      expect(IntervalType.work.displayName, 'WORK');
      expect(IntervalType.rest.displayName, 'REST');
    });
    
    test('type checking methods work', () {
      expect(IntervalType.work.isWork, true);
      expect(IntervalType.work.isRest, false);
      expect(IntervalType.rest.isRest, true);
      expect(IntervalType.preparation.isPreparation, true);
    });
  });
  
  group('TimerStatus', () {
    test('state checking methods work', () {
      expect(TimerStatus.ready.isReady, true);
      expect(TimerStatus.running.isRunning, true);
      expect(TimerStatus.paused.isPaused, true);
      expect(TimerStatus.completed.isCompleted, true);
    });
    
    test('action validation works', () {
      expect(TimerStatus.ready.canStart, true);
      expect(TimerStatus.ready.canPause, false);
      
      expect(TimerStatus.running.canPause, true);
      expect(TimerStatus.running.canStart, false);
      
      expect(TimerStatus.paused.canResume, true);
      expect(TimerStatus.paused.canStart, false);
    });
  });
  
  group('TimerState', () {
    test('creates initial state with prep', () {
      final state = TimerState.initial(preparationTime: 5);
      
      expect(state.status, TimerStatus.ready);
      expect(state.currentRound, 1);
      expect(state.currentInterval, IntervalType.preparation);
      expect(state.remainingSeconds, 5);
      expect(state.totalElapsedSeconds, 0);
    });
    
    test('creates initial state without prep', () {
      final state = TimerState.initial(preparationTime: 0);
      
      expect(state.status, TimerStatus.ready);
      expect(state.currentInterval, IntervalType.work);
    });
    
    test('creates completed state', () {
      final state = TimerState.completed(totalElapsedSeconds: 325);
      
      expect(state.status, TimerStatus.completed);
      expect(state.totalElapsedSeconds, 325);
      expect(state.remainingSeconds, 0);
    });
    
    test('copyWith creates new instance', () {
      final state1 = TimerState.initial(preparationTime: 5);
      final state2 = state1.copyWith(
        remainingSeconds: 4,
        totalElapsedSeconds: 1,
      );
      
      expect(state1.remainingSeconds, 5);
      expect(state1.totalElapsedSeconds, 0);
      expect(state2.remainingSeconds, 4);
      expect(state2.totalElapsedSeconds, 1);
    });
    
    test('helper methods work correctly', () {
      final prepState = TimerState.initial(preparationTime: 5);
      expect(prepState.isPreparation, true);
      expect(prepState.canStart, true);
      
      final workState = prepState.copyWith(
        currentInterval: IntervalType.work,
        status: TimerStatus.running,
      );
      expect(workState.isWork, true);
      expect(workState.canPause, true);
    });
  });
  
  group('TimerNotifier', () {
    test('initializes with ready state', () {
      final notifier = TimerNotifier(null);
      
      expect(notifier.state.status, TimerStatus.ready);
    });
    
    test('initialize sets up timer with config', () {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(
        workDuration: 20,
        restDuration: 10,
        rounds: 5,
        preparationTime: 5,
      );
      
      notifier.initialize(config);
      
      expect(notifier.state.status, TimerStatus.ready);
      expect(notifier.state.currentInterval, IntervalType.preparation);
      expect(notifier.state.remainingSeconds, 5);
      expect(notifier.state.currentRound, 1);
    });
    
    test('initialize without prep starts at work', () {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(
        workDuration: 20,
        restDuration: 10,
        rounds: 5,
        preparationTime: 0,
      );
      
      notifier.initialize(config);
      
      expect(notifier.state.currentInterval, IntervalType.work);
      expect(notifier.state.remainingSeconds, 20);
    });
    
    test('start changes status to running', () {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig();
      
      notifier.initialize(config);
      notifier.start();
      
      expect(notifier.state.status, TimerStatus.running);
      
      // Clean up
      notifier.dispose();
    });
    
    test('pause changes status to paused', () {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig();
      
      notifier.initialize(config);
      notifier.start();
      notifier.pause();
      
      expect(notifier.state.status, TimerStatus.paused);
      
      notifier.dispose();
    });
    
    test('resume changes status back to running', () {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig();
      
      notifier.initialize(config);
      notifier.start();
      notifier.pause();
      notifier.resume();
      
      expect(notifier.state.status, TimerStatus.running);
      
      notifier.dispose();
    });
    
    test('stop resets to initial state', () {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(preparationTime: 5);
      
      notifier.initialize(config);
      notifier.start();
      notifier.stop();
      
      expect(notifier.state.status, TimerStatus.ready);
      expect(notifier.state.remainingSeconds, 5);
      expect(notifier.state.totalElapsedSeconds, 0);
      
      notifier.dispose();
    });
    
    test('pause preserves remaining seconds', () async {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(
        workDuration: 10,
        restDuration: 5,
        rounds: 2,
        preparationTime: 3,
      );
      
      notifier.initialize(config);
      notifier.start();
      
      // Wait 1 second for timer to tick
      await Future.delayed(const Duration(milliseconds: 1100));
      
      final remainingBeforePause = notifier.state.remainingSeconds;
      notifier.pause();
      
      // Wait another second while paused
      await Future.delayed(const Duration(milliseconds: 1100));
      
      // Should still be same time
      expect(notifier.state.remainingSeconds, remainingBeforePause);
      expect(notifier.state.status, TimerStatus.paused);
      
      notifier.dispose();
    });
    
    test('timer counts down correctly', () async {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(
        workDuration: 5,
        restDuration: 3,
        rounds: 1,
        preparationTime: 3,
      );
      
      notifier.initialize(config);
      expect(notifier.state.remainingSeconds, 3); // Starting prep time
      
      notifier.start();
      
      // Wait for 2 ticks (2 seconds)
      await Future.delayed(const Duration(milliseconds: 2200));
      
      // Should have counted down by ~2 seconds
      expect(notifier.state.remainingSeconds, lessThanOrEqualTo(1));
      expect(notifier.state.totalElapsedSeconds, greaterThanOrEqualTo(2));
      
      notifier.dispose();
    });
    
    test('preparation transitions to work', () async {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(
        workDuration: 10,
        restDuration: 5,
        rounds: 2,
        preparationTime: 2, // Short prep for faster test
      );
      
      notifier.initialize(config);
      expect(notifier.state.currentInterval, IntervalType.preparation);
      expect(notifier.state.remainingSeconds, 2);
      
      notifier.start();
      
      // Wait for prep to complete (2 seconds + buffer)
      await Future.delayed(const Duration(milliseconds: 2500));
      
      // Should now be in work interval
      expect(notifier.state.currentInterval, IntervalType.work);
      expect(notifier.state.currentRound, 1);
      expect(notifier.state.remainingSeconds, lessThanOrEqualTo(10));
      
      notifier.dispose();
    });
    
    test('work transitions to rest', () async {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(
        workDuration: 2, // Short for faster test
        restDuration: 5,
        rounds: 2,
        preparationTime: 0, // Skip prep
      );
      
      notifier.initialize(config);
      expect(notifier.state.currentInterval, IntervalType.work);
      expect(notifier.state.remainingSeconds, 2);
      
      notifier.start();
      
      // Wait for work to complete (2 seconds + buffer)
      await Future.delayed(const Duration(milliseconds: 2500));
      
      // Should now be in rest interval
      expect(notifier.state.currentInterval, IntervalType.rest);
      expect(notifier.state.currentRound, 1);
      
      notifier.dispose();
    });
    
    test('rest transitions to next round work', () async {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(
        workDuration: 2,
        restDuration: 2, // Short for faster test
        rounds: 3,
        preparationTime: 0,
      );
      
      notifier.initialize(config);
      notifier.start();
      
      // Wait for first work + rest to complete (4 seconds + buffer)
      await Future.delayed(const Duration(milliseconds: 4500));
      
      // Should be in round 2, work interval
      expect(notifier.state.currentRound, 2);
      expect(notifier.state.currentInterval, IntervalType.work);
      
      notifier.dispose();
    });
    
    test('workout completes after all rounds', () async {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(
        workDuration: 1,
        restDuration: 1,
        rounds: 2, // 2 rounds = 4 seconds total
        preparationTime: 0,
      );
      
      notifier.initialize(config);
      notifier.start();
      
      // Wait for entire workout (4 seconds + buffer)
      await Future.delayed(const Duration(milliseconds: 4500));
      
      // Should be completed
      expect(notifier.state.status, TimerStatus.completed);
      expect(notifier.state.remainingSeconds, 0);
      
      notifier.dispose();
    });
    
    test('reset returns to initial configuration', () {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig(
        workDuration: 20,
        restDuration: 10,
        rounds: 5,
        preparationTime: 5,
      );
      
      notifier.initialize(config);
      notifier.start();
      
      // Modify state by pausing
      notifier.pause();
      
      // Reset should return to initial
      notifier.reset();
      
      expect(notifier.state.status, TimerStatus.ready);
      expect(notifier.state.currentRound, 1);
      expect(notifier.state.currentInterval, IntervalType.preparation);
      expect(notifier.state.remainingSeconds, 5);
      expect(notifier.state.totalElapsedSeconds, 0);
      
      notifier.dispose();
    });
    
    test('cannot start without initialization', () {
      final notifier = TimerNotifier(null);
      
      expect(() => notifier.start(), throwsStateError);
      
      notifier.dispose();
    });
    
    test('cannot pause when not running', () {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig();
      
      notifier.initialize(config);
      notifier.pause(); // Try to pause while ready
      
      // Should still be in ready state (pause ignored)
      expect(notifier.state.status, TimerStatus.ready);
      
      notifier.dispose();
    });
    
    test('cannot resume when not paused', () {
      final notifier = TimerNotifier(null);
      const config = IntervalConfig();
      
      notifier.initialize(config);
      notifier.resume(); // Try to resume while ready
      
      // Should still be in ready state (resume ignored)
      expect(notifier.state.status, TimerStatus.ready);
      
      notifier.dispose();
    });
  });
}
