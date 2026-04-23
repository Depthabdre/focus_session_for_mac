import 'package:get_it/get_it.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/services/notification_service.dart';
import '../data/datasources/timer_local_datasource.dart';
import '../data/repositories/timer_repository_impl.dart';
import '../domain/repositories/timer_repository.dart';
import '../domain/usecases/calculate_chunks_usecase.dart';
import '../domain/usecases/manage_timer_usecase.dart';
import '../presentation/bloc/timer_bloc.dart';

void registerTimerDependencies(GetIt sl) {
  sl.registerLazySingleton<TimerLocalDataSource>(
    TimerLocalDataSourceImpl.new,
  );
  sl.registerLazySingleton<TimerRepository>(
    () => TimerRepositoryImpl(sl<TimerLocalDataSource>()),
  );

  sl.registerLazySingleton<CalculateChunksUseCase>(CalculateChunksUseCase.new);
  sl.registerLazySingleton<ManageTimerUseCase>(ManageTimerUseCase.new);

  sl.registerFactory<TimerBloc>(
    () => TimerBloc(
      calculateChunksUseCase: sl<CalculateChunksUseCase>(),
      manageTimerUseCase: sl<ManageTimerUseCase>(),
      notificationService: sl<NotificationService>(),
      audioService: sl<AudioService>(),
    ),
  );
}
