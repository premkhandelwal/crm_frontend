part of 'master_bloc.dart';

@immutable
sealed class MasterState {
  get submissionStatus => null;
}

final class MasterInitial extends MasterState {}

final class AddCustomerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final Customer? customer;

  AddCustomerState({required this.submissionStatus, this.customer});
}

final class EditCustomerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  EditCustomerState({required this.submissionStatus});
}

final class DeleteCustomerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final Customer? deletedCustomer;
  DeleteCustomerState({required this.submissionStatus, this.deletedCustomer});
}

final class FetchCustomerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Customer> customerList;

  FetchCustomerState(
      {required this.submissionStatus, this.customerList = const []});
}

final class AddMakeState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  AddMakeState({required this.submissionStatus});
}

final class EditMakeState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  EditMakeState({required this.submissionStatus});
}

final class DeleteMakeState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final Make? deletedMake;
  DeleteMakeState({required this.submissionStatus, this.deletedMake});
}

final class FetchMakeState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Make> makeList;

  FetchMakeState({required this.submissionStatus, this.makeList = const []});
}

final class AddHarnessState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  AddHarnessState({required this.submissionStatus});
}

final class EditHarnessState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  EditHarnessState({required this.submissionStatus});
}

final class DeleteHarnessState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final Harness? deletedHarness;
  DeleteHarnessState({required this.submissionStatus, this.deletedHarness});
}

final class FetchHarnessState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Harness> harnessList;

  FetchHarnessState(
      {required this.submissionStatus, this.harnessList = const []});
}

final class AddBmsState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  AddBmsState({required this.submissionStatus});
}

final class EditBmsState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  EditBmsState({required this.submissionStatus});
}

final class DeleteBmsState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final Bms? deletedBms;
  DeleteBmsState({required this.submissionStatus, this.deletedBms});
}

final class FetchBmsState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Bms> bmsList;

  FetchBmsState({required this.submissionStatus, this.bmsList = const []});
}

final class AddBatchState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final Batch? batch;
  AddBatchState({required this.submissionStatus, this.batch});
}

final class EditBatchState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  EditBatchState({required this.submissionStatus});
}

final class DeleteBatchState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final Batch? deletedBatch;

  DeleteBatchState({required this.submissionStatus, this.deletedBatch});
}

final class FetchBatchState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Batch> batchList;

  FetchBatchState({required this.submissionStatus, this.batchList = const []});
}

final class FetchBatchForVehicleManufacturerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Batch> batchList;
  final VehicleManufacturer? vehicleManufacturer;

  FetchBatchForVehicleManufacturerState(
      {required this.submissionStatus,
      this.vehicleManufacturer,
      this.batchList = const []});
}

final class FetchBatchForCustomerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final List<Batch> batchList;

  FetchBatchForCustomerState(
      {required this.submissionStatus, this.batchList = const []});
}

final class AddBmsSrNoInBatchState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  AddBmsSrNoInBatchState({required this.submissionStatus});
}

final class FetchAllVehicleManufacturerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final List<VehicleManufacturer> vehicleManufacturerList;

  FetchAllVehicleManufacturerState(
      {required this.submissionStatus,
      this.vehicleManufacturerList = const []});
}

final class FetchVehicleForCustomerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final List<VehicleManufacturer> vehicleManufacturerList;

  FetchVehicleForCustomerState(
      {required this.submissionStatus,
      this.vehicleManufacturerList = const []});
}

final class AddVehicleManufacturerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final VehicleManufacturer? vehicleManufacturer;
  AddVehicleManufacturerState({required this.submissionStatus, this.vehicleManufacturer});
}

final class EditVehicleManufacturerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;

  EditVehicleManufacturerState({required this.submissionStatus});
}

final class DeleteVehicleManufacturerState extends MasterState {
  @override
  final SubmissionStatus submissionStatus;
  final VehicleManufacturer? deletedVehicleManufacturer;

  DeleteVehicleManufacturerState(
      {required this.submissionStatus, this.deletedVehicleManufacturer});
}
