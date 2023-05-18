import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/database/userData.dart';
import 'package:smart_grounds/screens/home.dart';
import 'package:smart_grounds/screens/Auth/login_screen.dart';
import 'package:smart_grounds/screens/constants.dart';

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
          primarySwatch: _createMaterialColor(primaryGreen),
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
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => auth.currentUser != null
                ? Home(
                    userType: userType?.toLowerCase(),
                  )
                : Login(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return Material(
      color: Color(0xFF0D1C2E),
      child: Center(
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFc0e862),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Smart Grounds",
                  style: TextStyle(fontSize: 30, color: Color(0xFF0D1C2E)),
                )),
          ),
        ),
      ),
    );
  }
}

MaterialColor _createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {
    50: color.withOpacity(strengths[0]),
    100: color.withOpacity(strengths[0]),
    200: color.withOpacity(strengths[0]),
    300: color.withOpacity(strengths[0]),
    400: color.withOpacity(strengths[0]),
    500: color.withOpacity(strengths[0]),
    600: color.withOpacity(strengths[0]),
    700: color.withOpacity(strengths[0]),
    800: color.withOpacity(strengths[0]),
    900: color.withOpacity(strengths[0]),
  };
  return MaterialColor(color.value, swatch);
}
