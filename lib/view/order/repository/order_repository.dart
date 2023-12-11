import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/view/order/models/order_constant_model.dart';
import 'package:ecommerce_user/view/order/models/order_model.dart';
import 'package:ecommerce_user/view/category/models/category_model.dart';
import 'package:ecommerce_user/view/product/models/product_model.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';

class OrderRepository {
  static final _db = FirebaseFirestore.instance;

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionUtils).doc(documentOrderConstants).snapshots();

  static Future<void> updateOrderConstants(OrderConstantModel model) {
    return _db
        .collection(collectionUtils)
        .doc(documentOrderConstants)
        .update(model.toMAp());
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
}