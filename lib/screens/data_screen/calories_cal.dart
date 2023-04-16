import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
    "Pullups": 8.0,
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
  TextEditingController minsContoller = TextEditingController();
  List<String> workoutsDone = [];
  List<String> workoutsTime = [];
  FocusNode minsNode = FocusNode();
  TextEditingController weightController = TextEditingController();
  FocusNode weightNode = FocusNode();
  List<double> caloriesList = [];
  getWeight() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    if (documentSnapshot.exists) {
      setState(() {
        weight = documentSnapshot['weight'];
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
    minsContoller.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Calories"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : weight == null
                  ? Container(
                      child: TextFormField(
                        controller: weightController,
                        focusNode: weightNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Weight',
                            suffix: IconButton(
                                onPressed: () async {
                                  await firestore
                                      .collection('users')
                                      .doc(auth.currentUser!.uid)
                                      .update({
                                    'weight':
                                        double.parse(weightController.text)
                                  });
                                  setState(() {
                                    getWeight();
                                  });
                                },
                                icon: Icon(Icons.send))),
                      ),
                    )
                  : Column(children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 200,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: SizedBox(),
                                value: selectedWorkout,
                                onChanged: (value) {
                                  setState(() {
                                    selectedWorkout = value!;
                                  });
                                },
                                items: workoutsName
                                    .map<DropdownMenuItem<String>>(
                                        (e) => DropdownMenuItem(
                                              child: Text(e),
                                              value: e,
                                            ))
                                    .toList(),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: 100,
                              width: 100,
                              child: TextFormField(
                                controller: minsContoller,
                                focusNode: minsNode,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                    hintText: "00:00",
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan))),
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
                        height: 30,
                        width: 120,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                workoutsDone.add(selectedWorkout);
                                workoutsTime.add(
                                    minsContoller.text.replaceAll(':', '.'));
                                minsContoller.clear();
                              });
                            },
                            child: Text("Add")),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: workoutsDone.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Row(
                                    children: [
                                      Text(workoutsDone[index],
                                          style: GoogleFonts.zillaSlab(
                                              fontSize: 18,
                                              color: Colors.black)),
                                      Spacer(),
                                      Text(workoutsTime[index],
                                          style: GoogleFonts.zillaSlab(
                                              fontSize: 17,
                                              color: Colors.grey[600])),
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
                                        color: Colors.black,
                                      )),
                                );
                              })),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          height: 50,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () async {
                              for (int i = 0; i < workoutsDone.length; i++) {
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
                                'calories': calories.toString()
                              }).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Calories Calulated and updated Successfully")));
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Calculate"),
                          ),
                        ),
                      )
                    ]),
        ),
      ),
    );
  }
}
