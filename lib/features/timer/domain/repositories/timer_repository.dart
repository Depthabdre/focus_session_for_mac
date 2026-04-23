import '../entities/focus_session.dart';

abstract class TimerRepository {
  Future<void> saveSession(FocusSession session);
  Future<FocusSession?> getActiveSession();
  Future<void> clearSession();
}
