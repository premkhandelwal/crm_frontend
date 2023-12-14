// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bms_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bms _$BmsFromJson(Map<String, dynamic> json) => Bms(
      id: json['id'] as String? ?? "",
      name: json['name'] as String,
      details: json['details'] as String,
    );

Map<String, dynamic> _$BmsToJson(Bms instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
    };
