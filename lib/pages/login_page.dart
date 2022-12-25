import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/models/user_model.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/notification_model.dart';
import '../utils/constants.dart';
import 'launcher_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = '/loginpage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _errMsg = '';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late UserProvider userProvider;
  bool isAnonymous = false;

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
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _authenticate(true);
              },
              child: const Text('Login'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('New User? '),
                TextButton(
                  onPressed: () {
                    _authenticate(false);
                  },
                  child: const Text("Register here"),
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
                      context, LauncherPage.routeName),
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
            Navigator.pushReplacementNamed(context, LauncherPage.routeName);
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
            userCreationTime: Timestamp.fromDate(
                AuthService.currentUser!.metadata.creationTime!),
          );
          userProvider.addUser(userModel).then((value) {
            EasyLoading.dismiss();
            if (mounted) {
              if (isAnonymous) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, LauncherPage.routeName);
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
          userCreationTime: Timestamp.fromDate(DateTime.now()),
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
        );
        await userProvider.addNotification(notification);
        EasyLoading.dismiss();
      }
      if (mounted) {
        if (isAnonymous) {
          EasyLoading.dismiss();
          Navigator.pop(context);
        } else {
          EasyLoading.dismiss();
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
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
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
    }
  }
}
