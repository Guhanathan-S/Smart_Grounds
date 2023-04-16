import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/database/userData.dart';
import 'package:smart_grounds/screens/home.dart';
import 'package:smart_grounds/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? userType;
  getType() async {
    if (auth.currentUser != null) {
      userType = await UserDataBase(uid: auth.currentUser!.uid).getUserType();
    }
  }

  @override
  void initState() {
    getType();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => auth.currentUser != null
                ? Home(
                    userType: userType,
                  )
                : Login(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text(
            "Smart Grounds",
            style: TextStyle(fontSize: 30, color: Colors.cyan),
          )),
    );
  }
}
