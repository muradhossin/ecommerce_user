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
      _handleForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundNotification(message);
    });

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

    NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      debugPrint('App was opened by a notification');
    }


    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onSelectNotification);

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




  //handle onTap notification
  Future<void> onSelectNotification(NotificationResponse? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  //handle notification when app is in background
  Future<void> _handleBackgroundNotification(RemoteMessage remoteMessage) async {
    debugPrint('onBackgroundMessage: $remoteMessage');
    // showNotification(
    //   id: 0,
    //   title: remoteMessage.notification!.title!,
    //   body: remoteMessage.notification!.body!,
    // );
  }

  //handle notification when app is in foreground
  Future<void> _handleForegroundNotification(RemoteMessage remoteMessage) async {
    debugPrint('onMessage: $remoteMessage');
    showNotification(
      id: 0,
      title: remoteMessage.notification!.title!,
      body: remoteMessage.notification!.body!,
    );
  }
}
