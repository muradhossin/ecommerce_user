import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/view/cart/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartBubbleView extends StatelessWidget {
  const CartBubbleView({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.getCartRoute());
      },
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(
              Icons.shopping_cart,
              size: 30,
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(1),
              alignment: Alignment.center,
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: Consumer<CartProvider>(
                    builder: (context, provider, child) =>
                        Text('${provider.cartList.length}')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
