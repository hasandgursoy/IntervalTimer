import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_timer/features/timer/domain/entities/workout_preset.dart';

/// Repository for managing workout presets in local storage
/// 
/// Uses SharedPreferences to persist presets across app sessions.
/// Presets are stored as a JSON array.
class PresetRepository {
  static const String _presetsKey = 'workout_presets';
  
  final SharedPreferences _prefs;
  
  PresetRepository(this._prefs);
  
  /// Save a new preset or update existing one
  Future<bool> savePreset(WorkoutPreset preset) async {
    try {
      final presets = await getAllPresets();
      
      // Remove existing preset with same ID (if updating)
      presets.removeWhere((p) => p.id == preset.id);
      
      // Add the new/updated preset
      presets.add(preset);
      
      // Convert to JSON and save
      final jsonList = presets.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      final success = await _prefs.setString(_presetsKey, jsonString);
      
      if (success) {
        print('[PresetRepository] Saved preset: ${preset.name}');
      } else {
        print('[PresetRepository] Failed to save preset: ${preset.name}');
      }
      
      return success;
    } catch (e) {
      print('[PresetRepository] Error saving preset: $e');
      return false;
    }
  }
  
  /// Delete a preset by ID
  Future<bool> deletePreset(String id) async {
    try {
      final presets = await getAllPresets();
      
      // Check if it's a default preset
      final preset = presets.firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('Preset not found'),
      );
      
      if (preset.isDefault) {
        print('[PresetRepository] Cannot delete default preset: ${preset.name}');
        return false;
      }
      
      // Remove the preset
      presets.removeWhere((p) => p.id == id);
      
      // Save updated list
      final jsonList = presets.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      final success = await _prefs.setString(_presetsKey, jsonString);
      
      if (success) {
        print('[PresetRepository] Deleted preset: $id');
      } else {
        print('[PresetRepository] Failed to delete preset: $id');
      }
      
      return success;
    } catch (e) {
      print('[PresetRepository] Error deleting preset: $e');
      return false;
    }
  }
  
  /// Get all presets (default + custom)
  Future<List<WorkoutPreset>> getAllPresets() async {
    try {
      final jsonString = _prefs.getString(_presetsKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        // Return only default presets if no saved presets
        return _getDefaultPresets();
      }
      
      // Parse JSON
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final savedPresets = jsonList
          .map((json) => WorkoutPreset.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Combine defaults with saved presets
      final defaults = _getDefaultPresets();
      final customPresets = savedPresets.where((p) => !p.isDefault).toList();
      
      return [...defaults, ...customPresets];
    } catch (e) {
      print('[PresetRepository] Error loading presets: $e');
      // Return default presets on error
      return _getDefaultPresets();
    }
  }
  
  /// Get a specific preset by ID
  Future<WorkoutPreset?> getPresetById(String id) async {
    try {
      final presets = await getAllPresets();
      return presets.firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('Preset not found'),
      );
    } catch (e) {
      print('[PresetRepository] Preset not found: $id');
      return null;
    }
  }
  
  /// Check if a preset name already exists
  Future<bool> presetNameExists(String name, {String? excludeId}) async {
    final presets = await getAllPresets();
    return presets.any((p) => 
      p.name.toLowerCase() == name.toLowerCase() && 
      p.id != excludeId
    );
  }
  
  /// Get default presets
  List<WorkoutPreset> _getDefaultPresets() {
    return [
      WorkoutPreset.tabata,
      WorkoutPreset.hiit,
      WorkoutPreset.quick,
    ];
  }
  
  /// Clear all custom presets (keep defaults)
  Future<bool> clearCustomPresets() async {
    try {
      final defaults = _getDefaultPresets();
      final jsonList = defaults.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      return await _prefs.setString(_presetsKey, jsonString);
    } catch (e) {
      print('[PresetRepository] Error clearing presets: $e');
      return false;
    }
  }
}
