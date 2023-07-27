import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../model/recordsmodel.dart';

class RecordsViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  List<GymEquipments> _gymEquipments = [];
  List<SportsItem> _cricketList = [];
  List<SportsItem> _volleyBallList = [];
  List<SportsItem> _footBallList = [];
  List<SportsItem> _tennisList = [];
  List<SportsItem> _badmintonList = [];
  bool _loading = true;
  get loading => _loading;
  get gym => _gymEquipments;
  get cricket => _cricketList;
  get volleyBall => _volleyBallList;
  get footBall => _footBallList;
  get tennis => _tennisList;
  get badminton => _badmintonList;
  RecordsViewModel() {
    getRecordsData();
  }

  loadingState(bool state) {
    _loading = state;
    notifyListeners();
  }

  getRecordsData() {
    database.ref().child('records').onValue.listen((event) {
      RecordsModel recordsModel =
          RecordsModel.fromJson(event.snapshot.value as Map<Object?, Object?>);
      _gymEquipments = recordsModel.gymEquipments!;
      _cricketList = recordsModel.sportsItems!.cricket!;
      _footBallList = recordsModel.sportsItems!.footBall!;
      _volleyBallList = recordsModel.sportsItems!.volleyBall!;
      _tennisList = recordsModel.sportsItems!.tennis!;
      _badmintonList = recordsModel.sportsItems!.badminton!;
      loadingState(false);
    });
  }

  getRecordDetails({required String category}) {
    switch (category) {
      case 'Gym':
        return gym;
      case 'Cricket':
        return cricket;
      case 'VolleyBall':
        return volleyBall;
      case 'FootBall':
        return footBall;
      case 'Tennis':
        return tennis;
      case 'Badminton':
        return badminton;
    }
  }
}
