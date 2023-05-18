import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_grounds/database/database.dart';
import 'package:smart_grounds/screens/bookings/booking_model.dart';
import 'package:smart_grounds/screens/constants.dart';

class BookGround extends StatefulWidget {
  @override
  _BookGroundState createState() => _BookGroundState();
}

class _BookGroundState extends State<BookGround> {
  bool submiting = false;
  DateTime? selectedEventDate = DateTime.now();
  TextEditingController bookedByController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String selectedStartTime = "0:00";
  String selectedEndTime = "0:00";
  String? _hour, _minute, _time;
  bool fullDay = false;
  List<String> category = [
    "Cricket",
    "Volley Ball",
    "Baseket Ball",
    "Tennis",
    "Foot Ball",
    "Badminton"
  ];
  bool available = true;
  List<BookingData> booked = [];
  List<BookingData> filtering = [];
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  Future<void> getData() async {
    booked.clear();
    await database.ref().child('booking').get().then((event) {
      if (event.exists) {
        var data = BookingModel.fromJson(event.value);
        print('getting data ::');
        if (selectedGround.toLowerCase() == 'cricket') {
          booked = data.cricket!;
          print('data from data base: ${booked.length}');
        } else if (selectedGround.toLowerCase() == 'badminton') {
          booked = data.badminton!;
        } else if (selectedGround.toLowerCase() == 'football') {
          booked = data.footBall!;
        } else if (selectedGround.toLowerCase() == 'tennis') {
          booked = data.tennis!;
        } else if (selectedGround.toLowerCase() == 'volleyball') {
          booked = data.volleyBall!;
        }
      }
    });
  }

  String selectedCategory = "Cricket";
  String selectedGround = '';
  DataBase dataBase = DataBase();
  ScrollController groundScrollController = ScrollController();
  InputDecoration inputDecoration(String labeltext) {
    return InputDecoration(
        hintText: labeltext,
        hintStyle: TextStyle(color: primaryColor1),
        filled: true,
        focusColor: whiteColor,
        fillColor: whiteColor,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: whiteColor),
            borderRadius: BorderRadius.circular(30)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: whiteColor),
            borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: whiteColor),
            borderRadius: BorderRadius.circular(30)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          width: devWidth,
          height: devHeight,
          color: whiteColor,
        ),
        ClipPath(
          clipper: TopUIClipper(),
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            decoration: BoxDecoration(color: primaryColor1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                RichText(
                    text: TextSpan(
                        style: TextStyle(color: primaryGreen, fontSize: 20),
                        children: [
                      TextSpan(text: "${weekDay[DateTime.now().weekday]},"),
                      TextSpan(text: " ${DateTime.now().day}"),
                      TextSpan(text: " ${month[DateTime.now().month]}"),
                      TextSpan(
                          text:
                              " ${DateTime.now().year.toString().substring(2)}")
                    ])),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Book your Slot",
                  style: TextStyle(color: primaryGreen, fontSize: 40),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.only(top: 50),
            child: Container(
              height: devHeight - (devHeight * (45 / 100)),
              width: devWidth - (devWidth * (10 / 100)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: groundScrollController,
                    child: Row(
                        children: List.generate(
                            icon.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedGround = icon.entries
                                          .map((data) => data.key)
                                          .toList()[index];
                                      selectedCategory = selectedGround;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 120,
                                    child: Card(
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: icon.entries
                                                  .map((data) => data.key)
                                                  .toList()[index] ==
                                              'Badminton'
                                          ? FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: ImageIcon(
                                                icon.entries
                                                    .map((data) => data.value)
                                                    .toList()[index],
                                                color: selectedGround ==
                                                        icon.entries
                                                            .map((data) =>
                                                                data.key)
                                                            .toList()[index]
                                                    ? primaryGreen
                                                    : primaryColor1,
                                              ),
                                            )
                                          : Icon(
                                              icon.entries
                                                  .map((data) => data.value)
                                                  .toList()[index],
                                              color: selectedGround ==
                                                      icon.entries
                                                          .map((data) =>
                                                              data.key)
                                                          .toList()[index]
                                                  ? primaryGreen
                                                  : primaryColor1),
                                      color: selectedGround ==
                                              icon.entries
                                                  .map((data) => data.key)
                                                  .toList()[index]
                                          ? primaryColor1
                                          : whiteColor,
                                    ),
                                  ),
                                ))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///Start Time
                          Container(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: whiteColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(35))),
                                onPressed: () {
                                  _selectStartTime(context);
                                },
                                child: Text(
                                  selectedStartTime,
                                  style: TextStyle(
                                      color: primaryColor1, fontSize: 25),
                                )),
                          ),

                          ///End Time
                          SizedBox(
                            width: 25,
                          ),

                          Container(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: whiteColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(35))),
                                onPressed: () {
                                  _selectEndTime(context);
                                },
                                child: Text(
                                  selectedEndTime,
                                  style: TextStyle(
                                      color: primaryColor1, fontSize: 25),
                                )),
                          )
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: primaryColor1, shape: BoxShape.circle),
                        child: Text(
                          "-",
                          style: TextStyle(fontSize: 30, color: primaryGreen),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  ///Booking Date

                  Card(
                    shadowColor: greyColor,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(children: [
                        RichText(
                          text: TextSpan(
                              style: GoogleFonts.publicSans(
                                  color: primaryColor1, fontSize: 30),
                              children: [
                                TextSpan(
                                    text:
                                        "${selectedEventDate!.day.toString()} "),
                                TextSpan(
                                    text:
                                        "${month[selectedEventDate!.month - 1]} "),
                                TextSpan(
                                    text:
                                        "${selectedEventDate!.year.toString().substring(2)}")
                              ]),
                        ),
                        Spacer(),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Card(
                              shape: CircleBorder(),
                              child: IconButton(
                                onPressed: () {
                                  buildMaterialDatePicker(context);
                                },
                                icon: Icon(Icons.calendar_today_outlined,
                                    color: primaryColor3),
                              ),
                            ),
                            Padding(
                              // alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                selectedEventDate!.month.toString(),
                                style: GoogleFonts.sourceSansPro(
                                    color: primaryColor1, fontSize: 8),
                              ),
                            )
                          ],
                        ),
                      ]),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  /// Name Field
                  fields("Name", bookedByController),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            submiting = true;
                          });
                          print('clicked');
                          await check();
                          if (available) {
                            print('booking');
                            dataBase
                                .bookGround(
                              booker: bookedByController.text,
                              sportName: selectedCategory
                                  .toLowerCase()
                                  .replaceAll(" ", ""),
                              date: selectedEventDate!
                                  .toLocal()
                                  .toString()
                                  .split(" ")[0],
                              startTime: selectedStartTime,
                              endTime: selectedEndTime,
                            )
                                .then((value) {
                              Navigator.pop(
                                  context,
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Booked Successfully",
                                      style: TextStyle(color: primaryColor1),
                                    ),
                                    backgroundColor: primaryGreen,
                                    duration: Duration(seconds: 2),
                                  )));
                            }).catchError((e) {
                              setState(() {
                                submiting = false;
                              });
                              print('error $e');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "There is an Error in Booking\n Try again later"),
                                backgroundColor: primaryColor3,
                                duration: Duration(seconds: 2),
                              ));
                            });
                          } else {
                            print('cannot be book');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Solt Already Booked. Choose another one",
                                style: TextStyle(color: primaryColor1),
                              ),
                              backgroundColor: primaryGreen,
                              duration: Duration(seconds: 3),
                            ));
                            setState(() {
                              submiting = false;
                            });
                          }
                          available = true;
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: primaryColor1),
                        child: Text(
                          "Book",
                          style: TextStyle(color: primaryGreen, fontSize: 20),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
        if (submiting)
          Container(
            height: double.infinity,
            width: double.infinity,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Adding Event",
                      style: TextStyle(color: primaryColor1, fontSize: 30),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CircularProgressIndicator(
                      color: primaryGreen,
                    )
                  ],
                ),
              ),
            ),
          )
      ]),
    );
  }

  Future<void> check() async {
    await getData();
    List bookingdata = [];
    booked.forEach((element) {
      bookingdata.add([element.bookedDate, element.startTime, element.endTime]);
    });
    bookingdata.forEach((element) {
      print("${element[0]}  == ${selectedEventDate.toString().split(" ")[0]}");
      print("${element[1]}  == $selectedStartTime");
      print("${element[2]}  == $selectedEndTime");
      if ((element.contains(selectedEventDate.toString().split(" ")[0]) &&
          element.contains(selectedStartTime) &&
          element.contains(selectedEndTime))) {
        available = false;
      }
    });
    if (available) {
      print('can be book');
    } else {
      print('can\'t book');
    }
    // available = false;
    print("Booking data : $bookingdata");
  }

  Widget fields(text, controller) {
    return Card(
      shadowColor: greyColor,
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 25),
        decoration: inputDecoration(text),
        cursorColor: primaryColor1,
      ),
    );
  }

  /// Date Picker

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEventDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month + 1, DateTime.now().day),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      helpText: 'Select Available date',
      cancelText: 'Not now',
      confirmText: 'Ok',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Availabel date',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
              dialogTheme: DialogTheme(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  primary: primaryColor1,
                  onPrimary: primaryGreen,
                  secondary: primaryColor2,
                  onSecondary: primaryColor2,
                  error: Colors.red,
                  onError: Colors.red,
                  background: primaryGreen,
                  onBackground: primaryGreen,
                  surface: primaryColor3,
                  onSurface: primaryColor3)),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedEventDate)
      setState(() {
        selectedEventDate = picked;
      });
  }

  /// start time picker

  final theme = ThemeData.light().copyWith(
      timePickerTheme: TimePickerThemeData(
          backgroundColor: primaryGreen,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          hourMinuteColor: primaryColor3,
          hourMinuteTextColor: primaryGreen,
          dialHandColor: primaryGreen,
          dialBackgroundColor: primaryColor1,
          dialTextColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.selected)
                  ? whiteColor
                  : primaryGreen),
          entryModeIconColor: primaryColor3),
      textTheme: TextTheme(
        labelSmall: TextStyle(color: primaryColor1, fontSize: 20),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => primaryColor3),
        foregroundColor:
            MaterialStateColor.resolveWith((states) => primaryGreen),
        overlayColor: MaterialStateColor.resolveWith((states) => whiteColor),
      )));

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (context, child) {
          return Theme(data: theme, child: child!);
        });
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        selectedStartTime = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  /// end time picker
  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (context, child) {
          return Theme(data: theme, child: child!);
        });
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        selectedEndTime = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  /// Divider
  Widget divider() => Divider(
        color: primaryGreen,
        thickness: 1,
      );
}

class TopUIClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, devHeight * (40 / 100));
    path.quadraticBezierTo(
        devWidth / 2, devHeight * (55 / 100), devWidth, devHeight * (40 / 100));
    path.lineTo(devWidth, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
