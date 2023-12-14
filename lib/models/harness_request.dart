import 'package:json_annotation/json_annotation.dart';

part 'harness_request.g.dart';

@JsonSerializable()
class Harness {
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
}
