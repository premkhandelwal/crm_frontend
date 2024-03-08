part of 'info_bloc.dart';

sealed class InfoState {}

final class InfoInitial extends InfoState {}

final class ComplaintSubmitState extends InfoState {
  final SubmissionStatus submissionStatus;
  final Complaint? complaint;
  ComplaintSubmitState({required this.submissionStatus, this.complaint});
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


