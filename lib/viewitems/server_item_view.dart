import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyan_vpn_app/blocs/home_bloc.dart';
import 'package:nyan_vpn_app/data/vos/server_vo.dart';
import 'package:nyan_vpn_app/resources/colors.dart';
import 'package:nyan_vpn_app/resources/dimens.dart';
import 'package:provider/provider.dart';

class ServerItemView extends StatelessWidget {
  ServerVO? serverVo;

  ServerItemView({required this.serverVo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var bloc = Provider.of<HomeBloc>(context, listen: false);
        // if(bloc.vpnStage == "connected") {
        //   print("VPN Stage is connected, so make it disconnect............");
        //   bloc.onTapDisconnect();
        // }
        showConfirmDialog(context, serverVo?.id ?? 0, serverVo);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: MARGIN_MEDIUM_2),
        height: 80,
        decoration: BoxDecoration(
          // color: Color.fromRGBO(81, 91, 226, 0.3),
          color: (serverVo?.isSelected ?? false)
              ? Color.fromRGBO(81, 91, 226, 0.15)
              : Color.fromRGBO(0, 0, 0, 0.02),
          border: Border.all(
              width: 2,
              color: (serverVo?.isSelected ?? false)
                  ? Color.fromRGBO(81, 91, 226, 0.1)
                  : Color.fromRGBO(0, 0, 0, 0.1)),
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2),
        ),
        padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlagAndCountryNameView(serverVo: serverVo),
            (serverVo?.isSelected ?? false)
                ? Image.asset(
                    "assets/images/select.png",
                    width: 25,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void showConfirmDialog(BuildContext context, int id, ServerVO? serverVo) {
    Widget okButton = TextButton(
      onPressed: () async {
        var bloc = Provider.of<HomeBloc>(context, listen: false);
        bloc.onTapDisconnect();
        await Future.delayed(Duration(milliseconds: 500));
        bloc.onChooseLocation(id);
        Navigator.pop(context);
      },
      child: Text(
        "OK",
        style: GoogleFonts.ubuntu(
          fontWeight: FontWeight.w500,
          color: PRIMARY_COLOR,
        ),
      ),
    );

    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "CANCEL",
        style: GoogleFonts.ubuntu(
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_CARD_MEDIUM_2),
      title: Image.asset(
        serverVo?.flag ?? "",
        height: 50,
      ),
      content: Text(
        "Do you want to connect ${serverVo?.countryName ?? ""}?",
        textAlign: TextAlign.center,
        style: GoogleFonts.ubuntu(),
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}

class FlagAndCountryNameView extends StatelessWidget {
  ServerVO? serverVo;

  FlagAndCountryNameView({required this.serverVo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FlagView(imageUrl: serverVo?.flag ?? ""),
        const SizedBox(width: MARGIN_MEDIUM_3),
        CountryNameView(countryName: serverVo?.countryName ?? ""),
      ],
    );
  }
}

class CountryNameView extends StatelessWidget {
  String countryName;

  CountryNameView({required this.countryName});

  @override
  Widget build(BuildContext context) {
    return Text(
      countryName,
      style: GoogleFonts.ubuntu(
        color: Color.fromRGBO(0, 0, 0, 0.6),
        fontSize: TEXT_REGULAR_2X,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class FlagView extends StatelessWidget {
  String imageUrl;

  FlagView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageUrl,
      width: 50,
    );
  }
}
