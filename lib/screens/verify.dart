import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/database/userData.dart';
import 'package:smart_grounds/screens/home.dart';

class Verification extends StatefulWidget {
  String? userName, type, registerId;
  String? number;
  Verification({this.userName, this.type, this.registerId, number});
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Timer? timer;
  User? user;
  @override
  void initState() {
    user = auth.currentUser;
    user!.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      verify();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verification Mail is Sent to the Email Id",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              SizedBox(
                height: 15,
              ),
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text(
                "Verifying",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verify() async {
    user = auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      timer!.cancel();
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "You Have Successfuly Verified",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ));
      });
      if (widget.type == 'others')
        await UserDataBase(uid: user!.uid).createUserData(
            widget.userName!, widget.type!, widget.registerId!, null,
            number: widget.number!);
      await UserDataBase(uid: user!.uid).createUserData(
          widget.userName!, widget.type!, widget.registerId!, null);
      ScaffoldMessenger.of(context).clearSnackBars();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    userType: widget.type!,
                  )));
    }
  }
}
