
import 'package:ecommerce_user/core/components/custom_image.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/view/user/models/address_model.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';
import 'package:ecommerce_user/view/user/provider/user_provider.dart';
import 'package:ecommerce_user/view/user/services/user_service.dart';
import 'package:flutter/material.dart';
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
                      UserService.userProfileInfoUpdate(userProvider, userFieldPhone, 'Mobile Number', context, userProvider.userModel!.phone);
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
                      UserService.userProfileInfoUpdate(userProvider, userFieldAge, 'Date of Birth', context, userProvider.userModel!.age);
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
                      UserService.userProfileInfoUpdate(userProvider, userFieldGender, 'Gender', context, userProvider.userModel!.gender);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                      userProvider.userModel!.addressModel?.address ??
                          'Not set yet'),
                  subtitle: const Text('Address'),
                  trailing: IconButton(
                    onPressed: () {
                      UserService.userProfileInfoUpdate(userProvider, '$userFieldAddressModel.$addressFieldAddressLine1', 'Address Line 1', context, userProvider.userModel!.addressModel?.address);
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
                      UserService.userProfileInfoUpdate(userProvider, '$userFieldAddressModel.$addressFieldCity', 'City', context, userProvider.userModel!.addressModel?.city);
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
                      UserService.userProfileInfoUpdate(userProvider, '$userFieldAddressModel.$addressFieldZipcode', 'Zip Code', context, userProvider.userModel!.addressModel?.zipcode);
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

                  IconButton(onPressed: () => UserService.userProfileInfoUpdate(userProvider, userFieldDisplayName, 'Display Name', context, userProvider.userModel!.displayName), icon: const Icon(Icons.edit)),
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
