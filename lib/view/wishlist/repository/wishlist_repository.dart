import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/core/constants/constants.dart';
import 'package:ecommerce_user/view/cart/models/cart_model.dart';
import 'package:ecommerce_user/view/product/models/product_model.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';

class WishListRepository {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addToWishList(String uid, ProductModel productModel) {
    return _db
      .collection(collectionUser)
      .doc(uid)
      .collection(collectionWishlist)
      .doc(productModel.productId)
      .set(productModel.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllWishListProductsByUser(String uid) {
    return _db.collection(collectionUser).doc(uid).collection(collectionWishlist).snapshots();
  }

  static Future<void> removeFromWishList(String uid, String productId) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionWishlist)
        .doc(productId)
        .delete();
  }
}