// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_geo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGeoResponse _$GetGeoResponseFromJson(Map<String, dynamic> json) =>
    GetGeoResponse(
      ip: json['ip'] as String?,
      location: json['location'] == null
          ? null
          : LocationVO.fromJson(json['location'] as Map<String, dynamic>),
      as: json['as'] == null
          ? null
          : AsVo.fromJson(json['as'] as Map<String, dynamic>),
      isp: json['isp'] as String?,
    );

Map<String, dynamic> _$GetGeoResponseToJson(GetGeoResponse instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'location': instance.location,
      'as': instance.as,
      'isp': instance.isp,
    };
