import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_grounds/screens/Auth/forget_password.dart';
import 'package:smart_grounds/screens/home.dart';
import 'package:smart_grounds/screens/Auth/register_screen.dart';
import 'package:smart_grounds/screens/constants.dart';

import 'auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LoginUI(
          topContainer: TopContainer(
            text1: 'Sign in to your\nAccount',
            text2: 'Sign in to your Account',
          ),
          bottomContainer: BottomContainer(),
        ));
  }
}

class LoginUI extends StatelessWidget {
  LoginUI({
    required this.topContainer,
    required this.bottomContainer,
  });
  late final Widget topContainer;
  late final Widget bottomContainer;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(flex: 1, child: topContainer),
        Flexible(
            flex: 2,
            child: Container(color: Colors.white, child: bottomContainer)),
      ],
    );
  }
}

class BottomContainer extends StatefulWidget {
  const BottomContainer({Key? key}) : super(key: key);

  @override
  State<BottomContainer> createState() => _BottomContainerState();
}

class _BottomContainerState extends State<BottomContainer>
    with AuthUser, FirebaseAuthentication {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Email Field
                  emailField(),
                  const SizedBox(
                    height: 20,
                  ),
                  // Password Field
                  passwordField(
                      onPressed: () => setState(() => obtext = !obtext),
                      labelText: 'Password'),
                  const SizedBox(
                    height: 20,
                  ),
                  // Forget Password
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ForgetPassword()))
                        .then((value) {
                      if (value)
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Password Reset Mail sent to the email.',
                            style: TextStyle(color: primaryColor1),
                          ),
                          action: SnackBarAction(
                              label: "OK",
                              textColor: primaryColor3,
                              onPressed: () => {}),
                          backgroundColor: primaryGreen,
                          duration: Duration(milliseconds: 1500),
                        ));
                    }),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                            color: Color(0xFFc0e862),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Login
                  GestureDetector(
                    onTap: () async {
                      isLoading = true;
                      FocusScope.of(context).unfocus();
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        final List value = await signInWithEmailandPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        setState(() {
                          isLoading = false;
                        });
                        if (value.last) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                        userType: value.first
                                            .toString()
                                            .toLowerCase(),
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              value.first,
                              style: TextStyle(color: primaryColor1),
                            ),
                            action: SnackBarAction(
                                label: "OK",
                                textColor: primaryColor3,
                                onPressed: () => {}),
                            backgroundColor: primaryGreen,
                            duration: Duration(milliseconds: 1500),
                          ));
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryGreen,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 30, color: primaryColor1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Register
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                    },
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'Don\'t have an account ?',
                          style: TextStyle(color: primaryColor1, fontSize: 15)),
                      TextSpan(
                          text: '  Register',
                          style: TextStyle(
                              color: primaryGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w500))
                    ])),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: isLoading,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                  visible: isLoading,
                  child: CircularProgressIndicator(
                    color: primaryGreen,
                  )),
            )
          ],
        ));
  }
}

//// Top Contanier UI

class TopContainer extends StatelessWidget {
  TopContainer(
      {required String this.text1,
      required String this.text2,
      IconButton? this.iconButton});
  late final text1;
  late final text2;
  late final Widget? iconButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            color: primaryColor1,
          ),
          Positioned.fill(
              child: ClipPath(
                  clipper: CenterClipper(),
                  child: Container(
                    color: primaryColor2,
                  ))),
          Positioned.fill(
              child: ClipPath(
                  clipper: TopClipper(),
                  child: Container(
                    color: primaryColor3,
                  ))),
          Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  text1,
                  style: TextStyle(
                      fontSize: 50,
                      color: whiteColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  text2,
                  style: TextStyle(fontSize: 20, color: white38Color),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
                alignment: Alignment.topLeft,
                child: iconButton ?? SizedBox.shrink()),
          )
        ],
      ),
    );
  }
}

/// Clipper for the first Container
class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
        0, //X - axis
        (size.height - (size.height * (22 / 100)))); // Y - axix
    path.cubicTo(
        size.width / 4, //control point1 X1
        (size.height - size.height * (10 / 100)), //control point1 Y1
        size.width / 2 + (size.width * (14 / 100)), //control point1 X2
        (size.height / 4) + size.height * (37 / 100), //control point2 Y2
        (size.width / 2) + size.width * (20.4 / 100), //Endpoint X3
        0); //Endpoint X3
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

/// Clipper for the  second Container
class CenterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
        0, //  X- axis
        size.height); // Y- axis
    path.lineTo(
        size.width / 2 + size.width * (9 / 100), // X- axis
        size.height); //Y - axis
    path.cubicTo(
        size.width / 2 + size.width * (23 / 100), // Control Point X1
        size.height - size.height * (17.45 / 100), // Control Point Y1
        size.width / 2 + size.width * (38.2 / 100), // Control Point X2
        size.height - size.height * (34.9 / 100), // Control Point Y2
        size.width - size.width * (6.7 / 100), // End Point X3
        0); // End Point Y3
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
