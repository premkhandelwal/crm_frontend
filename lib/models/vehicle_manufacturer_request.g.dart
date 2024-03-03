// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_manufacturer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleManufacturer _$VehicleManufacturerFromJson(Map<String, dynamic> json) =>
    VehicleManufacturer(
      id: json['id'] as String? ?? "",
      name: json['name'] as String,
      customerId: json['customerId'] as String,
    );

Map<String, dynamic> _$VehicleManufacturerToJson(
        VehicleManufacturer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'customerId': instance.customerId,
    };
