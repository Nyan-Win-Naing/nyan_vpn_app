import 'package:dio/dio.dart';
import 'package:nyan_vpn_app/network/api_constant.dart';
import 'package:nyan_vpn_app/network/responses/get_geo_response.dart';
import 'package:retrofit/retrofit.dart';

part 'ip_address_api.g.dart';

@RestApi(baseUrl: BASE_URL_DIO)
abstract class IpAddressApi {
  factory IpAddressApi(Dio dio) = _IpAddressApi;

  @GET(ENDPOINT_GET_COUNTRY)
  Future<GetGeoResponse> getGeo(
    @Query(PARAM_API_KEY) String apiKey,
    @Query(PARAM_IP_ADDRESS) String ipAddress,
  );
}
