import 'package:ecommerce_user/core/components/no_data_view.dart';
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/view/cart/widget/cart_item_view.dart';
import 'package:ecommerce_user/view/cart/provider/cart_provider.dart';
import 'package:ecommerce_user/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
            },
            child: const Text('CLEAR'),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => provider.cartList.isNotEmpty ? Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartModel = provider.cartList[index];
                  return CartItemView(
                      cartModel: cartModel, cartProvider: provider);
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'SUBTOTAL: $currencySymbol${provider.getCartSubTotal()}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: provider.cartList.isEmpty ? null : () {
                        Navigator.pushNamed(context, AppRouter.getCheckoutRoute());
                      },
                      child: const Text("CHECKOUT"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ) : const NoDataView(),
      ),
    );
  }
}
