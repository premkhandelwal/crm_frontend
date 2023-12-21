// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'batch_request.g.dart';

@JsonSerializable()
class Batch extends Equatable {
  final String id;
  final Map<String, List<String>> bmsList;
  final String batchName;
  final String customerId;

  const Batch({
    this.id = "",
    this.bmsList = const {},
    required this.batchName,
    required this.customerId,
  });

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);

  Map<String, dynamic> toJson() => _$BatchToJson(this);

  @override
  String toString() {
    return batchName;
  }

  @override
  List<Object?> get props => [id, batchName, customerId, bmsList];

  Batch copyWith({
    String? id,
    String? batchName,
    String? customerId,
  }) {
    return Batch(
      id: id ?? this.id,
      batchName: batchName ?? this.batchName,
      customerId: customerId ?? this.customerId,
    );
  }
}
