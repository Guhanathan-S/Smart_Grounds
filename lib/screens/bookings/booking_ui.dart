import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/screens/bookings/book_ground.dart';
import 'package:smart_grounds/screens/bookings/booking_model.dart';

class Booking extends StatefulWidget {
  final sport;
  Booking({required this.sport});
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  List<BookingData> booked = [];
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  StreamSubscription? _dataBaseEvents;
  getData() {
    booked.clear();
    _dataBaseEvents = database.ref().child('booking').onValue.listen((event) {
      var data = BookingModel.fromJson(event.snapshot.value);
      if (widget.sport == 'cricket') {
        booked = data.cricket!;
      } else if (widget.sport == 'badminton') {
        booked = data.badminton!;
      } else if (widget.sport == 'football') {
        booked = data.footBall!;
      } else if (widget.sport == 'tennis') {
        booked = data.tennis!;
      } else if (widget.sport == 'volleyball') {
        booked = data.volleyBall!;
      } else if (widget.sport == 'basketball') {
        booked = data.basketBall!;
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: ListView.separated(
              itemBuilder: (context, index) {
                if (index == booked.length) {
                  return SizedBox(height: 100);
                }
                if (booked.length == 0) {
                  return Center(child: CircularProgressIndicator());
                }
                return card(booked[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: booked.length + 1),
        ),

        /// Add Events
        Positioned(
            bottom: 10,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookGround()));
              },
              child: Material(
                shape: CircleBorder(),
                color: Colors.cyan,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 45,
                ),
              ),
            ))
      ],
    );
  }
}

Widget card(booked) {
  return Card(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Date',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 10,
              ),
              Text(booked.bookedDate, style: TextStyle(fontSize: 20)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text('Time:', style: TextStyle(fontSize: 20)),
              SizedBox(
                width: 5,
              ),
              Text("${booked.startTime}  -  ${booked.endTime}",
                  style: TextStyle(fontSize: 20)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text('Booked By:', style: TextStyle(fontSize: 20)),
              SizedBox(
                width: 5,
              ),
              Text(booked.bookedBy, style: TextStyle(fontSize: 20))
            ],
          ),
        ],
      ),
    ),
  );
}
