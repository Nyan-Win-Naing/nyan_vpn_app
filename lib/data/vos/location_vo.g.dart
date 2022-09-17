// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationVO _$LocationVOFromJson(Map<String, dynamic> json) => LocationVO(
      country: json['country'] as String?,
      region: json['region'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$LocationVOToJson(LocationVO instance) =>
    <String, dynamic>{
      'country': instance.country,
      'region': instance.region,
      'timezone': instance.timezone,
    };
