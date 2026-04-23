import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/window_service.dart';
import '../data/datasources/settings_local_datasource.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/usecases/get_settings_usecase.dart';
import '../domain/usecases/update_settings_usecase.dart';
import '../presentation/bloc/settings_bloc.dart';

Future<void> registerSettingsDependencies(GetIt sl) async {
  if (!sl.isRegistered<SharedPreferences>()) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
  }

  if (!sl.isRegistered<WindowService>()) {
    sl.registerLazySingleton<WindowService>(WindowService.new);
  }
  if (!sl.isRegistered<NotificationService>()) {
    sl.registerLazySingleton<NotificationService>(NotificationService.new);
  }
  if (!sl.isRegistered<AudioService>()) {
    sl.registerLazySingleton<AudioService>(AudioService.new);
  }

  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl<SettingsLocalDataSource>()),
  );
  sl.registerLazySingleton<GetSettingsUseCase>(
    () => GetSettingsUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<UpdateSettingsUseCase>(
    () => UpdateSettingsUseCase(sl<SettingsRepository>()),
  );

  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      getSettingsUseCase: sl<GetSettingsUseCase>(),
      updateSettingsUseCase: sl<UpdateSettingsUseCase>(),
    ),
  );
}
