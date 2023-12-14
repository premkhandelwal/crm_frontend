import 'package:json_annotation/json_annotation.dart';

part 'customer_request.g.dart';

@JsonSerializable()
class Customer {
  String id;
  final String name;

  Customer({this.id = "", required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  String toString() {
    return name;
  }
}
