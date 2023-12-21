// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bms_request.g.dart';

@JsonSerializable()
class Bms extends Equatable {
  final String id;
  final String name;
  final String details;
  final List<String> harnessDetails;
  final String makeId;

  const Bms(
      {this.id = "",
      required this.name,
      required this.details,
      required this.harnessDetails,
      required this.makeId});

  factory Bms.fromJson(Map<String, dynamic> json) => _$BmsFromJson(json);

  Map<String, dynamic> toJson() => _$BmsToJson(this);

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [id, name, details, harnessDetails, makeId];

  Bms copyWith({
    String? id,
    String? name,
    String? details,
    List<String>? harnessDetails,
    String? makeId,
  }) {
    return Bms(
      id:id ?? this.id,
      name:name ?? this.name,
      details:details ?? this.details,
      harnessDetails: harnessDetails ?? this.harnessDetails,
      makeId:makeId ?? this.makeId,
    );
  }

  
}
