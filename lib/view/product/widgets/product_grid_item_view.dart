import 'package:ecommerce_user/core/components/custom_image.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/core/extensions/context.dart';
import 'package:ecommerce_user/core/extensions/style.dart';
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/view/product/models/product_model.dart';
import 'package:ecommerce_user/core/constants/constants.dart';
import 'package:ecommerce_user/core/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductGridItemView extends StatelessWidget {
  final ProductModel productModel;

  const ProductGridItemView({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.getProductDetailsRoute(), arguments: productModel),
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSmall),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                      child: CustomImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: productModel.thumbnailImageModel.imageDownloadUrl,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    productModel.productName,
                    style: const TextStyle().regular,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: RichText(
                    text: TextSpan(
                        text:
                            '$currencySymbol${getPriceAfterDiscount(productModel.salePrice, productModel.productDiscount)}',
                        style: const TextStyle().regular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w500),
                        children: [
                          if (productModel.productDiscount > 0)
                            TextSpan(
                                text:
                                    " $currencySymbol${productModel.salePrice}",
                                style: const TextStyle().regular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: context.theme.colorScheme.error, decoration: TextDecoration.lineThrough)),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: productModel.avgRating.toDouble(),
                        minRating: 0.0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemSize: 20,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          debugPrint(rating.toString());
                        },
                      ),
                      Text(" ${productModel.avgRating.toStringAsFixed(1)} (${productModel.ratingCount?.toInt()})"),
                    ],
                  ),
                ),
              ],
            ),
            if (productModel.productDiscount > 0)
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusMedium),
                      topRight: Radius.circular(Dimensions.radiusMedium),
                    ),
                    color: context.theme.textTheme.bodyLarge!.color!.withOpacity(.5),
                  ),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  height: 60,
                  child: Text(
                    '${productModel.productDiscount}% OFF',
                    style: const TextStyle().regular.copyWith(color: context.theme.cardColor, fontSize: Dimensions.fontSizeMedium),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
