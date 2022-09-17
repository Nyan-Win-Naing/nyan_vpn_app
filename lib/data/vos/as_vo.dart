import 'package:json_annotation/json_annotation.dart';

part 'as_vo.g.dart';

@JsonSerializable()
class AsVo {
  @JsonKey(name: "asn")
  int? asn;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "route")
  String? route;

  @JsonKey(name: "domain")
  String? domain;

  @JsonKey(name: "type")
  String? type;

  AsVo({this.asn, this.name, this.route, this.domain, this.type});

  factory AsVo.fromJson(Map<String, dynamic> json) =>
      _$AsVoFromJson(json);

  Map<String, dynamic> toJson() => _$AsVoToJson(this);
}