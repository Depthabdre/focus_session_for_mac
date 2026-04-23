import '../../../settings/domain/entities/app_settings.dart';
import '../entities/focus_session.dart';
import '../entities/session_phase.dart';

class CalculateChunksUseCase {
  const CalculateChunksUseCase();

  FocusSession call({
    required int totalTargetMinutes,
    required AppSettings settings,
  }) {
    if (totalTargetMinutes <= 0) {
      throw ArgumentError.value(
        totalTargetMinutes,
        'totalTargetMinutes',
        'Total target minutes must be greater than zero.',
      );
    }

    final int focusDuration = settings.focusDurationMinutes;
    final int breakDuration = settings.breakDurationMinutes;
    final int blockDuration = focusDuration + breakDuration;

    final List<SessionPhase> phases = <SessionPhase>[];

    final int fullBlocks = totalTargetMinutes ~/ blockDuration;
    final int remainder = totalTargetMinutes % blockDuration;

    for (int i = 0; i < fullBlocks; i++) {
      phases.add(
        SessionPhase(
          type: SessionPhaseType.focus,
          durationMinutes: focusDuration,
        ),
      );
      if (breakDuration > 0) {
        phases.add(
          SessionPhase(
            type: SessionPhaseType.breakTime,
            durationMinutes: breakDuration,
          ),
        );
      }
    }

    if (remainder > 0) {
      phases.add(
        SessionPhase(
          type: SessionPhaseType.focus,
          durationMinutes: remainder,
        ),
      );
    }

    if (phases.isEmpty) {
      phases.add(
        SessionPhase(
          type: SessionPhaseType.focus,
          durationMinutes: totalTargetMinutes,
        ),
      );
    }

    return FocusSession(
      phases: phases,
      totalTargetMinutes: totalTargetMinutes,
    );
  }
}
