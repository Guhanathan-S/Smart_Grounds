import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_grounds/screens/constants.dart';

class RecordDetails extends StatefulWidget {
  final data;
  final String? category;
  RecordDetails({required this.data, required this.category});

  @override
  _RecordDetailsState createState() => _RecordDetailsState();
}

class _RecordDetailsState extends State<RecordDetails> {
  late List<bool> imageLoaded;
  @override
  void initState() {
    imageLoaded = List.generate(widget.data.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor3,
        appBar: AppBar(
            title: Text(widget.category!), backgroundColor: primaryGreen),
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
                      precacheImage(
                              NetworkImage(widget.data[index].image != null
                                  ? widget.data[index].image!
                                  : "https://i.imgur.com/sUFH1Aq.png"),
                              context)
                          .then((_) {
                        setState(() {
                          imageLoaded[index] = true;
                        });
                      });
                      return Material(
                        elevation: 10,
                        color: primaryGreen,
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
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: imageLoaded[index]
                                    ? FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.network(
                                          widget.data[index].image != null
                                              ? widget.data[index].image!
                                              : "https://i.imgur.com/sUFH1Aq.png",
                                        ),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor1,
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              if (widget.category == 'Gym')
                                Center(
                                    child: Text(
                                  widget.data[index].equipmentName,
                                  style: GoogleFonts.zillaSlab(
                                      fontSize: 18, color: primaryColor1),
                                )),
                              if (widget.category != 'Gym')
                                Center(
                                  child: Text(
                                    widget.data[index].itemName,
                                    style: GoogleFonts.zillaSlab(
                                        fontSize: 18, color: primaryColor1),
                                  ),
                                ),
                              if (widget.category == 'Gym') ...[
                                row("Date", widget.data[index].installedDate),
                                row(
                                    "Condition",
                                    widget.data[index].condition == 1
                                        ? "Accessible"
                                        : "Under Service"),
                              ],
                              if (widget.category != 'Gym') ...[
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
              style: TextStyle(fontSize: 18, color: primaryColor1),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              ": $data",
              style: GoogleFonts.zillaSlab(fontSize: 18, color: primaryColor1),
            ),
          ],
        ),
      ),
    );
  }
}
