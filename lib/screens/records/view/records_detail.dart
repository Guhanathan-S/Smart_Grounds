import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_grounds/utils/network_connectivity/network_view.dart';
import '../../../utils/network_connectivity/internetError.dart';
import '/utils/constants.dart';
import '../view_model/records_view.dart';

class RecordDetails extends StatefulWidget {
  late final String category;
  RecordDetails({required this.category});

  @override
  _RecordDetailsState createState() => _RecordDetailsState();
}

class _RecordDetailsState extends State<RecordDetails> {
  List<dynamic> sportsData = [];
  @override
  Widget build(BuildContext context) {
    NetworkConnectivityViewModel networkConnectivity =
        context.watch<NetworkConnectivityViewModel>();
    RecordsViewModel recordsViewModel = context.watch<RecordsViewModel>();
    if (networkConnectivity.connectionStatus) {
      sportsData = recordsViewModel.getRecordDetails(category: widget.category);
    }
    return Scaffold(
        backgroundColor: primaryColor3,
        appBar:
            AppBar(title: Text(widget.category), backgroundColor: primaryGreen),
        body: networkConnectivity.connectionStatus
            ? SafeArea(
                child: recordsViewModel.loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: primaryGreen,
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.all(10),
                        child: GridView.builder(
                            itemCount: sportsData.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 230,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),
                            itemBuilder: (context, index) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 150,
                                          width: 190,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: FutureBuilder(
                                              future: precacheImage(
                                                      NetworkImage(
                                                          sportsData[index]
                                                              .image!),
                                                      context)
                                                  .then((value) => true),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapShot) {
                                                if (!snapShot.hasData)
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: primaryColor1,
                                                    ),
                                                  );
                                                return FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Image.network(
                                                      sportsData[index].image!),
                                                );
                                              })),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (widget.category == 'Gym')
                                        Center(
                                            child: Text(
                                          sportsData[index].equipmentName,
                                          style: GoogleFonts.zillaSlab(
                                              fontSize: 18,
                                              color: primaryColor1),
                                        )),
                                      if (widget.category != 'Gym')
                                        Center(
                                          child: Text(
                                            sportsData[index].itemName,
                                            style: GoogleFonts.zillaSlab(
                                                fontSize: 18,
                                                color: primaryColor1),
                                          ),
                                        ),
                                      if (widget.category == 'Gym') ...[
                                        row("Date",
                                            sportsData[index].installedDate),
                                        row(
                                            "Condition",
                                            sportsData[index].condition == 1
                                                ? "Accessible"
                                                : "Under Service"),
                                      ],
                                      if (widget.category != 'Gym') ...[
                                        row('Total',
                                            sportsData[index].itemCount),
                                        row(
                                            'Purchased',
                                            sportsData[index].purchasedDate !=
                                                    null
                                                ? sportsData[index]
                                                    .purchasedDate
                                                : "")
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            })))
            : InternetError());
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
