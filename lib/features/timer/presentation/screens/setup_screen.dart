import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/core/constants/app_constants.dart';
import 'package:interval_timer/core/constants/app_sizes.dart';
import 'package:interval_timer/core/utils/responsive_helper.dart';
import 'package:interval_timer/features/timer/domain/entities/interval_config.dart';
import 'package:interval_timer/features/timer/domain/entities/workout_preset.dart';
import 'package:interval_timer/features/timer/presentation/providers/config_provider.dart';
import 'package:interval_timer/features/timer/presentation/providers/preset_provider.dart';
import 'package:interval_timer/features/timer/presentation/providers/timer_provider.dart';
import 'package:interval_timer/features/timer/presentation/screens/presets_screen.dart';
import 'package:interval_timer/features/timer/presentation/screens/settings_screen.dart';
import 'package:interval_timer/features/timer/presentation/screens/timer_screen.dart';

/// Setup screen where users configure their workout
/// 
/// Allows users to set work/rest durations, rounds, and preparation time.
/// Shows a preview of total workout duration.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  // Text controllers for input fields
  late TextEditingController _workController;
  late TextEditingController _restController;
  late TextEditingController _roundsController;
  late TextEditingController _prepController;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with default values
    _workController = TextEditingController(
      text: AppConstants.defaultWorkDuration.toString(),
    );
    _restController = TextEditingController(
      text: AppConstants.defaultRestDuration.toString(),
    );
    _roundsController = TextEditingController(
      text: AppConstants.defaultRounds.toString(),
    );
    _prepController = TextEditingController(
      text: AppConstants.defaultPrepDuration.toString(),
    );
  }

  @override
  void dispose() {
    _workController.dispose();
    _restController.dispose();
    _roundsController.dispose();
    _prepController.dispose();
    super.dispose();
  }

  /// Parse integer from text field, return default if invalid
  int _parseValue(String text, int defaultValue) {
    final value = int.tryParse(text);
    return value ?? defaultValue;
  }

  /// Calculate total workout duration from current inputs
  int _calculateTotalDuration() {
    final work = _parseValue(_workController.text, AppConstants.defaultWorkDuration);
    final rest = _parseValue(_restController.text, AppConstants.defaultRestDuration);
    final rounds = _parseValue(_roundsController.text, AppConstants.defaultRounds);
    final prep = _parseValue(_prepController.text, AppConstants.defaultPrepDuration);
    
    return prep + ((work + rest) * rounds);
  }

  /// Format seconds to MM:SS format
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Start workout with current configuration
  void _startWorkout() {
    final work = _parseValue(_workController.text, AppConstants.defaultWorkDuration);
    final rest = _parseValue(_restController.text, AppConstants.defaultRestDuration);
    final rounds = _parseValue(_roundsController.text, AppConstants.defaultRounds);
    final prep = _parseValue(_prepController.text, AppConstants.defaultPrepDuration);

    // Validate values
    if (work < AppConstants.minIntervalDuration || work > AppConstants.maxIntervalDuration) {
      _showError('Work duration must be between ${AppConstants.minIntervalDuration} and ${AppConstants.maxIntervalDuration} seconds');
      return;
    }
    if (rest < AppConstants.minIntervalDuration || rest > AppConstants.maxIntervalDuration) {
      _showError('Rest duration must be between ${AppConstants.minIntervalDuration} and ${AppConstants.maxIntervalDuration} seconds');
      return;
    }
    if (rounds < AppConstants.minRounds || rounds > AppConstants.maxRounds) {
      _showError('Rounds must be between ${AppConstants.minRounds} and ${AppConstants.maxRounds}');
      return;
    }

    // Create config
    final config = IntervalConfig(
      workDuration: work,
      restDuration: rest,
      rounds: rounds,
      preparationTime: prep,
    );

    // Save to provider
    ref.read(configProvider.notifier).state = config;

    // Initialize timer
    ref.read(timerProvider.notifier).initialize(config);

    // Navigate to timer screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TimerScreen(),
      ),
    );
  }

  /// Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktopOrTablet = !ResponsiveHelper.isMobile(context);
    final contentWidth = ResponsiveHelper.getContentWidth(context);
    final verticalSpacing = ResponsiveHelper.getVerticalSpacing(context, AppSizes.paddingLarge);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interval Timer Setup',
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
          ),
        ),
        actions: [
          // Presets button
          IconButton(
            icon: Icon(
              Icons.bookmark,
              size: ResponsiveHelper.isMobile(context) ? AppSizes.iconMedium : AppSizes.iconLarge,
            ),
            tooltip: 'Presets',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PresetsScreen(),
                ),
              );
            },
          ),
          // Settings button
          IconButton(
            icon: Icon(
              Icons.settings,
              size: ResponsiveHelper.isMobile(context) ? AppSizes.iconMedium : AppSizes.iconLarge,
            ),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktopOrTablet ? contentWidth : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              // Header
              // Text(
              //   'Configure Your Workout',
              //   style: Theme.of(context).textTheme.headlineMedium,
              //   textAlign: TextAlign.center,
              // ),
              // const SizedBox(height: 8),
              // Text(
              //   'Set your intervals and get ready to sweat!',
              //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //     color: Colors.grey[600],
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              
              // const SizedBox(height: AppConstants.largePadding * 2),
              
              // Work Duration
              _buildInputField(
                controller: _workController,
                label: 'Work Duration',
                hint: 'Seconds of exercise',
                icon: Icons.fitness_center,
                color: AppConstants.workIntervalColor,
              ),
              
              SizedBox(height: verticalSpacing),
              
              // Rest Duration
              _buildInputField(
                controller: _restController,
                label: 'Rest Duration',
                hint: 'Seconds of rest',
                icon: Icons.self_improvement,
                color: AppConstants.restIntervalColor,
              ),
              
              SizedBox(height: verticalSpacing),
              
              // Number of Rounds
              _buildInputField(
                controller: _roundsController,
                label: 'Number of Rounds',
                hint: 'Total rounds',
                icon: Icons.repeat,
                color: Colors.purple,
              ),
              
              SizedBox(height: verticalSpacing),
              
              // Preparation Time
              _buildInputField(
                controller: _prepController,
                label: 'Preparation Time',
                hint: 'Get ready countdown',
                icon: Icons.timer,
                color: AppConstants.prepIntervalColor,
              ),
              
              SizedBox(height: verticalSpacing * 2),
              
              // Total Duration Preview
              Container(
                padding: const EdgeInsets.all(AppConstants.largePadding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Workout Time',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDuration(_calculateTotalDuration()),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_calculateTotalDuration()} seconds',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: verticalSpacing * 2),
              
              // Start Workout Button
              ElevatedButton(
                onPressed: _startWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.workIntervalColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.play_arrow, size: 32),
                    SizedBox(width: 12),
                    Text(
                      'START WORKOUT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Save as Preset button
              OutlinedButton.icon(
                onPressed: _saveAsPreset,
                icon: const Icon(Icons.bookmark_add),
                label: const Text('SAVE AS PRESET'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: AppConstants.workIntervalColor,
                    width: 2,
                  ),
                  foregroundColor: AppConstants.workIntervalColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Save current configuration as a preset
  Future<void> _saveAsPreset() async {
    final work = _parseValue(_workController.text, AppConstants.defaultWorkDuration);
    final rest = _parseValue(_restController.text, AppConstants.defaultRestDuration);
    final rounds = _parseValue(_roundsController.text, AppConstants.defaultRounds);
    final prep = _parseValue(_prepController.text, AppConstants.defaultPrepDuration);

    // Create config
    final config = IntervalConfig(
      workDuration: work,
      restDuration: rest,
      rounds: rounds,
      preparationTime: prep,
    );

    // Show dialog to enter preset name
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _SavePresetDialog(),
    );

    if (name == null || name.isEmpty) {
      return; // User cancelled
    }

    // Create preset
    final preset = WorkoutPreset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      config: config,
      createdAt: DateTime.now(),
    );

    // Save preset
    final success = await ref.read(presetProvider.notifier).addPreset(preset);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Preset "$name" saved!'
                : 'Failed to save preset. Name may already exist.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  /// Build input field widget
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.maxInputFieldWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: ResponsiveHelper.isMobile(context) ? AppSizes.iconSmall : AppSizes.iconMedium,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: ResponsiveHelper.getButtonHeight(context),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                ),
                suffixText: label.contains('Round') ? 'rounds' : 'seconds',
                suffixStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeSmall),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.responsivePadding(context, AppSizes.paddingMedium),
                  vertical: ResponsiveHelper.responsivePadding(context, AppSizes.paddingSmall),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  borderSide: BorderSide(color: color.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  borderSide: BorderSide(color: color.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  borderSide: BorderSide(color: color, width: 2),
                ),
              ),
              onChanged: (value) {
                // Rebuild to update total duration
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog for saving a preset
class _SavePresetDialog extends StatefulWidget {
  @override
  State<_SavePresetDialog> createState() => _SavePresetDialogState();
}

class _SavePresetDialogState extends State<_SavePresetDialog> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Preset'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter a name for this workout preset:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Preset Name',
                hintText: 'e.g., My Morning Workout',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.bookmark),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                if (value.trim().length < 3) {
                  return 'Name must be at least 3 characters';
                }
                if (value.trim().length > 30) {
                  return 'Name must be less than 30 characters';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
              maxLength: 30,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_nameController.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.workIntervalColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
