import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  NotificationService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
     var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }

  //show notification
  Future<void> showNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'app_icon',
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );

    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}