import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/view/checkout/models/purchase_model.dart';
import 'package:ecommerce_user/view/category/models/category_model.dart';
import 'package:ecommerce_user/view/product/models/comment_model.dart';
import 'package:ecommerce_user/view/product/models/product_model.dart';
import 'package:ecommerce_user/view/product/models/rating_model.dart';

class ProductRepository {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addRating(RatingModel ratingModel) {
    final ratingDoc = _db
        .collection(collectionProduct)
        .doc(ratingModel.productId)
        .collection(collectionRating)
        .doc(ratingModel.userModel.userId);
    return ratingDoc.set(ratingModel.toMap());
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


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
      String categoryName) =>
      _db
          .collection(collectionProduct)
          .where('$productFieldCategory.$categoryFieldName',
          isEqualTo: categoryName)
          .snapshots();


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
}
