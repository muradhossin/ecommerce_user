import 'dart:developer';

import 'package:ecommerce_user/view/user/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  bool _isLightTheme = true;

  ThemeProvider(this._isLightTheme);

  bool get isLightTheme => _isLightTheme;

  void toggleTheme() {
    _isLightTheme = !isLightTheme;
    setTheme(isLightTheme);
    notifyListeners();
  }

  Future<void> setTheme(bool isLightTheme) async {
    UserRepository.setTheme(isLightTheme);
  }

  Future<bool> getTheme() async{
    _isLightTheme = await UserRepository.getTheme();
    log('-----------------> THEME: $isLightTheme');
    return isLightTheme;

  }

}
