import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late FirebaseMessaging _firebaseMessaging;

  NotificationHelper() {
    _firebaseMessaging = FirebaseMessaging.instance;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _configureFirebaseMessaging();
  }

  Future<void> _configureFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundNotification(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundNotification(message.data);
    });

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('app_icon');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {

        },);

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: androidInitializationSettings,
        iOS: initializationSettingsDarwin,

    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
        onSelectNotification(payload);
      }
    },
      onDidReceiveBackgroundNotificationResponse: (payload) async {
        if (payload != null) {
          debugPrint('background notification payload: $payload');
          onSelectNotification(payload);
        }
      },
    );

  }

  Future<void> showNotification({
    int id = 0,
    String title = 'Title',
    String body = 'Body',
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

     const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _handleForegroundNotification(Map<String, dynamic> data) {
    final String title = data['title'] ?? 'Foreground Title';
    final String body = data['body'] ?? 'Foreground Body';

    showNotification(title: title, body: body);
  }

  void _handleBackgroundNotification(Map<String, dynamic> data) {
    final String title = data['title'] ?? 'Background Title';
    final String body = data['body'] ?? 'Background Body';

    showNotification(title: title, body: body);
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    final String title = message.data['title'] ?? 'Background Title';
    final String body = message.data['body'] ?? 'Background Body';

    showNotification(title: title, body: body);
  }

  //handle onTap notification
  Future<void> onSelectNotification(NotificationResponse? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }
}
