import 'package:flutter/material.dart';
import '../constants.dart';
import 'booking_ui.dart';

class Booking_Home extends StatefulWidget {
  const Booking_Home({Key? key}) : super(key: key);

  @override
  State<Booking_Home> createState() => _Booking_HomeState();
}

class _Booking_HomeState extends State<Booking_Home>
    with TickerProviderStateMixin {
  TabController? tabControllerBook;
  @override
  void initState() {
    tabControllerBook = TabController(length: 6, vsync: this);
    super.initState();
  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 5),
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                color: primaryColor3,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryGreen),
                labelColor: whiteColor,
                indicatorColor: primaryGreen,
                controller: tabControllerBook,
                unselectedLabelColor: whiteColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                labelPadding: EdgeInsets.symmetric(horizontal: 5),
                indicatorPadding: EdgeInsets.symmetric(horizontal: -2),
                onTap: (value) {
                  setState(() {
                    _index = value;
                  });
                },
                tabs: [
                  Tab(
                      child: tabs(
                          icon: Icon(
                            Icons.sports_cricket,
                          ),
                          data: 'Cricket',
                          index: 0)),
                  Tab(
                      child: tabs(
                          icon: Icon(
                            Icons.sports_volleyball,
                          ),
                          data: "VolleyBall",
                          index: 1)),
                  Tab(
                    child: tabs(
                        icon: ImageIcon(
                          AssetImage(
                            'assets/badminton.png',
                          ),
                        ),
                        data: 'Badminton',
                        index: 2),
                  ),
                  Tab(
                      child: tabs(
                          icon: Icon(
                            Icons.sports_volleyball,
                          ),
                          data: "Tennis",
                          index: 3)),
                  Tab(
                      child: tabs(
                          icon: Icon(
                            Icons.sports_soccer,
                          ),
                          data: 'Football',
                          index: 4)),
                  Tab(
                      child: tabs(
                          icon: Icon(
                            Icons.sports_baseball,
                          ),
                          data: 'Basket Ball',
                          index: 5)),
                ],
              )),
          Expanded(
            child: Container(
                child: <Widget>[
              Booking(sport: 'cricket'),
              Booking(sport: 'volleyball'),
              Booking(sport: 'badminton'),
              Booking(sport: 'tennis'),
              Booking(sport: 'football'),
              Booking(sport: 'basketball')
            ][_index]),
          )
        ]));
  }

  Widget tabs({required icon, required String data, required index}) {
    return Row(
      children: [
        icon,
        SizedBox(
          width: 10,
        ),
        if (_index == index)
          Text(
            data,
            style: TextStyle(color: whiteColor, fontSize: 25),
          ),
      ],
    );
  }
}
