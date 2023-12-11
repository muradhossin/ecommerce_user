const String firebaseStorageProductImageDir = 'ProductImages';
const String currencySymbol = '৳';

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
  static const String comment = 'New Comment';
  static const String order = 'New Order';
  static const String user = 'New User';
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