import 'package:ecommerce_user/core/components/custom_button.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatelessWidget {
  const OrderSuccessfulPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.done,
              color: Colors.green,
              size: 150,
            ),
            const Text('Your order has been placed'),

            const SizedBox(height: Dimensions.paddingLarge),
            CustomButton(text: 'Ok', onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.getLauncherRoute())),
          ],
        ),
      ),
    );
  }
}
