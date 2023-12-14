import 'package:json_annotation/json_annotation.dart';

part 'bms_request.g.dart';

@JsonSerializable()
class Bms {
  String id;
  final String name;
  final String details;

  Bms({this.id = "", required this.name, required this.details});

  factory Bms.fromJson(Map<String, dynamic> json) => _$BmsFromJson(json);

  Map<String, dynamic> toJson() => _$BmsToJson(this);

  @override
  String toString() {
    return name;
  }
}
