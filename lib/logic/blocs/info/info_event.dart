part of 'info_bloc.dart';

sealed class InfoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ComplaintSubmitButtonPressed extends InfoEvent {
  final Complaint complaintData;

  ComplaintSubmitButtonPressed({required this.complaintData});
}

class FetchAllComplaintsEvent extends InfoEvent {
  FetchAllComplaintsEvent();
}

class UpdateComplaintStatusEvent extends InfoEvent {
  final Map<String, String?> complaint;

  UpdateComplaintStatusEvent({required this.complaint});
}



class ExportToExcelEvent extends InfoEvent {
  final List<Complaint> complaintList;
  final List<Customer> customerList;
  final List<VehicleManufacturer> vehicleManufacturerList;
  final List<Batch> batchList;
  final List<Bms> bmsList;
  final List<Make> makeList;
  final List<Harness> harnessList;

  ExportToExcelEvent(
      {required this.complaintList,
      required this.customerList,
      required this.vehicleManufacturerList,
      required this.batchList,
      required this.bmsList,
      required this.makeList,
      required this.harnessList});

  @override
  // TODO: implement props
  List<Object?> get props => [DateTime.now()];
}
