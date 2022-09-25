import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyan_vpn_app/blocs/home_bloc.dart';
import 'package:nyan_vpn_app/data/vos/server_vo.dart';
import 'package:nyan_vpn_app/viewitems/server_item_view.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:provider/provider.dart';

import '../resources/dimens.dart';

class ServerPage extends StatelessWidget {
  OpenVPN openVpn;

  ServerPage({required this.openVpn});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(openVpn),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: RichText(
            text: TextSpan(
              text: "Servers",
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                // color: Color.fromRGBO(81, 91, 226, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: TEXT_REGULAR_3X,
              ),
            ),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Selector<HomeBloc, String>(
              selector: (context, bloc) => bloc.country ?? "",
              builder: (context, country, child) => (country.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MARGIN_MEDIUM_2),
                        Selector<HomeBloc, List<ServerVO>>(
                          selector: (context, bloc) => bloc.serverList ?? [],
                          shouldRebuild: (previous, next) => previous != next,
                          builder: (context, serverList, child) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: MARGIN_MEDIUM_2),
                            child: ListView.builder(
                              itemCount: serverList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ServerItemView(
                                    serverVo: serverList[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 2.5 / 3,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
