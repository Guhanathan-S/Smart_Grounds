import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/database/userData.dart';
import 'package:smart_grounds/screens/home.dart';
import 'package:smart_grounds/screens/verify.dart';

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
  Timer? timer;
  User? user;
  String registerNumber = "";
  String registerName = "";
  String userNumber = "";
  final regx = RegExp(r'^[0-9]+s');
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
    return Container(
      padding: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height -
          (MediaQuery.of(context).size.height / 2),
      width: MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width / 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: ListView(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onTap,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF3BD588),
                  size: 25,
                ),
              ),
              SizedBox(width: 80),
              Text(
                "Signup",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 40,
                    foreground: Paint()..shader = linearGradient),
              ),
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          SizedBox(
            height: 25,
          ),
          Form(
              key: formkey,
              child: Column(
                children: [
                  fieldName(),
                  if (isInstitution) fieldNumber(),
                  fieldEmail(),
                  SizedBox(
                    height: 20,
                  ),
                  fieldPassword(() {
                    setState(() {
                      obtext = !obtext;
                    });
                  }),
                ],
              )),
          Row(
            children: [
              Checkbox(
                value: isInstitution,
                onChanged: (value) {
                  setState(() {
                    isInstitution = value!;
                  });
                },
                checkColor: Colors.white,
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
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  backgroundColor: Color(0xFF2D75D4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () {
                final isValid = formkey.currentState!.validate();
                if (isValid) {
                  formkey.currentState!.save();
                  if (isInstitution) {
                    auth
                        .createUserWithEmailAndPassword(
                            email: email!, password: password!)
                        .then((value) {
                      user = auth.currentUser!;
                      UserDataBase(uid: user!.uid).createUserData(
                          email!, 'others', '', null,
                          number: userNumber);
                      widget.onTap();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              userType: 'others',
                            ),
                          ));
                    });
                  } else if (email!.contains("kanchiuniv.ac.in") ||
                      email == 'guhanmcgrath17@gmail.com') {
                    var regis = email!.split("@");
                    if (email!.contains("111")) {
                      type = "Student";
                      registerNumber = regis[0];
                    } else {
                      type = "Staff";
                      registerName = regis[0];
                      registerName.toUpperCase();
                    }
                    auth
                        .createUserWithEmailAndPassword(
                            email: email!, password: password!)
                        .then((_) async {
                      widget.onTap();
                      user = auth.currentUser;
                      user!.sendEmailVerification();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Verification(
                                    userName: userName,
                                    type: type,
                                    registerId: type == "Staff"
                                        ? registerName
                                        : registerNumber.toUpperCase(),
                                  )));
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("your not belong to the institution")));
                  }
                }
              },
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  Widget fieldName() => TextFormField(
      validator: (value) {
        if (value!.length < 3) {
          return "Enter atleast 3 Character";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        userName = value;
      },
      controller: controllerName,
      maxLength: 20,
      decoration: InputDecoration(
          labelText: "UserName",
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          )));

  Widget fieldEmail() => TextFormField(
        validator: (value) {
          final pattern = RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
          if (!pattern.hasMatch(value!)) {
            return "Enter a valid email";
          } else {
            return null;
          }
        },
        onSaved: (value) {
          email = value;
        },
        decoration: InputDecoration(
            labelText: "Email",
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            )),
      );

  Widget fieldPassword(Function call) => TextFormField(
        validator: (value) {
          if (value!.length < 7) {
            return "Enter strong password";
          } else {
            return null;
          }
        },
        onSaved: (value) {
          password = value;
        },
        obscureText: obtext,
        obscuringCharacter: "*",
        decoration: InputDecoration(
            labelText: "Password",
            suffixIcon: IconButton(
                icon: obtext
                    ? Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      )
                    : Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ),
                onPressed: () {
                  call();
                }),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            )),
      );

  Widget fieldNumber() => TextFormField(
      validator: (value) {
        if (value!.length < 10) {
          return "Enter Valid Number";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        userNumber = value!;
      },
      controller: controllerNumber,
      maxLength: 10,
      decoration: InputDecoration(
          labelText: "Mobile Number",
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          )));
}
