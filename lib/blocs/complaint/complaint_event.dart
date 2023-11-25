part of 'complaint_bloc.dart';

@immutable
sealed class ComplaintEvent {}

class ComplaintSubmitButtonPressed extends ComplaintEvent {
  final Complaint complaintData;

  ComplaintSubmitButtonPressed({required this.complaintData});
}

class FetchComplaintsEvent extends ComplaintEvent {}
