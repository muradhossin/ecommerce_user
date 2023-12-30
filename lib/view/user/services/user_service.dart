import 'package:ecommerce_user/core/utils/widget_functions.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';
import 'package:ecommerce_user/view/user/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';


class UserService{

  static void userImageUpdate (UserProvider userProvider) {
    ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        EasyLoading.show(status: 'Uploading image...');
        try{
          userProvider.uploadImage(value.path).then((value) {
              userProvider.updateUserProfileField(userFieldImageUrl, value);
              EasyLoading.dismiss();
          });
        } catch (e) {
          EasyLoading.dismiss();
          EasyLoading.showError(e.toString());
        }
    }});
  }

  static void userProfileInfoUpdate (UserProvider userProvider, String field, String title, BuildContext context) {
    showSingleTextFieldInputDialog(
      title: title,
      context: context,
      onSubmit: (value) async{
        EasyLoading.show(status: 'Updating...');
        await userProvider.updateUserProfileField(field, value);
        EasyLoading.dismiss();
      }
    );
  }

}