import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/main.dart';
import 'flutter_notifications.dart';
import '../screens/records/view/addRecords.dart';
import '../../database/firebase_data/database.dart';
import 'package:http/http.dart' as https;

class FirebasePushMessaging {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static late final fCMToken;
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    fCMToken = await _firebaseMessaging.getToken();
    print(fCMToken);
    await DataBase().registerDeviceTokens(fCMToken);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.data);
        print(message.notification?.body);
        print(message.notification?.android?.clickAction);
        navigatorKey.currentState
            ?.push(MaterialPageRoute(builder: (context) => AddRecords()));
      }
    });

    FirebaseMessaging.onMessage.listen(FlutterNotifications.display);
    FirebaseMessaging.onMessageOpenedApp.listen(FlutterNotifications.display);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  static Future<String> scheduleNotification(
      {required String title,
      required String content,
      required String date,
      required String time}) async {
    print(date);
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, String> data = {
      "date": date,
      "time": time,
      "title": title,
      "content": content
    };
    String body = jsonEncode(data);
    https.Response response = await https.post(
        Uri.parse(
            "http://192.168.212.136:4000/smart-grounds/api/send-event-notification"),
        headers: headers,
        body: body);
    return response.body;
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  FlutterNotifications.display(message);
  print('App is Terminated');
}
