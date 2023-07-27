import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_grounds/screens/data_screen/view_model/datascreen_view.dart';
import '../../notifications/firebase_messaging.dart';
import '../../notifications/flutter_notifications.dart';
import 'database/firebase_data/userData.dart';
import 'package:smart_grounds/screens/controls/view_model/controls_view.dart';
import 'package:smart_grounds/screens/home.dart';
import 'package:smart_grounds/screens/Auth/login_screen.dart';
import '../../utils/constants.dart';
import 'package:smart_grounds/screens/records/view_model/records_view.dart';
import 'utils/network_connectivity/network_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNotifications.initialize();
  await Firebase.initializeApp();
  String userType = "";
  devHeight = window.physicalSize.height / 2.75;
  devWidth = window.physicalSize.width / 2.75;
  if (UserDataBase.auth.currentUser != null) {
    await UserDataBase.getUserData();
    userType = UserDataBase.userDetails.userType;
    FirebasePushMessaging().initNotification();
  }
  runApp(MyApp(
    userType: userType,
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({required this.userType});
  final String userType;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ControlViewModel()),
          ChangeNotifierProvider(create: (context) => RecordsViewModel()),
          ChangeNotifierProvider(
              create: (context) => NetworkConnectivityViewModel()),
          ChangeNotifierProvider(create: (context) => DataViewModel())
        ],
        child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: _createMaterialColor(primaryGreen),
            ),
            home: userType.isNotEmpty ? Home(userType: userType) : Login()));
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryColor1,
        body: Center(
          child: CircularProgressIndicator(
            color: primaryGreen,
            strokeWidth: 4,
          ),
        ),
      ),
    );
  }
}

MaterialColor _createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {
    50: color.withOpacity(strengths[0]),
    100: color.withOpacity(strengths[0]),
    200: color.withOpacity(strengths[0]),
    300: color.withOpacity(strengths[0]),
    400: color.withOpacity(strengths[0]),
    500: color.withOpacity(strengths[0]),
    600: color.withOpacity(strengths[0]),
    700: color.withOpacity(strengths[0]),
    800: color.withOpacity(strengths[0]),
    900: color.withOpacity(strengths[0]),
  };
  return MaterialColor(color.value, swatch);
}
