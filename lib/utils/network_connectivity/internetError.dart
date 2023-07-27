import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class InternetError extends StatelessWidget {
  const InternetError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(image: AssetImage('assets/internet_error.png')),
          SizedBox(
            height: 10,
          ),
          Text(
            'OOPS, No Internet',
            style: GoogleFonts.roboto(fontSize: 40, color: primaryGreen),
          )
        ],
      ),
    );
  }
}
