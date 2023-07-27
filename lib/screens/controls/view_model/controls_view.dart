import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/screens/controls/model/controls_model.dart';

class ControlViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  List<Switches> _switchesList = [];
  List<String> _switchesArea = [];
  bool _loading = true;
  bool get loading => _loading;
  List<Switches> get switchesList => _switchesList;
  get switchesLength => _switchesList.length;
  get switchArea => _switchesArea;
  get totalArea => _switchesArea.length;

  ControlViewModel() {
    getControlsData();
  }

  loadingState(bool state) {
    _loading = state;
    notifyListeners();
  }

  getControlsData() {
    database.ref().child('controls').onValue.listen((event) {
      ControlsModel _controlsModel =
          ControlsModel.fromJson(event.snapshot.value as Map<Object?, Object?>);
      _switchesList = _controlsModel.area!;
      _switchesArea = _controlsModel.areaId!;
      loadingState(false);
    });
  }

  changeControls(
      {required String controls, required String switchs, required int state}) {
    database.ref().child(controls).update({switchs: state});
  }
}
