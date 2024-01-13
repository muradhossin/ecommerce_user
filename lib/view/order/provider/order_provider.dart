import 'package:ecommerce_user/view/auth/services/auth_service.dart';
import 'package:ecommerce_user/view/cart/repository/cart_repository.dart';
import 'package:ecommerce_user/view/order/models/order_item_model.dart';
import 'package:ecommerce_user/view/order/models/order_model.dart';
import 'package:ecommerce_user/view/order/repository/order_repository.dart';
import 'package:flutter/material.dart';

import '../models/order_constant_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();
  List<OrderModel> orderList = [];
  List<OrderItem> orderItemList = [];

  getOrderConstants() {
    OrderRepository.getOrderConstants().listen((snapshot) {
      if (snapshot.exists) {
        orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  getOrdersByUser() {
    OrderRepository.getOrdersByUser(AuthService.currentUser!.uid).listen((snapshot) {
      orderList = List.generate(snapshot.docs.length, (index) => OrderModel.fromMap(snapshot.docs[index].data()));
      orderItemList = orderList.map((order) => OrderItem(orderModel: order)).toList();
      notifyListeners();
    });
  }


  Future<void> updateOrderConstants(OrderConstantModel model) {
    return OrderRepository.updateOrderConstants(model);
  }

  int getDiscountAmount(num subtotal) {
    return ((subtotal * orderConstantModel.discount) / 100).round();
  }

  int getVatAmount(num cartSubTotal) {
    final priceAfterDiscount = cartSubTotal - getDiscountAmount(cartSubTotal);
    return ((priceAfterDiscount * orderConstantModel.vat) / 100).round();
  }

  int getGrandTotal(num cartSubTotal) {
    return ((cartSubTotal - getDiscountAmount(cartSubTotal)) +
        getVatAmount(cartSubTotal) +
        orderConstantModel.deliveryCharge).round();
  }

  Future<void> saveOrder(OrderModel orderModel) async {
    await OrderRepository.saveOrder(orderModel);
    return CartRepository.clearCart(orderModel.userId, orderModel.productDetails);
  }

  void toggleExpansion(int panelIndex) {
    orderItemList[panelIndex].isExpanded = !orderItemList[panelIndex].isExpanded;
    notifyListeners();
  }


}
