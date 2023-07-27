import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/database/firebase_data/userData.dart';
import '../model/data_model.dart ';

class DataViewModel extends ChangeNotifier {
  List<UserData> _userData = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  bool _isLoading = true;
  bool get loading => _isLoading;
  DataViewModel.sharedInstance();
  static final DataViewModel _shared = DataViewModel.sharedInstance();
  factory DataViewModel() {
    _shared.getData();
    return _shared;
  }
  List<UserData> get userData => _userData;
  loadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  getData() {
    database
        .ref()
        .child("users_data/${UserDataBase.userDetails.registerNumber}")
        .onValue
        .listen((event) {
      if (event.snapshot.exists)
        _userData =
            DataModel.fromJson(event.snapshot.value as Map<Object?, Object?>)
                .data!;
      loadingState(false);
    });
  }
}
