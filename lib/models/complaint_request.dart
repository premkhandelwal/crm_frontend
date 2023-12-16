import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'complaint_request.g.dart';

@JsonSerializable()
class Complaint extends Equatable {
  String bmsClientName;
  String bmsName;
  DateTime returnDate;
  String complaint;
  String batchNo;
  List<String> harnessDetails; // Assuming details are key-value pairs
  String make;
  String customerId;

  Complaint({
    required this.bmsClientName,
    required this.bmsName,
    required this.returnDate,
    required this.complaint,
    required this.batchNo,
    required this.harnessDetails,
    required this.make,
    required this.customerId,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) =>
      _$ComplaintFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintToJson(this);

  @override
  List<Object?> get props => [
        bmsClientName,
        bmsName,
        returnDate,
        complaint,
        batchNo,
        harnessDetails,
        make,
        customerId
      ];
}
