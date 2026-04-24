import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Can be implemented if background execution is required
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  VoidCallback? _onUserInteraction;

  Future<void> initialize() async {
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: false,
          notificationCategories: [
            DarwinNotificationCategory(
              'focus_phase_category',
              actions: <DarwinNotificationAction>[
                DarwinNotificationAction.plain(
                  'stop_alarm_action',
                  'Stop alarm',
                ),
              ],
              options: <DarwinNotificationCategoryOption>{
                DarwinNotificationCategoryOption.customDismissAction,
              },
            ),
          ],
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(macOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onUserInteraction?.call();
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
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

    _onUserInteraction = onUserInteraction;

    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentSound: false,
          presentAlert: true,
          presentBadge: true,
          presentBanner: true,
          categoryIdentifier: 'focus_phase_category',
          interruptionLevel: InterruptionLevel.timeSensitive,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      macOS: darwinPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 0, // fixed ID for replacement mode
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
    );
  }
}
