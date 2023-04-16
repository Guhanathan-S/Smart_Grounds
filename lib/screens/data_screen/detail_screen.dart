import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return data();
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: 10)),
    );
  }

  Widget data() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(10),
      child: Center(
        child: Container(
          height: 220,
          width: 370,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              details("Equipement", "Name"),
              Divider(),
              details("Start Time", "00 : 00"),
              Divider(),
              details("End Time", "00 : 00"),
              Divider(),
              details("Total time ", "00 : 00"),
              Divider(),
              details("Calories Burn", "200 C"),
            ],
          ),
        ),
      ),
    );
  }

  Widget details(text, data) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        Spacer(),
        Text(
          ":  $data",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        SizedBox(
          width: 40,
        )
      ],
    );
  }
}
