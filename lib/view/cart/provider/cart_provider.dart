import 'package:ecommerce_user/view/cart/repository/cart_repository.dart';
import 'package:flutter/material.dart';

import '../../auth/services/auth_service.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  num priceWithQuantity(CartModel cartModel) {
    return cartModel.quantity * cartModel.salePrice;
  }

  getAllCartItemsByUser() {
    CartRepository.getCartItemsByUser(AuthService.currentUser!.uid)
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
    return CartRepository.addToCart(AuthService.currentUser!.uid, cartModel);
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
    return CartRepository.removeFromCart(AuthService.currentUser!.uid, productId);
  }

  void decreaseQuantity(CartModel cartModel) {
    if(cartModel.quantity > 1){
      cartModel.quantity -= 1;
      CartRepository.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
    }
  }

  void increaseQuantity(CartModel cartModel) {
    cartModel.quantity += 1;
    CartRepository.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
  }

  num getCartSubTotal(){
    num total = 0;
    for(final cartModel in cartList){
      total += priceWithQuantity(cartModel);
    }
    return total;
  }

  Future<void> clearCart() {
    return CartRepository.clearCart(AuthService.currentUser!.uid, cartList);
  }

}
