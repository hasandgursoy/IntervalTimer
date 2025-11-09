import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_timer/features/timer/data/repositories/preset_repository.dart';
import 'package:interval_timer/features/timer/domain/entities/workout_preset.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider for PresetRepository
final presetRepositoryProvider = FutureProvider<PresetRepository>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return PresetRepository(prefs);
});

/// Provider for preset state management
final presetProvider = StateNotifierProvider<PresetNotifier, AsyncValue<List<WorkoutPreset>>>((ref) {
  return PresetNotifier(ref);
});

/// State notifier for managing workout presets
class PresetNotifier extends StateNotifier<AsyncValue<List<WorkoutPreset>>> {
  final Ref _ref;
  PresetRepository? _repository;
  
  PresetNotifier(this._ref) : super(const AsyncValue.loading()) {
    _initializeAndLoadPresets();
  }
  
  /// Initialize repository and load presets
  Future<void> _initializeAndLoadPresets() async {
    try {
      final repository = await _ref.read(presetRepositoryProvider.future);
      _repository = repository;
      await loadPresets();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      print('[PresetNotifier] Error initializing: $e');
    }
  }
  
  /// Load all presets from repository
  Future<void> loadPresets() async {
    if (_repository == null) {
      print('[PresetNotifier] Repository not initialized yet');
      return;
    }
    
    state = const AsyncValue.loading();
    
    try {
      final presets = await _repository!.getAllPresets();
      state = AsyncValue.data(presets);
      print('[PresetNotifier] Loaded ${presets.length} presets');
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      print('[PresetNotifier] Error loading presets: $e');
    }
  }
  
  /// Add a new preset
  Future<bool> addPreset(WorkoutPreset preset) async {
    if (_repository == null) {
      print('[PresetNotifier] Repository not initialized');
      return false;
    }
    
    try {
      // Check if name already exists
      final nameExists = await _repository!.presetNameExists(preset.name);
      if (nameExists) {
        print('[PresetNotifier] Preset name already exists: ${preset.name}');
        return false;
      }
      
      // Save to repository
      final success = await _repository!.savePreset(preset);
      
      if (success) {
        // Reload presets
        await loadPresets();
        print('[PresetNotifier] Added preset: ${preset.name}');
      }
      
      return success;
    } catch (e) {
      print('[PresetNotifier] Error adding preset: $e');
      return false;
    }
  }
  
  /// Update an existing preset
  Future<bool> updatePreset(WorkoutPreset preset) async {
    if (_repository == null) {
      print('[PresetNotifier] Repository not initialized');
      return false;
    }
    
    try {
      // Check if name already exists (excluding current preset)
      final nameExists = await _repository!.presetNameExists(
        preset.name,
        excludeId: preset.id,
      );
      
      if (nameExists) {
        print('[PresetNotifier] Preset name already exists: ${preset.name}');
        return false;
      }
      
      // Save to repository
      final success = await _repository!.savePreset(preset);
      
      if (success) {
        // Reload presets
        await loadPresets();
        print('[PresetNotifier] Updated preset: ${preset.name}');
      }
      
      return success;
    } catch (e) {
      print('[PresetNotifier] Error updating preset: $e');
      return false;
    }
  }
  
  /// Delete a preset
  Future<bool> deletePreset(String id) async {
    if (_repository == null) {
      print('[PresetNotifier] Repository not initialized');
      return false;
    }
    
    try {
      final success = await _repository!.deletePreset(id);
      
      if (success) {
        // Reload presets
        await loadPresets();
        print('[PresetNotifier] Deleted preset: $id');
      }
      
      return success;
    } catch (e) {
      print('[PresetNotifier] Error deleting preset: $e');
      return false;
    }
  }
  
  /// Get a specific preset by ID
  Future<WorkoutPreset?> getPresetById(String id) async {
    if (_repository == null) {
      print('[PresetNotifier] Repository not initialized');
      return null;
    }
    
    try {
      return await _repository!.getPresetById(id);
    } catch (e) {
      print('[PresetNotifier] Error getting preset: $e');
      return null;
    }
  }
  
  /// Clear all custom presets (keep defaults)
  Future<bool> clearCustomPresets() async {
    if (_repository == null) {
      print('[PresetNotifier] Repository not initialized');
      return false;
    }
    
    try {
      final success = await _repository!.clearCustomPresets();
      
      if (success) {
        // Reload presets
        await loadPresets();
        print('[PresetNotifier] Cleared custom presets');
      }
      
      return success;
    } catch (e) {
      print('[PresetNotifier] Error clearing presets: $e');
      return false;
    }
  }
}
