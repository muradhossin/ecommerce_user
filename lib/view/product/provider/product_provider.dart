import 'dart:io';

import 'package:ecommerce_user/view/auth/services/auth_service.dart';
import 'package:ecommerce_user/view/product/models/comment_model.dart';
import 'package:ecommerce_user/view/product/models/rating_model.dart';
import 'package:ecommerce_user/view/product/repository/product_repository.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/image_model.dart';
import '../models/product_model.dart';
import '../../checkout/models/purchase_model.dart';
import '../../../core/constants/constants.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];


  getAllProducts() {
    ProductRepository.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }



  getAllProductsByCategory(String categoryName) {
    ProductRepository.getAllProductsByCategory(categoryName).listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<List<CommentModel>> getCommentsByProduct(String productId) async{
    final snapshot = await ProductRepository.getCommentsByProduct(productId);
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
    return ProductRepository.addNewProduct(productModel, purchaseModel);
  }

  Future<void> addRating(
      String productId, double rating, UserModel userModel) async {
    final ratingModel = RatingModel(
      ratingId: AuthService.currentUser!.uid,
      userModel: userModel,
      productId: productId,
      rating: rating,
    );
    await ProductRepository.addRating(ratingModel);
    final snapshot = await ProductRepository.getRatingsByProduct(productId);
    final ratingModelList = List.generate(snapshot.docs.length,
        (index) => RatingModel.fromMap(snapshot.docs[index].data()));
    double totalRating = 0.0;
    double ratingCount = 0.0;
    for (var model in ratingModelList) {
      totalRating += model.rating;
      ratingCount += 1;
    }
    final avgRating = totalRating / ratingModelList.length;
    return updateProductField(
        ratingModel.productId, productFieldAvgRating, productFieldRatingCount, avgRating, ratingCount);
  }

  Future<void> updateProductField(
      String productId, String fieldAvgRating, fieldRatingCount,  dynamic avgRate, dynamic ratingCount) {
    return ProductRepository.updateProductField(productId, {fieldAvgRating: avgRate, fieldRatingCount: ratingCount});
  }


  double priceAfterDiscount(num price, num discount) {
    final discountAmount = (price * discount) / 100;
    return price - discountAmount;
  }

  Future<void> addComment(CommentModel commentModel) {
    return ProductRepository.addComment(commentModel);
  }

}
