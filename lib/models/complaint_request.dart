// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'complaint_request.g.dart';

@JsonSerializable()
class Complaint extends Equatable {
  final String id;
  final String? customerId;
  final String? batchId;
  final String? bmsId;
  final String? makeId;
  final String? harnessId;
  final String? vehicleManufacturerId;
  final String? bmsSerialNo;
  final DateTime? returnDate;
  final String? complaint;
  final String? observation;
  final String? comment;
  final String? solution;
  final String? testingDoneBy;
  final String? status;

  const Complaint({
    this.id = "",
    this.customerId,
    this.batchId,
    this.bmsId,
    this.vehicleManufacturerId,
    this.makeId,
    this.harnessId,
    this.bmsSerialNo,
    this.returnDate,
    this.complaint,
    this.observation,
    this.comment,
    this.solution,
    this.testingDoneBy,
    this.status,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) =>
      _$ComplaintFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintToJson(this);

  @override
  List<Object?> get props => [customerId, batchId, bmsId, bmsSerialNo];

  Complaint copyWith(
      {String? id,
      String? customerId,
      String? batchId,
      String? bmsId,
      String? bmsSerialNo,
      DateTime? returnDate,
      String? complaint,
      String? observation,
      String? comment,
      String? solution,
      String? testingDoneBy,
      String? status}) {
    return Complaint(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      batchId: batchId ?? this.batchId,
      bmsId: bmsId ?? this.bmsId,
      bmsSerialNo: bmsSerialNo ?? this.bmsSerialNo,
      returnDate: returnDate ?? this.returnDate,
      complaint: complaint ?? this.complaint,
      observation: observation ?? this.observation,
      comment: comment ?? this.comment,
      solution: solution ?? this.solution,
      testingDoneBy: testingDoneBy ?? this.testingDoneBy,
      status: status ?? this.status,
    );
  }
}
