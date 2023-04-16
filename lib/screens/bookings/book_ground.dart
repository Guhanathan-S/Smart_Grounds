import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:smart_grounds/database/database.dart';
import 'package:smart_grounds/screens/bookings/booking_model.dart';

class BookGround extends StatefulWidget {
  @override
  _BookGroundState createState() => _BookGroundState();
}

class _BookGroundState extends State<BookGround> {
  bool submiting = false;
  DateTime? selectedEventDate = DateTime.now();
  TextEditingController bookedByController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String selectedStartTime = "";
  String selectedEndTime = "";
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
  bool available = false;
  List<BookingData> booked = [];
  List<BookingData> filtering = [];
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  getData() {
    booked.clear();
    database.ref().child('booking').onValue.listen((event) {
      var data = BookingModel.fromJson(event.snapshot.value);
      if (selectedGround == 'cricket') {
        booked = data.cricket!;
      } else if (selectedGround == 'badminton') {
        booked = data.badminton!;
      } else if (selectedGround == 'football') {
        booked = data.footBall!;
      } else if (selectedGround == 'tennis') {
        booked = data.tennis!;
      } else if (selectedGround == 'volleyball') {
        booked = data.volleyBall!;
      }
      setState(() {});
    });
  }

  String selectedCategory = "Cricket";
  String selectedGround = '';
  DataBase dataBase = DataBase();
  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
        hintText: hint,
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Events"),
        backgroundColor: Colors.cyan,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                fields("Booker Name", bookedByController),

                // Ground
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.cyan)),
                  child: DropdownButton<String>(
                      isExpanded: true,
                      underline: Container(),
                      value: selectedCategory,
                      onChanged: (String? value) async {
                        setState(() {
                          selectedCategory = value!;
                          selectedGround = selectedCategory
                              .toLowerCase()
                              .replaceAll(' ', '');
                        });
                        await getData();
                      },
                      items: category
                          .map<DropdownMenuItem<String>>((item) =>
                              DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                          .toList()),
                ),

                SizedBox(
                  height: 30,
                ),

                /// Date
                GestureDetector(
                    onTap: () {
                      buildMaterialDatePicker(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.cyan)),
                        child: Row(children: [
                          IconButton(
                            onPressed: () {
                              buildMaterialDatePicker(context);
                            },
                            icon: Icon(Icons.calendar_today_outlined,
                                color: Colors.cyan),
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

                /// Start Time
                if (!fullDay)
                  Row(
                    children: [
                      Text(
                        "Start Time",
                        style: TextStyle(color: Colors.cyan, fontSize: 20),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          _selectStartTime(context);
                        },
                        child: Container(
                          height: 60,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.cyan, width: 3)),
                          child: Text(
                            selectedStartTime,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),

                /// End Time
                if (!fullDay)
                  Row(
                    children: [
                      Text(
                        "End Time",
                        style: TextStyle(color: Colors.cyan, fontSize: 20),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          _selectEndTime(context);
                        },
                        child: Container(
                          height: 60,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.cyan, width: 3)),
                          child: Text(
                            selectedEndTime,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                      ),
                    ],
                  ),

                SizedBox(
                  height: 10,
                ),

                /// Full day
                Row(
                  children: [
                    Checkbox(
                        value: fullDay,
                        onChanged: (value) {
                          setState(() {
                            fullDay = value!;
                          });
                        }),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Check for Full Day'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                /// Add Button
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            submiting = true;
                          });
                          await check();
                          if (available) {
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
                              Future.delayed(Duration(seconds: 2))
                                  .then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Booked Successfully"),
                                  backgroundColor: Colors.black,
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
                                content: Text("There is an Error in Booking"),
                                backgroundColor: Colors.cyan,
                                duration: Duration(seconds: 2),
                              ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "Try agian later",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black,
                                duration: Duration(seconds: 1),
                              ));
                            });
                          } else {
                            setState(() {
                              submiting = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Solt Already Booked. Choose another one",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                              duration: Duration(seconds: 3),
                            ));
                          }
                          available = false;
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Text(
                          "ADD",
                          style: TextStyle(fontSize: 25),
                        )),
                  ),
                )
              ],
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
    );
  }

  check() {
    booked.forEach((element) {
      if (element.bookedDate ==
          selectedEventDate!.toLocal().toString().split(" ")[0]) {
        if (DateTime.parse(
                    "${element.bookedDate} ${element.startTime!.split(" ")[0]}" +
                        ":00")
                .isBefore(DateTime.parse(
                    "${selectedEventDate.toString().split(" ")[0]}"
                    " ${selectedStartTime.toString().split(" ")[0]}:00"))
            //         &&
            // DateTime.parse(
            //         "${element.bookedDate} ${element.startTime!.split(" ")[0]}" +
            //             ":00")
            //     .isBefore(DateTime.parse(
            //         "${selectedEventDate.toString().split(" ")[0]}"
            //         " ${selectedEndTime.toString().split(" ")[0]}:00"))
            ||
            (DateTime.parse("${selectedEventDate.toString().split(" ")[0]}" +
                    " ${selectedStartTime.toString().split(" ")[0]}:00")
                .isAfter(DateTime.parse(
                    "${element.bookedDate} ${element.endTime!.split(" ")[0]}" +
                        ":00")))) {
          setState(() {
            available = true;
          });
        }
        if (DateTime.parse("${selectedEventDate.toString().split(" ")[0]}" +
                " ${selectedStartTime.toString().split(" ")[0]}:00")
            .isAfter(DateTime.parse(
                "${element.bookedDate} ${element.endTime!.split(" ")[0]}" +
                    ":00"))) {}
      } else {
        setState(() {
          available = true;
        });
      }
    });
  }

  Widget fields(text, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.cyan),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: controller,
          maxLength: 30,
          decoration: inputDecoration(text),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  /// Date Picker

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEventDate!,
      firstDate: DateTime(2010),
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
          data: ThemeData.light(),
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

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        // selectedStartTime = _time;
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
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        // selectedStartTime = _time;
        selectedEndTime = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
}
