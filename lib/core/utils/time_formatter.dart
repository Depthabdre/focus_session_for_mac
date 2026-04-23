String formatSecondsToMmSs(int totalSeconds) {
  final int safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
  final int minutes = safeSeconds ~/ 60;
  final int seconds = safeSeconds % 60;

  final String mm = minutes.toString().padLeft(2, '0');
  final String ss = seconds.toString().padLeft(2, '0');
  return '$mm:$ss';
}
