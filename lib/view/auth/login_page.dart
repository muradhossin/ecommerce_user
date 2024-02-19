import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/core/components/custom_image.dart';
import 'package:ecommerce_user/core/constants/app_constants.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/core/extensions/context.dart';
import 'package:ecommerce_user/core/extensions/image_path.dart';
import 'package:ecommerce_user/core/extensions/style.dart';
import 'package:ecommerce_user/core/routes/app_router.dart';
import 'package:ecommerce_user/core/utils/helper_functions.dart';
import 'package:ecommerce_user/view/notification/provider/notification_provider.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';
import 'package:ecommerce_user/view/user/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import '../notification/models/notification_model.dart';
import '../../core/constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _errMsg = '';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  late UserProvider userProvider;
  late NotificationProvider notificationProvider;
  bool isAnonymous = false;
  bool _showPassword = false;

  @override
  void initState() {
    isAnonymous = AuthService.currentUser == null
        ? false
        : AuthService.currentUser!.isAnonymous;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    _passwordController.addListener(() {
      setState(() {});
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [

            CustomImage(imagePath: Images.logo, width: 100, height: 100,),
            const SizedBox(height: Dimensions.heightMedium,),

            const Text(AppConstants.appName, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,),),
            const SizedBox(height: Dimensions.heightExtraLarge,),

            TextFormField(
              onFieldSubmitted: (value) {
                _passwordFocusNode.requestFocus();
              },
              autofillHints: const [AutofillHints.email],
              enableSuggestions: true,
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusMedium)),
                  borderSide: BorderSide(color: context.theme.primaryColor.withOpacity(.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusMedium)),
                  borderSide: BorderSide(color: context.theme.primaryColor),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusMedium)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusMedium)),
                ),
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: Dimensions.paddingMedium,),

            TextFormField(
              onFieldSubmitted: (value) {
                _authenticate(true);
              },
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusMedium)),
                  borderSide: BorderSide(color: context.theme.primaryColor.withOpacity(.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusMedium)),
                  borderSide: BorderSide(color: context.theme.primaryColor),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusMedium)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusMedium)),
                ),
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                suffixIcon: _passwordController.text.isNotEmpty ? IconButton(
                  icon: Icon(!_showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                    _showPassword = !_showPassword;
                    });
                  },
                ) : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: Dimensions.paddingLarge),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.primaryColor,
                animationDuration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(Dimensions.paddingMedium),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                ),
              ),
              onPressed: () {
                _authenticate(true);
              },
              child: Text('Login', style: const TextStyle().regular.copyWith(color: context.theme.colorScheme.onPrimary),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('New Here? '),
                TextButton(
                  onPressed: () {
                    _authenticate(false);
                  },
                  child: const Text("Register Now"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _errMsg,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                _signInWithGoogleAccount();
              },
              icon: const Icon(
                Icons.g_mobiledata,
                size: 35,
              ),
              label: const Text("Sing in with Google"),
            ),
            TextButton.icon(
              onPressed: () {
                AuthService.signInAnonymously().then(
                  (value) => Navigator.pushReplacementNamed(
                      context, AppRouter.getLauncherRoute()),
                );
              },
              icon: const Icon(Icons.account_circle_outlined),
              label: const Text("Login as Guest"),
            ),
          ],
        ),
      )),
    );
  }

  void _authenticate(bool tag) async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        if (tag) {
          await AuthService.login(email, password);
          EasyLoading.dismiss();
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRouter.getLauncherRoute());
          }
        } else {
          if (AuthService.currentUser != null) {
            final credential =
                EmailAuthProvider.credential(email: email, password: password);
            await convertAnonymousUserIntoRealAccount(credential);
          } else {
            await AuthService.register(email, password);
          }
        }

        if (!tag) {
          final userModel = UserModel(
            userId: AuthService.currentUser!.uid,
            email: AuthService.currentUser!.email!,
            userCreationTime: AuthService.currentUser!.metadata.creationTime.toString(),
          );
          userProvider.addUser(userModel).then((value) {
            EasyLoading.dismiss();
            if (mounted) {
              if (isAnonymous) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, AppRouter.getLauncherRoute());
              }
            }
          }).catchError((error) {
            EasyLoading.dismiss();
            showMsg(context, "Could not save user info");
          });
        }
      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }

  void _signInWithGoogleAccount() async {
    try {
      EasyLoading.show(status: "Please wait");
      final credential = await AuthService.signInWithGoogle();
      final userExists = await userProvider.doesUserExist(credential.user!.uid);
      if (AuthService.currentUser != null) {
        final credential1 = GoogleAuthProvider.credential(idToken: credential.credential!.token.toString());
        await convertAnonymousUserIntoRealAccount(credential1);
      }

      if (!userExists) {
        EasyLoading.show(status: "Redirecting user...");
        final userModel = UserModel(
          userId: credential.user!.uid,
          email: credential.user!.email!,
          userCreationTime: Timestamp.fromDate(DateTime.now()).toString(),
          displayName: credential.user!.displayName,
          imageUrl: credential.user!.photoURL,
          phone: credential.user!.phoneNumber,
        );
        await userProvider.addUser(userModel);
        final notification = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: NotificationType.user,
          message: 'A new user is created, UserID: ${userModel.userId}',
          userModel: userModel,
          createdAt: DateTime.now(),
        );
        await notificationProvider.addNotification(notification);
        EasyLoading.dismiss();
      }
      if (mounted) {
        if (isAnonymous) {
          EasyLoading.dismiss();
          Navigator.pop(context);
        } else {
          EasyLoading.dismiss();
          Navigator.pushReplacementNamed(context, AppRouter.getLauncherRoute());
        }
      }
    } catch (error) {
      EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<void> convertAnonymousUserIntoRealAccount(
      AuthCredential credential) async {
    try {
      await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          debugPrint("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          debugPrint("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          debugPrint("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          debugPrint("Unknown error.");
      }
    }
  }
}
