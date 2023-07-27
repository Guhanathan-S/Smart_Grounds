import 'package:flutter/material.dart';
import '/utils/constants.dart';
import '../view/records_detail.dart';

class Records extends StatefulWidget {
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  List<List<String>> records = [
    ["Gym", 'assets/gym.jpg'],
    ["Cricket", 'assets/cricket.jpg'],
    ["VolleyBall", 'assets/volleyBall.jpg'],
    ["FootBall", 'assets/football.jpg'],
    ["Tennis", 'assets/tennis.jpg'],
    ["Badminton", 'assets/badminton.jpeg']
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.all(5),
        child: GridView.builder(
            itemCount: 6,
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
                          builder: (context) =>
                              RecordDetails(category: records[index][0])));
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
