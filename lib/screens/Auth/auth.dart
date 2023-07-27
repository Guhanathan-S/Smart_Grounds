import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../database/firebase_data/userData.dart';
import '../../utils/constants.dart';
import 'dart:math' as math;

class AuthUser {
  bool obtext = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Widget emailField() => Container(
        margin: EdgeInsets.all(10),
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (!pattern.hasMatch(value!)) {
              return "Enter a valid email";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              label: Text("Email", style: TextStyle(color: Colors.grey)),
              floatingLabelAlignment: FloatingLabelAlignment.start,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor1),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor1)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor1)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: emailController.text.isEmpty
                          ? Colors.red
                          : primaryColor1))),
        ),
      );

  Widget passwordField(
          {required Function() onPressed,
          required String labelText,
          TextEditingController? passwordControllerOP,
          String? Function(String? value)? validator,
          bool? obtextR}) =>
      Container(
        margin: EdgeInsets.all(10),
        child: TextFormField(
          controller: passwordControllerOP ?? passwordController,
          validator: validator ??
              (value) {
                if (value!.isEmpty) {
                  return 'Enter valid Password';
                } else if (value.length < 7) {
                  return "Enter strong password";
                } else {
                  return null;
                }
              },
          obscureText: obtextR ?? obtext,
          obscuringCharacter: "*",
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: obtextR ?? obtext
                      ? IconUI()
                      : Icon(
                          Icons.remove_red_eye,
                          color: Color(0xFF0D1C2E),
                        ),
                  onPressed: onPressed),
              label: Text(
                labelText,
                style: TextStyle(color: Colors.grey),
              ),
              floatingLabelAlignment: FloatingLabelAlignment.start,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor1)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor1)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: passwordController.text.isEmpty
                          ? Colors.red
                          : primaryColor1))),
        ),
      );

  Widget numberField() => Container(
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          validator: (value) {
            if (value!.length < 10) {
              return "Enter Valid Number";
            } else {
              return null;
            }
          },
          controller: numberController,
          maxLength: 10,
          decoration: InputDecoration(
              label: Text('Number', style: TextStyle(color: Colors.grey)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor1)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor1)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: numberController.text.isEmpty
                          ? Colors.red
                          : primaryColor1))),
        ),
      );

  Widget nameField() => Container(
        padding: EdgeInsets.all(10),
        child: TextFormField(
            validator: (value) {
              if (value!.length < 3) {
                return "Enter atleast 3 Character";
              } else {
                return null;
              }
            },
            controller: nameController,
            maxLength: 20,
            decoration: InputDecoration(
                label: Text('Name', style: TextStyle(color: Colors.grey)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor1)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor1)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: nameController.text.isEmpty
                            ? Colors.red
                            : primaryColor1)))),
      );

  void disposeController() {
    emailController.dispose();
    passwordController.dispose();
  }
}

//// Icon UI

class IconUI extends StatelessWidget {
  IconUI({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(
          Icons.remove_red_eye_outlined,
          color: Color(0xFF1E2E3D),
        ),
        Transform.rotate(
          angle: -math.pi / 4,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              height: constraints.maxHeight * (6.25 / 100),
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: Color(0xFF1E2E3D),
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }),
        )
      ],
    );
  }
}

class FirebaseAuthentication {
  UserDataBase _userDataBase = UserDataBase();
  FirebaseAuth instance = UserDataBase.auth;
  Timer? timer;
  var processingMessage = ''.obs;
  Future<List> signInWithEmailandPassword(
          {required String email, required String password}) async =>
      await instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((_) async {
        late List finalValue;
        await UserDataBase.getUserData();
        finalValue = [UserDataBase.userDetails.userType, true];
        return finalValue;
      }).onError((error, stackTrace) {
        print('error : $error');
        if (error.toString().toLowerCase().contains('there is no user')) {
          return ['You don\'t have the account', false];
        } else if (error.toString().toLowerCase().contains('invalid')) {
          return ['Invalid Email or Password', false];
        } else {
          return ['Unable to Login', false];
        }
      });

  Future<List> signUpWithEmailandPassword({
    required String email,
    required String password,
    required bool notInstitution,
    String? userNumber,
    String? registerName,
  }) async {
    String? type;
    String? registerNumber;
    bool isVerified = false;
    List finalValue = [];
    if (!(email.toLowerCase().contains('kanchiuniv.ac.in') ||
            email == 'guhanmcgrath17@gmail.com') &&
        !notInstitution)
      return [
        'Your not belong to the Institution. Use your Institution Mail or Check the Checkbox ',
        false
      ];
    return await instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((_) async {
      User user = instance.currentUser!;
      await user.updateDisplayName(registerName).then((value) {
        print('User Created');
        user.sendEmailVerification().onError((error, stackTrace) {
          return ['Can\'t send Verification mail. Try again', false];
        });
      });
      processingMessage.update((value) {
        processingMessage =
            'Verification Mail sent to your Mail. Please Verify'.obs;
      });
      isVerified = await verify(user: user);
      if (!isVerified) {
        print('Verification Time Completes. Deleting registered user ');
        await user.delete();
        return ['Can\'t verify your account. Try again', false];
      }
      print('Verified');
      type = 'Staff';
      if (notInstitution) type = 'Others';
      registerNumber = email.split('@').first;
      if (email.contains("111")) type = 'Student';
      await _userDataBase
          .createUserData(
              name: registerName,
              type: type,
              registerId: email,
              number:
                  type!.toLowerCase() == 'others' ? userNumber : registerNumber,
              weight: null)
          .whenComplete(() {
        finalValue = [type, true];
      }).onError((error, stackTrace) {
        finalValue = ['Can\'t Regiter now. Try again Later', false];
      });
      return finalValue;
    }).onError((error, stackTrace) {
      print('error from create user  : $error');
      return [
        'Email Id is already register. If you are account onwer reset the password',
        false
      ];
    });
  }

  Future<void> resetPassword({String? email}) async =>
      await instance.sendPasswordResetEmail(email: email!);

  Future<bool> verify({required User? user}) async {
    int loopCount = 1;
    do {
      await Future.delayed(Duration(seconds: 5), () async {});
      await user!.reload();
      if (instance.currentUser!.emailVerified) return true;
      loopCount++;
    } while (loopCount <= 12);
    return false;
  }
}
