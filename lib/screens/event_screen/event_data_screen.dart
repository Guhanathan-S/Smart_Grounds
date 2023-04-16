import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/screens/event_screen/addEvents.dart';
import 'package:smart_grounds/screens/event_screen/eventDataModel.dart';
import 'package:smart_grounds/screens/event_screen/updateEvent.dart';

class EventDataScreen extends StatefulWidget {
  final type;
  const EventDataScreen({this.type});

  @override
  _EventDataScreenState createState() => _EventDataScreenState();
}

class _EventDataScreenState extends State<EventDataScreen> {
  List<EventData> events = [];
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  StreamSubscription? _dataBaseEvents;
  getData() {
    events.clear();
    _dataBaseEvents = database.ref().child('events').onValue.listen((event) {
      var data = EventModel.fromJson(event.snapshot.value);
      events = data.eventData!;
      setState(() {});
    });
  }

  bool updateEvent = false;
  DateTime dateTime = DateTime.now();
  String team1 = "";
  String team2 = "";
  String id = "";
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _dataBaseEvents!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: ListView.separated(
              itemBuilder: (context, index) {
                if (index == events.length)
                  return SizedBox(
                    height: 100,
                  );
                if (events.length == 0)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return card(events[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: events.length + 1),
        ),

        /// update
        if (widget.type == 'Staff')
          if (updateEvent)
            Positioned.fill(
              child: Center(
                child: UpdateEventScore(
                  team1: team1,
                  team2: team2,
                  id: id,
                  onTap: () {
                    setState(() {
                      updateEvent = false;
                    });
                  },
                ),
              ),
            ),

        /// Add Events
        if (widget.type == 'Staff')
          Positioned(
              bottom: 10,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddEvents()));
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

  Widget card(event) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: EdgeInsets.all(10),
          height: 205,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    event.eventName != null ? event.eventName : "",
                    style: TextStyle(fontSize: 25),
                  ),
                  Spacer(),
                  if (widget.type == 'Staff')
                    if (event.team1Score == null &&
                        dateTime.isAfter(DateTime.parse(
                            "${event.date} ${event.startTime.split(" ")[0]}" +
                                ":00")) &&
                        dateTime.isAfter(DateTime.parse(
                            "${event.date} ${event.endTime.split(" ")[0]}" +
                                ":00")))
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            updateEvent = true;
                            team1 = event.team1;
                            team2 = event.team2;
                            id = event.eventId;
                          });
                        },
                        child: Text(
                          "Update Score",
                          style: TextStyle(
                              color: Colors.transparent,
                              shadows: [
                                Shadow(
                                    color: Colors.black, offset: Offset(0, -5))
                              ],
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.cyan,
                              decorationThickness: 3,
                              decorationStyle: TextDecorationStyle.solid),
                        ),
                      )
                ],
              ),
              Divider(),
              carddata(event.team1 != null ? event.team1 : "",
                  event.team2 != null ? event.team2 : ""),
              SizedBox(
                height: 15,
              ),
              event.team1Score != null && event.team2Score != null
                  ? carddata(event.team1Score != null ? event.team1Score : "",
                      event.team2Score != null ? event.team2Score : "")
                  : dateTime.isBefore(DateTime.parse(
                          "${event.date} ${event.startTime.split(" ")[0]}" +
                              ":00"))
                      ? Container(
                          child: Text(
                            "Upcoming Event",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        )
                      : dateTime.isAfter(DateTime.parse(
                                  "${event.date} ${event.startTime.split(" ")[0]}" +
                                      ":00")) &&
                              dateTime.isBefore(DateTime.parse(
                                  "${event.date} ${event.endTime.split(" ")[0]}" +
                                      ":00"))
                          ? Container(child: Text("On Going Event"))
                          : Container(
                              child: Text(
                                  'Event Completed and Scores yet to be updated')),
              Divider(),
              Row(
                children: [
                  Text(
                    "Won By :",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(event.wonBy != null ? event.wonBy! : "",
                      style: TextStyle(
                        fontSize: 18,
                      ))
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text(event.date != null ? event.date : ""),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.place_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text(event.place != null ? event.place : "")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget carddata(text1, text2) {
    return Row(
      children: [
        SizedBox(
          width: 30,
        ),
        Text(text1, style: TextStyle(fontSize: 20, color: Colors.black)),
        Spacer(),
        Text(text2, style: TextStyle(fontSize: 20, color: Colors.black)),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
