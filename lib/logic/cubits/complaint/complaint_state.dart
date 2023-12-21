part of 'complaint_cubit.dart';

sealed class ComplaintState extends Equatable {
  const ComplaintState();

  @override
  List<Object> get props => [];
}

final class ComplaintInitial extends ComplaintState {}

final class SelectedCustomerChangedState extends ComplaintState {
  final Customer customer;

  const SelectedCustomerChangedState({required this.customer});

  @override
  List<Object> get props => [customer];
}

final class SelectedBatchChangedState extends ComplaintState {
  final Batch batch;

  const SelectedBatchChangedState({required this.batch});
  @override
  List<Object> get props => [batch];
}

final class SelectedBmsChangedState extends ComplaintState {
  final Bms bms;
  final List<String> serialNoList;

  const SelectedBmsChangedState({required this.bms, required this.serialNoList});
  @override
  List<Object> get props => [bms,serialNoList];
}

final class SelectedSerialNoChangedState extends ComplaintState {
  final String serialNo;

  const SelectedSerialNoChangedState({required this.serialNo});
  @override
  List<Object> get props => [serialNo];
}
