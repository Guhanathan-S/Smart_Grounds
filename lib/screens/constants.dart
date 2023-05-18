import 'package:flutter/material.dart';

var devHeight;

var devWidth;

final pattern = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

final regx = RegExp(r'^[0-9]+s');

const Color primaryGreen = Color(0xFFc0e862);

const Color primaryColor1 = Color(0xFF0D1C2E);

const Color primaryColor2 = Color(0xFF152534);

Color primaryColor3 = Color(0xFF1E2E3D);

const Color whiteColor = Colors.white;

const Color greyColor = Colors.grey;

const Color white38Color = Colors.white38;

const List month = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'July',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

const List weekDay = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

const Map icon = {
  "Cricket": Icons.sports_cricket,
  "Badminton": AssetImage('assets/badminton.png'),
  "VolleyBall": Icons.sports_volleyball,
  "Tennis": Icons.sports_tennis,
  "FootBall": Icons.sports_soccer,
  "BaseketBall": Icons.sports_basketball,
};

Color? col = Icon(Icons.add).color;

class TopClipperConst extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, devHeight / 7);
    path.quadraticBezierTo(
        devWidth / 2, devHeight / 4, devWidth, devHeight / 7);
    path.lineTo(devWidth, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
