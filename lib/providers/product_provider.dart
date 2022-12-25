import 'dart:io';

import 'package:ecommerce_user/auth/auth_service.dart';
import 'package:ecommerce_user/models/comment_model.dart';
import 'package:ecommerce_user/models/notification_model.dart';
import 'package:ecommerce_user/models/rating_model.dart';
import 'package:ecommerce_user/models/user_model.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/image_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../utils/constants.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];
  List<PurchaseModel> purchaseList = [];

  Future<void> addCategory(String category) {
    final categoryModel = CategoryModel(
      categoryName: category,
    );
    return DbHelper.addCategory(categoryModel);
  }

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryList.sort((model1, model2) =>
          model1.categoryName.compareTo(model2.categoryName));
      notifyListeners();
    });
  }

  List<CategoryModel> getCategoriesForFiltering() {
    return <CategoryModel>[
      CategoryModel(categoryName: "All"),
      ...categoryList,
    ];
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllPurchases() {
    DbHelper.getAllPurchases().listen((snapshot) {
      purchaseList = List.generate(snapshot.docs.length,
          (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(String categoryName) {
    DbHelper.getAllProductsByCategory(categoryName).listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<List<CommentModel>> getCommentsByProduct(String productId) async{
    final snapshot = await DbHelper.getCommentsByProduct(productId);
    final commentList = List.generate(snapshot.docs.length, (index) => CommentModel.fromMap(snapshot.docs[index].data()));
    return commentList;
  }

  Future<ImageModel> uploadImage(String path) async {
    final imageName = 'pro_${DateTime.now().millisecondsSinceEpoch}';
    final imageRef = FirebaseStorage.instance
        .ref()
        .child('$firebaseStorageProductImageDir/$imageName');
    final uploadTask = imageRef.putFile(File(path));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return ImageModel(
      title: imageName,
      imageDownloadUrl: downloadUrl,
    );
  }

  Future<void> deleteImage(String url) {
    return FirebaseStorage.instance.refFromURL(url).delete();
  }

  Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    return DbHelper.addNewProduct(productModel, purchaseModel);
  }

  Future<void> addRating(
      String productId, double rating, UserModel userModel) async {
    final ratingModel = RatingModel(
      ratingId: AuthService.currentUser!.uid,
      userModel: userModel,
      productId: productId,
      rating: rating,
    );
    await DbHelper.addRating(ratingModel);
    final snapshot = await DbHelper.getRatingsByProduct(productId);
    final ratingModelList = List.generate(snapshot.docs.length,
        (index) => RatingModel.fromMap(snapshot.docs[index].data()));
    double totalRating = 0.0;
    for (var model in ratingModelList) {
      totalRating += model.rating;
    }
    final avgRating = totalRating / ratingModelList.length;
    return updateProductField(
        ratingModel.productId, productFieldAvgRating, avgRating);
  }

  Future<void> updateProductField(
      String productId, String field, dynamic value) {
    return DbHelper.updateProductField(productId, {field: value});
  }

  List<PurchaseModel> getPurchaseByProductId(String productId) {
    return purchaseList
        .where((element) => element.productId == productId)
        .toList();
  }

  Future<void> repurchase(
      PurchaseModel purchaseModel, ProductModel productModel) {
    return DbHelper.repurchase(purchaseModel, productModel);
  }

  double priceAfterDiscount(num price, num discount) {
    final discountAmount = (price * discount) / 100;
    return price - discountAmount;
  }

  Future<void> addComment(CommentModel commentModel) {
    return DbHelper.addComment(commentModel);
  }

  addNotification(NotificationModel notification) {
    return DbHelper.addNotification(notification);
  }
}
