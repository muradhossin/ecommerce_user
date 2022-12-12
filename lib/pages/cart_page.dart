import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/providers/cart_provider.dart';
import 'package:ecommerce_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/cart';

  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {},
            child: const Text('CLEAR'),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartModel = provider.cartList[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                      imageUrl: cartModel.productImageUrl,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: Text(cartModel.productName),
                    subtitle: Text("Quantity: ${cartModel.quantity}"),
                    trailing: Text('$currencySymbol${cartModel.salePrice}'),
                  );
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('SUBTOTAL: $currencySymbol 235545'),
                    ),
                    OutlinedButton(
                      onPressed: provider.cartList.isEmpty ? null : () {

                      },
                      child: const Text("CHECKOUT"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
