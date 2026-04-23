import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/session_phase.dart';

class CircularProgressTimer extends StatelessWidget {
  const CircularProgressTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.phaseType,
  });

  final int remainingSeconds;
  final int totalSeconds;
  final SessionPhaseType phaseType;

  @override
  Widget build(BuildContext context) {
    final double progress = totalSeconds == 0
        ? 0
        : (1 - (remainingSeconds / totalSeconds)).clamp(0.0, 1.0);
    final Color activeColor = phaseType == SessionPhaseType.breakTime
        ? const Color(0xFF7ED39A)
        : const Color(0xFF2FB7FF);

    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            value: 1,
            strokeWidth: 14,
            color: const Color(0xFF3A3C43),
            backgroundColor: Colors.transparent,
          ),
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 14,
            color: activeColor,
            backgroundColor: Colors.transparent,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                formatSecondsToMmSs(remainingSeconds),
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF2F4F8),
                ),
              ),
              Text(
                phaseType == SessionPhaseType.breakTime ? 'BREAK' : 'FOCUS',
                style: const TextStyle(
                  letterSpacing: 1.2,
                  fontSize: 13,
                  color: Color(0xFFB7BCC8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
