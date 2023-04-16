import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_grounds/screens/data_screen/calories_cal.dart';
import 'package:smart_grounds/screens/data_screen/data_model.dart';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  List<UserData> usersData = [];
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  StreamSubscription? _dataStream;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
  String userId = "";
  bool isLoading = true;
  bool data = false;
  getUserId() async {
    try {
      await fireStoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
        userId = value.get('register_number');
      });
      getData();
    } catch (e) {
      setState(() {
        data = true;
      });
    }
  }

  getData() {
    _dataStream =
        database.ref().child("users_data/$userId").onValue.listen((event) {
      var recivedData = Data_Model.fromJson(event.snapshot.value);
      usersData = recivedData.data!;
      setState(() {});
    });
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  void dispose() {
    if (_dataStream != null) {
      _dataStream!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data)
      return Center(
        child: Text("No Record Found"),
      );
    if (usersData.length == 0)
      return Center(
        child: CircularProgressIndicator(),
      );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 20,
            );
          },
          itemCount: usersData.length + 1,
          itemBuilder: (context, index) {
            if (index == usersData.length)
              return SizedBox(
                height: 50,
              );
            return card(usersData[index]);
          }),
    );
  }

  Widget card(data) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => DetailCard()));
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            height: 160,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      data.date != null ? data.date : "",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                carddata("In time", data.inTime != null ? data.inTime : ""),
                carddata("Out time", data.outTime != null ? data.outTime : ""),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (data.calories == null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalorisCal(
                                        dataKey: data.key,
                                      )));
                        },
                        child: Text(
                          "Enter Workouts To get Calories",
                          style: GoogleFonts.zillaSlab(
                              fontSize: 18, color: Colors.grey[600]),
                        ),
                      ),
                    if (data.calories != null) ...[
                      Text(
                        "Total Calories burn   :",
                      ),
                      Spacer(),
                      Text(data.calories),
                      SizedBox(
                        width: 100,
                      )
                    ]
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget carddata(text, data) {
    return Row(
      children: [
        ImageIcon(
          AssetImage("assets/clock.png"),
          size: 20,
          color: Colors.black,
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        Spacer(),
        Text(
          ":  $data",
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        SizedBox(
          width: 50,
        ),
      ],
    );
  }
}
