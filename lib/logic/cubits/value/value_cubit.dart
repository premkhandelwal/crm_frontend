import 'package:crm/models/bms_request.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'value_state.dart';

class ValueCubit extends Cubit<ValueState> {
  ValueCubit() : super(ValueInitial());

  void selectedBmsChanged(Bms bms, bool isAdded, int index) {
    emit(SelectedBmsChangedState(bms: bms, isAdded: isAdded, index: index));
  }

  void selectedBmsTextControllerChanged(Bms bms, bool isAdded, int index) {
    emit(SelectedBmsTextControllerChangedState(
        bms: bms, isAdded: isAdded, index: index));
  }
}
