import 'package:ecommerce_user/view/auth/services/auth_service.dart';
import 'package:ecommerce_user/view/product/models/product_model.dart';
import 'package:ecommerce_user/view/wishlist/repository/wishlist_repository.dart';
import 'package:flutter/cupertino.dart';

class WishListProvider extends ChangeNotifier {
  List<ProductModel> wishList = [];


  Future<void>  addToWishList(ProductModel productModel) {
    return WishListRepository.addToWishList(AuthService.currentUser!.uid, productModel);
  }

  bool isProductInWishList(String s) {
    bool tag = false;
    for(final productModel in wishList){
      if(productModel.productId == s){
        tag = true;
        break;
      }
    }
    return tag;
  }

  getAllWishListProductsByUser() {
    WishListRepository.getAllWishListProductsByUser(AuthService.currentUser!.uid)
        .listen((snapshot) {
      wishList = List.generate(snapshot.docs.length,
              (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });

  }
  Future<void> removeFromWishList(String productId) {
    return WishListRepository.removeFromWishList(AuthService.currentUser!.uid, productId);
  }
}