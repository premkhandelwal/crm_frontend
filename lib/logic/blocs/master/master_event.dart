part of 'master_bloc.dart';

@immutable
sealed class MasterEvent {}

final class AddCustomerEvent extends MasterEvent {
  final Customer customerData;

  AddCustomerEvent({required this.customerData});
}

final class EditCustomerEvent extends MasterEvent {
  final Customer customerData;

  EditCustomerEvent({required this.customerData});
}

final class DeleteCustomerEvent extends MasterEvent {
  final Customer customerData;

  DeleteCustomerEvent({required this.customerData});
}

final class FetchCustomerEvent extends MasterEvent {}

final class AddMakeEvent extends MasterEvent {
  final Make makeData;

  AddMakeEvent({required this.makeData});
}

final class EditMakeEvent extends MasterEvent {
  final Make makeData;

  EditMakeEvent({required this.makeData});
}

final class DeleteMakeEvent extends MasterEvent {
  final Make makeData;

  DeleteMakeEvent({required this.makeData});
}

final class FetchMakeEvent extends MasterEvent {}

final class AddHarnessEvent extends MasterEvent {
  final Harness harnessData;

  AddHarnessEvent({required this.harnessData});
}

final class EditHarnessEvent extends MasterEvent {
  final Harness harnessData;

  EditHarnessEvent({required this.harnessData});
}

final class DeleteHarnessEvent extends MasterEvent {
  final Harness harnessData;

  DeleteHarnessEvent({required this.harnessData});
}

final class FetchHarnessEvent extends MasterEvent {}

final class AddBmsEvent extends MasterEvent {
  final Bms bmsData;

  AddBmsEvent({required this.bmsData});
}

final class EditBmsEvent extends MasterEvent {
  final Bms bmsData;

  EditBmsEvent({required this.bmsData});
}

final class DeleteBmsEvent extends MasterEvent {
  final Bms bmsData;

  DeleteBmsEvent({required this.bmsData});
}

final class FetchBmsEvent extends MasterEvent {}

final class AddBatchEvent extends MasterEvent {
  final Batch batchData;

  AddBatchEvent({required this.batchData});
}

final class EditBatchEvent extends MasterEvent {
  final Batch batchData;

  EditBatchEvent({required this.batchData});
}

final class DeleteBatchEvent extends MasterEvent {
  final Batch batchData;

  DeleteBatchEvent({required this.batchData});
}

final class FetchBatchEvent extends MasterEvent {}

class FetchBatchForVehicleManufacturerEvent extends MasterEvent {
  final VehicleManufacturer vehicleManufacturerId;

  FetchBatchForVehicleManufacturerEvent({required this.vehicleManufacturerId});
}

class FetchBatchForCustomerEvent extends MasterEvent {
  final String customerId;

  FetchBatchForCustomerEvent({required this.customerId});
}

class AddBmsSrNoInBatchEvent extends MasterEvent {
  final Batch batch;

  AddBmsSrNoInBatchEvent({required this.batch});
}

class FetchAllVehicleManufacturerEvent extends MasterEvent {}

class FetchVehicleForCustomerEvent extends MasterEvent {
  final String customerId;

  FetchVehicleForCustomerEvent({required this.customerId});
}


final class AddVehicleManufacturerEvent extends MasterEvent {
  final VehicleManufacturer vehicleManufacturerData;

  AddVehicleManufacturerEvent({required this.vehicleManufacturerData});
}

final class EditVehicleManufacturerEvent extends MasterEvent {
  final VehicleManufacturer vehicleManufacturerData;

  EditVehicleManufacturerEvent({required this.vehicleManufacturerData});
}

final class DeleteVehicleManufacturerEvent extends MasterEvent {
  final VehicleManufacturer vehicleManufacturerData;

  DeleteVehicleManufacturerEvent({required this.vehicleManufacturerData});
}
