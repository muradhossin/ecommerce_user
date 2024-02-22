
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/core/constants/constants.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/core/extensions/context.dart';
import 'package:ecommerce_user/core/extensions/style.dart';
import 'package:ecommerce_user/core/utils/helper_functions.dart';
import 'package:ecommerce_user/view/product/models/product_model.dart';
import 'package:ecommerce_user/view/product/provider/product_provider.dart';
import 'package:ecommerce_user/view/wishlist/provider/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class WishListView extends StatelessWidget {
  final Function onProductClick;
  final ProductModel productModel;
  const WishListView({super.key, required this.onProductClick, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onProductClick(),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        ),
        child: Column(children: [

          Row(
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                child: CachedNetworkImage(
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  imageUrl: productModel.thumbnailImageModel.imageDownloadUrl ?? '',
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: Dimensions.paddingLarge),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      productModel.productName,
                      style: const TextStyle().semiBold,
                    ),
                    const SizedBox(height: Dimensions.paddingSmall),

                    Text(
                      productModel.shortDescription ?? productModel.longDescription ?? '',
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: Dimensions.paddingSmall),

                    Row(children: [
                      Text('Price: $currencySymbol${Provider.of<ProductProvider>(context).priceAfterDiscount(productModel.salePrice, productModel.productDiscount)}'),
                      const SizedBox(width: Dimensions.paddingSmall),
                      Text('$currencySymbol${productModel.salePrice}', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium!.copyWith(decoration: TextDecoration.lineThrough)),
                    ],),

                  ],
                ),
              ),

              const SizedBox(width: Dimensions.paddingLarge),
              IconButton(
                onPressed: () async {
                  EasyLoading.show(status: 'Removing from wishlist...');
                  await Provider.of<WishListProvider>(context, listen: false).removeFromWishList(productModel.productId!).then((value) => {
                    if(context.mounted){
                      showMsg(context, 'Removed from wishlist'),
                    }

                  });
                  EasyLoading.dismiss();
                },
                icon: const Icon(Icons.delete),
              ),

            ],
          ),
        ]),
      ),
    );
  }
}
