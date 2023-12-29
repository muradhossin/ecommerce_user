
import 'package:ecommerce_user/core/utils/helper_functions.dart';
import 'package:ecommerce_user/view/auth/services/auth_service.dart';
import 'package:ecommerce_user/view/user/models/user_model.dart';
import 'package:ecommerce_user/view/user/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpVerificationPage extends StatefulWidget {
  static const String routeName = 'otp';

  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late String phone;
  final textEditingController = TextEditingController();
  bool isFirst = true;
  String incomingOtp = '';
  String vid = '';

  @override
  void didChangeDependencies() {
    if (isFirst) {
      phone = ModalRoute.of(context)!.settings.arguments as String;
      _sendVerificationCode();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          shrinkWrap: true,
          children: [
            Text(
              phone,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Verify Phone Number',
              style: Theme.of(context).textTheme.headline6,
            ),
            const Text(
              'An OTP code is sent to your mobile number. Enter the OTP code below',
            ),
            const SizedBox(
              height: 10,
            ),
            PinCodeFields(
              onComplete: (value) {
                setState(() {
                  incomingOtp = value;
                });
              },
              length: 6,
              controller: textEditingController,
              keyboardType: TextInputType.number,
            ),
            TextButton(
              onPressed: () {
                _verify();
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }


  void _sendVerificationCode() async {
    EasyLoading.show(status: "Please wait");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        vid = verificationId;
        showMsg(context, "Code sent");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    EasyLoading.dismiss();
  }

  void _verify() {
    EasyLoading.show(status: "Verifying");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: vid,
      smsCode: incomingOtp,
    );
    AuthService.currentUser!.linkWithCredential(credential).then((value) async{
      await Provider.of<UserProvider>(context, listen: false).updateUserProfileField(userFieldPhone, phone);
      EasyLoading.dismiss();
      Navigator.pop(context);
    }).catchError((error) {
      print(error.toString());
    });
    if (incomingOtp == textEditingController.text) {
      print('OTP MATCHED');
    } else {
      print('OTP MISMATCHED');
    }
  }

  @override
  void dispose() {

    textEditingController.dispose();
    super.dispose();
  }
}
