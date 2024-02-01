const String firebaseStorageProductImageDir = 'ProductImages';
const String firebaseStorageUserImageDir = 'UserImages';
const String currencySymbol = '৳';
const String collectionWishlist = 'WishList';

abstract class OrderStatus{
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
  static const String returned = 'Returned';
}

abstract class PaymentMethod{
  static const String cod = 'Cash on Delivery';
  static const String online = 'Online Payment';
}

abstract class NotificationType{
  static const String comment = 'new_comment';
  static const String order = 'order';
  static const String user = 'new_user';
}

abstract class NotificationTopic{
  static const String order = 'order';
  static const String promo = 'promo';
  static const String user = 'user';
}

const cities = [
  'Dhaka',
  'Chittagong',
  'Rajshahi',
  'Barishal',
  'Comila',
  'Noakhali',
  'Khulna',
  'Satkhira',
  'Patuakhali',
  'Syllet',
  'Coz Bazar'
];