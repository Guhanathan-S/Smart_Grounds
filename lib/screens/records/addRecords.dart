import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_grounds/database/database.dart';

class AddRecords extends StatefulWidget {
  @override
  _AddRecordsState createState() => _AddRecordsState();
}

class _AddRecordsState extends State<AddRecords> {
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  DateTime selectedAvailableDate = DateTime.now();
  DataBase dataBase = DataBase();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  ImagePicker _imagePicker = ImagePicker();
  XFile? imgFile;
  File? file;
  var imgUrl;
  bool condition = false;
  List<String> category = [
    "Gym Equipments",
    "Cricket",
    "Volley Ball",
    "Baseket Ball",
    "Tennis",
    "Foot Ball",
    "Badminton"
  ];
  String selectedCategory = "Gym Equipments";
  bool submiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Records"),
        backgroundColor: Colors.cyan,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),

                    ///Category
                    Container(
                      child: Text(
                        "Category",
                        style: TextStyle(fontSize: 20, color: Colors.cyan),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                          onChanged: (String? value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                          items: category
                              .map<DropdownMenuItem<String>>((item) =>
                                  DropdownMenuItem<String>(
                                      value: item, child: Text(item)))
                              .toList()),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    /// Name
                    Container(
                      child: Text("Name",
                          style: TextStyle(fontSize: 20, color: Colors.cyan)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: nameController,
                      maxLength: 30,
                      decoration: InputDecoration(
                          hintText: "Name",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan))),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /// Count

                    if (selectedCategory != "Gym Equipments") ...[
                      Container(
                        child: Text(
                          "Count",
                          style: TextStyle(fontSize: 20, color: Colors.cyan),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: valueController,
                        decoration: InputDecoration(
                            hintText: "Count",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],

                    /// Date
                    if (selectedCategory == "Gym Equipments")
                      SwitchListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text("Equipment Condition",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan)),
                          value: condition,
                          activeTrackColor: Colors.cyan,
                          activeColor: Colors.cyanAccent,
                          onChanged: (value) {
                            setState(() {
                              condition = value;
                            });
                          }),
                    Container(
                      child: Text("Installed Date",
                          style: TextStyle(fontSize: 20, color: Colors.cyan)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                                "${selectedAvailableDate.toLocal()}"
                                    .split(" ")[0],
                              )
                            ]))),
                    SizedBox(
                      height: 30,
                    ),

                    /// Image
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add Image"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 40,
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                uploadImage();
                              },
                              child: Text("Upload Image"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.cyan,
                                  textStyle: TextStyle(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          if (file != null)
                            Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              height: 300,
                              child: Image.file(
                                file!,
                                fit: BoxFit.fill,
                              ),
                            )
                        ],
                      ),
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
                              if (imgFile != null) {
                                var snapshot = await firebaseStorage
                                    .ref()
                                    .child(
                                        "image/$selectedCategory/${nameController.text}")
                                    .putFile(file!);
                                imgUrl = await snapshot.ref.getDownloadURL();
                              }
                              if (selectedCategory == "Gym Equipments") {
                                await dataBase.addGymReocrd(
                                    name: nameController.text,
                                    date: selectedAvailableDate
                                        .toString()
                                        .split(" ")[0],
                                    condition: condition ? 1 : 0,
                                    image: imgUrl,
                                    onSuccess: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Record Added Successfully"),
                                        backgroundColor: Colors.black,
                                        duration: Duration(seconds: 2),
                                      ));
                                      setState(() {
                                        submiting = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    onError: () {
                                      setState(() {
                                        submiting = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "There is an Error in Adding data"),
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
                                await dataBase.addSportsRecord(
                                    itemName: nameController.text,
                                    count: valueController.text,
                                    sport: selectedCategory
                                        .toLowerCase()
                                        .replaceAll(" ", ""),
                                    image: imgUrl,
                                    date: selectedAvailableDate
                                        .toString()
                                        .split(" ")[0],
                                    onSuccess: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Record Added Successfully"),
                                        backgroundColor: Colors.black,
                                        duration: Duration(seconds: 2),
                                      ));
                                      setState(() {
                                        submiting = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    onError: () {
                                      setState(() {
                                        submiting = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "There is an Error in Adding data"),
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
                              }
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
              if (submiting)
                Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Colors.black38,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                          color: Colors.transparent,
                          elevation: 15,
                          child: Text(
                            "Adding Record",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  /// Image Picker
  uploadImage() async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      imgFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        file = File(imgFile!.path);
      });
    }
  }

  /// Date picker
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedAvailableDate,
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
    if (picked != null && picked != selectedAvailableDate)
      setState(() {
        selectedAvailableDate = picked;
      });
  }
}
