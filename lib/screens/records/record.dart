import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_grounds/screens/constants.dart';
import 'package:smart_grounds/screens/records/addRecords.dart';
import 'package:smart_grounds/screens/records/records_detail.dart';
import 'package:smart_grounds/screens/records/recordsmodel.dart';

class Records extends StatefulWidget {
  final type;
  const Records({this.type});

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  DatabaseReference database = FirebaseDatabase.instance.ref();
  StreamSubscription? _recordsStream;
  List<GymEpuiments> gymList = [];
  List<SportsItem> cricketList = [];
  List<SportsItem> volleyBallList = [];
  List<SportsItem> footBallList = [];
  List<SportsItem> tennisList = [];
  List<SportsItem> badmintonList = [];
  List datas = [];
  bool isLoading = true;
  List<List<String>> records = [
    ["Gym", 'assets/gym.jpg'],
    ["Cricket", 'assets/cricket.jpg'],
    ["VolleyBall", 'assets/volleyBall.jpg'],
    ["FootBall", 'assets/football.jpg'],
    ["Tennis", 'assets/tennis.jpg'],
    ["Badminton", 'assets/badminton.jpeg']
  ];
  List expands = [];
  getData() {
    _recordsStream = database.ref.child('records').onValue.listen((event) {
      var data = RecordsModel.fromJson(event.snapshot.value);
      gymList = data.gymEquipments!;
      var sport = data.sportsItems!;
      cricketList = sport.cricket!;
      volleyBallList = sport.volleyBall != null ? sport.volleyBall! : [];
      footBallList = sport.footBall != null ? sport.footBall! : [];
      tennisList = sport.tennis != null ? sport.tennis! : [];
      badmintonList = sport.badminton != null ? sport.badminton! : [];
      setState(() {
        datas = [
          gymList,
          cricketList,
          volleyBallList,
          footBallList,
          tennisList,
          badmintonList
        ];
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _recordsStream!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.all(5),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                itemCount: datas.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 200,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecordDetails(
                                  data: datas[index],
                                  Category: records[index][0])));
                    },
                    child: Material(
                      elevation: 5,
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 130,
                            width: 170,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(records[index][1]),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            records[index][0],
                            style: TextStyle(
                                color: primaryColor1,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }));
  }
}
