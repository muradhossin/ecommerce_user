import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/core/constants/app_constants.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static final _db = FirebaseFirestore.instance;
  static final sharedPref = SharedPreferences.getInstance();

  static Future<void> setTheme(bool isLightTheme) async {
    sharedPref.then((value) => value.setBool(AppConstants.themeMode, isLightTheme));
  }

  static Future<bool> getTheme() async{
    return sharedPref.then((value) => value.getBool(AppConstants.themeMode) ?? true);
  }

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addUser(UserModel userModel) {
    final doc = _db.collection(collectionUser).doc(userModel.userId);
    return doc.set(userModel.toMap());
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
      String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();


  static Future<void> updateUserProfileField(
      String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser).doc(uid).update(map);
  }
}