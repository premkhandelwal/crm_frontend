part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}

final class AddCustomerEvent extends CustomerEvent {
  final Customer customerData;

  AddCustomerEvent({required this.customerData});
}

final class EditCustomerEvent extends CustomerEvent {
  final Customer customerData;

  EditCustomerEvent({required this.customerData});
}

final class DeleteCustomerEvent extends CustomerEvent {
  final Customer customerData;

  DeleteCustomerEvent({required this.customerData});
}

final class FetchCustomerEvent extends CustomerEvent {}

final class AddMakeEvent extends CustomerEvent {
  final Make makeData;

  AddMakeEvent({required this.makeData});
}

final class EditMakeEvent extends CustomerEvent {
  final Make makeData;

  EditMakeEvent({required this.makeData});
}

final class DeleteMakeEvent extends CustomerEvent {
  final Make makeData;

  DeleteMakeEvent({required this.makeData});
}

final class FetchMakeEvent extends CustomerEvent {}

final class AddHarnessEvent extends CustomerEvent {
  final Harness harnessData;

  AddHarnessEvent({required this.harnessData});
}

final class EditHarnessEvent extends CustomerEvent {
  final Harness harnessData;

  EditHarnessEvent({required this.harnessData});
}

final class DeleteHarnessEvent extends CustomerEvent {
  final Harness harnessData;

  DeleteHarnessEvent({required this.harnessData});
}

final class FetchHarnessEvent extends CustomerEvent {}

final class AddBmsEvent extends CustomerEvent {
  final Bms bmsData;

  AddBmsEvent({required this.bmsData});
}

final class EditBmsEvent extends CustomerEvent {
  final Bms bmsData;

  EditBmsEvent({required this.bmsData});
}

final class DeleteBmsEvent extends CustomerEvent {
  final Bms bmsData;

  DeleteBmsEvent({required this.bmsData});
}

final class FetchBmsEvent extends CustomerEvent {}

final class AddBatchEvent extends CustomerEvent {
  final Batch batchData;

  AddBatchEvent({required this.batchData});
}

final class EditBatchEvent extends CustomerEvent {
  final Batch batchData;

  EditBatchEvent({required this.batchData});
}

final class DeleteBatchEvent extends CustomerEvent {
  final Batch batchData;

  DeleteBatchEvent({required this.batchData});
}

final class FetchBatchEvent extends CustomerEvent {}
