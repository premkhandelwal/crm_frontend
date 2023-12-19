// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_request.g.dart';

@JsonSerializable()
class Customer extends Equatable {
  final String id;
  final String name;

  const Customer({this.id = "", required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  String toString() {
    return name;
  }
  
  @override
  List<Object?> get props => [id, name];

  Customer copyWith({
    String? id,
    String? name,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
