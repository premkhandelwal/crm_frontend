// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_manufacturer_request.g.dart';

@JsonSerializable()
class VehicleManufacturer extends Equatable {
  final String id;
  final String name;
  final String customerId;
  const VehicleManufacturer({
    this.id = "",
    required this.name,
    required this.customerId,
  });

  factory VehicleManufacturer.fromJson(Map<String, dynamic> json) => _$VehicleManufacturerFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleManufacturerToJson(this);

  @override
  List<Object?> get props => [id, name, customerId];
}
