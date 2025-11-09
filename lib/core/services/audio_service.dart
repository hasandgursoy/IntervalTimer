import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Audio service for playing interval timer sounds
/// 
/// Provides methods to play different sounds for workout events:
/// - Start workout
/// - Work interval
/// - Rest interval
/// - Workout complete
/// - Countdown beeps (last 3 seconds)
/// 
/// Uses audioplayers package for cross-platform audio support.
/// Also provides haptic feedback for better user experience.
class AudioService {
  // Audio player instances
  final AudioPlayer _player = AudioPlayer();
  
  // Audio enabled state
  bool _isEnabled = true;
  
  // Haptic feedback enabled state
  bool _hapticEnabled = true;
  
  // Volume (0.0 to 1.0)
  double _volume = 0.7;
  
  /// Constructor
  AudioService() {
    _initializePlayer();
  }
  
  /// Initialize audio player settings
  Future<void> _initializePlayer() async {
    try {
      await _player.setVolume(_volume);
      await _player.setReleaseMode(ReleaseMode.stop);
      print('[AudioService] Initialized with volume: $_volume');
      
      // Verify sound files exist
      await _verifySoundFiles();
    } catch (e) {
      print('[AudioService] Error initializing: $e');
    }
  }
  
  /// Verify that all sound files are present
  Future<void> _verifySoundFiles() async {
    final soundFiles = ['start.mp3', 'work.mp3', 'rest.mp3', 'complete.mp3'];
    
    for (final file in soundFiles) {
      try {
        // Try to load the sound file to verify it exists
        final source = AssetSource('sounds/$file');
        await _player.setSource(source);
        print('[AudioService] ✓ Found: sounds/$file');
      } catch (e) {
        print('[AudioService] ✗ Missing: sounds/$file');
        if (kDebugMode) {
          print('[AudioService] Error: $e');
        }
      }
    }
    
    // Reset player after verification
    await _player.stop();
  }
  
  /// Get current enabled state
  bool get isEnabled => _isEnabled;
  
  /// Get current haptic feedback state
  bool get hapticEnabled => _hapticEnabled;
  
  /// Get current volume (0.0 to 1.0)
  double get volume => _volume;
  
  /// Enable or disable audio
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    print('[AudioService] Sound ${enabled ? 'enabled' : 'disabled'}');
  }
  
  /// Enable or disable haptic feedback
  Future<void> setHapticEnabled(bool enabled) async {
    _hapticEnabled = enabled;
    print('[AudioService] Haptic ${enabled ? 'enabled' : 'disabled'}');
  }
  
  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
    print('[AudioService] Volume set to: $_volume');
  }
  
  /// Trigger light haptic feedback (for interval transitions)
  Future<void> _triggerLightHaptic() async {
    if (_hapticEnabled) {
      try {
        await HapticFeedback.lightImpact();
      } catch (e) {
        if (kDebugMode) {
          print('[AudioService] Haptic feedback error: $e');
        }
      }
    }
  }
  
  /// Trigger medium haptic feedback (for workout complete)
  Future<void> _triggerMediumHaptic() async {
    if (_hapticEnabled) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (e) {
        if (kDebugMode) {
          print('[AudioService] Haptic feedback error: $e');
        }
      }
    }
  }
  
  /// Trigger selection haptic feedback (for button presses)
  Future<void> triggerSelectionHaptic() async {
    if (_hapticEnabled) {
      try {
        await HapticFeedback.selectionClick();
      } catch (e) {
        if (kDebugMode) {
          print('[AudioService] Haptic feedback error: $e');
        }
      }
    }
  }
  
  /// Play workout start sound
  Future<void> playStartSound() async {
    await _triggerLightHaptic();
    
    if (!_isEnabled) return;
    
    try {
      print('[AudioService] Playing start sound');
      await _player.stop(); // Stop any current sound
      await _player.play(AssetSource('sounds/start.mp3'));
    } catch (e) {
      print('[AudioService] Error playing start sound: $e');
      // Fallback to console notification if file not found
      if (kDebugMode) {
        print('[AudioService] Make sure sounds/start.mp3 exists in assets folder');
      }
    }
  }
  
  /// Play work interval start sound
  Future<void> playWorkSound() async {
    await _triggerLightHaptic();
    
    if (!_isEnabled) return;
    
    try {
      print('[AudioService] Playing work sound');
      await _player.stop(); // Stop any current sound
      await _player.play(AssetSource('sounds/work.mp3'));
    } catch (e) {
      print('[AudioService] Error playing work sound: $e');
      if (kDebugMode) {
        print('[AudioService] Make sure sounds/work.mp3 exists in assets folder');
      }
    }
  }
  
  /// Play rest interval start sound
  Future<void> playRestSound() async {
    await _triggerLightHaptic();
    
    if (!_isEnabled) return;
    
    try {
      print('[AudioService] Playing rest sound');
      await _player.stop(); // Stop any current sound
      await _player.play(AssetSource('sounds/rest.mp3'));
    } catch (e) {
      print('[AudioService] Error playing rest sound: $e');
      if (kDebugMode) {
        print('[AudioService] Make sure sounds/rest.mp3 exists in assets folder');
      }
    }
  }
  
  /// Play workout complete sound
  Future<void> playCompleteSound() async {
    await _triggerMediumHaptic();
    
    if (!_isEnabled) return;
    
    try {
      print('[AudioService] Playing complete sound');
      await _player.stop(); // Stop any current sound
      await _player.play(AssetSource('sounds/complete.mp3'));
    } catch (e) {
      print('[AudioService] Error playing complete sound: $e');
      if (kDebugMode) {
        print('[AudioService] Make sure sounds/complete.mp3 exists in assets folder');
      }
    }
  }
  
  /// Play countdown beep (for last 3 seconds)
  Future<void> playCountdownBeep() async {
    if (!_isEnabled) return;
    
    try {
      print('[AudioService] Playing countdown beep');
      await _player.stop(); // Stop any current sound
      // Using work sound for countdown if countdown.mp3 doesn't exist
      await _player.play(AssetSource('sounds/work.mp3'));
    } catch (e) {
      print('[AudioService] Error playing countdown beep: $e');
      if (kDebugMode) {
        print('[AudioService] Make sure sounds/work.mp3 exists in assets folder');
      }
    }
  }
  
  /// Play preparation sound (same as work but different tone)
  Future<void> playPrepSound() async {
    if (!_isEnabled) return;
    
    try {
      print('[AudioService] Playing prep sound');
      await _player.stop(); // Stop any current sound
      // Using start sound for prep as they're similar
      await _player.play(AssetSource('sounds/start.mp3'));
    } catch (e) {
      print('[AudioService] Error playing prep sound: $e');
      if (kDebugMode) {
        print('[AudioService] Make sure sounds/start.mp3 exists in assets folder');
      }
    }
  }
  
  /// Test all sounds in sequence
  Future<void> testAllSounds() async {
    print('[AudioService] Testing all sounds...');
    await playStartSound();
    await Future.delayed(const Duration(milliseconds: 500));
    await playWorkSound();
    await Future.delayed(const Duration(milliseconds: 500));
    await playRestSound();
    await Future.delayed(const Duration(milliseconds: 500));
    await playCountdownBeep();
    await Future.delayed(const Duration(milliseconds: 500));
    await playCompleteSound();
    print('[AudioService] Sound test complete');
  }
  
  /// Dispose audio player
  Future<void> dispose() async {
    await _player.dispose();
    print('[AudioService] Disposed');
  }
}
