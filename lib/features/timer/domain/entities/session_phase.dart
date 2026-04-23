import 'package:equatable/equatable.dart';

enum SessionPhaseType { focus, breakTime, completed }

class SessionPhase extends Equatable {
  const SessionPhase({
    required this.type,
    required this.durationMinutes,
  });

  final SessionPhaseType type;
  final int durationMinutes;

  int get durationSeconds => durationMinutes * 60;

  @override
  List<Object?> get props => <Object?>[type, durationMinutes];
}
