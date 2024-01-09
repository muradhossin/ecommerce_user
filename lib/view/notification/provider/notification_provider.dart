import 'package:ecommerce_user/view/notification/models/notification_model.dart';
import 'package:ecommerce_user/view/notification/repository/notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider extends ChangeNotifier {
  String _fcmToken = '';

  //Fcm token
  Future<void> getFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    _fcmToken = token!;
    notifyListeners();
  }

  Future<void> addNotification(NotificationModel notification) {
    return NotificationRepository.addNotification(notification);
  }

  //add fcm token
  Future<void> addFcmToken(String userId) {
    return NotificationRepository.addFcmToken(userId, _fcmToken);
  }

  //send notification
  Future<void> sendNotification(NotificationModel notificationModel) {
    return NotificationRepository.sendNotification(notificationModel, _fcmToken);
  }



}