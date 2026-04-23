import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  const AppSettings({
    required this.focusDurationMinutes,
    required this.breakDurationMinutes,
    required this.soundEnabled,
    required this.notificationsEnabled,
  });

  static const AppSettings defaults = AppSettings(
    focusDurationMinutes: 25,
    breakDurationMinutes: 5,
    soundEnabled: true,
    notificationsEnabled: true,
  );

  final int focusDurationMinutes;
  final int breakDurationMinutes;
  final bool soundEnabled;
  final bool notificationsEnabled;

  AppSettings copyWith({
    int? focusDurationMinutes,
    int? breakDurationMinutes,
    bool? soundEnabled,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      focusDurationMinutes:
          focusDurationMinutes ?? this.focusDurationMinutes,
      breakDurationMinutes:
          breakDurationMinutes ?? this.breakDurationMinutes,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [
    focusDurationMinutes,
    breakDurationMinutes,
    soundEnabled,
    notificationsEnabled,
  ];
}
