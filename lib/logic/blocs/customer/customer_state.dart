part of 'customer_bloc.dart';

@immutable
sealed class CustomerState {}

final class CustomerInitial extends CustomerState {}

final class AddCustomerState extends CustomerState {
  final SubmissionStatus submissionStatus;

  AddCustomerState({required this.submissionStatus});
}

final class FetchCustomerState extends CustomerState {
  final SubmissionStatus submissionStatus;
  final List<Customer> customerList;

  FetchCustomerState(
      {required this.submissionStatus, this.customerList = const []});
}

final class AddMakeState extends CustomerState {
  final SubmissionStatus submissionStatus;

  AddMakeState({required this.submissionStatus});
}

final class FetchMakeState extends CustomerState {
  final SubmissionStatus submissionStatus;
  final List<Make> makeList;

  FetchMakeState(
      {required this.submissionStatus, this.makeList = const []});
}
final class AddHarnessState extends CustomerState {
  final SubmissionStatus submissionStatus;

  AddHarnessState({required this.submissionStatus});
}

final class FetchHarnessState extends CustomerState {
  final SubmissionStatus submissionStatus;
  final List<Harness> harnessList;

  FetchHarnessState(
      {required this.submissionStatus, this.harnessList = const []});
}

final class AddBmsState extends CustomerState {
  final SubmissionStatus submissionStatus;

  AddBmsState({required this.submissionStatus});
}

final class FetchBmsState extends CustomerState {
  final SubmissionStatus submissionStatus;
  final List<Bms> bmsList;

  FetchBmsState(
      {required this.submissionStatus, this.bmsList = const []});
}

final class AddBatchState extends CustomerState {
  final SubmissionStatus submissionStatus;

  AddBatchState({required this.submissionStatus});
}

final class FetchBatchState extends CustomerState {
  final SubmissionStatus submissionStatus;
  final List<Batch> batchList;

  FetchBatchState(
      {required this.submissionStatus, this.batchList = const []});
}
