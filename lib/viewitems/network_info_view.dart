import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyan_vpn_app/resources/dimens.dart';

class NetworkInfoView extends StatelessWidget {
  String label;
  String data;

  NetworkInfoView({required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      padding: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_CARD_MEDIUM_2),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(81, 91, 226, 0.2),
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 1 / 3,
            child: Text(
              label,
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1.4 / 3,
            child: Text(
              data.isNotEmpty ? data : "N/A",
              textAlign: TextAlign.right,
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
