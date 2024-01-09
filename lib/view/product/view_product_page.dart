import 'package:ecommerce_user/core/components/no_data_view.dart';
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/view/category/provider/category_provider.dart';
import 'package:ecommerce_user/view/checkout/provider/checkout_provider.dart';
import 'package:ecommerce_user/view/notification/provider/notification_provider.dart';
import 'package:ecommerce_user/view/product/widgets/main_drawer.dart';
import 'package:ecommerce_user/view/product/widgets/product_grid_item_view.dart';
import 'package:ecommerce_user/view/promo/promo_code_page.dart';
import 'package:ecommerce_user/view/cart/provider/cart_provider.dart';
import 'package:ecommerce_user/view/notification/services/notification_service.dart';
import 'package:ecommerce_user/view/user/provider/user_provider.dart';
import 'package:ecommerce_user/view/user/user_profile_page.dart';
import 'package:ecommerce_user/view/wishlist/provider/wishlist_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/dimensions.dart';
import '../auth/services/auth_service.dart';
import '../cart/widget/cart_bubble_view.dart';
import '../category/models/category_model.dart';
import '../order/provider/order_provider.dart';
import 'provider/product_provider.dart';

class ViewProductPage extends StatefulWidget {
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;

  @override
  void initState() {
    updateFcmtoken();
    super.initState();
  }

  @override
  void didChangeDependencies() {

    Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<CheckoutProvider>(context, listen: false).getAllPurchases();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    Provider.of<CartProvider>(context, listen: false).getAllCartItemsByUser();
    Provider.of<OrderProvider>(context, listen: false).getOrdersByUser();
    Provider.of<WishListProvider>(context, listen: false).getAllWishListProductsByUser();
    super.didChangeDependencies();
  }

  void updateFcmtoken() async {
    Provider.of<NotificationProvider>(context, listen: false).getFcmToken().then((value) {
      Provider.of<NotificationProvider>(context, listen: false).addFcmToken(AuthService.currentUser!.uid);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('All Product'),
        actions: const [
          CartBubbleView(),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) =>
          Column(
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
                  items: categoryProvider
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
              provider.productList.isNotEmpty ? Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSmall),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: Dimensions.paddingExtraSmall,
                    crossAxisSpacing: Dimensions.paddingExtraSmall,
                  ),
                  itemCount: provider.productList.length,
                  itemBuilder: ((context, index) {
                    final product = provider.productList[index];
                    return ProductGridItemView(productModel: product);
                  }),
                ),
              ) : const NoDataView(),
            ],
          ),
        ),
      ),
    );
  }
}
