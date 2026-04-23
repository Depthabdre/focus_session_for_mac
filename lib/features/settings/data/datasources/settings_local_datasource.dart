import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/app_settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettingsModel> getSettings();
  Future<AppSettingsModel> updateSettings(AppSettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this._prefs);

  static const String _settingsKey = 'app_settings';

  final SharedPreferences _prefs;

  @override
  Future<AppSettingsModel> getSettings() async {
    try {
      final String? jsonString = _prefs.getString(_settingsKey);
      if (jsonString == null || jsonString.isEmpty) {
        return const AppSettingsModel(
          focusDurationMinutes: 25,
          breakDurationMinutes: 5,
          soundEnabled: true,
          notificationsEnabled: true,
        );
      }

      final Map<String, dynamic> map =
          json.decode(jsonString) as Map<String, dynamic>;
      return AppSettingsModel.fromJson(map);
    } catch (error) {
      throw CacheException('Unable to read settings: $error');
    }
  }

  @override
  Future<AppSettingsModel> updateSettings(AppSettingsModel settings) async {
    try {
      final String jsonString = json.encode(settings.toJson());
      final bool success = await _prefs.setString(_settingsKey, jsonString);
      if (!success) {
        throw const CacheException('Failed to persist settings');
      }
      return settings;
    } catch (error) {
      throw CacheException('Unable to persist settings: $error');
    }
  }
}
