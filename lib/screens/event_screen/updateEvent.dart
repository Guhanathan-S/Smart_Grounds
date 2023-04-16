import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_grounds/database/database.dart';

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
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 400,
      width: 350,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                spreadRadius: 5,
                blurRadius: 8,
                offset: Offset(0, 3))
          ]),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onTap,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.cyan,
                    size: 25,
                  ),
                ),
                Spacer(),
                Text(
                  "Add Scores",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Spacer(),
              ],
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.cyan,
            ),
            fields(widget.team1 != null ? widget.team1! : "", score1Controller),
            fields(widget.team2 != null ? widget.team2! : "", score2Controller),
            fields("Won By", wonByController),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                    onPressed: () {
                      database
                          .updateEvent(
                              team1Score: score1Controller.text,
                              team2Score: score2Controller.text,
                              wonBy: wonByController.text,
                              id: widget.id!)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Scores Update",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.black,
                        ));
                        widget.onTap();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text("Update")),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget fields(text, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.cyan, fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: inputDecoration(),
        ),
      ],
    );
  }
}
