import 'package:crm/models/bms_request.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bms_value_state.dart';

class BmsValueCubit extends Cubit<BmsValueState> {
  BmsValueCubit() : super(ValueInitial());

  void selectedBmsChanged(Bms bms, bool isAdded, int index) {
    emit(SelectedBmsChangedState(bms: bms, isAdded: isAdded, index: index));
  }

  void selectedBmsTextControllerChanged(Bms bms, bool isAdded, int index) {
    emit(SelectedBmsTextControllerChangedState(
        bms: bms, isAdded: isAdded, index: index));
  }
}
