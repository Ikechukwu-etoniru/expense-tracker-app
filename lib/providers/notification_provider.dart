import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
         const AndroidInitializationSettings('noti_logo');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future stylishNotification(String title, String description) async {
    var android = const AndroidNotificationDetails('channelId', 'channelName',
        channelDescription: 'channel description',
        color: Color(0xff010a42),
        enableVibration: true,
        icon: 'noti_logo',
        largeIcon: DrawableResourceAndroidBitmap('icon'),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    var platform = NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
      1,
      title,
      description,
      platform,
    );
  }

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
