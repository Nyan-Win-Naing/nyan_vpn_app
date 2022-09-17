import 'package:json_annotation/json_annotation.dart';

part 'location_vo.g.dart';

@JsonSerializable()
class LocationVO {
  @JsonKey(name: "country")
  String? country;

  @JsonKey(name: "region")
  String? region;

  @JsonKey(name: "timezone")
  String? timezone;

  LocationVO({this.country, this.region, this.timezone});

  factory LocationVO.fromJson(Map<String, dynamic> json) =>
      _$LocationVOFromJson(json);

  Map<String, dynamic> toJson() => _$LocationVOToJson(this);
}