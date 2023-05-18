import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_grounds/screens/constants.dart';

class CalorisCal extends StatefulWidget {
  final dataKey;
  const CalorisCal({this.dataKey});

  @override
  _CalorisCalState createState() => _CalorisCalState();
}

class _CalorisCalState extends State<CalorisCal> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DatabaseReference database = FirebaseDatabase.instance.ref();
  FirebaseAuth auth = FirebaseAuth.instance;
  var weight;
  bool isLoading = true;
  String registerNumber = "";
  Map<String, double> workouts = {
    "Pushups": 8.0,
    "Bicycling": 5.5,
    "Treadmill": 9.0,
    "Weight Lifting": 6.0,
    "Squats": 5.0,
    "Front Raise": 2.0,
    "Pull Ups": 8.0,
    "Plank": 3.0,
    "Bench Press": 4,
    "Roping": 3.0,
    "Dumbell Squeeze Press": 4.0,
    "Dumbbell Incline Curl": 6.0,
    "Skipping": 12.3,
    "Situps": 8.0,
    "Upright Row": 2.8,
    "Handstand Pushup": 10.5,
    "Generalized Workout": 8.0
  };
  List<String> workoutsName = [
    "Pushups",
    "Bicycling",
    "Treadmill",
    "Weight Lifting",
    "Squats",
    "Front Raise",
    "Pull Ups",
    "Plank",
    "Bench Press",
    "Roping",
    "Dumbell Squeeze Press",
    "Dumbbell Incline Curl",
    "Skipping",
    "Situps",
    "Upright Row",
    "Handstand Pushup",
    "Generalized Workout"
  ];
  String selectedWorkout = "Pushups";
  TextEditingController minsController = TextEditingController();
  TextEditingController secController = TextEditingController();
  TextEditingController totCalController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  List<String> workoutsDone = [];
  List<String> workoutsTime = [];
  FocusNode minsNode = FocusNode();
  FocusNode secNode = FocusNode();
  FocusNode weightNode = FocusNode();
  FocusNode totCalNode = FocusNode();
  List<double> caloriesList = [];
  bool calVisible = true;
  int previousLength = 0;
  double totalTime = 0.00;
  getWeight() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    if (documentSnapshot.exists) {
      setState(() {
        try {
          weight = documentSnapshot['weight'];
        } catch (e) {
          weight = null;
        }
        registerNumber = documentSnapshot['register_number'];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getWeight();
    super.initState();
  }

  @override
  void dispose() {
    minsController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
            child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: devHeight / 4, right: 10, left: 10, bottom: 10),
              color: primaryGreen,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor1,
                        strokeWidth: 4,
                      ),
                    )
                  : Column(children: [
                      if (weight == null)
                        SizedBox(
                          height: 60,
                          child: textField(
                              textController: weightController,
                              focusNode: weightNode,
                              labelText: 'Weight',
                              onPressed: () async {
                                await firestore
                                    .collection('users')
                                    .doc(auth.currentUser!.uid)
                                    .update({
                                  'weight': double.parse(weightController.text)
                                });
                                setState(() {
                                  weight = double.parse(weightController.text);
                                });
                              }),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      if (calVisible)
                        SizedBox(
                          height: 60,
                          child: textField(
                              textController: totCalController,
                              focusNode: totCalNode,
                              labelText: 'Calories to Burn',
                              onPressed: () async {
                                database.ref
                                    .child(
                                        'users_data/$registerNumber/${widget.dataKey}')
                                    .update({
                                  'totCal': int.parse(totCalController.text)
                                });
                                // await firestore
                                //     .collection('users')
                                //     .doc(auth.currentUser!.uid)
                                //     .update({
                                //   'totCal': int.parse(totCalController.text)
                                // });
                                setState(() {
                                  calVisible = false;
                                });
                              }),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(highlightColor: primaryGreen),
                              child: PopupMenuButton(
                                onSelected: (String value) {
                                  setState(() {
                                    selectedWorkout = value;
                                  });
                                  // showMenu<String>(
                                  //         context: context,
                                  //         color: primaryColor1,
                                  //         shape: RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(20)),
                                  //         position: RelativeRect.fromSize(
                                  //             Rect.zero, Size(70, 200)),
                                  //         // fromLTRB(
                                  //         //     0,0,0, 0),
                                  //         items: workoutsName
                                  //             .map<PopupMenuEntry<String>>(
                                  //                 (e) => PopupMenuItem<String>(
                                  //                     value: e,
                                  //                     child: ListTile(
                                  //                       title: Text(
                                  //                         e,
                                  //                         style: TextStyle(
                                  //                             color:
                                  //                                 primaryGreen),
                                  //                       ),
                                  //                     )))
                                  //             .toList())
                                  //     .then((value) {
                                  //   setState(() {
                                  //     selectedWorkout = value ?? selectedWorkout;
                                  //   });
                                  // });
                                },
                                color: primaryColor1,
                                offset: Offset(10, 30),
                                elevation: 10,
                                constraints: BoxConstraints(
                                    maxHeight: devHeight / 2, maxWidth: 200),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                itemBuilder: (BuildContext context) {
                                  return workoutsName
                                      .map<PopupMenuEntry<String>>(
                                          (e) => PopupMenuItem<String>(
                                              value: e,
                                              child: ListTile(
                                                title: Text(
                                                  e,
                                                  style: TextStyle(
                                                      color: primaryGreen),
                                                ),
                                              )))
                                      .toList();
                                },
                                child: Container(
                                    height: 50,
                                    width: 200,
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: primaryColor1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 10,
                                          child: Text(
                                            selectedWorkout,
                                            style: TextStyle(
                                                color: primaryColor1,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: primaryColor1,
                                        )
                                      ],
                                    )

                                    // DropdownButton<String>(
                                    //   isExpanded: true,
                                    //   dropdownColor: primaryGreen,
                                    //   iconEnabledColor: primaryColor1,
                                    //   borderRadius: BorderRadius.circular(20),
                                    //   value: selectedWorkout,
                                    //   style: TextStyle(color: primaryColor1),
                                    //   underline: SizedBox(),
                                    //   // selectedItemBuilder: (context) {
                                    //   //   return [
                                    //   //     Align(
                                    //   //       alignment: Alignment.center,
                                    //   //       child: Container(
                                    //   //         child: Text(
                                    //   //           selectedWorkout,
                                    //   //           style:
                                    //   //               TextStyle(color: primaryColor1),
                                    //   //         ),
                                    //   //       ),
                                    //   //     )
                                    //   //   ];
                                    //   //   // List.generate(
                                    //   //   //     workoutsName.length,
                                    //   //   //     (index) => Container(
                                    //   //   //           decoration: BoxDecoration(
                                    //   //   //               borderRadius:
                                    //   //   //                   BorderRadius.circular(20)),
                                    //   //   //           child: Text(
                                    //   //   //             workoutsName[index],
                                    //   //   //             style: TextStyle(
                                    //   //   //                 color: primaryColor1),
                                    //   //   //           ),
                                    //   //   //         ));
                                    //   // },
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       selectedWorkout = value!;
                                    //     });
                                    //   },
                                    //   items: workoutsName
                                    //       .map<DropdownMenuItem<String>>((e) =>
                                    //           DropdownMenuItem(
                                    //             child: Card(
                                    //               shape: RoundedRectangleBorder(
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(20)),
                                    //               child: Text(
                                    //                 e,
                                    //               ),
                                    //             ),
                                    //             value: e,
                                    //           ))
                                    //       .toList(),
                                    // ),

                                    ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: 60,
                              width: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: TextFormField(
                                      controller: minsController,
                                      focusNode: minsNode,
                                      textAlign: TextAlign.end,
                                      cursorColor: primaryColor1,
                                      keyboardType: TextInputType.datetime,
                                      onChanged: (value) {
                                        if (value.length >= 2) {
                                          if (value.length > 2)
                                            minsController.text = minsController
                                                    .text
                                                    .substring(
                                                        0, value.length - 2) +
                                                minsController.text.substring(
                                                    value.length - 1);
                                          FocusScope.of(context)
                                              .requestFocus(secNode);
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: "00",
                                        hintStyle:
                                            TextStyle(color: primaryColor1),
                                        border: InputBorder.none,
                                        // border: OutlineInputBorder(
                                        //     borderSide:
                                        //         BorderSide(color: Colors.black)),
                                        // focusedBorder: OutlineInputBorder(
                                        //     borderSide:
                                        //         BorderSide(color: Colors.cyan))
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ':',
                                    style: TextStyle(color: primaryColor1),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: RawKeyboardListener(
                                      focusNode: FocusNode(),
                                      onKey: (RawKeyEvent event) {
                                        if (previousLength == 0) {
                                          if (event.logicalKey ==
                                              LogicalKeyboardKey.backspace) {
                                            print('backSpace is pressed');
                                            FocusScope.of(context)
                                                .requestFocus(minsNode);
                                          }
                                        }
                                        previousLength =
                                            secController.value.text.length;
                                      },
                                      child: TextFormField(
                                        controller: secController,
                                        focusNode: secNode,
                                        cursorColor: primaryColor1,
                                        keyboardType: TextInputType.datetime,
                                        decoration: InputDecoration(
                                            hintText: "00",
                                            hintStyle:
                                                TextStyle(color: primaryColor1),
                                            border: InputBorder.none
                                            // border: OutlineInputBorder(
                                            //     borderSide:
                                            //         BorderSide(color: Colors.black)),
                                            // focusedBorder: OutlineInputBorder(
                                            //     borderSide:
                                            //         BorderSide(color: Colors.cyan))
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "If you don't know the workouts select \"Generalized Workout\" to get Approximate Calories Burn",
                        style: GoogleFonts.zillaSlab(
                            fontSize: 20, color: Colors.grey[600]),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 40,
                        width: 120,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              setState(() {
                                workoutsDone.add(selectedWorkout);
                                workoutsTime.add(minsController.text +
                                    '.' +
                                    secController.text);
                                minsController.clear();
                                secController.clear();
                              });
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(color: primaryGreen),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: workoutsDone.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: primaryColor1,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Text(workoutsDone[index],
                                            style: GoogleFonts.zillaSlab(
                                                fontSize: 18,
                                                color: primaryGreen)),
                                        Spacer(),
                                        Text(workoutsTime[index],
                                            style: GoogleFonts.zillaSlab(
                                                fontSize: 17,
                                                color: primaryGreen)),
                                        SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            workoutsDone.removeAt(index);
                                            workoutsTime.removeAt(index);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: primaryGreen,
                                        )),
                                  ),
                                );
                              })),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          height: 50,
                          width: 120,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () async {
                              for (int i = 0; i < workoutsDone.length; i++) {
                                totalTime += double.parse(workoutsTime[i]);
                                var calories = double.parse(workoutsTime[i]) *
                                    (workouts[workoutsDone[i]]! *
                                        3.5 *
                                        weight) /
                                    200;
                                caloriesList.add(calories);
                              }
                              double calories = 0.0;
                              caloriesList.forEach((element) {
                                calories += element;
                              });
                              await database.ref
                                  .child(
                                      'users_data/$registerNumber/${widget.dataKey}')
                                  .update({
                                'calories': calories.toInt(),
                                'time': '${totalTime.toInt()} min'
                              }).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Calories Calulated and updated Successfully")));
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              "Calculate",
                              style: TextStyle(color: primaryGreen),
                            ),
                          ),
                        ),
                      )
                    ]),
            ),
            ClipPath(
                clipper: TopClipperConst(),
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  decoration: BoxDecoration(color: primaryColor1),
                  child: Text(
                    'Calculate Calories',
                    style: TextStyle(color: primaryGreen, fontSize: 35),
                  ),
                )),
          ],
        )),
      ),
    );
  }

  Widget textField(
      {required String labelText,
      required Function() onPressed,
      required TextEditingController textController,
      required FocusNode focusNode}) {
    return TextFormField(
      controller: textController,
      focusNode: focusNode,
      cursorColor: primaryColor1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: primaryColor1),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: primaryColor1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: primaryColor1)),
          suffix: IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.send,
                color: primaryColor1,
              ))),
    );
  }
}
