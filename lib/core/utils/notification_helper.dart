import 'dart:convert';

import 'package:ecommerce_user/core/constants/constants.dart';
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/view/notification/models/notification_body.dart';
import 'package:ecommerce_user/view/notification/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main.dart';

class NotificationHelper {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationHelper() {
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
    String? payload,
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
      payload: payload,


    );
  }




  //handle onTap notification
  Future<void> onSelectNotification(NotificationResponse? payload) async {
    if (payload != null) {
      NotificationBody? notificationModel = NotificationBody.fromMap(jsonDecode(payload.payload!));
      debugPrint('----------> notificationModel: ${notificationModel.toMap()}');
      debugPrint('notification payload: ${jsonDecode(payload.payload!)}}');
      
      if(notificationModel.type == NotificationType.order){
        navigatorKey.currentState!.pushNamed(AppRouter.getOrderRoute());
      }
      

    }
  }

  //handle notification when app is in background
  Future<void> _handleBackgroundNotification(RemoteMessage remoteMessage) async {
    debugPrint('onBackgroundMessage: ${remoteMessage.toMap()}');
    NotificationBody notificationModel = NotificationBody.fromMap(remoteMessage.data);

    onSelectNotification(NotificationResponse(payload: jsonEncode(notificationModel.toMap()), notificationResponseType: NotificationResponseType.selectedNotification));

    // showNotification(
    //   id: 0,
    //   title: remoteMessage.notification!.title!,
    //   body: remoteMessage.notification!.body!,
    // );
  }

  //handle notification when app is in foreground
  Future<void> _handleForegroundNotification(RemoteMessage remoteMessage) async {
    debugPrint('onMessage: ${remoteMessage.toMap()}');
   
    debugPrint('----------> notificationData: ${remoteMessage.data}');
    NotificationBody notificationModel = NotificationBody.fromMap(remoteMessage.data);
    debugPrint('----------> notificationModel: ${notificationModel.toMap()}');

    debugPrint('----------> notificationModelBG: ${notificationModel?.toMap()}');
    showNotification(
      id: 0,
      title: remoteMessage.notification!.title!,
      body: remoteMessage.notification!.body!,
      payload: jsonEncode(notificationModel.toMap()),
    );
  }

}
