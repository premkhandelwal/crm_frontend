// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Complaint _$ComplaintFromJson(Map<String, dynamic> json) => Complaint(
      bmsClientName: json['bmsClientName'] as String,
      bmsName: json['bmsName'] as String,
      returnDate: DateTime.parse(json['returnDate'] as String),
      complaint: json['complaint'] as String,
      batchNo: json['batchNo'] as String,
      harnessDetails: (json['harnessDetails'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      make: json['make'] as String,
      customerId: json['customerId'] as String,
    );

Map<String, dynamic> _$ComplaintToJson(Complaint instance) => <String, dynamic>{
      'bmsClientName': instance.bmsClientName,
      'bmsName': instance.bmsName,
      'returnDate': instance.returnDate.toIso8601String(),
      'complaint': instance.complaint,
      'batchNo': instance.batchNo,
      'harnessDetails': instance.harnessDetails,
      'make': instance.make,
      'customerId': instance.customerId,
    };
