import 'dart:convert';

import 'package:ecommerce_user/core/constants/constants.dart';
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/view/notification/models/notification_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main.dart';
import '../../view/promo/promo_code_page.dart';

class NotificationHelper {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationHelper() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _configureFirebaseMessaging();
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: initializationSettingsDarwin,);

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


  Future<void> _configureFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleBackgroundNotification(message);
    });

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


  //handle notification when app is in foreground
  Future<void> _handleForegroundNotification(RemoteMessage remoteMessage) async {
    debugPrint('onMessage: ${remoteMessage.toMap()}');
   
    debugPrint('----------> notificationData: ${remoteMessage.data}');
    NotificationBody notificationModel = NotificationBody.fromMap(remoteMessage.data);
    debugPrint('----------> notificationModel: ${notificationModel.toMap()}');

    debugPrint('----------> notificationModelBG: ${notificationModel.toMap()}');
    showNotification(
      id: 0,
      title: remoteMessage.notification!.title!,
      body: remoteMessage.notification!.body!,
      payload: jsonEncode(notificationModel.toMap()),
    );
  }

  static Future<void> handleBackgroundNotification(RemoteMessage remoteMessage) async{
    debugPrint('onMessageOpenedApp: ${remoteMessage.toMap()}');

    if(remoteMessage.data['type'] == NotificationType.order){
      navigatorKey.currentState!.pushNamed(AppRouter.getOrderRoute());
    }else if(remoteMessage.data['key'] == 'promo'){
      navigatorKey.currentState!.pushNamed(PromoCodePage.routeName, arguments: remoteMessage.data['value']);
    }else if(remoteMessage.data['key'] == 'user'){
      navigatorKey.currentState!.pushNamed(AppRouter.getUserProfileRoute());
    }

  }

  static Future<bool> checkNotificationPermission() async{
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      return true;
    }
    return false;
  }

  static Future<void> requestNotificationPermission() async{
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }





}
