import 'package:ecommerce_user/view/checkout/models/purchase_model.dart';
import 'package:ecommerce_user/view/checkout/repository/checkout_repository.dart';
import 'package:ecommerce_user/view/product/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class CheckoutProvider extends ChangeNotifier {
  List<PurchaseModel> purchaseList = [];

  getAllPurchases() {
    CheckoutRepository.getAllPurchases().listen((snapshot) {
      purchaseList = List.generate(snapshot.docs.length,
              (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  List<PurchaseModel> getPurchaseByProductId(String productId) {
    return purchaseList
        .where((element) => element.productId == productId)
        .toList();
  }

  Future<void> repurchase(
      PurchaseModel purchaseModel, ProductModel productModel) {
    return CheckoutRepository.repurchase(purchaseModel, productModel);
  }

}