import 'package:ecommerce_user/auth/auth_service.dart';
import 'package:ecommerce_user/db/db_helper.dart';
import 'package:ecommerce_user/models/notification_model.dart';
import 'package:ecommerce_user/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  Future<void> addUser(UserModel userModel) =>
      DbHelper.addUser(userModel);

  Future<bool> doesUserExist(String uid) =>
      DbHelper.doesUserExist(uid);

  getUserInfo(){
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if(snapshot.exists){
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> updateUserProfileField(String field, dynamic value){
    return DbHelper.updateUserProfileField(AuthService.currentUser!.uid, {field : value});
  }

  addNotification(NotificationModel notification) {
    return DbHelper.addNotification(notification);
  }
}