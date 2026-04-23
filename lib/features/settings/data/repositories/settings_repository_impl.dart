import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<AppSettings> getSettings() async {
    try {
      return await _localDataSource.getSettings();
    } on CacheException catch (error) {
      throw CacheFailure(error.message);
    }
  }

  @override
  Future<AppSettings> updateSettings(AppSettings settings) async {
    try {
      final AppSettingsModel model = AppSettingsModel.fromEntity(settings);
      return await _localDataSource.updateSettings(model);
    } on CacheException catch (error) {
      throw CacheFailure(error.message);
    }
  }
}
