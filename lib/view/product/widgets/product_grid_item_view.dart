import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/core/components/custom_image.dart';
import 'package:ecommerce_user/view/product/models/product_model.dart';
import 'package:ecommerce_user/view/product/product_details_page.dart';
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
      onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: productModel),
      child: Card(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CustomImage(
                    imageUrl: productModel.thumbnailImageModel.imageDownloadUrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    productModel.productName,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: RichText(
                    text: TextSpan(
                        text:
                            '$currencySymbol${getPriceAfterDiscount(productModel.salePrice, productModel.productDiscount)}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        children: [
                          if (productModel.productDiscount > 0)
                            TextSpan(
                                text:
                                    " $currencySymbol${productModel.salePrice}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough))
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
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      Text(" ${productModel.avgRating.toStringAsFixed(1)}"),
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
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  height: 60,
                  color: Colors.black54,
                  child: Text(
                    '${productModel.productDiscount}% OFF',
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
