import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:smart_grounds/screens/bookings/booking_ui.dart';
import 'package:smart_grounds/screens/controls/controls.dart';
import 'package:smart_grounds/screens/data_screen/data_screen.dart';
import 'package:smart_grounds/screens/event_screen/event_data_screen.dart';
import 'package:smart_grounds/screens/login_screen.dart';
import 'package:smart_grounds/screens/records/record.dart';

class Home extends StatefulWidget {
  final userType;
  Home({
    @required this.userType,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController? tabController;
  bool isStaff = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    if (widget.userType != 'others') {
      isStaff = widget.userType == "Staff" ? true : false;
      tabController = TabController(length: isStaff ? 4 : 3, vsync: this);
    } else {
      tabController = TabController(length: 6, vsync: this);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Smart Grounds"),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          content: SizedBox(
                            height: 100,
                            width: 120,
                            child: Column(
                              children: [
                                Text(
                                  "You want to log out",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 80,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            signOutUser();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.cyan,
                                              elevation: 20,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 80,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              elevation: 30,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          )),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          title: Text("Are you Sure"),
                        ));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 165,
              child: TabBarView(
                  controller: tabController,
                  children: widget.userType == 'others'
                      ? [
                          Container(
                              height: MediaQuery.of(context).size.height - 165,
                              child: Booking(sport: 'cricket')),
                          Container(
                            height: MediaQuery.of(context).size.height - 165,
                            child: Booking(sport: 'volleyball'),
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height - 165,
                              child: Booking(sport: 'badminton')),
                          Container(
                              height: MediaQuery.of(context).size.height - 165,
                              child: Booking(sport: 'tennis')),
                          Container(
                              height: MediaQuery.of(context).size.height - 165,
                              child: Booking(sport: 'football')),
                          Container(
                              height: MediaQuery.of(context).size.height - 165,
                              child: Booking(sport: 'basketball'))
                        ]

                      /// Belongs to institution
                      : [
                          if (isStaff)
                            Container(
                                height:
                                    MediaQuery.of(context).size.height - 165,
                                child: Controls()),
                          Container(
                            height: MediaQuery.of(context).size.height - 165,
                            child: Records(
                              type: widget.userType,
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 165,
                            child: Data(),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 165,
                            child: EventDataScreen(
                              type: widget.userType,
                            ),
                          ),
                        ]),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              height: 58,
              width: MediaQuery.of(context).size.width - 10,
              alignment: Alignment.center,
              child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  controller: tabController,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  labelPadding: EdgeInsets.symmetric(
                      horizontal: isStaff
                          ? 20
                          : widget.userType == 'others'
                              ? 10
                              : 30),
                  tabs: widget.userType == 'others'
                      ? [
                          Tab(
                            child: Text(
                              'Cricket',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Volley Ball',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Badminton',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Tennis',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Foot Ball',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Basket Ball',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ]
                      : [
                          if (isStaff)
                            Tab(
                              text: "Controls",
                              icon: Icon(Icons.accessibility),
                            ),
                          Tab(
                            text: "Records",
                            icon: Icon(Icons.storage),
                          ),
                          Tab(
                            text: "Data",
                            icon: Icon(Icons.fitness_center),
                          ),
                          Tab(text: "Events", icon: Icon(Icons.emoji_events)),
                        ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOutUser() async {
    await auth.signOut().then((value) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Login()), ((route) => false));
    });
  }
}
