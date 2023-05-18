import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_grounds/screens/bookings/booking_ui.dart';
import 'package:smart_grounds/screens/controls/controls.dart';
import 'package:smart_grounds/screens/data_screen/data_screen.dart';
import 'package:smart_grounds/screens/event_screen/addEvents.dart';
import 'package:smart_grounds/screens/event_screen/event_data_screen.dart';
import 'package:smart_grounds/screens/Auth/login_screen.dart';
import 'package:smart_grounds/screens/records/addRecords.dart';
import 'package:smart_grounds/screens/records/record.dart';

import 'bookings/book_ground.dart';
import 'bookings/booking_home.dart';
import 'constants.dart';

class Home extends StatefulWidget {
  final userType;
  Home({
    @required this.userType,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController? _tabController;
  bool isStaff = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  int _index = 0;
  @override
  void initState() {
    print(widget.userType);
    if (widget.userType != 'others') {
      isStaff = widget.userType == "staff" ? true : false;
      _tabController = TabController(length: isStaff ? 5 : 3, vsync: this);
    } else {
      _tabController = TabController(
        length: 6,
        vsync: this,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor3,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Smart Grounds",
          style: TextStyle(color: primaryGreen),
        ),
        backgroundColor: primaryColor1,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: primaryColor3,
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
                                      fontWeight: FontWeight.w700,
                                      color: whiteColor),
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
                                              backgroundColor: primaryGreen,
                                              elevation: 20,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: primaryColor1,
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
                                              backgroundColor: primaryColor1,
                                              elevation: 30,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: primaryGreen,
                                                fontSize: 20),
                                          )),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          title: Text(
                            "Are you Sure ?",
                            style: TextStyle(color: whiteColor),
                          ),
                        ));
              },
              icon: Icon(
                Icons.logout,
                color: primaryGreen,
              ))
        ],
      ),
      body: widget.userType == 'others'
          ? <Widget>[
              Booking(sport: 'cricket'),
              Booking(sport: 'volleyball'),
              Booking(sport: 'badminton'),
              Booking(sport: 'tennis'),
              Booking(sport: 'football'),
              Booking(sport: 'basketball')
            ][_index]

          /// Belongs to institution
          : <Widget>[
              if (isStaff) Controls(),
              Records(type: widget.userType),
              Data(),
              EventDataScreen(type: widget.userType),
              if (isStaff) Booking_Home(),
            ][_index],
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: VisibleScaffoldWidgets(),
          builder: (context, value, child) {
            final bool visibility = value as bool;
            return Visibility(
              visible: visibility,
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColor1,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                height: 58,
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width - 10,
                alignment: Alignment.center,
                child: TabBar(
                    isScrollable: true,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryGreen),
                    labelColor: whiteColor,
                    indicatorColor: primaryGreen,
                    controller: _tabController,
                    unselectedLabelColor: whiteColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 4,
                    onTap: (value) {
                      setState(() {
                        _index = value;
                      });
                    },
                    padding: EdgeInsets.only(
                        top: 10, bottom: 5, left: 10, right: 10),
                    labelPadding: EdgeInsets.symmetric(horizontal: 8),
                    indicatorPadding: EdgeInsets.symmetric(horizontal: -4),
                    tabs: widget.userType == 'others'
                        ? [
                            Tab(
                                child: tabs(
                                    icon: Icon(Icons.sports_cricket),
                                    data: 'Cricket',
                                    index: 0)),
                            Tab(
                                child: tabs(
                                    icon: Icon(Icons.sports_volleyball),
                                    data: "VolleyBall",
                                    index: 1)),
                            Tab(
                              child: tabs(
                                  icon: ImageIcon(
                                    AssetImage(
                                      'assets/badminton.png',
                                    ),
                                  ),
                                  data: 'Badminton',
                                  index: 2),
                            ),
                            Tab(
                                child: tabs(
                                    icon: Icon(Icons.sports_volleyball),
                                    data: "Tennis",
                                    index: 3)),
                            Tab(
                                child: tabs(
                                    icon: Icon(Icons.sports_soccer),
                                    data: 'Football',
                                    index: 4)),
                            Tab(
                                child: tabs(
                                    icon: Icon(Icons.sports_baseball),
                                    data: 'Basket Ball',
                                    index: 5)),
                          ]
                        : [
                            if (isStaff)
                              Tab(
                                child: tabs(
                                  icon: ImageIcon(AssetImage('assets/iot.png')),
                                  data: "Controls",
                                  index: 0,
                                ),
                              ),
                            Tab(
                                child: tabs(
                                    icon: ImageIcon(
                                        AssetImage('assets/files.png')),
                                    data: "Records",
                                    index: isStaff ? 1 : 0)),
                            Tab(
                              child: tabs(
                                  data: "Data",
                                  icon: ImageIcon(
                                      AssetImage('assets/exercise.png')),
                                  index: isStaff ? 2 : 1),
                            ),
                            Tab(
                              child: tabs(
                                  data: "Events",
                                  icon: ImageIcon(
                                      AssetImage('assets/running.png')),
                                  index: isStaff ? 3 : 2),
                            ),
                            if (isStaff)
                              Tab(
                                child: tabs(
                                    data: "Booking",
                                    icon: ImageIcon(
                                        AssetImage('assets/booking.png')),
                                    index: 4),
                              )
                          ]),
              ),
            );
          }),
      extendBody: true,
      floatingActionButton: ValueListenableBuilder(
          valueListenable: VisibleScaffoldWidgets(),
          builder: (context, value, child) {
            final bool visibility = value as bool;
            if ((widget.userType == 'staff' &&
                    (_index == 4 || _index == 3 || _index == 1)) ||
                widget.userType == 'others')
              return Visibility(
                visible: visibility,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _index == 4
                                ? BookGround()
                                : _index == 3
                                    ? AddEvents()
                                    : AddRecords()));
                      },
                      child: AddIcon()),
                ),
              );
            return Visibility(
              visible: false,
              child: Container(),
            );
            // return widget.userType == 'others' ||
            //         _index == 4 ||
            //         _index == 3 ||
            //         _index == 1
            //     ? Align(
            //         alignment: Alignment.bottomRight,
            //         child: GestureDetector(
            //             onTap: () {
            //               Navigator.of(context).push(MaterialPageRoute(
            //                   builder: (context) => _index == 4
            //                       ? BookGround()
            //                       : _index == 3
            //                           ? AddEvents()
            //                           : AddRecords()));
            //             },
            //             child: AddIcon()),
            //       )
            //     : null;
          }),
    );
  }

  Widget tabs({required icon, required String data, required index}) {
    return Row(
      children: [
        icon,
        SizedBox(
          width: 10,
        ),
        if (_index == index)
          Text(
            data,
            style: GoogleFonts.kalam(color: whiteColor, fontSize: 25),
          ),
      ],
    );
  }

  Future<void> signOutUser() async {
    await auth.signOut().then((value) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Login()), ((route) => false));
    });
  }
}

class VisibleScaffoldWidgets extends ValueNotifier<bool> {
  VisibleScaffoldWidgets._sharedInstance() : super(true);
  static final VisibleScaffoldWidgets _shared =
      VisibleScaffoldWidgets._sharedInstance();
  factory VisibleScaffoldWidgets() => _shared;

  void changeVisibleState({required bool state}) {
    value = state;
    notifyListeners();
  }
}
