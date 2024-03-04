part of 'info_bloc.dart';

sealed class InfoState {}

final class InfoInitial extends InfoState {}

final class ComplaintSubmitState extends InfoState {
  final SubmissionStatus submissionStatus;

  ComplaintSubmitState({required this.submissionStatus});
}

final class ComplaintFetchState extends InfoState {
  final SubmissionStatus submissionStatus;
  final List<Complaint> complaintList;
  ComplaintFetchState(
      {required this.submissionStatus, this.complaintList = const []});
}

final class UpdateComplaintStatusState extends InfoState {
  final SubmissionStatus status;
  final Complaint? complaint;

  UpdateComplaintStatusState({required this.status, this.complaint});
}





final class FetchVehicleForCustomerState extends InfoState {
  final SubmissionStatus submissionStatus;
  final List<VehicleManufacturer> vehicleManufacturerList;

  FetchVehicleForCustomerState(
      {required this.submissionStatus, this.vehicleManufacturerList = const []});
}
