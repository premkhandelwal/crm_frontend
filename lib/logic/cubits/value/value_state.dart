part of 'value_cubit.dart';

sealed class ValueState extends Equatable {
  const ValueState();

  @override
  List<Object> get props => [];

  Bms? get bms => null;
}

final class ValueInitial extends ValueState {}

final class SelectedBmsChangedState extends ValueState {
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

final class SelectedBmsTextControllerChangedState extends ValueState {
  final bool isAdded;
  @override
  final Bms bms;
  final int index;

  const SelectedBmsTextControllerChangedState({
    required this.isAdded,
    required this.bms,
    required this.index,
  });

  @override
  List<Object> get props => [isAdded, bms];
}
