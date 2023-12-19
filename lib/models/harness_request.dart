// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harness_request.g.dart';

@JsonSerializable()
class Harness extends Equatable {
  final String id;
  final String name;

  const Harness({this.id = "", required this.name});

  factory Harness.fromJson(Map<String, dynamic> json) =>
      _$HarnessFromJson(json);

  Map<String, dynamic> toJson() => _$HarnessToJson(this);

  @override
  String toString() {
    return name;
  }
  
  @override
  List<Object?> get props => [id, name];

  Harness copyWith({
    String? id,
    String? name,
  }) {
    return Harness(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
