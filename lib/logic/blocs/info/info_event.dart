part of 'info_bloc.dart';


sealed class InfoEvent {}

class ComplaintSubmitButtonPressed extends InfoEvent {
  final Complaint complaintData;

  ComplaintSubmitButtonPressed({required this.complaintData});
}

class FetchComplaintsEvent extends InfoEvent {
  final String customerId;

  FetchComplaintsEvent({required this.customerId});
}

class UpdateComplaintStatusEvent extends InfoEvent {
  final Map<String, String?> complaint;

  UpdateComplaintStatusEvent({required this.complaint});
}




class FetchVehicleForCustomerEvent extends InfoEvent {
  final String customerId;

  FetchVehicleForCustomerEvent({required this.customerId});
}

