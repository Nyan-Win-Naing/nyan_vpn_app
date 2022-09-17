import 'package:nyan_vpn_app/network/responses/get_geo_response.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class IpModel extends Model {
  Future<GetGeoResponse> getGeo(String ipAddress);
}