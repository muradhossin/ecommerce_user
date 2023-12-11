import 'package:ecommerce_user/view/login/services/auth_service.dart';
import 'package:ecommerce_user/view/notification/models/notification_model.dart';
import 'package:ecommerce_user/view/notification/repository/notification_repository.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';
import 'package:ecommerce_user/view/user/repository/user_repository.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  Future<void> addUser(UserModel userModel) =>
      UserRepository.addUser(userModel);

  Future<bool> doesUserExist(String uid) =>
      UserRepository.doesUserExist(uid);

  getUserInfo(){
    UserRepository.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if(snapshot.exists){
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> updateUserProfileField(String field, dynamic value){
    return UserRepository.updateUserProfileField(AuthService.currentUser!.uid, {field : value});
  }

}