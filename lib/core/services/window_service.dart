import 'dart:ui';

import 'package:window_manager/window_manager.dart';

class WindowService {
  Future<void> configureMainWindow() async {
    const WindowOptions options = WindowOptions(
      size: Size(980, 660),
      minimumSize: Size(880, 600),
      center: true,
      titleBarStyle: TitleBarStyle.hidden,
      backgroundColor: Color(0x00000000),
    );

    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
