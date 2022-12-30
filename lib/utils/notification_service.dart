import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  NotificationService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }

  Future<void> sendNotification(RemoteMessage message) async{
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, message.notification!.title, message.notification!.body, notificationDetails,
        payload: 'item x');
  }
}