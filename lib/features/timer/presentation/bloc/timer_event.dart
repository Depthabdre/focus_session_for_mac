import 'package:equatable/equatable.dart';

import '../../../settings/domain/entities/app_settings.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class TimerStarted extends TimerEvent {
  const TimerStarted({
    required this.totalTargetMinutes,
    required this.settings,
  });

  final int totalTargetMinutes;
  final AppSettings settings;

  @override
  List<Object?> get props => <Object?>[totalTargetMinutes, settings];
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerStopped extends TimerEvent {
  const TimerStopped();
}

class TimerTicked extends TimerEvent {
  const TimerTicked(this.now);

  final DateTime now;

  @override
  List<Object?> get props => <Object?>[now];
}
