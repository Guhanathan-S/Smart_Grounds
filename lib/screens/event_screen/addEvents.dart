import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_grounds/database/database.dart';
import 'package:smart_grounds/screens/constants.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({Key? key}) : super(key: key);

  @override
  _AddEventsState createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  bool submiting = false;
  DateTime? selectedEventDate = DateTime.now();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController team1Controller = TextEditingController();
  TextEditingController team2Controller = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController organizerController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String selectedStartTime = "";
  String selectedEndTime = "";
  String? _hour, _minute, _time;

  DataBase dataBase = DataBase();
  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: primaryColor1),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor1,
            ),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor1),
            borderRadius: BorderRadius.circular(20)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            color: primaryGreen,
            height: devHeight,
            padding: EdgeInsets.only(top: devHeight / 6, right: 10, left: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  fields("Event Name", eventNameController),
                  fields("Organizer", organizerController),
                  fields("Team 1 Name", team1Controller),
                  fields("Team 2 Name", team2Controller),
                  fields("Place", placeController),

                  /// Date
                  GestureDetector(
                      onTap: () {
                        buildMaterialDatePicker(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: primaryColor1)),
                          child: Row(children: [
                            IconButton(
                              onPressed: () {
                                buildMaterialDatePicker(context);
                              },
                              icon: Icon(Icons.calendar_today_outlined,
                                  color: primaryColor1),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${selectedEventDate!.toLocal()}".split(" ")[0],
                            )
                          ]))),

                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    'Event Timings',
                    style: GoogleFonts.alexandria(
                        color: primaryColor1, fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  /// Start Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectStartTime(context);
                        },
                        child: Container(
                          height: 60,
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: primaryColor1)),
                          child: Text(
                            selectedStartTime,
                            style: TextStyle(
                                color: primaryColor1,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '-',
                        style: TextStyle(color: primaryColor1, fontSize: 50),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectEndTime(context);
                        },
                        child: Container(
                          height: 60,
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: primaryColor1)),
                          child: Text(
                            selectedEndTime,
                            style: TextStyle(
                                color: primaryColor1,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  /// Add Button
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 50,
                      width: devWidth - devWidth * (20 / 100),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              submiting = true;
                            });
                            dataBase
                                .addEvent(
                              eventName: eventNameController.text,
                              organizer: organizerController.text,
                              team1: team1Controller.text,
                              team2: team2Controller.text,
                              place: placeController.text,
                              date: selectedEventDate!
                                  .toLocal()
                                  .toString()
                                  .split(" ")[0],
                              startTime: selectedStartTime,
                              endTime: selectedEndTime,
                            )
                                .then((value) {
                              Future.delayed(Duration(seconds: 2))
                                  .then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Event Added Successfully",
                                    style: TextStyle(color: primaryColor1),
                                  ),
                                  backgroundColor: primaryGreen,
                                  duration: Duration(seconds: 2),
                                ));
                                setState(() {
                                  submiting = false;
                                });
                                Navigator.pop(context);
                              });
                            }).catchError((e) {
                              setState(() {
                                submiting = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "There is an Error in Adding Event",
                                  style: TextStyle(color: primaryColor1),
                                ),
                                backgroundColor: primaryGreen,
                                duration: Duration(seconds: 2),
                              ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "Try agian later",
                                  style: TextStyle(color: primaryColor1),
                                ),
                                backgroundColor: primaryGreen,
                                duration: Duration(seconds: 1),
                              ));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor1,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Text(
                            "ADD",
                            style: TextStyle(fontSize: 25, color: primaryGreen),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          ClipPath(
            clipper: TopClipperConst(),
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              decoration: BoxDecoration(color: primaryColor1),
              child: Text(
                'Add Events',
                style: TextStyle(color: primaryGreen, fontSize: 35),
              ),
            ),
          ),
          if (submiting)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black38,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Adding Event"),
                  SizedBox(
                    height: 5,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            )
        ]),
      ),
    );
  }

  Widget fields(text, controller) {
    return TextFormField(
      controller: controller,
      maxLength: 30,
      cursorColor: primaryColor1,
      decoration: inputDecoration(text),
    );
  }

  /// Date Picker

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEventDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
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

  final theme = ThemeData.dark().copyWith(
    timePickerTheme: TimePickerThemeData(
        backgroundColor: primaryGreen,
        dayPeriodShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        hourMinuteShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        hourMinuteColor: primaryColor3,
        hourMinuteTextStyle: TextStyle(color: primaryColor1, fontSize: 40),
        hourMinuteTextColor: whiteColor,
        dialHandColor: primaryGreen,
        dialBackgroundColor: primaryColor1,
        dialTextColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? whiteColor
                : primaryGreen),
        entryModeIconColor: Colors.transparent),
    textTheme: TextTheme(
      labelSmall: TextStyle(color: primaryColor1, fontSize: 20),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateColor.resolveWith((states) => primaryColor3),
      foregroundColor: MaterialStateColor.resolveWith((states) => primaryGreen),
      overlayColor: MaterialStateColor.resolveWith((states) => whiteColor),
    )),
  );

  /// start time picker

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
}
