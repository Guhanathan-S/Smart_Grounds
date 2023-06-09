import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/screens/constants.dart';

import 'controls_model.dart';

class Controls extends StatefulWidget {
  const Controls({Key? key}) : super(key: key);

  @override
  _ControlsState createState() => _ControlsState();
}

List<bool> expands = [];

class _ControlsState extends State<Controls> {
  var switchs;
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  List<Switches> switchList = [];
  List<String> switchArea = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: StreamBuilder(
          stream: database.ref().child('controls').onValue,
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapShot) {
            if (!snapShot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  color: primaryGreen,
                  strokeWidth: 4,
                ),
              );
            if (snapShot.data!.snapshot.children.isEmpty)
              return Center(
                child: Text(
                  'Can\'t load controls',
                  style: TextStyle(color: primaryGreen, fontSize: 35),
                ),
              );
            switchList.clear();
            switchArea.clear();
            switchArea.addAll(
                Controls_Model.fromJson(snapShot.data!.snapshot.value).areaId!);
            switchList.addAll(
                Controls_Model.fromJson(snapShot.data!.snapshot.value).area!);
            List<bool> temp = expands.toList();
            expands.clear();
            expands = List.generate(switchArea.length, (index) {
              try {
                return temp[index];
              } catch (e) {
                return false;
              }
            });
            return ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 20,
                );
              },
              itemCount: switchArea.length,
              itemBuilder: (context, index) {
                return ControlsCard(
                  index: index,
                  switchArea: switchArea[index],
                  switchList: switchList,
                );
              },
            );
          }),
    );
  }
}

class ControlsCard extends StatefulWidget {
  ControlsCard(
      {required this.switchList,
      required this.switchArea,
      required this.index});
  List<Switches> switchList;
  String switchArea;
  int index;

  @override
  State<ControlsCard> createState() => _ControlsCardState();
}

class _ControlsCardState extends State<ControlsCard> {
  FirebaseDatabase database = FirebaseDatabase.instanceFor(app: Firebase.app());
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ExpansionPanelList(
        dividerColor: primaryColor1,
        expansionCallback: (int index, bool expanded) {
          setState(() => expands[widget.index] = !expanded);
        },
        children: [
          ExpansionPanel(
              backgroundColor: primaryGreen,
              headerBuilder: (context, isExpand) {
                StringBuffer titleData = StringBuffer();
                widget.switchArea.split("_").forEach((element) {
                  titleData
                    ..write(element[0].toUpperCase())
                    ..write(element.substring(1))
                    ..write(' ');
                });
                return ListTile(
                  title: Text(
                    titleData.toString(),
                  ),
                  textColor: primaryColor1,
                  iconColor: primaryColor1,
                );
              },
              isExpanded: expands[widget.index],
              body: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      widget.switchList[widget.index].switchStates!.length,
                  itemBuilder: (context, index1) {
                    StringBuffer titleData = StringBuffer();
                    widget.switchList[widget.index].switchId![index1]
                        .split("_")
                        .forEach((element) {
                      titleData
                        ..write(element[0].toUpperCase())
                        ..write(element.substring(1))
                        ..write(' ');
                    });
                    return SwitchListTile(
                        activeColor: whiteColor,
                        inactiveTrackColor: primaryColor3,
                        inactiveThumbColor: primaryColor3,
                        activeTrackColor: whiteColor,
                        title: Text(
                          titleData.toString(),
                          style: TextStyle(color: primaryColor1),
                        ),
                        value: widget.switchList[widget.index]
                                    .switchStates![index1].switchState ==
                                1
                            ? true
                            : false,
                        onChanged: (value) {
                          database
                              .ref()
                              .child('controls/${widget.switchArea}')
                              .update({
                            "${widget.switchList[widget.index].switchId![index1]}":
                                value ? 1 : 0
                          });
                        });
                  }))
        ],
      ),
    );
  }
}
