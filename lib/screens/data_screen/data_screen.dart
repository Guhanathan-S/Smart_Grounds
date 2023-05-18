import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/screens/constants.dart';
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
  ScrollController listController = ScrollController();
  getUserId() async {
    await fireStoreInstance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      userId = value.get('register_number');
      print(userId);
    });
    // getData();
  }

  getData() {
    _dataStream =
        database.ref().child("users_data/$userId").onValue.listen((event) {
      try {
        var recivedData = Data_Model.fromJson(event.snapshot.value);
        usersData = recivedData.data!;
      } catch (e) {
        print(e);
        data = true;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // getUserId();
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
    // if (data)
    //   return Center(
    //     child: Text(
    //       "No Record Found",
    //       style: TextStyle(color: primaryGreen, fontSize: 30),
    //     ),
    //   );
    // if (usersData.length == 0)
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser!.uid)
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapShot) {
            if (!snapShot.hasData)
              return Center(child: CircularProgressIndicator());
            userId = snapShot.data!.get('register_number');
            return StreamBuilder(
                stream: database.ref().child("users_data/$userId").onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapShot) {
                  usersData.clear();
                  if (!snapShot.hasData)
                    return Center(child: CircularProgressIndicator());
                  if (snapShot.data!.snapshot.children.isEmpty)
                    return Center(
                      child: Text(
                        'No Records',
                        style: TextStyle(color: primaryGreen, fontSize: 35),
                      ),
                    );
                  usersData.addAll(
                      Data_Model.fromJson(snapShot.data!.snapshot.value).data!);
                  usersData.sort((a, b) => a.date!.compareTo(b.date!));
                  List<UserData> temp = [];
                  temp.addAll(usersData.reversed);
                  usersData.clear();
                  usersData.addAll(temp);
                  return ListView.separated(
                      controller: listController,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: usersData.length + 1,
                      itemBuilder: (context, index) {
                        // print(listController.);
                        if (index == usersData.length)
                          return SizedBox(
                            height: 50,
                          );
                        return NewCardDesign(
                          userData: usersData[index],
                        );

                        // DetailsCardUi();

                        // card(usersData[index]);
                      });
                });
          }),
    );
  }

  // Widget card(data) {
  //   return Material(
  //     elevation: 5,
  //     borderRadius: BorderRadius.circular(10),
  //     child: GestureDetector(
  //       onTap: () {
  //         // Navigator.push(
  //         //     context, MaterialPageRoute(builder: (context) => DetailCard()));
  //       },
  //       child: Container(
  //           margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //           height: 160,
  //           padding: EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.calendar_today_outlined,
  //                     color: Colors.black,
  //                   ),
  //                   SizedBox(
  //                     width: 5,
  //                   ),
  //                   Text(
  //                     data.date != null ? data.date : "",
  //                     style: TextStyle(fontSize: 14, color: Colors.black),
  //                   ),
  //                 ],
  //               ),
  //               carddata("In time", data.inTime != null ? data.inTime : ""),
  //               carddata("Out time", data.outTime != null ? data.outTime : ""),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   if (data.calories == null)
  //                     GestureDetector(
  //                       onTap: () {
  //                         Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => CalorisCal(
  //                                       dataKey: data.key,
  //                                     )));
  //                       },
  //                       child: Text(
  //                         "Enter Workouts To get Calories",
  //                         style: GoogleFonts.zillaSlab(
  //                             fontSize: 18, color: Colors.grey[600]),
  //                       ),
  //                     ),
  //                   if (data.calories != null) ...[
  //                     Text(
  //                       "Total Calories burn   :",
  //                     ),
  //                     Spacer(),
  //                     Text(data.calories),
  //                     SizedBox(
  //                       width: 100,
  //                     )
  //                   ]
  //                 ],
  //               )
  //             ],
  //           )),
  //     ),
  //   );
  // }

  // Widget carddata(text, data) {
  //   return Row(
  //     children: [
  //       ImageIcon(
  //         AssetImage("assets/clock.png"),
  //         size: 20,
  //         color: Colors.black,
  //       ),
  //       SizedBox(width: 5),
  //       Text(
  //         text,
  //         style: TextStyle(
  //           fontSize: 14,
  //         ),
  //       ),
  //       Spacer(),
  //       Text(
  //         ":  $data",
  //         style: TextStyle(fontSize: 14, color: Colors.black),
  //       ),
  //       SizedBox(
  //         width: 50,
  //       ),
  //     ],
  //   );
  // }
}

class NewCardDesign extends StatefulWidget {
  NewCardDesign({required this.userData});

  UserData userData;

  @override
  State<NewCardDesign> createState() => _NewCardDesignState();
}

class _NewCardDesignState extends State<NewCardDesign>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late int totalTime;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalTime = (((widget.userData.time != null
                        ? (int.parse(widget.userData.time!.split(' ')[0]))
                            .toInt()
                        : 0) ~/
                    30) *
                30 +
            30)
        .toInt();
    return Container(
      height: 250,
      width: devWidth,
      decoration: BoxDecoration(
          color: primaryGreen, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Chip(
              backgroundColor: primaryColor1,
              label: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: primaryGreen,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.userData.date!,
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              dataCardUi(
                  title: 'Calories Burn',
                  data: widget.userData.calories != null
                      ? widget.userData.calories!
                      : 0,
                  total: widget.userData.totCal),
              SizedBox(
                width: 10,
              ),
              dataCardUi(
                  title: 'Time',
                  data: widget.userData.time != null
                      ? (int.parse(widget.userData.time!.split(' ')[0])).toInt()
                      : 0,
                  total: totalTime),
              // Expanded(
              //   child: Container(
              //     height: 180,
              //     decoration: BoxDecoration(
              //         color: primaryColor1,
              //         borderRadius: BorderRadius.circular(20)),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           'Time',
              //           style: TextStyle(color: primaryGreen),
              //         ),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             Container(
              //               height: 100,
              //               width: 100,
              //               decoration: BoxDecoration(
              //                 border: Border.all(
              //                     color: primaryGreen.withOpacity(.6),
              //                     width: 4),
              //                 shape: BoxShape.circle,
              //               ),
              //             ),
              //             Container(
              //               height: 95,
              //               width: 95,
              //               child: AnimatedBuilder(
              //                   animation: _animation,
              //                   builder: (context, child) {
              //                     return CustomPaint(
              //                       painter: CircleProgressPainter(
              //                           progress: _animation.value,
              //                           data: (45 / 60) * 100),
              //                       child: Align(
              //                           alignment: Alignment.center,
              //                           child: Text(
              //                             '45',
              //                             style: TextStyle(
              //                                 color: whiteColor, fontSize: 20),
              //                           )),
              //                       // CircularOuterIndicatorPainter(
              //                       //   animation: _animation.value,
              //                       // ),
              //                     );
              //                   }),
              //             )
              //           ],
              //         )
              //         // Container(
              //         //   child: CircularProgressIndicator(
              //         //     value: 50.0 /
              //         //         100, // Convert percentage to a value between 0 and 1
              //         //     backgroundColor: Colors.grey[300],
              //         //     valueColor: AlwaysStoppedAnimation<Color>(
              //         //         Colors.blue), // Optional: set the progress color
              //         //   ),
              //         // )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }

  Widget dataCardUi({
    required String title,
    required int data,
    required int? total,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (data == 0 || total == null)
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CalorisCal(
                      dataKey: widget.userData.key!,
                    )));
        },
        child: Container(
            height: 180,
            decoration: BoxDecoration(
                color: primaryColor1, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: primaryGreen),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(alignment: Alignment.center, children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: primaryGreen.withOpacity(.6), width: 4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    height: 95,
                    width: 95,
                    child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: CircleProgressPainter(
                                progress: _animation.value,
                                data:
                                    total != null ? ((data) / total) * 100 : 0),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  data != 0 ? data.toString() : 'No Data',
                                  style: TextStyle(
                                      color: whiteColor, fontSize: 20),
                                )),
                            // CircularOuterIndicatorPainter(
                            //   animation: _animation.value,
                            // ),
                          );
                        }),
                  )
                ])
              ],
            )),
      ),
    );
  }
}

class DetailsCardUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            color: whiteColor,
            height: 300,
          ),

          /// Top Container
          Align(
            alignment: Alignment.topRight,
            child: ClipPath(
              clipper: TopContainerClipper(),
              child: Container(
                height: 60,
                width: devWidth / 1.4,
                color: primaryGreen,
              ),
            ),
          ),

          /// Right Container
          Align(
              alignment: Alignment.topRight,
              child: ClipPath(
                  clipper: RightSideContainer(),
                  child: Container(
                    height: 300,
                    width: devWidth / 2 - 10,
                    decoration: BoxDecoration(
                        color: primaryColor1,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/fitness.jpg"))),
                  ))),

          /// Left Container
          Align(
            alignment: Alignment.topLeft,
            child: ClipPath(
              clipper: LeftSideContainer(),
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  color: Colors.amber[400],
                  height: 300,
                  width: devWidth / 1.55,
                ),
              ),
            ),
          ),

          /// Bottom Container
          Positioned(
            bottom: 0,
            child: ClipPath(
                clipper: BottomContainerClipper(),
                child: Container(
                  height: 70,
                  width: devWidth / 2 + 80,
                  color: primaryColor1,
                )),
          ),
        ],
      ),
    );
  }
}

class TopContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class RightSideContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 1.3, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 1.3, size.height);
    path.lineTo(size.width / 8, size.height / 1.2);
    path.quadraticBezierTo(0, size.height / 1.3, 0, size.height / 1.5);
    // path.lineTo(0, size.height / 1.2);
    path.lineTo(0, size.height / 3);
    path.quadraticBezierTo(0, size.height / 6, size.width / 6, size.height / 7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class LeftSideContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width / 1.5, size.height / 8);
    path.quadraticBezierTo(
        size.width, size.height / 6, size.width, size.height / 3);
    path.lineTo(size.width, size.height / 1.5);
    path.quadraticBezierTo(
        size.width, size.height / 1.26, size.width / 1.2, size.height / 1.18);
    path.lineTo(0, size.height);

    // path.lineTo(size.width / 1.3, size.height);
    // path.lineTo(size.width / 8, size.height / 1.2);
    // path.quadraticBezierTo(0, size.height / 1.3, 0, size.height / 1.5);
    // // path.lineTo(0, size.height / 1.2);
    // path.lineTo(0, size.height / 3);
    // path.quadraticBezierTo(0, size.height / 6, size.width / 6, size.height / 7);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class BottomContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width / 1.3, size.height / 2.4);
    path.quadraticBezierTo(
        size.width / 1.1, size.height / 2, size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class CircularIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = primaryColor3.withOpacity(20)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// class CircularOuterIndicatorPainter extends CustomPainter {
//   CircularOuterIndicatorPainter({required double animation})
//       : animation = animation;
//   late double animation;
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = whiteColor
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 13
//       ..style = PaintingStyle.stroke;

//     Path path = Path();
//     path.moveTo((size.width / 2), (size.height));
//     path.arcToPoint(
//       Offset((size.width / 2) * animation, (0) * animation),
//       radius: Radius.circular(size.width / 2),
//     );

//     canvas.drawPath(path, paint);
//     Path path1 = Path();
//     path1.moveTo(size.width / 2, 0);
//     path1.arcToPoint(
//       Offset(90, 27.5),
//       radius: Radius.circular(size.width / 2),
//     );
//     print("${size.width} , ${(size.height / 2)}");
//     canvas.drawPath(path1, paint);
//     double radius = size.width / 2;
//     List points = [];
//     for (int theta = 0; theta <= 360; theta++) {
//       final x = radius * cos(theta * pi / 180);
//       final y = radius * sin(theta * pi / 180);
//       points.add([x, y]);
//     }
//     print(points.length);
//     // final rect = Rect.fromCircle(
//     //     center: Offset(size.width / 2, size.height / 2),
//     //     radius: size.width / 2);
//     // canvas.drawArc(rect, pi / 4, pi, false, paint);
//   }

//   @override
//   bool shouldRepaint(CircularOuterIndicatorPainter oldDelegate) =>
//       oldDelegate.animation != animation;
// }

class CircleProgressPainter extends CustomPainter {
  late Paint _paint;
  double progress;
  double data;

  CircleProgressPainter({required this.progress, required this.data}) {
    _paint = Paint()
      ..color = primaryGreen
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 13
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      pi / 2,
      pi * 0.02 * data * progress,
      false,
      _paint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// class CircleProgressCalPainter extends CustomPainter {
//   late Paint _paint;
//   double progress;
//   double data;

//   CircleProgressCalPainter({required this.progress, required this.data}) {
//     _paint = Paint()
//       ..color = primaryGreen
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 13 
//       ..style = PaintingStyle.stroke;
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     double radius = size.width / 2;
//     canvas.drawArc(
//       Rect.fromCircle(center: Offset(radius, radius), radius: radius),
//       pi / 2,
//       pi * 0.02 * data * progress,
//       false,
//       _paint,
//     );
//   }

//   @override
//   bool shouldRepaint(CircleProgressCalPainter oldDelegate) =>
//       oldDelegate.progress != progress;
// }
