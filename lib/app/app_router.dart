import 'package:flutter/material.dart';

import '../features/settings/presentation/pages/settings_page.dart';
import '../features/timer/presentation/pages/focus_home_page.dart';

class AppRouter {
  static const String homeRoute = '/';
  static const String settingsRoute = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case settingsRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
      case homeRoute:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const FocusHomePage(),
          settings: settings,
        );
    }
  }
}
