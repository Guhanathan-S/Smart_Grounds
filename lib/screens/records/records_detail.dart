import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecordDetails extends StatefulWidget {
  final data;
  String? Category;
  RecordDetails({@required this.data, @required this.Category});

  @override
  _RecordDetailsState createState() => _RecordDetailsState();
}

class _RecordDetailsState extends State<RecordDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.Category!),
        ),
        body: SafeArea(
            child: Container(
                margin: EdgeInsets.all(10),
                child: GridView.builder(
                    itemCount: widget.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 230,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 150,
                                width: 190,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          widget.data[index].image != null
                                              ? widget.data[index].image!
                                              : "https://i.imgur.com/sUFH1Aq.png",
                                        ),
                                        fit: BoxFit.fill)),
                              ),
                              if (widget.Category == 'Gym')
                                Center(
                                    child: Text(
                                  widget.data[index].equipmentName,
                                  style: GoogleFonts.zillaSlab(
                                      fontSize: 18, color: Colors.black),
                                )),
                              if (widget.Category != 'Gym')
                                Center(
                                  child: Text(
                                    widget.data[index].itemName,
                                    style: GoogleFonts.zillaSlab(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              if (widget.Category == 'Gym') ...[
                                row("Date", widget.data[index].installedDate),
                                row(
                                    "Condition",
                                    widget.data[index].condition == 1
                                        ? "Accessible"
                                        : "Under Service"),
                              ],
                              if (widget.Category != 'Gym') ...[
                                row('Total', widget.data[index].itemCount),
                                row(
                                    'Purchased',
                                    widget.data[index].purchasedDate != null
                                        ? widget.data[index].purchasedDate
                                        : "")
                              ],
                            ],
                          ),
                        ),
                      );
                    }))));
  }

  Widget row(title, data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              ": $data",
              style: GoogleFonts.zillaSlab(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
