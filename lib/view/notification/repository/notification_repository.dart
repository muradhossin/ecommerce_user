import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/core/constants/app_constants.dart';
import 'package:ecommerce_user/view/notification/models/notification_body.dart';
import 'package:ecommerce_user/view/notification/models/notification_model.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  static final _db = FirebaseFirestore.instance;


  static Future<void> addFcmToken(String userId, String fcmToken) async {
    return _db.collection(collectionUser).doc(userId).update(
        {'fcm_token': fcmToken}
    );

  }

  static Future<void> addNotification(NotificationModel notification) {
    return _db
        .collection(collectionNotification)
        .doc(notification.id)
        .set(notification.toMap());
  }

  static Future<void> sendNotification(NotificationModel notificationModel, String fcmToken) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=${AppConstants.serverKey}', // replace with your server key
    };
    NotificationBody notification = NotificationBody(
      id: notificationModel.orderModel?.orderId ?? '',
      type: notificationModel.type,
      body: 'your order ID: ${notificationModel.orderModel?.orderId} is placed successfully',
      title: 'Order Placed',
    );
    final body = jsonEncode({
      'to': fcmToken, // replace with the device token
      'notification': {
        'title': 'Order Placed',
        'body': 'your order ID: ${notificationModel.orderModel?.orderId} is placed successfully',
        'type' : '',
        'id' : '${notificationModel.orderModel?.orderId}',
      },
      'data': notification.toMap(),
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      debugPrint('Notification sent successfully');
    } else {
      debugPrint('Failed to send notification: ${response.body}');
    }
  }
}
