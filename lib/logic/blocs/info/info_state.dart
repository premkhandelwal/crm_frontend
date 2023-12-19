part of 'info_bloc.dart';

@immutable
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

final class FetchBatchForCustomerState extends InfoState {
  final SubmissionStatus submissionStatus;
  final List<Batch> batchList;

  FetchBatchForCustomerState(
      {required this.submissionStatus, this.batchList = const []});
}
