import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/core/themes/dark_theme.dart';
import 'package:ecommerce_user/core/themes/light_theme.dart';
import 'package:ecommerce_user/core/utils/notification_helper.dart';
import 'package:ecommerce_user/view/auth/login_page.dart';
import 'package:ecommerce_user/view/auth/otp_verification_page.dart';
import 'package:ecommerce_user/view/cart/cart_page.dart';
import 'package:ecommerce_user/view/category/provider/category_provider.dart';
import 'package:ecommerce_user/view/checkout/checkout_page.dart';
import 'package:ecommerce_user/view/checkout/provider/checkout_provider.dart';
import 'package:ecommerce_user/view/launcher/launcher_page.dart';
import 'package:ecommerce_user/view/notification/provider/notification_provider.dart';
import 'package:ecommerce_user/view/order/order_page.dart';
import 'package:ecommerce_user/view/order/order_successful_page.dart';
import 'package:ecommerce_user/view/product/product_details_page.dart';
import 'package:ecommerce_user/view/promo/promo_code_page.dart';
import 'package:ecommerce_user/view/product/view_product_page.dart';
import 'package:ecommerce_user/view/cart/provider/cart_provider.dart';
import 'package:ecommerce_user/view/order/provider/order_provider.dart';
import 'package:ecommerce_user/view/product/provider/product_provider.dart';
import 'package:ecommerce_user/view/user/provider/user_provider.dart';
import 'package:ecommerce_user/view/user/user_profile_page.dart';
import 'package:ecommerce_user/view/wishlist/provider/wishlist_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.


  print("Handling a background message: ${message.toMap()}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('FCM TOKEN: $fcmToken');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic("promo");
  await FirebaseMessaging.instance.subscribeToTopic("user");

  NotificationHelper notificationHelper = NotificationHelper();
  await notificationHelper.initNotifications();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => WishListProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      builder: EasyLoading.init(),
      onGenerateRoute: AppRouter.generateRoute,
      onGenerateInitialRoutes: (String initialRouteName) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: AppRouter.getLauncherRoute()),
            builder: (context) => const LauncherPage(),
          ),
        ];
      },
    );
  }
}



