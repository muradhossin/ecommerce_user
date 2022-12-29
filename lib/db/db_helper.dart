import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/models/cart_model.dart';
import 'package:ecommerce_user/models/comment_model.dart';
import 'package:ecommerce_user/models/notification_model.dart';
import 'package:ecommerce_user/models/order_model.dart';
import 'package:ecommerce_user/models/rating_model.dart';
import 'package:ecommerce_user/models/user_model.dart';

import '../models/category_model.dart';
import '../models/order_constant_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

class DbHelper {
  static const String collectionAdmin = 'Admins';
  static final _db = FirebaseFirestore.instance;

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addUser(UserModel userModel) {
    final doc = _db.collection(collectionUser).doc(userModel.userId!);
    return doc.set(userModel.toMap());
  }

  static Future<void> addRating(RatingModel ratingModel) {
    final ratingDoc = _db
        .collection(collectionProduct)
        .doc(ratingModel.productId)
        .collection(collectionRating)
        .doc(ratingModel.userModel.userId);
    return ratingDoc.set(ratingModel.toMap());
  }

  static Future<void> addCategory(CategoryModel categoryModel) {
    final catDoc = _db.collection(collectionCategory).doc();
    categoryModel.categoryId = catDoc.id;
    return catDoc.set(categoryModel.toMap());
  }

  static Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    final wb = _db.batch();
    final productDoc = _db.collection(collectionProduct).doc();
    final purchaseDoc = _db.collection(collectionPurchase).doc();
    productModel.productId = productDoc.id;
    purchaseModel.productId = productDoc.id;
    purchaseModel.purchaseId = purchaseDoc.id;
    wb.set(productDoc, productModel.toMap());
    wb.set(purchaseDoc, purchaseModel.toMap());
    final updatedCount =
        purchaseModel.purchaseQuantity + productModel.category.productCount;
    final catDoc = _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId);
    wb.update(catDoc, {categoryFieldProductCount: updatedCount});
    return wb.commit();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
          String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionUtils).doc(documentOrderConstants).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Future<QuerySnapshot<Map<String, dynamic>>> getRatingsByProduct(
          String productId) =>
      _db
          .collection(collectionProduct)
          .doc(productId)
          .collection(collectionRating)
          .get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() => _db
      .collection(collectionProduct)
      .where(productFieldAvailable, isEqualTo: true)
      .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPurchases() =>
      _db.collection(collectionPurchase).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
          String categoryName) =>
      _db
          .collection(collectionProduct)
          .where('$productFieldCategory.$categoryFieldName',
              isEqualTo: categoryName)
          .snapshots();

  static Future<void> updateUserProfileField(
      String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser).doc(uid).update(map);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllPurchaseByProductId(
          String productId) =>
      _db
          .collection(collectionPurchase)
          .where(purchaseFieldProductId, isEqualTo: productId)
          .get();

  static Future<void> repurchase(
      PurchaseModel purchaseModel, ProductModel productModel) async {
    final wb = _db.batch();
    final doc = _db.collection(collectionPurchase).doc();
    purchaseModel.purchaseId = doc.id;
    wb.set(doc, purchaseModel.toMap());
    final productDoc =
        _db.collection(collectionProduct).doc(productModel.productId);
    wb.update(productDoc, {
      productFieldStock: (productModel.stock + purchaseModel.purchaseQuantity)
    });
    final snapshot = await _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId)
        .get();
    final previousCount = snapshot.data()?[categoryFieldProductCount] ?? 0;
    final catDoc = _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId);
    wb.update(catDoc, {
      categoryFieldProductCount:
          (purchaseModel.purchaseQuantity + previousCount)
    });
    return wb.commit();
  }

  static Future<void> updateOrderConstants(OrderConstantModel model) {
    return _db
        .collection(collectionUtils)
        .doc(documentOrderConstants)
        .update(model.toMAp());
  }

  static Future<void> updateProductField(
      String productId, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(productId).update(map);
  }

  static Future<void> addComment(CommentModel commentModel) {
    final doc = _db
        .collection(collectionProduct)
        .doc(commentModel.productId)
        .collection(collectionComment)
        .doc();
    commentModel.commentId = doc.id;
    return doc.set(commentModel.toMap());
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getCommentsByProduct(
          String productId) =>
      _db
          .collection(collectionProduct)
          .doc(productId)
          .collection(collectionComment)
          .where(commentFieldApproved, isEqualTo: true)
          .get();

  static Future<void> addToCart(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCartItemsByUser(
          String uid) =>
      _db
          .collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();

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

  static Future<void> saveOrder(OrderModel orderModel) async {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc(orderModel.orderId);
    wb.set(orderDoc, orderModel.toMap());
    for (final cardModel in orderModel.productDetails) {
      final proSnapshot = await _db
          .collection(collectionProduct)
          .doc(cardModel.productId)
          .get();
      final productModel = ProductModel.fromMap(proSnapshot.data()!);
      final catSnapshot = await _db
          .collection(collectionCategory)
          .doc(productModel.category.categoryId)
          .get();
      final categoryModel = CategoryModel.fromMap(catSnapshot.data()!);
      final newStock = productModel.stock - cardModel.quantity;
      final newProductCountInCategory =
          categoryModel.productCount - cardModel.quantity;
      final proDoc = _db.collection(collectionProduct).doc(cardModel.productId);
      final catDoc = _db
          .collection(collectionCategory)
          .doc(productModel.category.categoryId);
      wb.update(proDoc, {productFieldStock: newStock});
      wb.update(catDoc, {categoryFieldProductCount: newProductCountInCategory});
    }
    final userDoc = _db.collection(collectionUser).doc(orderModel.userId);
    wb.update(
        userDoc, {userFieldAddressModel: orderModel.deliveryAddress.toMap()});
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByUser(
          String uid) =>
      _db
          .collection(collectionOrder)
          .where(orderFieldUserId, isEqualTo: uid)
          .snapshots();

  static Future<void> addNotification(NotificationModel notification) {
    return _db
        .collection(collectionNotification)
        .doc(notification.id)
        .set(notification.toMap());
  }
}
