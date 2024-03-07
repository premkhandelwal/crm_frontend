import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  ComplaintCubit() : super(ComplaintInitial());

  void selectedCustomerChanged(Customer customer) {
    emit(SelectedCustomerChangedState(
        customer: customer));
  }



  void selectedBatchChanged(Batch batch) {
    emit(SelectedBatchChangedState(batch: batch));
  }



  void selectedSerialNoChanged(String serialNo) {
    emit(SelectedSerialNoChangedState(serialNo: serialNo));
  }

  void backButtonPressed(int layerInd) {
    emit(BackButtonPressedState(layerInd: layerInd));
  }

  void showStatusDialog() {
    emit(StatusDialogDisplayState());
  }
}
