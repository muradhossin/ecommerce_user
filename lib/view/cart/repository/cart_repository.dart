import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/view/cart/models/cart_model.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';

class CartRepository {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addToCart(String uid, CartModel cartModel) {
    return _db
      .collection(collectionUser)
      .doc(uid)
      .collection(collectionCart)
      .doc(cartModel.productId)
      .set(cartModel.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCartItemsByUser(String uid) {
    return _db.collection(collectionUser).doc(uid).collection(collectionCart).snapshots();
  }

  static Future<void> removeFromCart(String uid, String productId) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(productId)
        .delete();
  }

  static Future<void> updateCartQuantity(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }

  static Future<void> clearCart(String uid, List<CartModel> cartList) {
    final wb = _db.batch();
    for (final cartModel in cartList) {
      final doc = _db
          .collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .doc(cartModel.productId);
      wb.delete(doc);
    }
    return wb.commit();
  }

}