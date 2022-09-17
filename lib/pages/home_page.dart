import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyan_vpn_app/blocs/home_bloc.dart';
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
        status: 'loading...',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              padding: EdgeInsets.only(right: MARGIN_MEDIUM),
              child: Icon(
                Icons.location_on,
                color: Colors.black,
              ),
            ),
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
                          builder: (context, byteOut, child) =>
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
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
                          openVpn: openVpn,
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
  OpenVPN openVpn;
  String vpnStage;

  VpnButtonSectionView({required this.openVpn, required this.vpnStage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (vpnStage == "disconnected") {
              openVpn.connect(
                sgConfig,
                "Singapore",
                username: "tcpvpn.com-NyanWinNaing",
                password: "NyanWinNaing19",
                bypassPackages: [],
                certIsRequired: false,
              );
            } else {
              openVpn.disconnect();
              var bloc = Provider.of<HomeBloc>(context, listen: false);
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
        text: "Nyan VPN",
        style: GoogleFonts.ubuntu(
          // color: Colors.black,
          color: Color.fromRGBO(81, 91, 226, 1.0),
          fontWeight: FontWeight.w500,
          fontSize: TEXT_REGULAR_3X,
        ),
      ),
    );
  }
}
