part of 'complaint_bloc.dart';

@immutable
sealed class ComplaintState {}

final class ComplaintInitial extends ComplaintState {}

final class ComplaintSubmitState extends ComplaintState {
  final SubmissionStatus submissionStatus;

  ComplaintSubmitState({required this.submissionStatus});
}

final class ComplaintFetchState extends ComplaintState {
  final SubmissionStatus submissionStatus;
  final List<Complaint> complaintList;
  ComplaintFetchState(
      {required this.submissionStatus, this.complaintList = const []});
}
