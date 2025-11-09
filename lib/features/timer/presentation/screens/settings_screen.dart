import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/core/constants/app_constants.dart';
import 'package:interval_timer/core/constants/app_sizes.dart';
import 'package:interval_timer/core/services/audio_provider.dart';
import 'package:interval_timer/core/utils/responsive_helper.dart';

/// Settings screen for audio and app preferences
/// 
/// Allows users to:
/// - Enable/disable sound effects
/// - Adjust volume level
/// - Test sounds
/// - Enable/disable haptic feedback
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioEnabled = ref.watch(audioEnabledProvider);
    final audioVolume = ref.watch(audioVolumeProvider);
    final hapticEnabled = ref.watch(hapticEnabledProvider);
    final audioService = ref.read(audioServiceProvider);

    final screenPadding = ResponsiveHelper.getScreenPadding(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final contentWidth = ResponsiveHelper.getContentWidth(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : contentWidth,
            ),
            child: ListView(
              padding: screenPadding,
              children: [
                // Audio Settings Section
                _buildSectionTitle(context, 'Audio Settings'),
                SizedBox(height: ResponsiveHelper.responsivePadding(context, AppSizes.paddingMedium)),
                
                // Enable/Disable Sounds Card
                Card(
                  elevation: AppSizes.cardElevation,
                  child: Padding(
                    padding: ResponsiveHelper.getCardPadding(context),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text(
                            'Enable Sounds',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Play audio cues during workout',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                            ),
                          ),
                          value: audioEnabled,
                          onChanged: (value) {
                            ref.read(audioEnabledProvider.notifier).setEnabled(value);
                          },
                          secondary: Icon(
                            audioEnabled ? Icons.volume_up : Icons.volume_off,
                            color: audioEnabled 
                                ? AppConstants.workIntervalColor 
                                : Colors.grey,
                            size: ResponsiveHelper.responsiveFontSize(context, AppSizes.iconLarge),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: ResponsiveHelper.responsivePadding(context, AppSizes.paddingMedium)),
                
                // Volume Control Card
                Card(
                  elevation: AppSizes.cardElevation,
                  child: Padding(
                    padding: ResponsiveHelper.getCardPadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.volume_down, 
                              color: Colors.grey,
                              size: ResponsiveHelper.responsiveFontSize(context, AppSizes.iconMedium),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Volume',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${(audioVolume * 100).round()}%',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                                fontWeight: FontWeight.bold,
                                color: audioEnabled 
                                    ? AppConstants.workIntervalColor 
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: AppSizes.sliderHeight,
                          child: Slider(
                            value: audioVolume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 20,
                            label: '${(audioVolume * 100).round()}%',
                            onChanged: audioEnabled
                                ? (value) {
                                    ref.read(audioVolumeProvider.notifier).setVolume(value);
                                  }
                                : null,
                          ),
                        ),
                        if (!audioEnabled)
                          Text(
                            'Enable sounds to adjust volume',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeSmall),
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: ResponsiveHelper.responsivePadding(context, AppSizes.paddingMedium)),
                
                // Haptic Feedback Card
                Card(
                  elevation: AppSizes.cardElevation,
                  child: Padding(
                    padding: ResponsiveHelper.getCardPadding(context),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text(
                            'Haptic Feedback',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Vibrate on interval transitions',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                            ),
                          ),
                          value: hapticEnabled,
                          onChanged: (value) {
                            ref.read(hapticEnabledProvider.notifier).setEnabled(value);
                          },
                          secondary: Icon(
                            hapticEnabled ? Icons.vibration : Icons.mobile_off,
                            color: hapticEnabled 
                                ? AppConstants.workIntervalColor 
                                : Colors.grey,
                            size: ResponsiveHelper.responsiveFontSize(context, AppSizes.iconLarge),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: ResponsiveHelper.responsivePadding(context, AppSizes.paddingLarge)),
                
                // Sound Test Section
                _buildSectionTitle(context, 'Test Sounds'),
                SizedBox(height: ResponsiveHelper.responsivePadding(context, AppSizes.paddingMedium)),
                
                Card(
                  elevation: AppSizes.cardElevation,
                  child: Padding(
                    padding: ResponsiveHelper.getCardPadding(context),
                    child: Column(
                      children: [
                        Text(
                          'Preview audio cues for different intervals',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: ResponsiveHelper.responsivePadding(context, AppSizes.paddingMedium)),
                        
                        // Test buttons in a responsive layout
                        Wrap(
                          spacing: ResponsiveHelper.responsivePadding(context, 12),
                          runSpacing: ResponsiveHelper.responsivePadding(context, 12),
                          alignment: WrapAlignment.center,
                          children: [
                            _buildTestButton(
                              context: context,
                              label: 'Start',
                              icon: Icons.play_arrow,
                              color: Colors.green,
                              onPressed: audioEnabled
                                  ? () => audioService.playStartSound()
                                  : null,
                            ),
                            _buildTestButton(
                              context: context,
                              label: 'Work',
                              icon: Icons.fitness_center,
                              color: AppConstants.workIntervalColor,
                              onPressed: audioEnabled
                                  ? () => audioService.playWorkSound()
                                  : null,
                            ),
                            _buildTestButton(
                              context: context,
                              label: 'Rest',
                              icon: Icons.self_improvement,
                              color: AppConstants.restIntervalColor,
                              onPressed: audioEnabled
                                  ? () => audioService.playRestSound()
                                  : null,
                            ),
                            _buildTestButton(
                              context: context,
                              label: 'Complete',
                              icon: Icons.check_circle,
                              color: Colors.blue,
                              onPressed: audioEnabled
                                  ? () => audioService.playCompleteSound()
                                  : null,
                            ),
                          ],
                        ),
                        
                        SizedBox(height: ResponsiveHelper.responsivePadding(context, AppSizes.paddingMedium)),
                        
                        // Test all sounds button
                        SizedBox(
                          width: double.infinity,
                          height: ResponsiveHelper.getButtonHeight(context),
                          child: OutlinedButton.icon(
                            onPressed: audioEnabled
                                ? () => audioService.testAllSounds()
                                : null,
                            icon: const Icon(Icons.hearing),
                            label: Text(
                              'TEST ALL SOUNDS',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: audioEnabled
                                  ? AppConstants.workIntervalColor
                                  : Colors.grey,
                              side: BorderSide(
                                color: audioEnabled
                                    ? AppConstants.workIntervalColor
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: ResponsiveHelper.responsivePadding(context, AppSizes.paddingLarge)),
                
                // App Info Section
                _buildSectionTitle(context, 'About'),
                SizedBox(height: ResponsiveHelper.responsivePadding(context, AppSizes.paddingMedium)),
                
                Card(
                  elevation: AppSizes.cardElevation,
                  child: Padding(
                    padding: ResponsiveHelper.getCardPadding(context),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.info_outline,
                            color: AppConstants.workIntervalColor,
                            size: ResponsiveHelper.responsiveFontSize(context, AppSizes.iconMedium),
                          ),
                          title: Text(
                            'Version',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '1.0.0',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeSmall),
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.developer_mode,
                            color: AppConstants.workIntervalColor,
                            size: ResponsiveHelper.responsiveFontSize(context, AppSizes.iconMedium),
                          ),
                          title: Text(
                            'Developer',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeMedium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Interval Timer App',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeSmall),
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
        ),
      ),
    );
  }

  /// Build section title widget
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
          fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeLarge),
        ),
      ),
    );
  }

  /// Build test button widget
  Widget _buildTestButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: ResponsiveHelper.isMobile(context) 
          ? (MediaQuery.of(context).size.width - 64) / 2 - 6 
          : 120,
      height: ResponsiveHelper.getButtonHeight(context),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: ResponsiveHelper.responsiveFontSize(context, AppSizes.iconSmall),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, AppSizes.fontSizeSmall),
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? color : Colors.grey[300],
          foregroundColor: onPressed != null ? Colors.white : Colors.grey[600],
          elevation: onPressed != null ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
          ),
        ),
      ),
    );
  }
}