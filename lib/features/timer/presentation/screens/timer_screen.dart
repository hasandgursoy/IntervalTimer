import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/core/constants/app_constants.dart';
import 'package:interval_timer/core/constants/app_sizes.dart';
import 'package:interval_timer/core/utils/responsive_helper.dart';
import 'package:interval_timer/features/timer/domain/entities/interval_type.dart';
import 'package:interval_timer/features/timer/domain/entities/timer_status.dart';
import 'package:interval_timer/features/timer/presentation/providers/config_provider.dart';
import 'package:interval_timer/features/timer/presentation/providers/timer_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Timer screen displaying the active workout
/// 
/// Shows large countdown timer, current interval, round counter,
/// circular progress indicator, and control buttons.
/// Keeps screen awake during active workout using wakelock.
class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  @override
  void initState() {
    super.initState();
    // Enable wakelock when timer screen is shown
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Always disable wakelock when leaving the screen
    WakelockPlus.disable();
    super.dispose();
  }

  /// Get color for current interval type
  Color _getIntervalColor(IntervalType type) {
    switch (type) {
      case IntervalType.preparation:
        return AppConstants.prepIntervalColor;
      case IntervalType.work:
        return AppConstants.workIntervalColor;
      case IntervalType.rest:
        return AppConstants.restIntervalColor;
    }
  }

  /// Format seconds to MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Show stop confirmation dialog
  Future<bool> _showStopConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Workout?'),
        content: const Text(
          'Are you sure you want to stop the workout? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('STOP'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Handle stop button press
  void _handleStop(BuildContext context) async {
    final confirmed = await _showStopConfirmation(context);
    if (confirmed && context.mounted) {
      ref.read(timerProvider.notifier).stop();
      Navigator.of(context).pop(); // Return to setup screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final config = ref.watch(configProvider);
    
    final intervalColor = _getIntervalColor(timerState.currentInterval);
    final isRunning = timerState.status == TimerStatus.running;
    final isPaused = timerState.status == TimerStatus.paused;
    final isCompleted = timerState.status == TimerStatus.completed;

    // Critical responsive sizing to prevent overflow
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate safe circle size that fits screen
    final availableWidth = screenWidth - 32; // Account for padding
    final circleSize = math.min(availableWidth * 0.7, 280.0);
    
    // Calculate font sizes based on circle size
    final timerFontSize = screenWidth < 400 ? circleSize * 0.25 : circleSize * 0.3;
    final roundFontSize = math.min(screenWidth * 0.045, 18.0);
    final intervalBadgeFontSize = math.min(screenWidth * 0.055, 24.0);
    
    // Get interval duration based on current interval type
    final intervalDuration = timerState.currentInterval == IntervalType.preparation
        ? config.preparationTime
        : timerState.currentInterval == IntervalType.work
            ? config.workDuration
            : config.restDuration;

    // Calculate progress for circular indicator
    final progress = intervalDuration > 0
        ? (intervalDuration - timerState.remainingSeconds) / intervalDuration
        : 0.0;

    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation during workout
        if (isRunning || isPaused) {
          return await _showStopConfirmation(context);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: intervalColor.withOpacity(0.1),
        appBar: AppBar(
          title: const Text('Workout in Progress'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // Hide back button
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                // Top spacing
                const SizedBox(height: 24),
                
                // Round Counter
                Text(
                  'ROUND ${timerState.currentRound} / ${config.rounds}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.grey[700],
                    fontSize: roundFontSize,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Interval Type Label - constrained width
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.6,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: intervalColor,
                        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: intervalColor.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          timerState.currentInterval.displayName.toUpperCase(),
                          style: TextStyle(
                            fontSize: intervalBadgeFontSize,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Circular Progress with Countdown
                SizedBox(
                  width: circleSize,
                  height: circleSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background circle
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                      
                      // Circular progress indicator
                      SizedBox(
                        width: circleSize - 20,
                        height: circleSize - 20,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: screenWidth < 400 ? 8 : 12,
                          backgroundColor: intervalColor.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(intervalColor),
                        ),
                      ),
                      
                      // Countdown text - constrained to fit within circle
                      Positioned.fill(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _formatTime(timerState.remainingSeconds),
                                  style: TextStyle(
                                    fontSize: timerFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: intervalColor,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'seconds',
                                  style: TextStyle(
                                    fontSize: math.min(screenWidth * 0.035, 16.0),
                                    color: Colors.grey[600],
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Workout completed message
                if (isCompleted) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: math.min(screenWidth * 0.15, 64),
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'WORKOUT COMPLETE!',
                            style: TextStyle(
                              fontSize: math.min(screenWidth * 0.06, 24),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Great job! Total time: ${_formatTime(timerState.totalElapsedSeconds)}',
                            style: TextStyle(
                              fontSize: math.min(screenWidth * 0.04, 16),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Control buttons - responsive layout
                if (!isCompleted) ...[
                  Wrap(                    
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 16,
                    children: [
                      // Pause/Resume button
                      if (isRunning || isPaused)
                        _buildControlButton(
                          icon: isRunning ? Icons.pause : Icons.play_arrow,
                          label: isRunning ? 'PAUSE' : 'RESUME',
                          color: isRunning ? Colors.orange : AppConstants.workIntervalColor,
                          onPressed: () {
                            if (isRunning) {
                              timerNotifier.pause();
                            } else {
                              timerNotifier.resume();
                            }
                          },
                        ),
                      
                      // Start button (for ready state)
                      if (timerState.status == TimerStatus.ready)
                        _buildControlButton(
                          icon: Icons.play_arrow,
                          label: 'START',
                          color: AppConstants.workIntervalColor,
                          onPressed: () => timerNotifier.start(),
                        ),
                      
                      // Stop button
                      if (isRunning || isPaused)
                        _buildControlButton(
                          icon: Icons.stop,
                          label: 'STOP',
                          color: Colors.red,
                          onPressed: () => _handleStop(context),
                        ),
                    ],
                  ),
                ] else ...[
                  // Done button (for completed state)
                  SizedBox(
                    height: ResponsiveHelper.getButtonHeight(context),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.workIntervalColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.responsivePadding(context, AppSizes.paddingXLarge),
                          vertical: ResponsiveHelper.responsivePadding(context, AppSizes.paddingMedium),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                        ),
                      ),
                      child: Text(
                        'DONE',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // Elapsed time
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Total Time: ${_formatTime(timerState.totalElapsedSeconds)}',
                      style: TextStyle(
                        fontSize: math.min(screenWidth * 0.04, 16),
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                
                // Bottom margin
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build control button widget
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = math.min(screenWidth * 0.15, 72.0);
    final iconSize = math.min(screenWidth * 0.08, 32.0);
    final fontSize = math.min(screenWidth * 0.035, 14.0);
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.4, // Max 40% of screen width
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
                elevation: 8,
              ),
              child: Icon(icon, size: iconSize),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
