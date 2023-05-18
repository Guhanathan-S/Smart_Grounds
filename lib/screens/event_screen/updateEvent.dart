import 'package:flutter/material.dart';
import 'package:smart_grounds/database/database.dart';
import 'package:smart_grounds/screens/constants.dart';
import 'package:smart_grounds/screens/event_screen/event_data_screen.dart';
import 'package:smart_grounds/screens/home.dart';

class UpdateEventScore extends StatefulWidget {
  String? team1, team2, id;
  final onTap;
  UpdateEventScore({this.team1, this.team2, this.id, this.onTap});
  @override
  _UpdateEventScoreState createState() => _UpdateEventScoreState();
}

class _UpdateEventScoreState extends State<UpdateEventScore> {
  TextEditingController score1Controller = TextEditingController();
  TextEditingController score2Controller = TextEditingController();
  TextEditingController wonByController = TextEditingController();
  var database = DataBase();
  InputDecoration inputDecoration() {
    return InputDecoration(
        hintText: "Score",
        hintStyle: TextStyle(color: Colors.black38),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: primaryColor3),
      child: Stack(
        children: [
          BottomSheetBackGroundUi(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BottomSheetDetails(
                widthLeft: 100,
                widthRight: 250,
                leftContainerColor: whiteColor,
                rightContainerColor: primaryGreen,
                leftClipper: 1.5,
                rightClipper: 7,
                heightRight: 80,
                heightLeft: 80,
                leftData: Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    "Team 1",
                    style: TextStyle(color: primaryColor1, fontSize: 20),
                  ),
                ),
                rightData: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: fields('Score / Point', score1Controller),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BottomSheetDetails(
                widthLeft: 100,
                widthRight: 250,
                leftContainerColor: whiteColor,
                rightContainerColor: primaryGreen,
                leftClipper: 1.5,
                rightClipper: 7,
                heightRight: 80,
                heightLeft: 80,
                leftData: Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    "Team 2",
                    style: TextStyle(color: primaryColor1, fontSize: 20),
                  ),
                ),
                rightData: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: fields('Score / Point', score2Controller),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BottomSheetDetails(
                widthLeft: 100,
                widthRight: 250,
                leftContainerColor: whiteColor,
                rightContainerColor: primaryGreen,
                leftClipper: 1.5,
                rightClipper: 7,
                heightRight: 80,
                heightLeft: 80,
                leftData: Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    "Won By",
                    style: TextStyle(color: primaryColor1, fontSize: 20),
                  ),
                ),
                rightData: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: fields('Results', wonByController),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    if (score1Controller.text.isNotEmpty &&
                        score2Controller.text.isNotEmpty &&
                        wonByController.text.isNotEmpty) {
                      database
                          .updateEvent(
                              team1Score: score1Controller.text,
                              team2Score: score2Controller.text,
                              wonBy: wonByController.text,
                              id: widget.id!)
                          .then((value) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Scores Update",
                            style: TextStyle(color: primaryColor1),
                          ),
                          backgroundColor: primaryGreen,
                        ));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 1200),
                        content: Text(
                          "Can't Update Please fill all the fields",
                          style: TextStyle(color: primaryColor1),
                        ),
                        backgroundColor: primaryGreen,
                      ));
                    }
                  },
                  child: ClipPath(
                    clipper: UpdateResultClipper(),
                    child: Container(
                      padding: EdgeInsets.only(left: 30),
                      alignment: Alignment.center,
                      height: 40,
                      width: 150,
                      color: primaryGreen,
                      child: Text(
                        'Update',
                        style: TextStyle(color: primaryColor1, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
          // Row(
          //   children: [
          //     IconButton(
          //       onPressed: () {
          //         Navigator.pop(context);
          //         VisibleScaffoldWidgets().changeVisibleState(state: true);
          //       },
          //       icon: Icon(Icons.arrow_back_ios_new,
          //           color: Colors.cyan, size: 25),
          //     ),
          //     Spacer(),
          //     Expanded(
          //       child: Text(
          //         "Results",
          //         style:
          //             TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          //       ),
          //     ),
          //     Spacer(),
          //   ],
          // ),
          // Divider(
          //   height: 10,
          //   thickness: 2,
          //   color: Colors.cyan,
          // ),
          // fields(
          //     widget.team1 != null ? widget.team1! : "", score1Controller),
          // fields(
          //     widget.team2 != null ? widget.team2! : "", score2Controller),
          // fields("Won By", wonByController),
          // SizedBox(
          //   height: 10,
          // ),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: SizedBox(
          //     height: 40,
          //     width: 150,
          //     child: ElevatedButton(
          //         onPressed: () {
          //           database
          //               .updateEvent(
          //                   team1Score: score1Controller.text,
          //                   team2Score: score2Controller.text,
          //                   wonBy: wonByController.text,
          //                   id: widget.id!)
          //               .then((value) {
          //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //               content: Text(
          //                 "Scores Update",
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //               backgroundColor: Colors.black,
          //             ));
          //             widget.onTap();
          //           });
          //         },
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Colors.cyan,
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20)),
          //         ),
          //         child: Text("Update")),
          //   ),
          // ),
          // SizedBox(
          //   height: 8,
          // )
        ],
      ),
    );
  }

  Widget fields(text, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          cursorColor: primaryColor1,
          decoration: InputDecoration(
            hintText: text,
            border: InputBorder.none,
            hintStyle: TextStyle(color: primaryColor1),
          ),
        ),
      ],
    );
  }
}
