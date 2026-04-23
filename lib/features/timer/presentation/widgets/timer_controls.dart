import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import '../bloc/timer_state.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.status,
    required this.onPause,
    required this.onResume,
    required this.onStop,
  });

  final TimerStatus status;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final bool paused = status == TimerStatus.paused;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FilledButton.icon(
          onPressed: paused ? onResume : onPause,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2FB7FF),
            foregroundColor: const Color(0xFF0A1A27),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          ),
          icon: Icon(paused ? Icons.play_arrow : Icons.pause),
          label: Text(paused ? 'Resume' : 'Pause'),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: onStop,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFE0E3EC),
            side: const BorderSide(color: Color(0xFF585C67)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          icon: const Icon(Icons.stop),
          label: const Text('Stop'),
        ),
      ],
    );
  }
}