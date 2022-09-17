import 'package:json_annotation/json_annotation.dart';
import 'package:nyan_vpn_app/data/vos/as_vo.dart';
import 'package:nyan_vpn_app/data/vos/location_vo.dart';

part 'get_geo_response.g.dart';

@JsonSerializable()
class GetGeoResponse  {
  @JsonKey(name: "ip")
  String? ip;

  @JsonKey(name: "location")
  LocationVO? location;

  @JsonKey(name: "as")
  AsVo? as;

  @JsonKey(name: "isp")
  String? isp;


  GetGeoResponse({this.ip, this.location, this.as, this.isp});

  factory GetGeoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetGeoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetGeoResponseToJson(this);
}