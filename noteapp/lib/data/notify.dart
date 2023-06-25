import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification(BuildContext context) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          if (payload == '/password') {
            Navigator.pushNamed(context, '/password');
          }
        });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'testa',
            importance: Importance.max,
            ongoing: true,
            playSound: false,
            sound: RawResourceAndroidNotificationSound(''),
            vibrationPattern: Int64List.fromList([0, 500]),
            // playSound: false,
            // autoCancel: false,
            additionalFlags: Int32List.fromList(<int>[4])),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channelId',
      'Note App',
      importance: Importance.max,
      playSound: false,
      styleInformation: BigTextStyleInformation(
        body ?? '',
        contentTitle: title,
        summaryText: 'Note App',
      ),
    );
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload ?? '',
    );
  }
}
