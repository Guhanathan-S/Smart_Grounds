import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_grounds/screens/Auth/auth.dart';
import 'package:smart_grounds/screens/home.dart';
import 'package:smart_grounds/screens/Auth/login_screen.dart';
import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  final onTap;
  RegisterScreen({this.onTap});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String registerNumber = "";
  String registerName = "";
  String userNumber = "";
  final Shader linearGradient = LinearGradient(
          colors: [Color(0xFF3BD588), Color(0xFF3BD588), Color(0xFF2D75D4)])
      .createShader(Rect.fromLTRB(0, 0, 200, 70));
  bool obtext = false;
  String? userName;
  String? email;
  String? password;
  String? type;
  bool isInstitution = false;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginUI(
        topContainer: TopContainer(
          text1: 'Register',
          text2: 'Create your Account',
          iconButton: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.west,
              color: whiteColor,
              size: 30,
            ),
          ),
        ),
        bottomContainer: BottomUIRegister(),
      ),
    );
  }
}

class BottomUIRegister extends StatefulWidget {
  const BottomUIRegister({Key? key}) : super(key: key);

  @override
  State<BottomUIRegister> createState() => _BottomUIRegisterState();
}

class _BottomUIRegisterState extends State<BottomUIRegister>
    with AuthUser, FirebaseAuthentication {
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordControllerRe = TextEditingController();
  ScrollController bottomScrollController = ScrollController();
  bool obtextRe = true;
  bool isLoading = false;
  bool notInstitution = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: AbsorbPointer(
              absorbing: isLoading,
              child: ListView(
                controller: bottomScrollController,
                children: [
                  //Name
                  nameField(),
                  SizedBox(height: 10),
                  //email field
                  emailField(),
                  SizedBox(height: 10),
                  //Password field
                  passwordField(
                      onPressed: () {
                        setState(() {
                          obtext = !obtext;
                        });
                      },
                      labelText: "Password"),
                  SizedBox(height: 20),
                  // Re - Enter Password field
                  passwordField(
                    obtextR: obtextRe,
                    onPressed: () {
                      setState(() {
                        obtextRe = !obtextRe;
                      });
                    },
                    labelText: "Re-Enter Password",
                    passwordControllerOP: passwordControllerRe,
                    validator: (value) {
                      if (value != passwordController.text)
                        return 'Password doesn\'t Match';
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  //Number
                  if (notInstitution) numberField(),
                  //CheckBox
                  Row(
                    children: [
                      Checkbox(
                        value: notInstitution,
                        onChanged: (value) {
                          setState(() {
                            notInstitution = value!;
                          });
                        },
                        checkColor: primaryColor1,
                        activeColor: primaryGreen,
                      ),
                      Expanded(
                        child: Text(
                          'Check the box if you are not belong the \'SCSVMV\' Institution. To Proceed Login',
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  //Register Button
                  ElevatedButton(
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 30, color: primaryColor1),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        processingMessage = 'Registering User'.obs;
                        formKey.currentState!.save();
                        List value = await signUpWithEmailandPassword(
                            email: emailController.text,
                            password: passwordController.text,
                            notInstitution: notInstitution,
                            userNumber: numberController.text,
                            registerName: nameController.text);
                        print('signUp returend');
                        setState(() {
                          isLoading = false;
                        });
                        if (value.last) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                      userType: value.first
                                          .toString()
                                          .toLowerCase())));
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
                            duration: Duration(milliseconds: 2000),
                          ));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Login
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: 'I have an account ?',
                            style:
                                TextStyle(color: primaryColor1, fontSize: 15)),
                        TextSpan(
                            text: '  Login',
                            style: TextStyle(
                                color: primaryGreen,
                                fontSize: 18,
                                fontWeight: FontWeight.w500))
                      ])),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: primaryGreen,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() => Text(
                          processingMessage.toString(),
                          style: TextStyle(color: primaryColor1, fontSize: 20),
                        ))
                  ],
                )),
          )
        ],
      ),
    );
  }
}
