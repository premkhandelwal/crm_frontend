part of 'customer_bloc.dart';

@immutable
sealed class CustomerState {
  get submissionStatus => null;
}

final class CustomerInitial extends CustomerState {}

final class AddCustomerState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  AddCustomerState({required this.submissionStatus});
}

final class EditCustomerState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  EditCustomerState({required this.submissionStatus});
}

final class DeleteCustomerState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final Customer? deletedCustomer;
  DeleteCustomerState(
      {required this.submissionStatus, this.deletedCustomer});
}

final class FetchCustomerState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Customer> customerList;

  FetchCustomerState(
      {required this.submissionStatus, this.customerList = const []});
}

final class AddMakeState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  AddMakeState({required this.submissionStatus});
}

final class EditMakeState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  EditMakeState({required this.submissionStatus});
}

final class DeleteMakeState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final Make? deletedMake;
  DeleteMakeState({required this.submissionStatus, this.deletedMake});
}

final class FetchMakeState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Make> makeList;

  FetchMakeState({required this.submissionStatus, this.makeList = const []});
}

final class AddHarnessState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  AddHarnessState({required this.submissionStatus});
}

final class EditHarnessState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  EditHarnessState({required this.submissionStatus});
}

final class DeleteHarnessState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final Harness? deletedHarness;
  DeleteHarnessState(
      {required this.submissionStatus, this.deletedHarness});
}

final class FetchHarnessState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Harness> harnessList;

  FetchHarnessState(
      {required this.submissionStatus, this.harnessList = const []});
}

final class AddBmsState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  AddBmsState({required this.submissionStatus});
}

final class EditBmsState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  EditBmsState({required this.submissionStatus});
}

final class DeleteBmsState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final Bms? deletedBms;
  DeleteBmsState({required this.submissionStatus, this.deletedBms});
}

final class FetchBmsState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Bms> bmsList;

  FetchBmsState({required this.submissionStatus, this.bmsList = const []});
}

final class AddBatchState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  AddBatchState({required this.submissionStatus});
}

final class EditBatchState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;

  EditBatchState({required this.submissionStatus});
}

final class DeleteBatchState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final Batch? deletedBatch;

  DeleteBatchState({required this.submissionStatus, this.deletedBatch});
}

final class FetchBatchState extends CustomerState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Batch> batchList;

  FetchBatchState({required this.submissionStatus, this.batchList = const []});
}
