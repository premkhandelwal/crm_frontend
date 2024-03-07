// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'batch_request.g.dart';

@JsonSerializable()
class Batch extends Equatable {
  final String id;
  final List<String> bmsSrNoList;
  final String batchName;
  final String customerId;
  final String vehicleManufacturerId;

  const Batch(
      {this.id = "",
      this.bmsSrNoList = const [],
      required this.batchName,
      required this.customerId,
      this.vehicleManufacturerId = ""});

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);

  Map<String, dynamic> toJson() => _$BatchToJson(this);

  @override
  String toString() {
    return batchName;
  }

  @override
  List<Object?> get props =>
      [id, batchName, customerId, bmsSrNoList, vehicleManufacturerId];

  Batch copyWith({
    String? id,
    List<String>? bmsSrNoList,
    String? batchName,
    String? customerId,
    String? vehicleManufacturerId,
  }) {
    return Batch(
        id: id ?? this.id,
        bmsSrNoList: bmsSrNoList ?? this.bmsSrNoList,
        batchName: batchName ?? this.batchName,
        customerId: customerId ?? this.customerId,
        vehicleManufacturerId:
            vehicleManufacturerId ?? this.vehicleManufacturerId);
  }
}
