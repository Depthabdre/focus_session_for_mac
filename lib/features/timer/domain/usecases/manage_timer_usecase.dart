class ManageTimerUseCase {
  const ManageTimerUseCase();

  DateTime buildTargetEndTime({
    required DateTime from,
    required int durationSeconds,
  }) {
    return from.add(Duration(seconds: durationSeconds));
  }

  int calculateRemainingSeconds({
    required DateTime now,
    required DateTime targetEndTime,
  }) {
    final int remaining = targetEndTime.difference(now).inSeconds;
    return remaining < 0 ? 0 : remaining;
  }
}
