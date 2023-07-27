import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkConnectivityViewModel extends ChangeNotifier {
  static bool _connectionStatus = false;
  NetworkConnectivityViewModel._sharedInstance() {
    getConnectionStatus();
  }
  static NetworkConnectivityViewModel _shared =
      NetworkConnectivityViewModel._sharedInstance();
  factory NetworkConnectivityViewModel() => _shared;
  get connectionStatus => _connectionStatus;
  getConnectionStatus() async {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile ||
          event == ConnectivityResult.ethernet ||
          event == ConnectivityResult.vpn) {
        _connectionStatus = true;
      } else {
        _connectionStatus = !false;
      }
      notifyListeners();
    });
  }
}
