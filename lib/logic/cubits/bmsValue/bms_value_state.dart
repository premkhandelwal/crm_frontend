part of 'bms_value_cubit.dart';

sealed class BmsValueState extends Equatable {
  const BmsValueState();

  @override
  List<Object> get props => [];

  Bms? get bms => null;
}

final class ValueInitial extends BmsValueState {}

final class SelectedBmsChangedState extends BmsValueState {
  final bool isAdded;
  @override
  final Bms bms;
  final int index;

  const SelectedBmsChangedState({
    required this.isAdded,
    required this.bms,
    required this.index,
  });

  @override
  List<Object> get props => [isAdded, bms];
}

final class SelectedBmsTextControllerChangedState extends BmsValueState {
  final bool isAdded;
  @override
  final Bms bms;
  final int index;
  final DateTime timestamp;

  const SelectedBmsTextControllerChangedState(this.timestamp, {
    required this.isAdded,
    required this.bms,
    required this.index,
  });

  @override
  List<Object> get props => [isAdded, bms, index, timestamp];
}
