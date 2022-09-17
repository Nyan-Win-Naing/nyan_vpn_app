// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'as_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AsVo _$AsVoFromJson(Map<String, dynamic> json) => AsVo(
      asn: json['asn'] as int?,
      name: json['name'] as String?,
      route: json['route'] as String?,
      domain: json['domain'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$AsVoToJson(AsVo instance) => <String, dynamic>{
      'asn': instance.asn,
      'name': instance.name,
      'route': instance.route,
      'domain': instance.domain,
      'type': instance.type,
    };
