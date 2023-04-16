import 'package:flutter/material.dart';
import 'package:smart_grounds/database/userData.dart';
import 'package:smart_grounds/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_grounds/screens/register_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List userdata = [];
  bool check = false;
  String? email;
  var usertype;
  bool isChecking = false;
  final instance = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool signup = false;
  bool loading = false;
  bool isInstitution = false;
  bool obtext = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Smarts Grounds"),
      ),
      body: SafeArea(
          child: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  final pattern = RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                  if (!pattern.hasMatch(value!)) {
                                    return "Enter a valid email";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  email = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "College Mail Id",
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: passwordController,
                                validator: (value) {
                                  if (value!.length < 7) {
                                    return "Enter strong password";
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: obtext,
                                obscuringCharacter: "*",
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        icon: obtext
                                            ? Icon(Icons.remove_red_eye,
                                                color: Colors.grey)
                                            : Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.black,
                                              ),
                                        onPressed: () {
                                          setState(() {
                                            obtext = !obtext;
                                          });
                                        }),
                                    hintText: "Password",
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            SizedBox(
                              width: 380,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    final isValid =
                                        formKey.currentState!.validate();
                                    if (isValid) {
                                      formKey.currentState!.save();
                                    }
                                    try {
                                      await instance
                                          .signInWithEmailAndPassword(
                                              email: emailController.text,
                                              password: passwordController.text)
                                          .then((_) {
                                        User? user = instance.currentUser;
                                        UserDataBase(uid: user!.uid)
                                            .getUserType()
                                            .then((value) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Home(
                                                        userType: value,
                                                      )));
                                        }).onError((error, stackTrace) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: const Text(
                                                      "Cannot Access the Data base right now"),
                                                  action: SnackBarAction(
                                                      label: "OK",
                                                      onPressed: () => {})));
                                        });
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: const Text(
                                                    "Email Id or Password is incorrect"),
                                                action: SnackBarAction(
                                                    label: "OK",
                                                    onPressed: () => {})));
                                      });
                                    } catch (e) {
                                      if (e
                                          .toString()
                                          .contains("There is no user")) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "You are not Register yet",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          backgroundColor: Colors.blue,
                                          duration:
                                              Duration(milliseconds: 1500),
                                        ));
                                      }
                                    }
                                  },
                                  child: Text("Login"),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 380,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      signup = true;
                                    });
                                  },
                                  child: Text("Register"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (signup)
              Positioned.fill(
                  child: Center(
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  child: RegisterScreen(
                    onTap: () {
                      setState(() {
                        signup = false;
                      });
                    },
                  ),
                ),
              )),
          ],
        ),
      )),
    );
  }
}
