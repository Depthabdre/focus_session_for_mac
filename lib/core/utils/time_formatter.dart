String formatSecondsToMmSs(int totalSeconds) {
  final int safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
  final int minutes = safeSeconds ~/ 60;
  final int seconds = safeSeconds % 60;

  final String mm = minutes.toString().padLeft(2, '0');
  final String ss = seconds.toString().padLeft(2, '0');
  return '$mm:$ss';
}

String formatSecondsDynamic(int totalSeconds) {
  final int safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
  final int minutes = safeSeconds ~/ 60;
  
  if (minutes >= 10) {
    // Above 10 minutes, show only the rounded-up minutes left
    final int displayMinutes = (safeSeconds / 60).ceil();
    return '$displayMinutes';
  } else {
    // Below 10 minutes, show mm:ss
    final int seconds = safeSeconds % 60;
    final String mm = minutes.toString().padLeft(2, '0');
    final String ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
