import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/models/cart_model.dart';
import 'package:ecommerce_user/providers/cart_provider.dart';
import 'package:ecommerce_user/utils/constants.dart';
import 'package:flutter/material.dart';

class CartItemView extends StatelessWidget {
  final CartModel cartModel;
  final CartProvider cartProvider;

  const CartItemView(
      {Key? key, required this.cartModel, required this.cartProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: CachedNetworkImage(
                width: 70,
                height: 70,
                imageUrl: cartModel.productImageUrl,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              title: Text(cartModel.productName),
              subtitle: Text('Unit Price: ${cartModel.salePrice}'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.remove_circle,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${cartModel.quantity}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_circle,
                    size: 30,
                  ),
                ),
                const Spacer(),
                Text(
                  '$currencySymbol',
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
