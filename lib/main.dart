import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'app/injection_container.dart';
import 'core/services/notification_service.dart';
import 'core/services/window_service.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/timer/presentation/bloc/timer_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isMacOS) {
    await windowManager.ensureInitialized();
  }

  await initDependencies();
  await sl<NotificationService>().initialize();

  if (Platform.isMacOS) {
    await sl<WindowService>().configureMainWindow();
  }

  final SettingsBloc settingsBloc = sl<SettingsBloc>()..add(const SettingsRequested());
  final TimerBloc timerBloc = sl<TimerBloc>();

  runApp(
    FocusSessionApp(
      timerBloc: timerBloc,
      settingsBloc: settingsBloc,
    ),
  );
}
