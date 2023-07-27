import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'message_model.dart' as fcMessage;

class FlutterNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android:
                AndroidInitializationSettings('@mipmap/splash_screen_icon'));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage remoteMessage) {
    fcMessage.Message messages =
        fcMessage.Message.fromJson(json.decode(remoteMessage.data["message"]));
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              'smart-grounds', "smart-grounds channel",
              importance: Importance.max,
              priority: Priority.high,
              ));
      _flutterLocalNotificationsPlugin.show(id, messages.notification?.title,
          messages.notification?.body, notificationDetails);
    } on Exception catch (e) {
      print(e);
    }
  }
}


