// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'make_request.g.dart';

@JsonSerializable()
class Make extends Equatable {
  final String id;
  final String name;

  const Make({this.id = "", required this.name});

  factory Make.fromJson(Map<String, dynamic> json) => _$MakeFromJson(json);

  Map<String, dynamic> toJson() => _$MakeToJson(this);
  @override
  String toString() {
    return name;
  }
  @override
  List<Object?> get props => [id, name];

  Make copyWith({
    String? id,
    String? name,
  }) {
    return Make(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
