import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/settings/presentation/bloc/settings_bloc.dart';
import '../features/timer/presentation/bloc/timer_bloc.dart';
import 'app_router.dart';
import 'app_theme.dart';

class FocusSessionApp extends StatelessWidget {
  const FocusSessionApp({
    super.key,
    required this.timerBloc,
    required this.settingsBloc,
  });

  final TimerBloc timerBloc;
  final SettingsBloc settingsBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TimerBloc>.value(value: timerBloc),
        BlocProvider<SettingsBloc>.value(value: settingsBloc),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Focus Session',
        theme: buildAppTheme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.homeRoute,
      ),
    );
  }
}
