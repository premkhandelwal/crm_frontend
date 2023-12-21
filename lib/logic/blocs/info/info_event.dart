part of 'info_bloc.dart';

@immutable
sealed class InfoEvent {}

class ComplaintSubmitButtonPressed extends InfoEvent {
  final Complaint complaintData;

  ComplaintSubmitButtonPressed({required this.complaintData});
}

class FetchComplaintsEvent extends InfoEvent {
  final String customerId;
  
  FetchComplaintsEvent({required this.customerId});
}

class FetchBatchForCustomerEvent extends InfoEvent {
  final String customerId;

  FetchBatchForCustomerEvent({required this.customerId});
}
