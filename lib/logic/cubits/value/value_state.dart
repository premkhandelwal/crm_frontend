part of 'value_cubit.dart';

sealed class ValueState extends Equatable {
  const ValueState();

  @override
  List<Object> get props => [];

  Bms? get  bms => null;
}

final class ValueInitial extends ValueState {}

final class SelectedBmsChangedState extends ValueState {
  final bool isAdded;
  @override
  final Bms bms;

  const SelectedBmsChangedState({
    required this.isAdded,
    required this.bms,
  });

  @override
  List<Object> get props => [isAdded, bms];
}

final class SelectedBmsSerialNoChangedState extends ValueState {
  final String serialNo;
  @override
  final Bms bms;

  const SelectedBmsSerialNoChangedState(
      {required this.serialNo, required this.bms});

  @override
  List<Object> get props => [serialNo, bms];
}

final class RemoveSerialNoState extends ValueState {
  @override
  final Bms bms;
  final String serialNo;
  const RemoveSerialNoState({required this.bms, required this.serialNo});
}
