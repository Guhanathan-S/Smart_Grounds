class Message {
  late final Notification? notification;
  late final Android? android;
  late final Ios? iOS;
  late final WebPush? webPush;
  late final FcmOptions? fcmOptions;
  late final Map<String, dynamic>? data;

  Message(
      {required this.notification,
      required this.android,
      required this.iOS,
      required this.webPush,
      required this.fcmOptions,
      required this.data});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        notification: json["notification"] != null
            ? Notification.fromJson(json["notification"]!)
            : null,
        android:
            json["android"] != null ? Android.fromJson(json["android"]) : null,
        iOS: json["apns"] != null ? Ios() : null,
        webPush: json["webpush"] != null ? WebPush() : null,
        fcmOptions: json["fcm_options"] != null ? FcmOptions() : null,
        data: json["data"]);
  }
}

class Notification {
  late final String? title;
  late final String? body;
  late final String? image;
  Notification({required this.title, required this.body, required this.image});
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
        title: json["title"] ?? null,
        body: json["body"] ?? null,
        image: json["image"] ?? null);
  }
}

class Android {
  late final AndroidNotification? androidNotification;
  Android({this.androidNotification});
  factory Android.fromJson(Map<String, dynamic> json) {
    return Android(
        androidNotification: json["notification"] != null
            ? AndroidNotification.fromJson(json["notification"]!)
            : null);
  }
}

class AndroidNotification {
  late final String? clickAction;
  AndroidNotification({this.clickAction});
  factory AndroidNotification.fromJson(Map<String, dynamic> json) {
    return AndroidNotification(clickAction: json["click_action"]);
  }
}

class Ios {}

class WebPush {}

class FcmOptions {}

class Data {}
