import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/foundation.dart';
import 'package:nyan_vpn_app/data/models/ip_model.dart';
import 'package:nyan_vpn_app/data/models/ip_model_impl.dart';
import 'package:nyan_vpn_app/utils/country_map.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class HomeBloc extends ChangeNotifier {

  /// States
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

  /// Models
  IpModel _model = IpModelImpl();


  HomeBloc() {
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
    if(stage == VPNStage.disconnected) {
      vpnStage = "disconnected";
      notifyListeners();
    } else if(stage == VPNStage.connected) {
      vpnStage = "connected";
      notifyListeners();
    } else {
      vpnStage == "connecting";
      notifyListeners();
    }
  }

  void onChangeDuration(VpnStatus? status) {
    if(status?.connectedOn == null) {
      duration = "00:00:00";
      notifyListeners();
    } else {
      duration = status?.duration;
      notifyListeners();
    }
  }

  void onChangeByteInByteOut(VpnStatus? status) {
    byteIn = double.parse((int.parse(status?.byteIn ?? "0") / 1024).toStringAsFixed(2));
    byteOut = double.parse((int.parse(status?.byteOut ?? "0") / 1024).toStringAsFixed(2));
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
}