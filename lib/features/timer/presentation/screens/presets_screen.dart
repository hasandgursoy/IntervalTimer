import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/core/constants/app_constants.dart';
import 'package:interval_timer/core/constants/app_sizes.dart';
import 'package:interval_timer/core/utils/responsive_helper.dart';
import 'package:interval_timer/features/timer/domain/entities/workout_preset.dart';
import 'package:interval_timer/features/timer/presentation/providers/config_provider.dart';
import 'package:interval_timer/features/timer/presentation/providers/preset_provider.dart';
import 'package:interval_timer/features/timer/presentation/providers/timer_provider.dart';
import 'package:interval_timer/features/timer/presentation/screens/timer_screen.dart';

/// Screen displaying saved workout presets
/// 
/// Shows default presets and user-created presets.
/// Users can load presets to start workouts or delete custom presets.
class PresetsScreen extends ConsumerWidget {
  const PresetsScreen({super.key});

  /// Format duration to readable string
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    }
    return '${seconds}s';
  }

  /// Load preset and start workout
  void _loadPreset(BuildContext context, WidgetRef ref, WorkoutPreset preset) {
    // Save config
    ref.read(configProvider.notifier).state = preset.config;
    
    // Initialize timer
    ref.read(timerProvider.notifier).initialize(preset.config);
    
    // Navigate to timer screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TimerScreen(),
      ),
    );
  }

  /// Delete preset with confirmation
  Future<void> _deletePreset(
    BuildContext context,
    WidgetRef ref,
    WorkoutPreset preset,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Preset?'),
        content: Text(
          'Are you sure you want to delete "${preset.name}"? This cannot be undone.',
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
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref.read(presetProvider.notifier).deletePreset(preset.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Deleted "${preset.name}"'
                  : 'Failed to delete preset',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetsAsync = ref.watch(presetProvider);
    final isMobile = ResponsiveHelper.isMobile(context);
    final screenPadding = ResponsiveHelper.getScreenPadding(context);
    final crossAxisCount = ResponsiveHelper.getGridColumnCount(context, desktopColumns: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout Presets',
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
          ),
        ),
      ),
      body: SafeArea(
        child: presetsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: screenPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: ResponsiveHelper.isMobile(context) ? 48 : 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading presets',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeSmall),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(presetProvider.notifier).loadPresets();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (presets) {
            if (presets.isEmpty) {
              return Center(
                child: Padding(
                  padding: screenPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: ResponsiveHelper.isMobile(context) ? 48 : 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No presets yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first workout preset!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Separate default and custom presets
            final defaultPresets = presets.where((p) => p.isDefault).toList();
            final customPresets = presets.where((p) => !p.isDefault).toList();

            if (isMobile) {
              // Use ListView for mobile
              return ListView(
                padding: screenPadding,
                children: [
                  // Default presets section
                  if (defaultPresets.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: 12,
                      ),
                      child: Text(
                        'Default Presets',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                        ),
                      ),
                ),
                ...defaultPresets.map((preset) => _buildPresetCard(
                  context,
                  ref,
                  preset,
                )),
                const SizedBox(height: AppConstants.largePadding),
              ],

              // Custom presets section
              if (customPresets.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    bottom: 12,
                  ),
                  child: Text(
                    'My Presets',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                ...customPresets.map((preset) => _buildPresetCard(
                  context,
                  ref,
                  preset,
                )),
              ],
            ],
          );
        } else {
          // Use GridView for tablet/desktop
          return Padding(
            padding: screenPadding,
            child: CustomScrollView(
              slivers: [
                // Default presets section
                if (defaultPresets.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: 12,
                      ),
                      child: Text(
                        'Default Presets',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                        ),
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSizes.gridSpacing,
                      mainAxisSpacing: AppSizes.gridRunSpacing,
                      childAspectRatio: 1.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPresetCard(
                        context,
                        ref,
                        defaultPresets[index],
                      ),
                      childCount: defaultPresets.length,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.largePadding),
                  ),
                ],

                // Custom presets section
                if (customPresets.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: 12,
                      ),
                      child: Text(
                        'My Presets',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                        ),
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSizes.gridSpacing,
                      mainAxisSpacing: AppSizes.gridRunSpacing,
                      childAspectRatio: 1.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPresetCard(
                        context,
                        ref,
                        customPresets[index],
                      ),
                      childCount: customPresets.length,
                    ),
                  ),
                ],
              ],
            ),
          );
        }
      },
    ),
      ),
    );
  }

  /// Build preset card widget
  Widget _buildPresetCard(
    BuildContext context,
    WidgetRef ref,
    WorkoutPreset preset,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final cardPadding = ResponsiveHelper.getCardPadding(context);
    
    return Card(
      margin: EdgeInsets.only(bottom: isMobile ? AppConstants.defaultPadding : 0),
      elevation: AppSizes.cardElevation,
      child: InkWell(
        onTap: () => _loadPreset(context, ref, preset),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with name and delete button
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          preset.isDefault
                              ? Icons.star
                              : Icons.fitness_center,
                          color: preset.isDefault
                              ? Colors.amber
                              : AppConstants.workIntervalColor,
                          size: ResponsiveHelper.responsiveFontSize(context, AppSizes.iconMedium),
                        ),
                        SizedBox(width: ResponsiveHelper.responsivePadding(context, AppSizes.paddingSmall)),
                        Expanded(
                          child: Text(
                            preset.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!preset.isDefault)
                    SizedBox(
                      width: AppSizes.minTouchTarget,
                      height: AppSizes.minTouchTarget,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        onPressed: () => _deletePreset(context, ref, preset),
                        tooltip: 'Delete preset',
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Workout details
              Wrap(
                spacing: ResponsiveHelper.responsivePadding(context, 8),
                runSpacing: ResponsiveHelper.responsivePadding(context, 4),
                children: [
                  _buildDetailChip(
                    icon: Icons.fitness_center,
                    label: 'Work',
                    value: '${preset.config.workDuration}s',
                    color: AppConstants.workIntervalColor,
                  ),
                  _buildDetailChip(
                    icon: Icons.self_improvement,
                    label: 'Rest',
                    value: '${preset.config.restDuration}s',
                    color: AppConstants.restIntervalColor,
                  ),
                  _buildDetailChip(
                    icon: Icons.repeat,
                    label: 'Rounds',
                    value: '${preset.config.rounds}',
                    color: Colors.purple,
                  ),
                ],
              ),
              
              SizedBox(height: ResponsiveHelper.responsivePadding(context, 12)),
              
              // Total duration and load button
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: ResponsiveHelper.responsiveFontSize(context, AppSizes.iconSmall),
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Total: ${_formatDuration(preset.config.totalDuration)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeSmall),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getButtonHeight(context),
                    child: ElevatedButton.icon(
                      onPressed: () => _loadPreset(context, ref, preset),
                      icon: const Icon(
                        Icons.play_arrow,
                        size: 18,
                      ),
                      label: Text(
                        'START',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeSmall),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.workIntervalColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build detail chip widget
  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
