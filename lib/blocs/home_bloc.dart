import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/foundation.dart';
import 'package:nyan_vpn_app/data/models/ip_model.dart';
import 'package:nyan_vpn_app/data/models/ip_model_impl.dart';
import 'package:nyan_vpn_app/data/vos/server_vo.dart';
import 'package:nyan_vpn_app/dummy/dummy_server_list.dart';
import 'package:nyan_vpn_app/utils/country_map.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

import '../utils/vpn_config.dart';

class HomeBloc extends ChangeNotifier {
  /// States
  OpenVPN? openVpn;
  String? ip;
  String? region;
  String? country;
  String? isp;
  String? asName;
  String? domain;
  String? vpnStage;
  String? duration;
  double? byteIn = 0;
  double? byteOut = 0;
  List<ServerVO>? serverList;

  /// Models
  IpModel _model = IpModelImpl();

  HomeBloc(OpenVPN openVpn) {
    this.openVpn = openVpn;
    loadNetworkInfo();
  }

  void loadNetworkInfo() async {
    Ipify.ipv4().then((ip) {
      this.ip = ip;
      notifyListeners();
      _model.getGeo(ip).then((response) {
        region = response.location?.region;
        country = countryMap[response.location?.country ?? ""];
        isp = response.isp;
        asName = response.as?.name;
        domain = response.as?.domain;
        print("Country is =========> $country");
        dummyServerList.forEach((serverVo) {
          if (serverVo.countryName == country) {
            serverVo.isSelected = true;
          }
        });
        List<ServerVO> selectedServerList = dummyServerList
            .where((serverVo) => serverVo.isSelected ?? false)
            .toList();
        if (selectedServerList.isEmpty) {
          dummyServerList.first.isSelected = true;
        }
        serverList = dummyServerList;
        notifyListeners();
      }).catchError((error) {
        debugPrint(error.toString());
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void onChangeVpnStage(VPNStage? stage) {
    print("Works on change vpn stage ...............");
    if (stage == VPNStage.disconnected) {
      vpnStage = "disconnected";
      notifyListeners();
    } else if (stage == VPNStage.connected) {
      vpnStage = "connected";
      notifyListeners();
    } else {
      vpnStage == "connecting";
      notifyListeners();
    }
  }

  void onChangeDuration(VpnStatus? status) {
    if (status?.connectedOn == null) {
      duration = "00:00:00";
      notifyListeners();
    } else {
      duration = status?.duration;
      notifyListeners();
    }
  }

  void onChangeByteInByteOut(VpnStatus? status) {
    byteIn = double.parse(
        (int.parse(status?.byteIn ?? "0") / 1024).toStringAsFixed(2));
    byteOut = double.parse(
        (int.parse(status?.byteOut ?? "0") / 1024).toStringAsFixed(2));
    notifyListeners();
  }

  void clearDuration() {
    duration = "00:00:00";
    notifyListeners();
  }

  void clearByteInByteOut() {
    byteIn = 0;
    byteOut = 0;
    notifyListeners();
  }

  void onChooseLocation(int id) {
    /// Remove all selected server in server list
    serverList?.forEach((server) {
      if (server.isSelected ?? false) {
        server.isSelected = false;
      }
    });

    serverList = serverList?.map((serverVo) {
      if (id == (serverVo.id ?? 0)) {
        serverVo.isSelected = true;
      }
      return serverVo;
    }).toList();
    dummyServerList = serverList ?? [];
    notifyListeners();
    onTapConnect();
  }

  void onTapConnect() {
    ServerVO? serverVo;
    serverList?.forEach((server) {
      if (server.isSelected ?? false) {
        serverVo = server;
      }
    });

    openVpn?.connect(
      serverVo?.config ?? "",
      serverVo?.countryName ?? "",
      username: serverVo?.userName ?? "",
      password: serverVo?.password ?? "",
      bypassPackages: [],
      certIsRequired: false,
    );
  }

  void onTapDisconnect() async {
    VPNStage? stage = await openVpn?.stage();
    print("VPN Stage in onTapDisconnect method is $stage ...................");
    if(stage == VPNStage.connected) {
      openVpn?.disconnect();
    }
  }
}
