import 'package:ecommerce_user/core/constants/app_constants.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/core/extensions/context.dart';
import 'package:ecommerce_user/core/extensions/style.dart';
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/view/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 150,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(AuthService.currentUser!.isAnonymous ? 'Guest User' : AppConstants.appName, style: const TextStyle().semiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.theme.cardColor)),
            ),
          ),
          if(!AuthService.currentUser!.isAnonymous) ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.getUserProfileRoute());
            },
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AppRouter.getCartRoute());
            },
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.getOrderRoute());
            },
            leading: const Icon(Icons.monetization_on),
            title: const Text('My Orders'),
          ),
          if(!AuthService.currentUser!.isAnonymous) ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.getWishListRoute());
            },
            leading: const Icon(Icons.favorite),
            title: const Text('My Wishlist'),
          ),
          ListTile(
            onTap: () {
              AuthService.logout().then(
                (value) => Navigator.pushReplacementNamed(
                    context, AppRouter.getLauncherRoute()),
              );
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
