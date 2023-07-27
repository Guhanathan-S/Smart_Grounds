import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_grounds/screens/data_screen/view_model/datascreen_view.dart';
import 'package:smart_grounds/utils/network_connectivity/internetError.dart';
import '../../../utils/constants.dart';
import '../../../utils/network_connectivity/network_view.dart';
import 'calories_cal.dart';
import '../model/data_model.dart ';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  ScrollController listController = ScrollController();

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
    NetworkConnectivityViewModel networkConnectivity =
        context.watch<NetworkConnectivityViewModel>();
    DataViewModel _userData = context.watch<DataViewModel>();
    return networkConnectivity.connectionStatus
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: _userData.loading
                ? Center(
                    child: CircularProgressIndicator(
                    color: primaryGreen,
                    strokeWidth: 4,
                  ))
                : _userData.userData.isEmpty
                    ? Center(
                        child: Text(
                          'No Records',
                          style: TextStyle(color: primaryGreen, fontSize: 35),
                        ),
                      )
                    : ListView.separated(
                        controller: listController,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 20,
                          );
                        },
                        itemCount: _userData.userData.length,
                        itemBuilder: (context, index) {
                          if (index == _userData.userData.length)
                            return SizedBox(
                              height: 50,
                            );
                          return NewCardDesign(
                            userData: _userData.userData[index],
                          );
                        }))
        : InternetError();
  }
}

class NewCardDesign extends StatefulWidget {
  NewCardDesign({required this.userData});

  final UserData userData;

  @override
  State<NewCardDesign> createState() => _NewCardDesignState();
}

class _NewCardDesignState extends State<NewCardDesign>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late int totalTime;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    _animationController.forward();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalTime = (((widget.userData.time != null
                        ? (int.parse(widget.userData.time!.split(' ')[0]))
                            .toInt()
                        : 0) ~/
                    30) *
                30 +
            30)
        .toInt();
    return Container(
      height: 250,
      width: devWidth,
      decoration: BoxDecoration(
          color: primaryGreen, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Chip(
              backgroundColor: primaryColor1,
              label: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: primaryGreen,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.userData.date!,
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              dataCardUi(
                  title: 'Calories Burn',
                  data: widget.userData.calories != null
                      ? widget.userData.calories!
                      : 0,
                  total: widget.userData.totCal),
              SizedBox(
                width: 10,
              ),
              dataCardUi(
                  title: 'Time',
                  data: widget.userData.time != null
                      ? (int.parse(widget.userData.time!.split(' ')[0])).toInt()
                      : 0,
                  total: totalTime),
            ],
          ),
        ],
      ),
    );
  }

  Widget dataCardUi({
    required String title,
    required int data,
    required int? total,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (data == 0 || total == null)
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CalorisCal(
                      dataKey: widget.userData.key!,
                    )));
        },
        child: Container(
            height: 180,
            decoration: BoxDecoration(
                color: primaryColor1, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: primaryGreen),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(alignment: Alignment.center, children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: primaryGreen.withOpacity(.6), width: 4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    height: 95,
                    width: 95,
                    child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: CircleProgressPainter(
                                progress: _animation.value,
                                data:
                                    total != null ? ((data) / total) * 100 : 0),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  data != 0 ? data.toString() : 'No Data',
                                  style: TextStyle(
                                      color: whiteColor, fontSize: 20),
                                )),
                          );
                        }),
                  )
                ])
              ],
            )),
      ),
    );
  }
}

class DetailsCardUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            color: whiteColor,
            height: 300,
          ),

          /// Top Container
          Align(
            alignment: Alignment.topRight,
            child: ClipPath(
              clipper: TopContainerClipper(),
              child: Container(
                height: 60,
                width: devWidth / 1.4,
                color: primaryGreen,
              ),
            ),
          ),

          /// Right Container
          Align(
              alignment: Alignment.topRight,
              child: ClipPath(
                  clipper: RightSideContainer(),
                  child: Container(
                    height: 300,
                    width: devWidth / 2 - 10,
                    decoration: BoxDecoration(
                        color: primaryColor1,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/fitness.jpg"))),
                  ))),

          /// Left Container
          Align(
            alignment: Alignment.topLeft,
            child: ClipPath(
              clipper: LeftSideContainer(),
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  color: Colors.amber[400],
                  height: 300,
                  width: devWidth / 1.55,
                ),
              ),
            ),
          ),

          /// Bottom Container
          Positioned(
            bottom: 0,
            child: ClipPath(
                clipper: BottomContainerClipper(),
                child: Container(
                  height: 70,
                  width: devWidth / 2 + 80,
                  color: primaryColor1,
                )),
          ),
        ],
      ),
    );
  }
}

class TopContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class RightSideContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 1.3, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 1.3, size.height);
    path.lineTo(size.width / 8, size.height / 1.2);
    path.quadraticBezierTo(0, size.height / 1.3, 0, size.height / 1.5);
    // path.lineTo(0, size.height / 1.2);
    path.lineTo(0, size.height / 3);
    path.quadraticBezierTo(0, size.height / 6, size.width / 6, size.height / 7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class LeftSideContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width / 1.5, size.height / 8);
    path.quadraticBezierTo(
        size.width, size.height / 6, size.width, size.height / 3);
    path.lineTo(size.width, size.height / 1.5);
    path.quadraticBezierTo(
        size.width, size.height / 1.26, size.width / 1.2, size.height / 1.18);
    path.lineTo(0, size.height);

    // path.lineTo(size.width / 1.3, size.height);
    // path.lineTo(size.width / 8, size.height / 1.2);
    // path.quadraticBezierTo(0, size.height / 1.3, 0, size.height / 1.5);
    // // path.lineTo(0, size.height / 1.2);
    // path.lineTo(0, size.height / 3);
    // path.quadraticBezierTo(0, size.height / 6, size.width / 6, size.height / 7);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class BottomContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width / 1.3, size.height / 2.4);
    path.quadraticBezierTo(
        size.width / 1.1, size.height / 2, size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class CircleProgressPainter extends CustomPainter {
  late Paint _paint;
  double progress;
  double data;

  CircleProgressPainter({required this.progress, required this.data}) {
    _paint = Paint()
      ..color = primaryGreen
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 13
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      pi / 2,
      pi * 0.02 * data * progress,
      false,
      _paint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
