import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/screens/Auth/auth.dart';
import 'package:smart_grounds/screens/Auth/login_screen.dart';
import '../constants.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LoginUI(
            topContainer: TopContainer(
              text1: 'Reset your \nPassword',
              text2: 'Send Passward Reset Link to Mail',
              iconButton: IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: Icon(
                  Icons.west,
                  color: whiteColor,
                  size: 30,
                ),
              ),
            ),
            bottomContainer: BottomContainerForgetPasswordUI()));
  }
}

class BottomContainerForgetPasswordUI extends StatefulWidget {
  const BottomContainerForgetPasswordUI({Key? key}) : super(key: key);

  @override
  State<BottomContainerForgetPasswordUI> createState() =>
      _BottomContainerForgetPasswordUIState();
}

class _BottomContainerForgetPasswordUIState
    extends State<BottomContainerForgetPasswordUI>
    with AuthUser, FirebaseAuthentication {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            //email Field
            emailField(),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await resetPassword(email: emailController.text);
                  Navigator.pop(context, true);
                }
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primaryGreen,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Send Link",
                  style: TextStyle(fontSize: 30, color: primaryColor1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
