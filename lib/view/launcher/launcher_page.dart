
import 'package:ecommerce_user/view/product/view_product_page.dart';
import 'package:flutter/material.dart';

import '../login/services/auth_service.dart';
import '../login/login_page.dart';

class LauncherPage extends StatelessWidget {
  const LauncherPage({Key? key}) : super(key: key);
  static const String routeName = '/launcherpage';
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, (){
      if(AuthService.currentUser != null){
        Navigator.pushReplacementNamed(context, ViewProductPage.routeName);
      }else{
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
