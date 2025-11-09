import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/core/services/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for AudioService singleton
/// 
/// Usage:
/// ```dart
/// final audioService = ref.read(audioServiceProvider);
/// await audioService.playWorkSound();
/// ```
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  
  // Load saved preferences
  _loadAudioPreferences(service);
  
  // Cleanup on disposal
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Load audio preferences from SharedPreferences
Future<void> _loadAudioPreferences(AudioService service) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    final isEnabled = prefs.getBool('audio_enabled') ?? true;
    final volume = prefs.getDouble('audio_volume') ?? 0.7;
    final hapticEnabled = prefs.getBool('haptic_enabled') ?? true;
    
    await service.setEnabled(isEnabled);
    await service.setVolume(volume);
    await service.setHapticEnabled(hapticEnabled);
    
    print('[AudioProvider] Loaded preferences: enabled=$isEnabled, volume=$volume, haptic=$hapticEnabled');
  } catch (e) {
    print('[AudioProvider] Error loading preferences: $e');
  }
}

/// Provider for audio enabled state
/// 
/// Used to watch and update the enabled state in the UI.
final audioEnabledProvider = StateNotifierProvider<AudioEnabledNotifier, bool>((ref) {
  return AudioEnabledNotifier(ref);
});

/// Notifier for audio enabled state
class AudioEnabledNotifier extends StateNotifier<bool> {
  final Ref _ref;
  
  AudioEnabledNotifier(this._ref) : super(true) {
    _loadState();
  }
  
  /// Load initial state from preferences
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getBool('audio_enabled') ?? true;
    } catch (e) {
      print('[AudioEnabledNotifier] Error loading state: $e');
    }
  }
  
  /// Toggle audio enabled/disabled
  Future<void> toggle() async {
    state = !state;
    await _saveState();
    await _ref.read(audioServiceProvider).setEnabled(state);
  }
  
  /// Set audio enabled state
  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _saveState();
    await _ref.read(audioServiceProvider).setEnabled(enabled);
  }
  
  /// Save state to preferences
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('audio_enabled', state);
    } catch (e) {
      print('[AudioEnabledNotifier] Error saving state: $e');
    }
  }
}

/// Provider for audio volume
/// 
/// Used to watch and update the volume in the UI.
final audioVolumeProvider = StateNotifierProvider<AudioVolumeNotifier, double>((ref) {
  return AudioVolumeNotifier(ref);
});

/// Notifier for audio volume
class AudioVolumeNotifier extends StateNotifier<double> {
  final Ref _ref;
  
  AudioVolumeNotifier(this._ref) : super(0.7) {
    _loadState();
  }
  
  /// Load initial state from preferences
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getDouble('audio_volume') ?? 0.7;
    } catch (e) {
      print('[AudioVolumeNotifier] Error loading state: $e');
    }
  }
  
  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    state = volume.clamp(0.0, 1.0);
    await _saveState();
    await _ref.read(audioServiceProvider).setVolume(state);
  }
  
  /// Save state to preferences
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('audio_volume', state);
    } catch (e) {
      print('[AudioVolumeNotifier] Error saving state: $e');
    }
  }
}

/// Provider for haptic feedback state
/// 
/// Used to watch and update the haptic feedback state in the UI.
final hapticEnabledProvider = StateNotifierProvider<HapticEnabledNotifier, bool>((ref) {
  return HapticEnabledNotifier(ref);
});

/// Notifier for haptic feedback state
class HapticEnabledNotifier extends StateNotifier<bool> {
  final Ref _ref;
  
  HapticEnabledNotifier(this._ref) : super(true) {
    _loadState();
  }
  
  /// Load initial state from preferences
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getBool('haptic_enabled') ?? true;
    } catch (e) {
      print('[HapticEnabledNotifier] Error loading state: $e');
    }
  }
  
  /// Toggle haptic feedback enabled/disabled
  Future<void> toggle() async {
    state = !state;
    await _saveState();
    await _ref.read(audioServiceProvider).setHapticEnabled(state);
  }
  
  /// Set haptic feedback enabled state
  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _saveState();
    await _ref.read(audioServiceProvider).setHapticEnabled(enabled);
  }
  
  /// Save state to preferences
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('haptic_enabled', state);
    } catch (e) {
      print('[HapticEnabledNotifier] Error saving state: $e');
    }
  }
}
