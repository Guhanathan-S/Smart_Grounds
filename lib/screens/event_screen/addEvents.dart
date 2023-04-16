import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:smart_grounds/database/database.dart';

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
                  height: 20,
                ),

                /// Add Button
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 50,
                    width: 120,
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
                            Future.delayed(Duration(seconds: 2)).then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Event Added Successfully"),
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("There is an Error in Adding Event"),
                              backgroundColor: Colors.cyan,
                              duration: Duration(seconds: 2),
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Try agian later",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                              duration: Duration(seconds: 1),
                            ));
                          });
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
