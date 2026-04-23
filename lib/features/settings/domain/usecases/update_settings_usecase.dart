import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  const UpdateSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<AppSettings> call(AppSettings settings) {
    return _repository.updateSettings(settings);
  }
}
