import 'package:ecommerce_user/view/notification/models/notification_model.dart';
import 'package:ecommerce_user/view/notification/repository/notification_repository.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider extends ChangeNotifier {

  Future<void> addNotification(NotificationModel notification) {
    return NotificationRepository.addNotification(notification);
  }


}