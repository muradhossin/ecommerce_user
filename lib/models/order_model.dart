import 'package:ecommerce_user/models/address_model.dart';
import 'package:ecommerce_user/models/cart_model.dart';
import 'package:ecommerce_user/models/date_model.dart';

const String collectionOrder = 'Order';

const String orderFieldOrderId = 'orderId';
const String orderFieldUserId = 'userId';
const String orderFieldGrandTotal = 'grandTotal';
const String orderFieldDiscount = 'discount';
const String orderFieldVAT = 'VAT';
const String orderFieldOrderStatus = 'orderStatus';
const String orderFieldPaymentMethod = 'paymentMethod';
const String orderFieldOrderDate = 'orderDate';
const String orderFieldDeliveryAddress = 'deliveryAddress';
const String orderFieldProductDetails = 'productDetails';

class OrderModel {
  String orderId;
  String userId;
  String orderStatus;
  String paymentMethod;
  num grandTotal;
  num discount;
  num VAT;
  DateModel orderDate;
  AddressModel deliveryAddress;
  List<CartModel> productDetails;

  OrderModel(
      {required this.orderId,
      required this.userId,
      required this.orderStatus,
      required this.paymentMethod,
      required this.grandTotal,
      required this.discount,
      required this.VAT,
      required this.orderDate,
      required this.deliveryAddress,
      required this.productDetails});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      orderFieldOrderId: orderId,
      orderFieldUserId: userId,
      orderFieldOrderStatus: orderStatus,
      orderFieldPaymentMethod: paymentMethod,
      orderFieldGrandTotal: grandTotal,
      orderFieldDiscount: discount,
      orderFieldVAT: VAT,
      orderFieldOrderDate: orderDate.toMap(),
      orderFieldDeliveryAddress: deliveryAddress.toMap(),
      orderFieldProductDetails: List.generate(
          productDetails.length, (index) => productDetails[index].toMap()),
    };
  }
}
