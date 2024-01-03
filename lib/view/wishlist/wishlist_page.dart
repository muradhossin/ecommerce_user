import 'package:ecommerce_user/core/components/no_data_view.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/view/wishlist/provider/wishlist_provider.dart';
import 'package:ecommerce_user/view/wishlist/widgets/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatelessWidget {
  const WishListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist'), elevation: 0),
      body: Consumer<WishListProvider>(
        builder: (context, provider, child) {
          if (provider.wishList.isEmpty) {
            return const Center(
              child: NoDataView(),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(Dimensions.paddingSmall),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: provider.wishList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSmall),
                child: WishListView(
                  onProductClick: () {
                    Navigator.pushNamed(context, AppRouter.getProductDetailsRoute(), arguments: provider.wishList[index]);
                  },
                  productModel: provider.wishList[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
