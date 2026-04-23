import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/audio_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../domain/entities/session_phase.dart';
import '../../domain/usecases/calculate_chunks_usecase.dart';
import '../../domain/usecases/manage_timer_usecase.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({
    required CalculateChunksUseCase calculateChunksUseCase,
    required ManageTimerUseCase manageTimerUseCase,
    required NotificationService notificationService,
    required AudioService audioService,
  })  : _calculateChunksUseCase = calculateChunksUseCase,
        _manageTimerUseCase = manageTimerUseCase,
        _notificationService = notificationService,
        _audioService = audioService,
        super(const TimerState.initial()) {
    on<TimerStarted>(_onTimerStarted);
    on<TimerPaused>(_onTimerPaused);
    on<TimerResumed>(_onTimerResumed);
    on<TimerStopped>(_onTimerStopped);
    on<TimerTicked>(_onTimerTicked);
  }

  final CalculateChunksUseCase _calculateChunksUseCase;
  final ManageTimerUseCase _manageTimerUseCase;
  final NotificationService _notificationService;
  final AudioService _audioService;

  Timer? _ticker;
  AppSettings _activeSettings = AppSettings.defaults;

  Future<void> _onTimerStarted(
    TimerStarted event,
    Emitter<TimerState> emit,
  ) async {
    _activeSettings = event.settings;
    final session = _calculateChunksUseCase(
      totalTargetMinutes: event.totalTargetMinutes,
      settings: event.settings,
    );

    final SessionPhase firstPhase = session.phases.first;
    final DateTime targetEndTime = _manageTimerUseCase.buildTargetEndTime(
      from: DateTime.now(),
      durationSeconds: firstPhase.durationSeconds,
    );

    emit(
      TimerState(
        status: TimerStatus.running,
        phases: session.phases,
        currentPhaseIndex: 0,
        remainingSeconds: firstPhase.durationSeconds,
        currentPhaseTotalSeconds: firstPhase.durationSeconds,
        targetEndTime: targetEndTime,
      ),
    );

    _startTicker();
  }

  Future<void> _onTimerPaused(
    TimerPaused event,
    Emitter<TimerState> emit,
  ) async {
    if (state.status != TimerStatus.running || state.targetEndTime == null) {
      return;
    }

    _ticker?.cancel();
    final int remaining = _manageTimerUseCase.calculateRemainingSeconds(
      now: DateTime.now(),
      targetEndTime: state.targetEndTime!,
    );

    emit(
      state.copyWith(
        status: TimerStatus.paused,
        remainingSeconds: remaining,
        targetEndTime: null,
      ),
    );
  }

  Future<void> _onTimerResumed(
    TimerResumed event,
    Emitter<TimerState> emit,
  ) async {
    if (state.status != TimerStatus.paused || !state.hasActivePhase) {
      return;
    }

    final DateTime targetEndTime = _manageTimerUseCase.buildTargetEndTime(
      from: DateTime.now(),
      durationSeconds: state.remainingSeconds,
    );

    emit(
      state.copyWith(
        status: TimerStatus.running,
        targetEndTime: targetEndTime,
      ),
    );

    _startTicker();
  }

  Future<void> _onTimerStopped(
    TimerStopped event,
    Emitter<TimerState> emit,
  ) async {
    _ticker?.cancel();
    emit(const TimerState.initial());
  }

  Future<void> _onTimerTicked(
    TimerTicked event,
    Emitter<TimerState> emit,
  ) async {
    if (state.status != TimerStatus.running || state.targetEndTime == null) {
      return;
    }

    final int remaining = _manageTimerUseCase.calculateRemainingSeconds(
      now: event.now,
      targetEndTime: state.targetEndTime!,
    );

    if (remaining > 0) {
      emit(state.copyWith(remainingSeconds: remaining));
      return;
    }

    await _moveToNextPhaseOrComplete(emit);
  }

  Future<void> _moveToNextPhaseOrComplete(Emitter<TimerState> emit) async {
    final int nextIndex = state.currentPhaseIndex + 1;

    if (nextIndex >= state.phases.length) {
      _ticker?.cancel();
      emit(
        state.copyWith(
          status: TimerStatus.completed,
          remainingSeconds: 0,
          currentPhaseTotalSeconds: 0,
          targetEndTime: null,
        ),
      );

      await _audioService.playTransitionSound(enabled: _activeSettings.soundEnabled);
      await _notificationService.showPhaseNotification(
        title: 'Focus session complete',
        body: 'Great work. You have reached your target time.',
        enabled: _activeSettings.notificationsEnabled,
      );
      return;
    }

    final SessionPhase previousPhase = state.phases[state.currentPhaseIndex];
    final SessionPhase nextPhase = state.phases[nextIndex];
    final DateTime nextTargetEnd = _manageTimerUseCase.buildTargetEndTime(
      from: DateTime.now(),
      durationSeconds: nextPhase.durationSeconds,
    );

    emit(
      state.copyWith(
        status: TimerStatus.running,
        currentPhaseIndex: nextIndex,
        remainingSeconds: nextPhase.durationSeconds,
        currentPhaseTotalSeconds: nextPhase.durationSeconds,
        targetEndTime: nextTargetEnd,
      ),
    );

    final bool transitionedBetweenFocusAndBreak =
        previousPhase.type != nextPhase.type;

    if (transitionedBetweenFocusAndBreak) {
      final String nextLabel = nextPhase.type == SessionPhaseType.breakTime
          ? 'Break'
          : 'Focus';
      await _audioService.playTransitionSound(enabled: _activeSettings.soundEnabled);
      await _notificationService.showPhaseNotification(
        title: '$nextLabel started',
        body: 'Your $nextLabel phase is now active.',
        enabled: _activeSettings.notificationsEnabled,
      );
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(TimerTicked(DateTime.now())),
    );
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
