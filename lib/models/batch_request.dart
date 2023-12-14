// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'batch_request.g.dart';

@JsonSerializable()
class Batch {
  String id;
  final String batchName;
  final String bmsId;
  final List<String> harnessDetails;
  final String makeId;
  final String customerId;


  Batch({
    this.id = "",
    required this.batchName,
    required this.bmsId,
    required this.harnessDetails,
    required this.makeId,
    required this.customerId,
  });

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);

  Map<String, dynamic> toJson() => _$BatchToJson(this);

  @override
  String toString() {
    return batchName;
  }
}
