import 'package:bloc/bloc.dart';
import 'package:crm/models/bms_request.dart';
import 'package:equatable/equatable.dart';

part 'value_state.dart';

class ValueCubit extends Cubit<ValueState> {
  ValueCubit() : super(ValueInitial());

  void selectedBmsChanged(Bms bms, bool isAdded) {
    emit(SelectedBmsChangedState(bms: bms, isAdded: isAdded));
  }

  void selectedBmsSerialNoChanged(Bms bms, String serialNo) {
    emit(SelectedBmsSerialNoChangedState(bms: bms, serialNo: serialNo));
  }

  void removeSerialNo(Bms bms, String serialNo) {
    emit(RemoveSerialNoState(bms: bms, serialNo: serialNo));
  }

}
