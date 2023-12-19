// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Batch _$BatchFromJson(Map<String, dynamic> json) => Batch(
      id: json['id'] as String? ?? "",
      bmsList: (json['bmsList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      batchName: json['batchName'] as String,
      customerId: json['customerId'] as String,
    );

Map<String, dynamic> _$BatchToJson(Batch instance) => <String, dynamic>{
      'id': instance.id,
      'bmsList': instance.bmsList,
      'batchName': instance.batchName,
      'customerId': instance.customerId,
    };
