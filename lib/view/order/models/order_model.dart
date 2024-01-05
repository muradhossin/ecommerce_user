
import 'package:ecommerce_user/view/cart/models/cart_model.dart';
import 'package:ecommerce_user/view/checkout/models/contact_info_model.dart';
import 'package:ecommerce_user/view/order/models/date_model.dart';
import 'package:ecommerce_user/view/user/models/address_model.dart';

const String collectionOrder = 'Order';

const String orderFieldOrderId = 'orderId';
const String orderFieldUserId = 'userId';
const String orderFieldGrandTotal = 'grandTotal';
const String orderFieldDiscount = 'discount';
const String orderFieldVAT = 'VAT';
const String orderFieldDeliveryCharge = 'deliveryCharge';
const String orderFieldOrderStatus = 'orderStatus';
const String orderFieldPaymentMethod = 'paymentMethod';
const String orderFieldOrderDate = 'orderDate';
const String orderFieldDeliveryAddress = 'deliveryAddress';
const String orderFieldProductDetails = 'productDetails';
const String orderFieldContactInfo = 'contactInfo';

class OrderModel {
  String orderId;
  String userId;
  String orderStatus;
  String paymentMethod;
  num grandTotal;
  num discount;
  num VAT;
  num deliveryCharge;
  DateModel orderDate;
  AddressModel deliveryAddress;
  ContactInfoModel contactInfo;
  List<CartModel> productDetails;

  OrderModel(
      {required this.orderId,
      required this.userId,
      required this.orderStatus,
      required this.paymentMethod,
      required this.grandTotal,
      required this.discount,
      required this.VAT,
      required this.deliveryCharge,
      required this.orderDate,
      required this.deliveryAddress,
      required this.productDetails,
      required this.contactInfo,
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      orderFieldOrderId: orderId,
      orderFieldUserId: userId,
      orderFieldOrderStatus: orderStatus,
      orderFieldPaymentMethod: paymentMethod,
      orderFieldGrandTotal: grandTotal,
      orderFieldDiscount: discount,
      orderFieldVAT: VAT,
      orderFieldDeliveryCharge: deliveryCharge,
      orderFieldOrderDate: orderDate.toMap(),
      orderFieldDeliveryAddress: deliveryAddress.toMap(),
      orderFieldContactInfo: contactInfo.toMap(),
      orderFieldProductDetails: List.generate(
          productDetails.length, (index) => productDetails[index].toMap()),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        orderId: map[orderFieldOrderId],
        userId: map[orderFieldUserId],
        orderStatus: map[orderFieldOrderStatus],
        paymentMethod: map[orderFieldPaymentMethod],
        grandTotal: map[orderFieldGrandTotal],
        discount: map[orderFieldDiscount],
        VAT: map[orderFieldVAT],
        deliveryCharge: map[orderFieldDeliveryCharge],
        orderDate: DateModel.fromMap(map[orderFieldOrderDate]),
        deliveryAddress: AddressModel.fromMap(map[orderFieldDeliveryAddress]),
        contactInfo: ContactInfoModel.fromMap(map[orderFieldContactInfo] ?? {}),
        productDetails: (map[orderFieldProductDetails] as List)
            .map((e) => CartModel.fromMap(e))
            .toList(),
      );
}
