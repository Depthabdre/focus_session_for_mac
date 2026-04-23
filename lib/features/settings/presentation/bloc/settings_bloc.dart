import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetSettingsUseCase getSettingsUseCase,
    required UpdateSettingsUseCase updateSettingsUseCase,
  })  : _getSettingsUseCase = getSettingsUseCase,
        _updateSettingsUseCase = updateSettingsUseCase,
        super(const SettingsLoading()) {
    on<SettingsRequested>(_onSettingsRequested);
    on<SettingsUpdated>(_onSettingsUpdated);
  }

  final GetSettingsUseCase _getSettingsUseCase;
  final UpdateSettingsUseCase _updateSettingsUseCase;

  Future<void> _onSettingsRequested(
    SettingsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      final settings = await _getSettingsUseCase();
      emit(SettingsLoaded(settings));
    } on Failure catch (failure) {
      emit(SettingsError(failure.message));
    } catch (error) {
      emit(SettingsError('Unexpected settings error: $error'));
    }
  }

  Future<void> _onSettingsUpdated(
    SettingsUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final settings = await _updateSettingsUseCase(event.settings);
      emit(SettingsLoaded(settings));
    } on Failure catch (failure) {
      emit(SettingsError(failure.message));
    } catch (error) {
      emit(SettingsError('Unexpected settings error: $error'));
    }
  }
}
