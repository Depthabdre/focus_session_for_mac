import 'package:equatable/equatable.dart';

import '../../domain/entities/app_settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class SettingsRequested extends SettingsEvent {
  const SettingsRequested();
}

class SettingsUpdated extends SettingsEvent {
  const SettingsUpdated(this.settings);

  final AppSettings settings;

  @override
  List<Object?> get props => <Object?>[settings];
}
