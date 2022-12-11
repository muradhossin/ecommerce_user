import 'package:ecommerce_user/auth/auth_service.dart';
import 'package:ecommerce_user/db/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  getAllCartItemsByUser() {
    DbHelper.getCartItemsByUser(AuthService.currentUser!.uid)
        .listen((snapshot) {
      cartList = List.generate(snapshot.docs.length,
          (index) => CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });

  }

  Future<void> addToCart({
    required String productId,
    required String productName,
    required String url,
    required num salePrice,
  }) {
    final cartModel = CartModel(
      productId: productId,
      productName: productName,
      productImageUrl: url,
      salePrice: salePrice,
    );
    return DbHelper.addToCart(AuthService.currentUser!.uid, cartModel);
  }

  bool isProductInCart(String productId){
    bool tag = false;
    for(final cartModel in cartList){
      if(cartModel.productId == productId){
        tag = true;
        break;
      }
    }
    return tag;
  }

  Future<void> removeFromCart(String productId) {
    return DbHelper.removeFromCart(AuthService.currentUser!.uid, productId);
  }

}
