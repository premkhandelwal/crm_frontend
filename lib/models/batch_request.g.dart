// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Batch _$BatchFromJson(Map<String, dynamic> json) => Batch(
      id: json['id'] as String? ?? "",
      batchName: json['batchName'] as String,
      bmsId: json['bmsId'] as String,
      harnessDetails: (json['harnessDetails'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      makeId: json['makeId'] as String,
      customerId: json['customerId'] as String,
    );

Map<String, dynamic> _$BatchToJson(Batch instance) => <String, dynamic>{
      'id': instance.id,
      'batchName': instance.batchName,
      'bmsId': instance.bmsId,
      'harnessDetails': instance.harnessDetails,
      'makeId': instance.makeId,
      'customerId': instance.customerId,
    };
