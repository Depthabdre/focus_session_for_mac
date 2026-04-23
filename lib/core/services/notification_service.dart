import 'dart:ui';
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
    VoidCallback? onUserInteraction,
  }) async {
    if (!enabled) {
      return;
    }

    final LocalNotification notification = LocalNotification(
      title: title,
      body: body,
      silent: true, // Audio service handles the continuous loop
      actions: [
        LocalNotificationAction(text: 'Stop alarm'),
      ],
    );

    notification.onClick = () {
      onUserInteraction?.call();
    };

    notification.onClickAction = (int actionIndex) {
      onUserInteraction?.call();
    };

    notification.onClose = (LocalNotificationCloseReason reason) {
      onUserInteraction?.call();
    };

    await notification.show();
  }
}
