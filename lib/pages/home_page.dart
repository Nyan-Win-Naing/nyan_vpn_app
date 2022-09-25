import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyan_vpn_app/blocs/home_bloc.dart';
import 'package:nyan_vpn_app/data/vos/server_vo.dart';
import 'package:nyan_vpn_app/dummy/dummy_server_list.dart';
import 'package:nyan_vpn_app/pages/server_page.dart';
import 'package:nyan_vpn_app/resources/colors.dart';
import 'package:nyan_vpn_app/resources/dimens.dart';
import 'package:nyan_vpn_app/utils/vpn_config.dart';
import 'package:nyan_vpn_app/viewitems/network_info_view.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late OpenVPN openVpn;
  HomeBloc? bloc;

  @override
  void initState() {
    super.initState();
    openVpn = OpenVPN(
      onVpnStatusChanged: (VpnStatus? status) {
        print("Status is ===============> $status");
        bloc?.onChangeDuration(status);
        bloc?.onChangeByteInByteOut(status);
      },
      onVpnStageChanged: (VPNStage? stage, String _) {
        print("Stage is ================> $stage");
        _showLoading(stage);
        if (stage == VPNStage.disconnected) {
          bloc?.clearDuration();
          bloc?.clearByteInByteOut();
        }
        bloc?.onChangeVpnStage(stage);
      },
    );
    openVpn.initialize(
      groupIdentifier: "apps.google.com",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nyan Win Naing",
    );
  }

  void _showLoading(VPNStage? stage) {
    if (stage == VPNStage.connected || stage == VPNStage.disconnected) {
      EasyLoading.dismiss();
    } else {
      EasyLoading.show(
        status: '${stage?.name}...',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(openVpn),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.vpn_key_outlined,
                color: Color.fromRGBO(81, 91, 226, 1.0),
              ),
              SizedBox(width: MARGIN_MEDIUM),
              AppBarTitleView(),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: MARGIN_MEDIUM),
              child: GestureDetector(
                onTap: () {
                  _navigateToServerPage(context);
                },
                child: const Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
              ),
            ),
            // Builder(
            //   builder: (context) {
            //     return PopupMenuButton<int>(
            //       onSelected: (int id) {
            //         var bloc = Provider.of<HomeBloc>(context, listen: false);
            //         if(bloc.vpnStage == "connected") {
            //           print("Previous VPN is Connected.............");
            //           showConfirmDialog(context, bloc);
            //         }
            //         bloc.onChooseLocation(id);
            //       },
            //       icon: Icon(
            //         Icons.location_on,
            //         color: Colors.black,
            //       ),
            //       itemBuilder: (context) => dummyServerList.map((serverVo) {
            //         return PopupMenuItem(
            //           value: serverVo.id ?? 0,
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Image.asset(
            //                 serverVo.flag ?? "",
            //                 width: 25,
            //               ),
            //               SizedBox(width: MARGIN_MEDIUM),
            //               Text(
            //                 serverVo.countryName ?? "",
            //                 style: GoogleFonts.ubuntu(),
            //               ),
            //             ],
            //           ),
            //         );
            //       }).toList(),
            //     );
            //   }
            // ),
          ],
        ),
        body: Builder(builder: (context) {
          bloc = Provider.of<HomeBloc>(context, listen: false);
          return Container(
            child: RefreshIndicator(
              color: Color.fromRGBO(27, 204, 115, 1.0),
              onRefresh: () async {
                bloc?.loadNetworkInfo();
              },
              child: ListView(
                children: [
                  SizedBox(height: MARGIN_LARGE),
                  // Selector<HomeBloc, String>(
                  //   selector: (context, bloc) => bloc.ip ?? "N/A",
                  //   builder: (context, ip, child) =>
                  //       IpAddressSectionView(ip: ip),
                  // ),
                  Selector<HomeBloc, double>(
                    selector: (context, bloc) => bloc.byteIn ?? 0,
                    builder: (context, byteIn, child) =>
                        Selector<HomeBloc, double>(
                      selector: (context, bloc) => bloc.byteOut ?? 0,
                      builder: (context, byteOut, child) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: MARGIN_MEDIUM_2),
                        child: DownloadUploadSpeedSectionView(
                          byteIn: byteIn,
                          byteOut: byteOut,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MARGIN_XLARGE),

                  Selector<HomeBloc, String>(
                      selector: (context, bloc) => bloc.vpnStage ?? "",
                      builder: (context, vpnStage, child) {
                        print(
                            "VPN Stage from Page Level Widget is ============> $vpnStage");
                        return VpnButtonSectionView(
                          vpnStage: vpnStage,
                        );
                      }),
                  SizedBox(height: MARGIN_CARD_MEDIUM_2),
                  Selector<HomeBloc, String>(
                    selector: (context, bloc) => bloc.duration ?? "00:00:00",
                    builder: (context, duration, child) =>
                        TimerSectionView(duration: duration),
                  ),
                  // SizedBox(height: MARGIN_MEDIUM_2),
                  SizedBox(height: MARGIN_XLARGE),
                  Consumer<HomeBloc>(
                    builder: (context, bloc, child) =>
                        NetworkInfoSectionView(bloc: bloc),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _navigateToServerPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServerPage(openVpn: openVpn),
      ),
    );
  }

  void showConfirmDialog(BuildContext context, HomeBloc bloc) {
    Widget okButton = TextButton(
      onPressed: () {
        bloc.onTapDisconnect();
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
      title: Text(
        "Confirmation",
        style: GoogleFonts.ubuntu(
          fontSize: TEXT_REGULAR_2X,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        "Do you want to connect this location?",
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

class DownloadUploadSpeedSectionView extends StatelessWidget {
  double byteIn;
  double byteOut;

  DownloadUploadSpeedSectionView({required this.byteIn, required this.byteOut});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ByteInfoView(label: "Download", data: byteIn),
        ByteInfoView(label: "Upload", data: byteOut),
      ],
    );
  }
}

class ByteInfoView extends StatelessWidget {
  final String label;
  final double data;

  ByteInfoView({required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: MARGIN_MEDIUM),
        Text(
          "$data KB/s",
          style: GoogleFonts.ubuntu(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class NetworkInfoSectionView extends StatelessWidget {
  final HomeBloc bloc;

  NetworkInfoSectionView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NetworkInfoView(label: "IP Address", data: bloc.ip ?? "N/A"),
        SizedBox(height: MARGIN_MEDIUM),
        NetworkInfoView(label: "ISP", data: bloc.isp ?? "N/A"),
        SizedBox(height: MARGIN_MEDIUM),
        NetworkInfoView(label: "AS Name", data: bloc.asName ?? "N/A"),
        SizedBox(height: MARGIN_MEDIUM),
        NetworkInfoView(label: "Domain", data: bloc.domain ?? "N/A"),
        SizedBox(height: MARGIN_MEDIUM),
        NetworkInfoView(label: "Region", data: bloc.region ?? "N/A"),
        SizedBox(height: MARGIN_MEDIUM),
        NetworkInfoView(label: "Country", data: bloc.country ?? "N/A"),
        SizedBox(height: MARGIN_MEDIUM),
      ],
    );
  }
}

class TimerSectionView extends StatelessWidget {
  String duration;

  TimerSectionView({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          duration,
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontSize: TEXT_REGULAR_3X,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ConnectStatusView extends StatelessWidget {
  String status;

  ConnectStatusView({required this.status});

  @override
  Widget build(BuildContext context) {
    return Text(
      status,
      style: GoogleFonts.ubuntu(
        color: status == "Connected"
            ? Color.fromRGBO(27, 204, 115, 1.0)
            : Colors.redAccent,
        fontSize: TEXT_REGULAR_3X,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class VpnButtonSectionView extends StatelessWidget {
  String vpnStage;

  VpnButtonSectionView({required this.vpnStage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (vpnStage == "disconnected") {
              var bloc = Provider.of<HomeBloc>(context, listen: false);
              bloc.onTapConnect();
            } else {
              var bloc = Provider.of<HomeBloc>(context, listen: false);
              bloc.onTapDisconnect();
              bloc.clearDuration();
            }
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: getBorderColor(vpnStage),
                // color: Colors.blueAccent,
                // color: Color.fromRGBO(27, 204, 115, 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: MARGIN_SMALL, vertical: MARGIN_SMALL),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(81, 91, 226, 1.0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(vpnStage),
                  size: MARGIN_60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: MARGIN_XLARGE),
        ConnectStatusView(status: getVpnStatus(vpnStage)),
      ],
    );
  }

  Color getBorderColor(String vpnStage) {
    print("VPN Stage is $vpnStage ....................");
    if (vpnStage == "disconnected") {
      return Colors.blueAccent;
    } else if (vpnStage == "connected") {
      return Color.fromRGBO(27, 204, 115, 1.0);
    } else {
      return Color.fromRGBO(0, 0, 0, 0.2);
    }
  }

  IconData getIcon(String vpnStage) {
    if (vpnStage == "disconnected") {
      return Icons.power_settings_new_rounded;
    } else if (vpnStage == "connected") {
      return Icons.square;
    } else {
      return Icons.vpn_key;
    }
  }

  String getVpnStatus(String vpnStage) {
    if (vpnStage == "disconnected") {
      return "Disconnected";
    } else if (vpnStage == "connected") {
      return "Connected";
    } else if (vpnStage == "authenticating") {
      return "Authenticating";
    } else {
      return "Connecting";
    }
  }
}

class IpAddressSectionView extends StatelessWidget {
  String ip;

  IpAddressSectionView({required this.ip});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          ip,
          style: GoogleFonts.ubuntu(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            fontSize: TEXT_REGULAR_3X,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class AppBarTitleView extends StatelessWidget {
  const AppBarTitleView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "NyanVPN",
        style: GoogleFonts.ubuntu(
          color: Colors.black,
          // color: Color.fromRGBO(81, 91, 226, 1.0),
          fontWeight: FontWeight.w500,
          fontSize: TEXT_REGULAR_3X,
        ),
      ),
    );
  }
}
