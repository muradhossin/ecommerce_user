import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/auth/auth_service.dart';
import 'package:ecommerce_user/customwidgets/main_drawer.dart';
import 'package:ecommerce_user/pages/launcher_page.dart';
import 'package:ecommerce_user/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';

  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;

  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductProvider>(context, listen: false).getAllPurchases();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('All Product'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<CategoryModel>(
                isExpanded: true,
                hint: const Text('Select Category'),
                value: categoryModel,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                items: provider
                    .getCategoriesForFiltering()
                    .map((catModel) => DropdownMenuItem(
                          value: catModel,
                          child: Text(catModel.categoryName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    categoryModel = value;
                  });
                  if (categoryModel!.categoryName == 'All') {
                    provider.getAllProducts();
                  } else {
                    provider
                        .getAllProductsByCategory(categoryModel!.categoryName);
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.productList.length,
                itemBuilder: (context, index) {
                  final product = provider.productList[index];
                  return ListTile(
                    onTap: () => Navigator.pushNamed(
                        context, ProductDetailsPage.routeName,
                        arguments: product),
                    leading: CachedNetworkImage(
                      width: 50,
                      imageUrl: product.thumbnailImageModel.imageDownloadUrl,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    title: Text(product.productName),
                    subtitle: Text(product.category.categoryName),
                    trailing: Text('Stock: ${product.stock}'),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
