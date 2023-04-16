import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/screens/controls/controls_model.dart';

class Controls extends StatefulWidget {
  const Controls({Key? key}) : super(key: key);

  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  var switchs;
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  StreamSubscription? _controlStream;
  bool expands = false;
  getData() async {
    _controlStream =
        database.ref().child('controls/gym/light_one').onValue.listen((event) {
      var recivedData = event.snapshot.value;
      switchs = recivedData;
      setState(() {});
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _controlStream!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView.separated(
          itemBuilder: (context, index) {
            return ExpansionPanelList(
              expansionCallback: (int index, bool expanded) {
                setState(() {
                  expands = !expanded;
                });
              },
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isExpand) {
                      return ListTile(
                        title: Text('Gym'),
                      );
                    },
                    isExpanded: expands,
                    body: Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return SwitchListTile(
                                title: Text("Light One"),
                                value: switchs == 1 ? true : false,
                                onChanged: (value) {
                                  setState(() {
                                    if (value) {
                                      database
                                          .ref()
                                          .child('controls/gym')
                                          .update({"light_one": 1});
                                    } else {
                                      database
                                          .ref()
                                          .child('controls/gym')
                                          .update({"light_one": 0});
                                    }
                                  });
                                });
                          }),
                    ))
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 20,
            );
          },
          itemCount: 1),
    );
  }
}

// class Cards extends StatefulWidget {
//   final data;
//   String? recordName;
//   bool? expands;
//   Cards({this.data, this.recordName, this.expands});

//   @override
//   _CardsState createState() => _CardsState();
// }

// class _CardsState extends State<Cards> {
//   @override
//   Widget build(BuildContext context) {
//     return;
//   }
// }
