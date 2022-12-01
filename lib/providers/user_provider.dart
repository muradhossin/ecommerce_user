import 'package:ecommerce_user/db/db_helper.dart';
import 'package:ecommerce_user/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Future<void> addUser(UserModel userModel) =>
      DbHelper.addUser(userModel);
}