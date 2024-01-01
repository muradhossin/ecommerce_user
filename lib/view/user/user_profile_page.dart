import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/core/components/custom_image.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/view/auth/otp_verification_page.dart';
import 'package:ecommerce_user/core/utils/widget_functions.dart';
import 'package:ecommerce_user/view/user/models/address_model.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';
import 'package:ecommerce_user/view/user/provider/user_provider.dart';
import 'package:ecommerce_user/view/user/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), elevation: 0),
      body: userProvider.userModel == null
          ? const Center(child: Text('Failed to load user data'))
          : ListView(
              children: [
                _headerSection(context, userProvider),
                ListTile(
                  leading: const Icon(Icons.call),
                  title: Text(userProvider.userModel!.phone ?? 'Not set yet'),
                  trailing: IconButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, OtpVerificationPage.routeName, arguments: value);
                      UserService.userProfileInfoUpdate(userProvider, userFieldPhone, 'Mobile Number', context);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(userProvider.userModel!.age ?? 'Not set yet'),
                  subtitle: const Text('Date of Birth'),
                  trailing: IconButton(
                    onPressed: () {
                      UserService.userProfileInfoUpdate(userProvider, userFieldAge, 'Date of Birth', context);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(userProvider.userModel!.gender ?? 'Not set yet'),
                  subtitle: const Text('Gender'),
                  trailing: IconButton(
                    onPressed: () {
                      UserService.userProfileInfoUpdate(userProvider, userFieldGender, 'Gender', context);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                      userProvider.userModel!.addressModel?.addressLine1 ??
                          'Not set yet'),
                  subtitle: const Text('Address Line 1'),
                  trailing: IconButton(
                    onPressed: () {
                      UserService.userProfileInfoUpdate(userProvider, '$userFieldAddressModel.$addressFieldAddressLine1', 'Address Line 1', context);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                      userProvider.userModel!.addressModel?.addressLine2 ??
                          'Not set yet'),
                  subtitle: const Text('Address Line 2'),
                  trailing: IconButton(
                    onPressed: () {
                      UserService.userProfileInfoUpdate(userProvider, '$userFieldAddressModel.$addressFieldAddressLine2', 'Address Line 2', context);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(userProvider.userModel!.addressModel?.city ??
                      'Not set yet'),
                  subtitle: const Text('City'),
                  trailing: IconButton(
                    onPressed: () {
                      UserService.userProfileInfoUpdate(userProvider, '$userFieldAddressModel.$addressFieldCity', 'City', context);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(userProvider.userModel!.addressModel?.zipcode ??
                      'Not set yet'),
                  subtitle: const Text('Zip Code'),
                  trailing: IconButton(
                    onPressed: () {
                      UserService.userProfileInfoUpdate(userProvider, '$userFieldAddressModel.$addressFieldZipcode', 'Zip Code', context);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
              ],
            ),
    );
  }

  Container _headerSection(BuildContext context, UserProvider userProvider) {
    return Container(
      height: 150,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [

          const SizedBox(width: Dimensions.paddingSmall,),
          Card(
            elevation: 5,
            child: userProvider.userModel!.imageUrl == null
                ? InkWell(
                    onTap: () {
                      UserService.userImageUpdate(userProvider);
                    },
                  child: const Icon(
                      Icons.person,
                      size: 90,
                      color: Colors.grey,
                    ),
                )
                : InkWell(
                  onTap: () {
                    UserService.userImageUpdate(userProvider);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImage(
                        fit: BoxFit.cover,
                        imageUrl: userProvider.userModel!.imageUrl!,
                        height: 90,
                        width: 90,
                      ),
                  ),
                  ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userProvider.userModel!.displayName ?? 'No Display Name',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),

                  IconButton(onPressed: () => UserService.userProfileInfoUpdate(userProvider, userFieldDisplayName, 'Display Name', context), icon: const Icon(Icons.edit)),
                ],
              ),
              Text(
                userProvider.userModel!.email,
                style: const TextStyle(color: Colors.white60),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
