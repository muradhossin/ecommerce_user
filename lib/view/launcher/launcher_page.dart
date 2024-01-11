
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/view/auth/services/auth_service.dart';
import 'package:flutter/material.dart';



class LauncherPage extends StatelessWidget {
  const LauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, (){
      if(AuthService.currentUser != null){
        Navigator.pushReplacementNamed(context, AppRouter.getViewProductRoute());
      }else{
        Navigator.pushReplacementNamed(context, AppRouter.getLoginRoute());
      }
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
