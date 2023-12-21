// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bms_batch_request.g.dart';

@JsonSerializable()
class BatchBms extends Equatable{
  final String bmsId;
  final String? serialNo;
  const BatchBms({
    required this.bmsId,
    this.serialNo,
  });

   factory BatchBms.fromJson(Map<String, dynamic> json) => _$BatchBmsFromJson(json);

  Map<String, dynamic> toJson() => _$BatchBmsToJson(this);
  
  @override
  List<Object?> get props => [bmsId, serialNo];
  
}
