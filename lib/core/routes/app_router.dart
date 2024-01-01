import 'package:ecommerce_user/view/auth/login_page.dart';
import 'package:ecommerce_user/view/checkout/checkout_page.dart';
import 'package:ecommerce_user/view/product/models/product_model.dart';
import 'package:ecommerce_user/view/product/product_details_page.dart';
import 'package:ecommerce_user/view/product/view_product_page.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_user/view/user/user_profile_page.dart';
import 'package:ecommerce_user/view/cart/cart_page.dart';
import 'package:ecommerce_user/view/order/order_page.dart';
import 'package:ecommerce_user/view/wishlist/wishlist_page.dart';
import 'package:ecommerce_user/view/launcher/launcher_page.dart';

class AppRouter {

  static const String userProfile = '/userprofile';
  static const String cartRouteName = '/cart';
  static const String orderRouteName = '/order';
  static const String wishListRouteName = '/wishlist';
  static const String launcherRouteName = '/launcher';
  static const String viewProductRouteName = '/view-product';
  static const String productDetailsRouteName = '/product-details';
  static const String checkoutRouteName = '/checkout';
  static const String loginRouteName = '/login';

  static String getUserProfileRoute() => userProfile;
  static String getCartRoute() => cartRouteName;
  static String getOrderRoute() => orderRouteName;
  static String getWishListRoute() => wishListRouteName;
  static String getLauncherRoute() => launcherRouteName;
  static String getViewProductRoute() => viewProductRouteName;
  static String getProductDetailsRoute(ProductModel productModel) => productDetailsRouteName;
  static String getCheckoutRoute() => checkoutRouteName;
  static String getLoginRoute() => loginRouteName;


  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case userProfile:
        return MaterialPageRoute(builder: (_) => const UserProfilePage());
      case cartRouteName:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case orderRouteName:
        return MaterialPageRoute(builder: (_) => const OrderPage());
      case wishListRouteName:
        return MaterialPageRoute(builder: (_) => const WishListPage());
      case launcherRouteName:
        return MaterialPageRoute(builder: (_) => const LauncherPage());
      case viewProductRouteName:
        return MaterialPageRoute(builder: (_) => const ViewProductPage());
      case productDetailsRouteName:
        ProductModel productModel = settings.arguments as ProductModel;
        return MaterialPageRoute(builder: (_) => ProductDetailsPage(
          productModel: productModel,
        ));
      case checkoutRouteName:
        return MaterialPageRoute(builder: (_) => const CheckoutPage());
      case loginRouteName:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      default:
        return MaterialPageRoute(builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ));
    }
  }
}