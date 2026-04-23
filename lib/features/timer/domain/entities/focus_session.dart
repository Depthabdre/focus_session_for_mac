import 'package:equatable/equatable.dart';

import 'session_phase.dart';

class FocusSession extends Equatable {
  const FocusSession({
    required this.phases,
    required this.totalTargetMinutes,
  });

  final List<SessionPhase> phases;
  final int totalTargetMinutes;

  @override
  List<Object?> get props => <Object?>[phases, totalTargetMinutes];
}
