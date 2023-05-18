import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_grounds/database/database.dart';
import 'package:smart_grounds/screens/constants.dart';
import 'package:smart_grounds/screens/event_screen/eventDataModel.dart';
import 'package:smart_grounds/screens/event_screen/updateEvent.dart';
import 'package:smart_grounds/screens/home.dart';

class EventDataScreen extends StatefulWidget {
  final type;
  const EventDataScreen({this.type});

  @override
  _EventDataScreenState createState() => _EventDataScreenState();
}

class _EventDataScreenState extends State<EventDataScreen> {
  List<EventData> events = [];
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  Stream<DatabaseEvent>? _dataBaseEvents;

  // getData() {
  //   events.clear();
  //   _dataBaseEvents = database.ref().child('events').onValue.listen((event) {
  //     var eventMap = event.snapshot.value;
  //     var data = EventModel.fromJson(event.snapshot.value);
  //     events = data.eventData!;
  //     setState(() {});
  //   });
  // }

  bool updateEvent = false;
  DateTime dateTime = DateTime.now();
  String team1 = "";
  String team2 = "";
  String id = "";
  @override
  void initState() {
    // getData();
    DataBase().removeOldEvent();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.type);
    return WillPopScope(
      onWillPop: () async {
        VisibleScaffoldWidgets().changeVisibleState(state: true);
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () => DataBase().removeOldEvent(),
        color: primaryColor1,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: StreamBuilder(
                    stream: database.ref().child('events').onValue,
                    builder: (BuildContext context,
                        AsyncSnapshot<DatabaseEvent> snapShot) {
                      if (!snapShot.hasData)
                        return CircularProgressIndicator(
                          strokeWidth: 4,
                          color: primaryColor1,
                        );
                      if (snapShot.data!.snapshot.children.isEmpty)
                        return Center(
                          child: Text(
                            'No Events',
                            style: TextStyle(color: primaryGreen, fontSize: 35),
                          ),
                        );
                      events.clear();
                      events.addAll(
                          EventModel.fromJson(snapShot.data!.snapshot.value)
                              .eventData!);
                      List<EventData> temp = [];
                      events.sort((a, b) {
                        DateTime dateTime1 = DateTime.parse(a.date.toString() +
                            "${a.endTime!.split(" ")[1] == "AM" && (a.endTime!.split(":")[0].substring(0, 1) == '0') ? " 0" : " "}" +
                            "${(int.parse(a.endTime!.split(":")[0]) + (a.endTime!.split(" ")[1] == "PM" ? 12 : 0)).toString()}:${a.endTime!.split(" ")[0].split(":")[1]}");
                        DateTime dateTime2 = DateTime.parse(b.date.toString() +
                            "${b.endTime!.split(" ")[1] == "AM" && (b.endTime!.split(":")[0].substring(0, 1) == '0') ? " 0" : " "}" +
                            "${(int.parse(b.endTime!.split(":")[0]) + (b.endTime!.split(" ")[1] == "PM" ? 12 : 0)).toString()}:${b.endTime!.split(" ")[0].split(":")[1]}");
                        return dateTime1.compareTo(dateTime2);
                      });
                      temp.addAll(events.reversed);
                      events.clear();
                      events.addAll(temp);
                      return GridView.builder(
                          itemCount: events.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 150,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            if (events.length == 0)
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            return GestureDetector(
                              onTap: () {
                                VisibleScaffoldWidgets()
                                    .changeVisibleState(state: false);
                                showBottomSheet(
                                    enableDrag: false,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      topRight: Radius.circular(35),
                                    )),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                          height: devHeight / 2,
                                          decoration: BoxDecoration(
                                              color: primaryColor3,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(35),
                                                topRight: Radius.circular(35),
                                              )),
                                          child: BottomSheetData(
                                            eventData: events[index],
                                            type: widget.type,
                                          ));
                                    });
                              },
                              child: Card(
                                  color: primaryGreen,
                                  shadowColor: primaryGreen,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: listCard(event: events[index])),
                            );
                          });
                    })),
          ],
        ),
      ),
    );
  }

  /// New Ui
  Widget listCard({required EventData event}) {
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 0,
          child: ClipPath(
            clipper: DetailLeftClipper(),
            child: Container(
              padding: EdgeInsets.only(left: 5),
              alignment: Alignment.centerLeft,
              width: 170,
              height: 40,
              color: whiteColor,
              child: Text(
                event.team1!,
                style:
                    GoogleFonts.andadaPro(color: primaryColor1, fontSize: 20),
              ),
            ),
          ),
        ),
        // Align(
        //   alignment: Alignment.center,
        //   child: Container(
        //     color: whiteColor,
        //     child: Text(
        //       'Vs',
        //       style: GoogleFonts.satisfy(color: primaryColor1, fontSize: 25),
        //     ),
        //   ),
        // ),
        Positioned(
            bottom: 20,
            right: 0,
            child: ClipPath(
              clipper: DetailRightClipper(),
              child: Container(
                padding: EdgeInsets.only(right: 5),
                alignment: Alignment.centerRight,
                width: 170,
                height: 40,
                color: whiteColor,
                child: Text(
                  event.team2!,
                  style:
                      GoogleFonts.andadaPro(color: primaryColor1, fontSize: 20),
                ),
              ),
            )),
      ],
    );
  }
}

// class DetailBottomSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: CircleAvatar(
//               child: Image(
//                 image: AssetImage('assets/volleyball-player.png'),
//                 color: primaryColor1,
//               ),
//               backgroundColor: primaryGreen,
//               radius: 100,
//             ),
//           ),
//           Positioned(
//             bottom: 30,
//             right: 0,
//             child: Column(
//               // crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text('TextData 2',
//                     style: GoogleFonts.ralewayDots(
//                         fontWeight: FontWeight.w600,
//                         color: whiteColor,
//                         fontSize: 25)),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text('Score 2',
//                     style: GoogleFonts.ralewayDots(
//                         fontWeight: FontWeight.w600,
//                         color: whiteColor,
//                         fontSize: 25))
//               ],
//             ),
//           ),
//           Positioned(
//             left: 0,
//             top: 30,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('TextData 1',
//                     style: GoogleFonts.ralewayDots(
//                         fontWeight: FontWeight.w600,
//                         color: whiteColor,
//                         fontSize: 25)),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text('Score 1',
//                     style: GoogleFonts.ralewayDots(
//                         fontWeight: FontWeight.w600,
//                         color: whiteColor,
//                         fontSize: 25))
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.topRight,
//             child: Column(
//               children: [
//                 Text(
//                   'Date',
//                   style: GoogleFonts.ralewayDots(
//                       fontWeight: FontWeight.w600,
//                       color: whiteColor,
//                       fontSize: 20),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text('Time',
//                     style: GoogleFonts.ralewayDots(
//                         fontWeight: FontWeight.w600,
//                         color: whiteColor,
//                         fontSize: 20))
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: Text(
//               'Results need to be updated',
//               style: GoogleFonts.ralewayDots(
//                   fontWeight: FontWeight.w600, color: whiteColor, fontSize: 20),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class BottomSheetData extends StatelessWidget {
  BottomSheetData({required this.eventData, required this.type});
  late final EventData eventData;
  late final String type;
  final DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    String scoreData = dateTime.isBefore(DateTime.parse(
            "${eventData.date} ${eventData.startTime!.split(" ")[0]}" + ":00"))
        ? "Upcoming Event"
        : dateTime.isAfter(DateTime.parse(
                    "${eventData.date} ${eventData.startTime!.split(" ")[0]}" +
                        ":00")) &&
                dateTime.isBefore(DateTime.parse(
                    "${eventData.date} ${eventData.endTime!.split(" ")[0]}" +
                        ":00"))
            ? "On Going Event"
            : "Event done results need to be updated";
    return Container(
        child: Stack(
      children: [
        BottomSheetBackGroundUi(),
        Container(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              ///  Team Name
              BottomSheetTeamData(
                teamName1: eventData.team1!,
                teamName2: eventData.team2!,
              ),

              /// Team Score
              BottomSheetDetails(
                widthLeft: 175,
                widthRight: 175,
                leftContainerColor: whiteColor,
                rightContainerColor: primaryGreen,
                leftData: Text(
                  eventData.team1Score != null
                      ? eventData.team1Score!
                      : scoreData == "Event done results need to be updated"
                          ? "Results not Updated"
                          : scoreData == 'On Going Event'
                              ? 'Score 1'
                              : 'Upcoming Event',
                  style: TextStyle(color: primaryColor1, fontSize: 15),
                ),
                rightData: Text(
                  eventData.team2Score != null
                      ? eventData.team2Score!
                      : scoreData == "Event done results need to be updated"
                          ? "Results not Updated"
                          : scoreData == 'On Going Event'
                              ? 'Score 1'
                              : 'Upcoming Event',
                  style: TextStyle(color: primaryColor1, fontSize: 15),
                ),
              ),

              /// Date
              BottomSheetDetails(
                widthLeft: 100,
                widthRight: 250,
                leftContainerColor: whiteColor,
                rightContainerColor: primaryGreen,
                leftClipper: 1.5,
                rightClipper: 7,
                leftData: Icon(
                  Icons.calendar_today_outlined,
                  color: primaryColor1,
                ),
                rightData: Text(
                  eventData.date!,
                  style: TextStyle(color: primaryColor1, fontSize: 18),
                ),
              ),

              /// Time Data
              BottomSheetDetails(
                widthLeft: 250,
                widthRight: 100,
                leftContainerColor: whiteColor,
                rightContainerColor: primaryGreen,
                leftClipper: 1.15,
                rightClipper: 3.5,
                leftData: Text(
                  "${eventData.startTime!}  -  ${eventData.endTime!} ",
                  style: TextStyle(color: primaryColor1, fontSize: 18),
                ),
                rightData: ImageIcon(
                  AssetImage('assets/clock.png'),
                  color: primaryColor1,
                ),
              ),

              /// Location
              BottomSheetDetails(
                widthLeft: 100,
                widthRight: 250,
                leftContainerColor: whiteColor,
                rightContainerColor: primaryGreen,
                leftClipper: 1.5,
                rightClipper: 7,
                leftData: Icon(
                  Icons.location_on_outlined,
                  color: primaryColor1,
                ),
                rightData: Text(
                  eventData.place!,
                  style: TextStyle(color: primaryColor1, fontSize: 18),
                ),
              ),

              SizedBox(
                height: 5,
              ),

              /// Update Icon
              eventData.team1Score == null &&
                      eventData.team2Score == null &&
                      scoreData == "Event done results need to be updated"
                  ? type == 'staff'
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              showBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return UpdateEventScore(
                                      id: eventData.eventId,
                                    );
                                  });
                            },
                            child: ClipPath(
                              clipper: UpdateResultClipper(),
                              child: Container(
                                padding: EdgeInsets.only(left: 30),
                                alignment: Alignment.center,
                                height: 40,
                                width: 150,
                                color: primaryGreen,
                                child: Text(
                                  'Update Result',
                                  style: TextStyle(
                                      color: primaryColor1, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                  : scoreData != "Event done results need to be updated"
                      ? Container()
                      : Text(
                          "Won By :  ${eventData.wonBy!}",
                          style: TextStyle(
                              fontSize: 25,
                              color: primaryGreen,
                              fontWeight: FontWeight.bold),
                        )
            ],
          ),
        )
      ],
    ));
  }
}

class BottomSheetBackGroundUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: primaryColor3,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)))),
        Positioned(
          right: -50,
          top: 20,
          child: Container(
            height: 180,
            width: 180,
            decoration:
                BoxDecoration(color: white38Color, shape: BoxShape.circle),
          ),
        ),
        Positioned(
          left: 80,
          child: ClipPath(
            clipper: CenterClipper(),
            child: Container(
              color: white38Color,
              height: 300,
              width: 160,
            ),
          ),
        ),

        /// bottom right side design
        Positioned(
          bottom: 30,
          right: 0,
          child: ClipPath(
            clipper: BottomClipper(),
            child: Container(
              height: 100,
              width: 180,
              color: white38Color,
            ),
          ),
        ),

        /// Bottom Left Side design
        Positioned(
            left: -25,
            bottom: 10,
            child: Row(
              children: List.generate(
                  15,
                  (index) => Transform.rotate(
                      angle: pi / 4,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        color: white38Color,
                        height: 120,
                        width: 2,
                      ))),
            ))
      ],
    );
  }
}

class BottomSheetTeamData extends StatelessWidget {
  BottomSheetTeamData({required String teamName1, required String teamName2})
      : teamName1 = teamName1,
        teamName2 = teamName2;
  late final String teamName1;
  late final String teamName2;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: devWidth,
      child: Stack(
        children: [
          /// Left Container
          Positioned(
            child: ClipPath(
                clipper: DetailLeftClipper(),
                child: Container(
                  alignment: Alignment.center,
                  color: whiteColor,
                  height: 100,
                  width: devWidth / 2 + 35,
                  child: Text(
                    teamName1,
                    style: TextStyle(color: primaryColor1),
                  ),
                )),
          ),

          /// Right Container
          Positioned(
            top: 15,
            right: 0,
            child: ClipPath(
                clipper: DetailRightClipper(),
                child: Container(
                  alignment: Alignment.center,
                  color: whiteColor,
                  height: 100,
                  width: devWidth / 2 + 35,
                  child: Text(
                    teamName2,
                    style: TextStyle(color: primaryColor1),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class BottomSheetDetails extends StatelessWidget {
  BottomSheetDetails(
      {required double widthLeft,
      required double widthRight,
      required Color leftContainerColor,
      required Color rightContainerColor,
      required Widget leftData,
      required Widget rightData,
      double leftClipper = 1.25,
      double rightClipper = 5,
      double heightLeft = 40,
      double heightRight = 40})
      : widthLeft = widthLeft,
        widthRight = widthRight,
        leftClipper = leftClipper,
        rightClipper = rightClipper,
        leftContainerColor = leftContainerColor,
        rightContainerColor = rightContainerColor,
        leftData = leftData,
        rightData = rightData,
        heightLeft = heightLeft,
        heightRight = heightRight;
  late final double widthLeft;
  late final double widthRight;
  late final double heightLeft;
  late final double heightRight;
  late final Color leftContainerColor;
  late final Color rightContainerColor;
  late final Widget leftData;
  late final Widget rightData;
  late final double leftClipper;
  late final double rightClipper;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Stack(
        children: [
          /// Left Container
          Positioned(
            left: 0,
            child: ClipPath(
              clipper: DataLeftClipper(clipperValue: leftClipper),
              child: Container(
                alignment: Alignment.center,
                height: heightLeft,
                width: widthLeft,
                color: leftContainerColor,
                child: leftData,
              ),
            ),
          ),

          /// Right Container
          Positioned(
            right: 0,
            child: ClipPath(
              clipper: DataRightClipper(clipperValue: rightClipper),
              child: Container(
                alignment: Alignment.center,
                height: heightRight,
                width: widthRight,
                color: rightContainerColor,
                child: rightData,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CenterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 3, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 1.5, size.height / 3);
    path.lineTo(size.width, size.height / 1.5);
    path.lineTo(size.width / 1.5, size.height);
    path.lineTo(0, size.height / 3);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 3.5, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class DetailLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 1.5, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class DetailRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 3, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class DataLeftClipper extends CustomClipper<Path> {
  DataLeftClipper({required double clipperValue}) : clipperValue = clipperValue;
  late final double clipperValue;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / clipperValue, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class DataRightClipper extends CustomClipper<Path> {
  DataRightClipper({required double clipperValue})
      : clipperValue = clipperValue;
  late final double clipperValue;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / clipperValue, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class UpdateResultClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 4, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
