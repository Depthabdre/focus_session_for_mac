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
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF1B1C20), Color(0xFF212229)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
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
                                icon: const Icon(Icons.settings_outlined),
                                color: const Color(0xFFCCD2DD),
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                      onStartTap: () {
                                        context.read<TimerBloc>().add(
                                              TimerStarted(
                                                totalTargetMinutes: _selectedMinutes,
                                                settings: settings,
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

class _NoSessionContent extends StatelessWidget {
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
  final VoidCallback onStartTap;

  @override
  Widget build(BuildContext context) {
    final int blockDuration = focusDuration + breakDuration;
    final int plannedBreaks = blockDuration > 0 ? selectedMinutes ~/ blockDuration : 0;

    String breakLabel;
    if (selectedMinutes <= focusDuration || plannedBreaks == 0) {
      breakLabel = 'You\'ll have no breaks.';
    } else if (plannedBreaks == 1) {
      breakLabel = 'You\'ll have 1 break.';
    } else {
      breakLabel = 'You\'ll have $plannedBreaks breaks.';
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D32),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Ready, set, focus!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Achieve your goals and get more done with focus sessions. '
            'Tell us how much time you have, and we\'ll set up the rest.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 26),
          Container(
            width: 170,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF383A40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$selectedMinutes',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                      const Text(
                        'mins',
                        style: TextStyle(
                          color: Color(0xFFB7BCC8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF32343A),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: IconButton(
                          onPressed: onPlusTap,
                          icon: const Icon(Icons.keyboard_arrow_up),
                          color: const Color(0xFFDEE3EF),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: onMinusTap,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          color: const Color(0xFFDEE3EF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            breakLabel,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 44,
            child: FilledButton.icon(
              onPressed: onStartTap,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start focus session'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2FB7FF),
                foregroundColor: const Color(0xFF0A1A27),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
        color: const Color(0xFF2B2D32),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            headline,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 26),
          CircularProgressTimer(
            remainingSeconds: timerState.remainingSeconds,
            totalSeconds: timerState.currentPhaseTotalSeconds,
            phaseType: timerState.currentPhaseType,
          ),
          const SizedBox(height: 22),
          Text(
            timerState.status == TimerStatus.paused ? 'Paused' : 'Running',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
