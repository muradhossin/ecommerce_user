import 'package:ecommerce_user/auth/auth_service.dart';
import 'package:ecommerce_user/models/user_model.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpVerificationPage extends StatefulWidget {
  static const String routeName = 'otp';

  const OtpVerificationPage({Key? key}) : super(key: key);

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
            PinCodeTextField(

              appContext: context,
              pastedTextStyle: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
              ),
              length: 6,
              obscureText: false,
              obscuringCharacter: '*',
              // obscuringWidget: const FlutterLogo(
              //   size: 24,
              // ),
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              validator: (v) {
                // if (v!.length < 3) {
                //   return "I'm from validator";
                // } else {
                //   return null;
                // }
                return null;
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              // errorAnimationController: errorController,
              controller: textEditingController,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
              onCompleted: (v) {
                debugPrint("Completed");
              },
              // onTap: () {
              //   print("Pressed");
              // },
              onChanged: (value) {
                debugPrint(value);
                setState(() {
                  incomingOtp = value;
                });
              },
              beforeTextPaste: (text) {
                debugPrint("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
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
