import 'package:dio/dio.dart';
import 'package:nyan_vpn_app/data/models/ip_model.dart';
import 'package:nyan_vpn_app/network/api_constant.dart';
import 'package:nyan_vpn_app/network/ip_address_api.dart';
import 'package:nyan_vpn_app/network/responses/get_geo_response.dart';

class IpModelImpl extends IpModel {
  late IpAddressApi mApi;

  static final IpModelImpl _singleton = IpModelImpl._internal();

  factory IpModelImpl() {
    return _singleton;
  }

  IpModelImpl._internal() {
    final dio = Dio();
    mApi = IpAddressApi(dio);
  }

  @override
  Future<GetGeoResponse> getGeo(String ipAddress) {
    return mApi.getGeo(
      API_KEY,
      ipAddress,
    ).then((response) {
      return Future.value(response);
    });
  }
}