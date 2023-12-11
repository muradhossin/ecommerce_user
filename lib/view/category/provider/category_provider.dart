import 'package:ecommerce_user/view/category/repository/category_repository.dart';
import 'package:flutter/cupertino.dart';

import '../models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];

  Future<void> addCategory(String category) {
    final categoryModel = CategoryModel(
      categoryName: category,
    );
    return CategoryRepository.addCategory(categoryModel);
  }

  getAllCategories() {
    CategoryRepository.getAllCategories().listen((snapshot) {
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
}