import 'package:local_notifier/local_notifier.dart';

class NotificationService {
  Future<void> initialize() async {
    await localNotifier.setup(
      appName: 'Focus Session',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  Future<void> showPhaseNotification({
    required String title,
    required String body,
    bool enabled = true,
  }) async {
    if (!enabled) {
      return;
    }

    final LocalNotification notification = LocalNotification(
      title: title,
      body: body,
      silent: false,
    );
    await notification.show();
  }
}
