import 'package:json_annotation/json_annotation.dart';

part 'make_request.g.dart';

@JsonSerializable()
class Make {
  String id;
  final String name;

  Make({this.id = "", required this.name});

  factory Make.fromJson(Map<String, dynamic> json) => _$MakeFromJson(json);

  Map<String, dynamic> toJson() => _$MakeToJson(this);
  @override
  String toString() {
    return name;
  }
}
