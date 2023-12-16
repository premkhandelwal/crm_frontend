import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harness_request.g.dart';

@JsonSerializable()
class Harness extends Equatable {
  String id;
  final String name;

  Harness({this.id = "", required this.name});

  factory Harness.fromJson(Map<String, dynamic> json) =>
      _$HarnessFromJson(json);

  Map<String, dynamic> toJson() => _$HarnessToJson(this);

  @override
  String toString() {
    return name;
  }
  
  @override
  List<Object?> get props => [id, name];
}
