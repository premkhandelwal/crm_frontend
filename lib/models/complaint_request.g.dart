// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Complaint _$ComplaintFromJson(Map<String, dynamic> json) => Complaint(
      customerId: json['customerId'] as String,
      batchId: json['batchId'] as String,
      bmsId: json['bmsId'] as String,
      returnDate: DateTime.parse(json['returnDate'] as String),
      complaint: json['complaint'] as String,
      observation: json['observation'] as String,
      comment: json['comment'] as String,
      solution: json['solution'] as String,
      testingDoneBy: json['testingDoneBy'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$ComplaintToJson(Complaint instance) => <String, dynamic>{
      'customerId': instance.customerId,
      'batchId': instance.batchId,
      'bmsId': instance.bmsId,
      'returnDate': instance.returnDate.toIso8601String(),
      'complaint': instance.complaint,
      'observation': instance.observation,
      'comment': instance.comment,
      'solution': instance.solution,
      'testingDoneBy': instance.testingDoneBy,
      'status': instance.status,
    };
