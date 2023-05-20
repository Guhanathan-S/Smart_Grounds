import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_grounds/database/database.dart';
import 'package:smart_grounds/screens/constants.dart';

class AddRecords extends StatefulWidget {
  @override
  _AddRecordsState createState() => _AddRecordsState();
}

class _AddRecordsState extends State<AddRecords> {
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  ScrollController recordsScrollController = ScrollController();
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
  String selectedRecordCategory = '';
  bool submiting = false;
  Map<dynamic, dynamic> records = {
    'Gym Equipments': AssetImage('assets/exercise.png')
  };

  @override
  void initState() {
    super.initState();
    records.addAll(icon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                width: devWidth,
                color: primaryGreen,
                padding:
                    EdgeInsets.only(top: devHeight / 4, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: recordsScrollController,
                      child: Row(
                          children: List.generate(
                              records.length,
                              (index) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedRecordCategory = records.entries
                                            .map((data) => data.key)
                                            .toList()[index];
                                        selectedCategory =
                                            selectedRecordCategory;
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 120,
                                      child: Card(
                                        shape: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: records.entries
                                                        .map((data) => data.key)
                                                        .toList()[index] ==
                                                    'Badminton' ||
                                                records.entries
                                                        .map((data) => data.key)
                                                        .toList()[index] ==
                                                    'Gym Equipments'
                                            ? FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: ImageIcon(
                                                  records.entries
                                                      .map((data) => data.value)
                                                      .toList()[index],
                                                  color: selectedRecordCategory ==
                                                          records.entries
                                                              .map((data) =>
                                                                  data.key)
                                                              .toList()[index]
                                                      ? primaryGreen
                                                      : primaryColor1,
                                                ),
                                              )
                                            : Icon(
                                                records.entries
                                                    .map((data) => data.value)
                                                    .toList()[index],
                                                color: selectedRecordCategory ==
                                                        records.entries
                                                            .map((data) =>
                                                                data.key)
                                                            .toList()[index]
                                                    ? primaryGreen
                                                    : primaryColor1),
                                        color: selectedRecordCategory ==
                                                records.entries
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
                    TextFormField(
                        controller: nameController,
                        cursorColor: primaryColor1,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: primaryColor1),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor1),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor1),
                                borderRadius: BorderRadius.circular(15)))),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                        controller: valueController,
                        cursorColor: primaryColor1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Count',
                            labelStyle: TextStyle(color: primaryColor1),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor1),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor1),
                                borderRadius: BorderRadius.circular(15)))),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                        onTap: () {
                          buildMaterialDatePicker(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                                "${selectedAvailableDate.toLocal()}"
                                    .split(" ")[0],
                                style: TextStyle(color: primaryColor1),
                              )
                            ]))),
                    SizedBox(
                      height: 30,
                    ),
                    //Image
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                uploadImage();
                              },
                              child: Text("Upload Image",
                                  style: TextStyle(color: primaryGreen)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          if (file != null)
                            Card(
                              color: primaryColor3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                selected: true,
                                selectedColor: primaryGreen,
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      file = null;
                                    });
                                  },
                                ),
                                title: Text(
                                  file
                                      .toString()
                                      .split('/')
                                      .last
                                      .replaceAll('\'', ''),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),

                    /// Add Button
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 50,
                        width: devWidth - devWidth * (20 / 100),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor1,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Text(
                            "ADD",
                            style: TextStyle(fontSize: 25, color: primaryGreen),
                          ),
                          onPressed: () async {
                            setState(() {
                              submiting = true;
                            });
                            if (imgFile != null) imgUrl = getImageUrl();
                            if (selectedCategory == "Gym Equipments") {
                              await dataBase.addGymReocrd(
                                  name: nameController.text,
                                  date: selectedAvailableDate
                                      .toString()
                                      .split(" ")[0],
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            ClipPath(
                clipper: TopClipperConst(),
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  decoration: BoxDecoration(color: primaryColor1),
                  child: Text(
                    'Add Records',
                    style: TextStyle(color: primaryGreen, fontSize: 35),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  /// Image Picker
  uploadImage() async {
    PermissionStatus permissionStatus;
    if (Platform.isAndroid) {
      permissionStatus = await Permission.storage.request();
    } else {
      permissionStatus = await Permission.photos.request();
    }
    if (permissionStatus.isDenied) print('Permissions is denied');
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
    if (picked != null && picked != selectedAvailableDate)
      setState(() {
        selectedAvailableDate = picked;
      });
  }

  Future<String> getImageUrl() async {
    var snapshot = await firebaseStorage
        .ref()
        .child("image/$selectedCategory/${nameController.text}")
        .putFile(file!);
    return await snapshot.ref.getDownloadURL();
  }
}
