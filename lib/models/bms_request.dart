// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bms_request.g.dart';

@JsonSerializable()
class Bms extends Equatable {
  final String id;
  final String name;
  final String details;

  const Bms({
    this.id = "",
    required this.name,
    required this.details,
  });

  factory Bms.fromJson(Map<String, dynamic> json) => _$BmsFromJson(json);

  Map<String, dynamic> toJson() => _$BmsToJson(this);

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [id, name, details];

  Bms copyWith({
    String? id,
    String? name,
    String? details,
  }) {
    return Bms(
      id: id ?? this.id,
      name: name ?? this.name,
      details: details ?? this.details,
    );
  }
}
