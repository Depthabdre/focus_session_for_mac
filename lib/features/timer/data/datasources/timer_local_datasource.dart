import '../../domain/entities/focus_session.dart';

abstract class TimerLocalDataSource {
  Future<void> saveSession(FocusSession session);
  Future<FocusSession?> getActiveSession();
  Future<void> clearSession();
}

class TimerLocalDataSourceImpl implements TimerLocalDataSource {
  const TimerLocalDataSourceImpl();

  @override
  Future<void> clearSession() async {}

  @override
  Future<FocusSession?> getActiveSession() async {
    return null;
  }

  @override
  Future<void> saveSession(FocusSession session) async {}
}
