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
      // appBar: AppBar(
      //   title: Text("Add Records"),
      //   backgroundColor: primaryGreen,
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                // height: devHeight,
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
                                        // selectedGround = icon.entries
                                        //     .map((data) => data.key)
                                        //     .toList()[index];
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
                          // Container(
                          //   padding: EdgeInsets.all(5),
                          //   alignment: Alignment.center,
                          //   height: 400,
                          //   child: Image.file(file!, fit: BoxFit.cover),
                          // ),
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
            // SingleChildScrollView(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SizedBox(
            //         height: 40,
            //       ),

            //       ///Category
            //       Container(
            //         child: Text(
            //           "Category",
            //           style: TextStyle(fontSize: 20, color: Colors.cyan),
            //         ),
            //       ),
            //       SizedBox(
            //         height: 5,
            //       ),
            //       Container(
            //         width: double.maxFinite,
            //         padding: EdgeInsets.all(5),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10),
            //             border: Border.all(color: Colors.cyan)),
            //         child: DropdownButton<String>(
            //             isExpanded: true,
            //             underline: Container(),
            //             value: selectedCategory,
            //             onChanged: (String? value) {
            //               setState(() {
            //                 selectedCategory = value!;
            //               });
            //             },
            //             items: category
            //                 .map<DropdownMenuItem<String>>((item) =>
            //                     DropdownMenuItem<String>(
            //                         value: item, child: Text(item)))
            //                 .toList()),
            //       ),

            //       SizedBox(
            //         height: 20,
            //       ),

            //       /// Name
            //       Container(
            //         child: Text("Name",
            //             style: TextStyle(fontSize: 20, color: Colors.cyan)),
            //       ),
            //       SizedBox(
            //         height: 5,
            //       ),
            //       TextFormField(
            //         controller: nameController,
            //         maxLength: 30,
            //         decoration: InputDecoration(
            //             hintText: "Name",
            //             focusedBorder: OutlineInputBorder(
            //                 borderSide: BorderSide(color: Colors.cyan)),
            //             border: OutlineInputBorder(
            //                 borderSide: BorderSide(color: Colors.cyan)),
            //             enabledBorder: OutlineInputBorder(
            //                 borderSide: BorderSide(color: Colors.cyan))),
            //       ),
            //       SizedBox(
            //         height: 20,
            //       ),

            //       /// Count

            //       if (selectedCategory != "Gym Equipments") ...[
            //         Container(
            //           child: Text(
            //             "Count",
            //             style: TextStyle(fontSize: 20, color: Colors.cyan),
            //           ),
            //         ),
            //         SizedBox(
            //           height: 5,
            //         ),
            //         TextFormField(
            //           controller: valueController,
            //           decoration: InputDecoration(
            //               hintText: "Count",
            //               focusedBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(color: Colors.cyan)),
            //               border: OutlineInputBorder(
            //                   borderSide: BorderSide(color: Colors.cyan)),
            //               enabledBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(color: Colors.cyan))),
            //         ),
            //         SizedBox(
            //           height: 20,
            //         ),
            //       ],

            //       /// Date
            //       if (selectedCategory == "Gym Equipments")
            //         SwitchListTile(
            //             contentPadding: EdgeInsets.all(0),
            //             title: Text("Equipment Condition",
            //                 style: TextStyle(fontSize: 20, color: Colors.cyan)),
            //             value: condition,
            //             activeTrackColor: Colors.cyan,
            //             activeColor: Colors.cyanAccent,
            //             onChanged: (value) {
            //               setState(() {
            //                 condition = value;
            //               });
            //             }),
            //       Container(
            //         child: Text("Installed Date",
            //             style: TextStyle(fontSize: 20, color: Colors.cyan)),
            //       ),
            //       SizedBox(
            //         height: 5,
            //       ),
            //       GestureDetector(
            //           onTap: () {
            //             buildMaterialDatePicker(context);
            //           },
            //           child: Container(
            //               decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(10),
            //                   border: Border.all(color: Colors.cyan)),
            //               child: Row(children: [
            //                 IconButton(
            //                   onPressed: () {
            //                     buildMaterialDatePicker(context);
            //                   },
            //                   icon: Icon(Icons.calendar_today_outlined,
            //                       color: Colors.cyan),
            //                 ),
            //                 SizedBox(
            //                   width: 15,
            //                 ),
            //                 Text(
            //                   "${selectedAvailableDate.toLocal()}"
            //                       .split(" ")[0],
            //                 )
            //               ]))),
            //       SizedBox(
            //         height: 30,
            //       ),

            //       /// Image
            //       Container(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text("Add Image"),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             SizedBox(
            //               height: 40,
            //               width: 120,
            //               child: ElevatedButton(
            //                 onPressed: () {
            //                   uploadImage();
            //                 },
            //                 child: Text("Upload Image"),
            //                 style: ElevatedButton.styleFrom(
            //                     backgroundColor: Colors.cyan,
            //                     textStyle: TextStyle(color: Colors.white),
            //                     shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(35))),
            //               ),
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             if (file != null)
            //               Container(
            //                 padding: EdgeInsets.all(5),
            //                 alignment: Alignment.center,
            //                 height: 300,
            //                 child: Image.file(
            //                   file!,
            //                   fit: BoxFit.fill,
            //                 ),
            //               )
            //           ],
            //         ),
            //       ),

            //       SizedBox(
            //         height: 10,
            //       ),

            //       /// Add Button
            //       Align(
            //         alignment: Alignment.bottomRight,
            //         child: SizedBox(
            //           height: 50,
            //           width: 120,
            //           child: ElevatedButton(
            //               onPressed: () async {
            //                 setState(() {
            //                   submiting = true;
            //                 });
            //                 if (imgFile != null) {
            //                   var snapshot = await firebaseStorage
            //                       .ref()
            //                       .child(
            //                           "image/$selectedCategory/${nameController.text}")
            //                       .putFile(file!);
            //                   imgUrl = await snapshot.ref.getDownloadURL();
            //                 }
            //                 if (selectedCategory == "Gym Equipments") {
            //                   await dataBase.addGymReocrd(
            //                       name: nameController.text,
            //                       date: selectedAvailableDate
            //                           .toString()
            //                           .split(" ")[0],
            //                       condition: condition ? 1 : 0,
            //                       image: imgUrl,
            //                       onSuccess: () {
            //                         ScaffoldMessenger.of(context)
            //                             .showSnackBar(SnackBar(
            //                           content:
            //                               Text("Record Added Successfully"),
            //                           backgroundColor: Colors.black,
            //                           duration: Duration(seconds: 2),
            //                         ));
            //                         setState(() {
            //                           submiting = false;
            //                         });
            //                         Navigator.pop(context);
            //                       },
            //                       onError: () {
            //                         setState(() {
            //                           submiting = false;
            //                         });
            //                         ScaffoldMessenger.of(context)
            //                             .showSnackBar(SnackBar(
            //                           content: Text(
            //                               "There is an Error in Adding data"),
            //                           backgroundColor: Colors.cyan,
            //                           duration: Duration(seconds: 2),
            //                         ));
            //                         ScaffoldMessenger.of(context)
            //                             .showSnackBar(SnackBar(
            //                           content: Text(
            //                             "Try agian later",
            //                             style: TextStyle(color: Colors.white),
            //                           ),
            //                           backgroundColor: Colors.black,
            //                           duration: Duration(seconds: 1),
            //                         ));
            //                       });
            //                 } else {
            //                   await dataBase.addSportsRecord(
            //                       itemName: nameController.text,
            //                       count: valueController.text,
            //                       sport: selectedCategory
            //                           .toLowerCase()
            //                           .replaceAll(" ", ""),
            //                       image: imgUrl,
            //                       date: selectedAvailableDate
            //                           .toString()
            //                           .split(" ")[0],
            //                       onSuccess: () {
            //                         ScaffoldMessenger.of(context)
            //                             .showSnackBar(SnackBar(
            //                           content:
            //                               Text("Record Added Successfully"),
            //                           backgroundColor: Colors.black,
            //                           duration: Duration(seconds: 2),
            //                         ));
            //                         setState(() {
            //                           submiting = false;
            //                         });
            //                         Navigator.pop(context);
            //                       },
            //                       onError: () {
            //                         setState(() {
            //                           submiting = false;
            //                         });
            //                         ScaffoldMessenger.of(context)
            //                             .showSnackBar(SnackBar(
            //                           content: Text(
            //                               "There is an Error in Adding data"),
            //                           backgroundColor: Colors.cyan,
            //                           duration: Duration(seconds: 2),
            //                         ));
            //                         ScaffoldMessenger.of(context)
            //                             .showSnackBar(SnackBar(
            //                           content: Text(
            //                             "Try agian later",
            //                             style: TextStyle(color: Colors.white),
            //                           ),
            //                           backgroundColor: Colors.black,
            //                           duration: Duration(seconds: 1),
            //                         ));
            //                       });
            //                 }
            //               },
            //               style: ElevatedButton.styleFrom(
            //                   backgroundColor: Colors.cyan,
            //                   elevation: 10,
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(20))),
            //               child: Text(
            //                 "ADD",
            //                 style: TextStyle(fontSize: 25),
            //               )),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // if (submiting)
            //   Container(
            //     height: double.maxFinite,
            //     width: double.maxFinite,
            //     color: Colors.black38,
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Material(
            //             color: Colors.transparent,
            //             elevation: 15,
            //             child: Text(
            //               "Adding Record",
            //               style: TextStyle(color: Colors.white, fontSize: 20),
            //             )),
            //         SizedBox(
            //           height: 15,
            //         ),
            //         CircularProgressIndicator()
            //       ],
            //     ),
            //   )
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
    // var permissionStatus = await Permission.photos.status;
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

// class TopClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, devHeight / 7);
//     path.quadraticBezierTo(
//         devWidth / 2, devHeight / 4, devWidth, devHeight / 7);
//     path.lineTo(devWidth, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
// }
