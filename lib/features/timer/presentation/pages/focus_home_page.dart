import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_router.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../../domain/entities/session_phase.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';
import '../widgets/circular_progress_timer.dart';
import '../widgets/timer_controls.dart';

class FocusHomePage extends StatefulWidget {
  const FocusHomePage({super.key});

  @override
  State<FocusHomePage> createState() => _FocusHomePageState();
}

class _FocusHomePageState extends State<FocusHomePage> {
  int _selectedMinutes = 25;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (BuildContext context, SettingsState settingsState) {
        final AppSettings settings = settingsState is SettingsLoaded
            ? settingsState.settings
            : AppSettings.defaults;

        if (_selectedMinutes <= 0) {
          _selectedMinutes = settings.focusDurationMinutes;
        }

        return Scaffold(
          backgroundColor: const Color(0xFF202020),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF202020), Color(0xFF2A2B2D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: BlocBuilder<TimerBloc, TimerState>(
                      builder: (BuildContext context, TimerState timerState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    AppRouter.settingsRoute,
                                  );
                                },
                                icon: const Icon(Icons.more_horiz),
                                color: const Color(0xFFE2E2E2),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: timerState.status == TimerStatus.running ||
                                      timerState.status == TimerStatus.paused
                                  ? _ActiveSessionContent(
                                      timerState: timerState,
                                    )
                                  : _NoSessionContent(
                                      selectedMinutes: _selectedMinutes,
                                      focusDuration: settings.focusDurationMinutes,
                                      breakDuration: settings.breakDurationMinutes,
                                      onMinusTap: () {
                                        setState(() {
                                          _selectedMinutes =
                                              (_selectedMinutes - 5).clamp(5, 720);
                                        });
                                      },
                                      onPlusTap: () {
                                        setState(() {
                                          _selectedMinutes =
                                              (_selectedMinutes + 5).clamp(5, 720);
                                        });
                                      },
                                      onStartTap: (bool skipBreaks) {
                                        final sessionSettings = skipBreaks 
                                            ? settings.copyWith(breakDurationMinutes: 0)
                                            : settings;

                                        context.read<TimerBloc>().add(
                                              TimerStarted(
                                                totalTargetMinutes: _selectedMinutes,
                                                settings: sessionSettings,
                                              ),
                                            );
                                      },
                                    ),
                            ),
                            if (timerState.status == TimerStatus.running ||
                                timerState.status == TimerStatus.paused)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: TimerControls(
                                  status: timerState.status,
                                  onPause: () => context.read<TimerBloc>().add(
                                        const TimerPaused(),
                                      ),
                                  onResume: () => context.read<TimerBloc>().add(
                                        const TimerResumed(),
                                      ),
                                  onStop: () => context.read<TimerBloc>().add(
                                        const TimerStopped(),
                                      ),
                                ),
                              ),
                            if (timerState.status == TimerStatus.completed)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  'Completed. Great focus streak.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NoSessionContent extends StatefulWidget {
  const _NoSessionContent({
    required this.selectedMinutes,
    required this.focusDuration,
    required this.breakDuration,
    required this.onMinusTap,
    required this.onPlusTap,
    required this.onStartTap,
  });

  final int selectedMinutes;
  final int focusDuration;
  final int breakDuration;
  final VoidCallback onMinusTap;
  final VoidCallback onPlusTap;
  final Function(bool skipBreaks) onStartTap;

  @override
  State<_NoSessionContent> createState() => _NoSessionContentState();
}

class _NoSessionContentState extends State<_NoSessionContent> {
  bool _skipBreaks = false;

  @override
  Widget build(BuildContext context) {
    final int blockDuration = widget.focusDuration + widget.breakDuration;
    final int plannedBreaks = blockDuration > 0 ? widget.selectedMinutes ~/ blockDuration : 0;

    String breakLabel;
    if (_skipBreaks || widget.selectedMinutes <= widget.focusDuration || plannedBreaks == 0) {
      breakLabel = 'You\'ll have no breaks.';
    } else if (plannedBreaks == 1) {
      breakLabel = 'You\'ll have 1 break.';
    } else {
      breakLabel = 'You\'ll have $plannedBreaks breaks.';
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF323232),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3F3F3F), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Ready, set, focus!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Achieve your goals and get more done with focus\nsessions. '
              'Tell us how much time you have, and we\'ll\nset up the rest.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFD0D0D0),
                    fontSize: 14,
                    height: 1.4,
                  ),
            ),
          ),
          const SizedBox(height: 38),
          Container(
            width: 160,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF404040),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4F4F4F)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${widget.selectedMinutes}',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'mins',
                        style: TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFF383838),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.onPlusTap,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                            child: const Center(
                              child: Icon(Icons.keyboard_arrow_up, color: Color(0xFFE2E2E2), size: 28),
                            ),
                          ),
                        ),
                      ),
                      Container(height: 1, color: const Color(0xFF4F4F4F)),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.onMinusTap,
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                            child: const Center(
                              child: Icon(Icons.keyboard_arrow_down, color: Color(0xFFE2E2E2), size: 28),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text(
            breakLabel,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _skipBreaks,
                  onChanged: (bool? value) {
                    setState(() {
                      _skipBreaks = value ?? false;
                    });
                  },
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFF53B5EA);
                    }
                    return Colors.transparent;
                  }),
                  checkColor: Colors.black,
                  side: const BorderSide(color: Color(0xFFA0A0A0), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Skip breaks',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFA0A0A0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 40,
            child: FilledButton.icon(
              onPressed: () => widget.onStartTap(_skipBreaks),
              icon: const Icon(Icons.play_arrow, size: 20, color: Colors.black),
              label: const Text('Start focus session'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF53B5EA),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveSessionContent extends StatelessWidget {
  const _ActiveSessionContent({required this.timerState});

  final TimerState timerState;

  @override
  Widget build(BuildContext context) {
    final bool isBreak = timerState.currentPhaseType == SessionPhaseType.breakTime;
    final String headline = isBreak ? 'Break time' : 'Stay focused';
    final String subtitle = isBreak
        ? 'Step away for a short recharge.'
        : 'Keep momentum. You are in a focus phase.';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF323232),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3F3F3F), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            headline,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFD0D0D0),
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 38),
          CircularProgressTimer(
            remainingSeconds: timerState.remainingSeconds,
            totalSeconds: timerState.currentPhaseTotalSeconds,
            phaseType: timerState.currentPhaseType,
          ),
          const SizedBox(height: 32),
          Text(
            timerState.status == TimerStatus.paused ? 'Paused' : 'Focus session active',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
