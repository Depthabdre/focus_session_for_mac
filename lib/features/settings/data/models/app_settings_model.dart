import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.focusDurationMinutes,
    required super.breakDurationMinutes,
    required super.soundEnabled,
    required super.notificationsEnabled,
  });

  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(
      focusDurationMinutes: entity.focusDurationMinutes,
      breakDurationMinutes: entity.breakDurationMinutes,
      soundEnabled: entity.soundEnabled,
      notificationsEnabled: entity.notificationsEnabled,
    );
  }

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      focusDurationMinutes: (json['focusDurationMinutes'] as int?) ??
          AppSettings.defaults.focusDurationMinutes,
      breakDurationMinutes: (json['breakDurationMinutes'] as int?) ??
          AppSettings.defaults.breakDurationMinutes,
      soundEnabled: (json['soundEnabled'] as bool?) ??
          AppSettings.defaults.soundEnabled,
      notificationsEnabled: (json['notificationsEnabled'] as bool?) ??
          AppSettings.defaults.notificationsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'focusDurationMinutes': focusDurationMinutes,
      'breakDurationMinutes': breakDurationMinutes,
      'soundEnabled': soundEnabled,
      'notificationsEnabled': notificationsEnabled,
    };
  }
}
