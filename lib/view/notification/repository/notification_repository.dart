import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/view/notification/models/notification_model.dart';

class NotificationRepository {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addNotification(NotificationModel notification) {
    return _db
        .collection(collectionNotification)
        .doc(notification.id)
        .set(notification.toMap());
  }
}
