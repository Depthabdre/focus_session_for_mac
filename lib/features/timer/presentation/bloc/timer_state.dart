import 'package:equatable/equatable.dart';

import '../../domain/entities/session_phase.dart';

enum TimerStatus { initial, running, paused, completed, error }

class TimerState extends Equatable {
  const TimerState({
    required this.status,
    required this.phases,
    required this.currentPhaseIndex,
    required this.remainingSeconds,
    required this.currentPhaseTotalSeconds,
    this.targetEndTime,
    this.message,
  });

  const TimerState.initial()
      : status = TimerStatus.initial,
        phases = const <SessionPhase>[],
        currentPhaseIndex = -1,
        remainingSeconds = 0,
        currentPhaseTotalSeconds = 0,
        targetEndTime = null,
        message = null;

  final TimerStatus status;
  final List<SessionPhase> phases;
  final int currentPhaseIndex;
  final int remainingSeconds;
  final int currentPhaseTotalSeconds;
  final DateTime? targetEndTime;
  final String? message;

  SessionPhaseType get currentPhaseType {
    if (currentPhaseIndex < 0 || currentPhaseIndex >= phases.length) {
      return SessionPhaseType.completed;
    }
    return phases[currentPhaseIndex].type;
  }

  bool get hasActivePhase =>
      currentPhaseIndex >= 0 && currentPhaseIndex < phases.length;

  TimerState copyWith({
    TimerStatus? status,
    List<SessionPhase>? phases,
    int? currentPhaseIndex,
    int? remainingSeconds,
    int? currentPhaseTotalSeconds,
    DateTime? targetEndTime,
    String? message,
  }) {
    return TimerState(
      status: status ?? this.status,
      phases: phases ?? this.phases,
      currentPhaseIndex: currentPhaseIndex ?? this.currentPhaseIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentPhaseTotalSeconds:
          currentPhaseTotalSeconds ?? this.currentPhaseTotalSeconds,
      targetEndTime: targetEndTime,
      message: message,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    phases,
    currentPhaseIndex,
    remainingSeconds,
    currentPhaseTotalSeconds,
    targetEndTime,
    message,
  ];
}
