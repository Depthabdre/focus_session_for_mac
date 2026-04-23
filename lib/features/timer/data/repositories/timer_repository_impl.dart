import '../../domain/entities/focus_session.dart';
import '../../domain/repositories/timer_repository.dart';
import '../datasources/timer_local_datasource.dart';

class TimerRepositoryImpl implements TimerRepository {
  const TimerRepositoryImpl(this._localDataSource);

  final TimerLocalDataSource _localDataSource;

  @override
  Future<void> clearSession() {
    return _localDataSource.clearSession();
  }

  @override
  Future<FocusSession?> getActiveSession() {
    return _localDataSource.getActiveSession();
  }

  @override
  Future<void> saveSession(FocusSession session) {
    return _localDataSource.saveSession(session);
  }
}
