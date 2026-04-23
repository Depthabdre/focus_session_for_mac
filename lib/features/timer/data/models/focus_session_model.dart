import '../../domain/entities/focus_session.dart';
import '../../domain/entities/session_phase.dart';

class FocusSessionModel extends FocusSession {
  const FocusSessionModel({
    required super.phases,
    required super.totalTargetMinutes,
  });

  factory FocusSessionModel.fromEntity(FocusSession session) {
    return FocusSessionModel(
      phases: session.phases,
      totalTargetMinutes: session.totalTargetMinutes,
    );
  }

  factory FocusSessionModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawPhases = (json['phases'] as List<dynamic>? ?? <dynamic>[]);

    final List<SessionPhase> phases = rawPhases
        .map((dynamic raw) => raw as Map<String, dynamic>)
        .map(
          (Map<String, dynamic> item) => SessionPhase(
            type: SessionPhaseType.values.byName(item['type'] as String),
            durationMinutes: item['durationMinutes'] as int,
          ),
        )
        .toList(growable: false);

    return FocusSessionModel(
      phases: phases,
      totalTargetMinutes: json['totalTargetMinutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'totalTargetMinutes': totalTargetMinutes,
      'phases': phases
          .map(
            (SessionPhase phase) => <String, dynamic>{
              'type': phase.type.name,
              'durationMinutes': phase.durationMinutes,
            },
          )
          .toList(growable: false),
    };
  }
}
