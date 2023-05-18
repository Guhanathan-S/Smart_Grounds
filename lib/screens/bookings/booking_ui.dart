import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/database/database.dart';
import 'package:smart_grounds/screens/bookings/booking_model.dart';
import '../constants.dart';

class Booking extends StatefulWidget {
  final sport;
  Booking({required this.sport});
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  List<BookingData> booked = [];
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  @override
  void initState() {
    super.initState();
    DataBase().removeBookedGround(widget.sport);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: StreamBuilder(
          stream: database.ref().child('booking/${widget.sport}').onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapShot) {
            booked.clear();
            if (!snapShot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapShot.data!.snapshot.children.isEmpty)
              return Center(
                child: Text(
                  'No Bookings',
                  style: TextStyle(color: primaryGreen, fontSize: 35),
                ),
              );
            snapShot.data!.snapshot.children.forEach((element) {
              booked.add(BookingData.fromJson(element.value));
            });
            return ListView.separated(
              shrinkWrap: true,
              itemCount: snapShot.data!.snapshot.children.length,
              itemBuilder: (context, index) {
                if (index == booked.length) return SizedBox(height: 100);
                if (booked.length == 0)
                  return Center(
                      child: CircularProgressIndicator(
                    color: primaryGreen,
                    strokeWidth: 4,
                  ));
                return card(booked: booked[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
            );
          }),
    );
  }
}

Widget card({required BookingData booked}) {
  return Card(
    elevation: 7,
    color: primaryGreen,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          details(icon: Icons.person_4_outlined, data: booked.bookedBy!),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              details(icon: Icons.access_time, data: booked.startTime!),
              Text(
                " - ",
                style: TextStyle(color: primaryColor1, fontSize: 40),
              ),
              details(icon: Icons.access_time, data: booked.endTime!),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          details(
              icon: Icons.calendar_today_outlined, data: booked.bookedDate!),
        ],
      ),
    ),
  );
}

Widget details({required IconData icon, required String data}) {
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: greyColor)),
    child: Row(
      children: [
        Icon(
          icon,
          color: greyColor,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          data,
          style: TextStyle(color: primaryColor1, fontSize: 25),
        ),
      ],
    ),
  );
}

class AddIcon extends StatelessWidget {
  const AddIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: primaryGreen,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 4,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
                color: primaryColor1),
          ),
          Container(
            height: 4,
            width: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: primaryColor1),
          ),
        ],
      ),
    );
  }
}
