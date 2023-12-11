import 'package:ecommerce_user/view/login/services/auth_service.dart';
import 'package:ecommerce_user/view/cart/cart_page.dart';
import 'package:ecommerce_user/view/launcher/launcher_page.dart';
import 'package:ecommerce_user/view/order/order_page.dart';
import 'package:ecommerce_user/view/user/user_profile_page.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 150,
            color: Theme.of(context).primaryColor,
          ),
          if(!AuthService.currentUser!.isAnonymous) ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, UserProfilePage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          if(!AuthService.currentUser!.isAnonymous) ListTile(
            onTap: () {
              Navigator.pushNamed(context, CartPage.routeName);
            },
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
          ),
          if(!AuthService.currentUser!.isAnonymous) ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, OrderPage.routeName);
            },
            leading: const Icon(Icons.monetization_on),
            title: const Text('My Orders'),
          ),
          ListTile(
            onTap: () {
              AuthService.logout().then(
                (value) => Navigator.pushReplacementNamed(
                    context, LauncherPage.routeName),
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