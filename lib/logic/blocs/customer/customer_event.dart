part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}

final class AddCustomerEvent extends CustomerEvent {
  final Customer customerData;

  AddCustomerEvent({required this.customerData});
}

final class FetchCustomerEvent extends CustomerEvent {}

final class AddMakeEvent extends CustomerEvent {
  final Make makeData;

  AddMakeEvent({required this.makeData});
}

final class FetchMakeEvent extends CustomerEvent {}

final class AddHarnessEvent extends CustomerEvent {
  final Harness harnessData;

  AddHarnessEvent({required this.harnessData});
}

final class FetchHarnessEvent extends CustomerEvent {}

final class AddBmsEvent extends CustomerEvent {
  final Bms bmsData;

  AddBmsEvent({required this.bmsData});
}

final class FetchBmsEvent extends CustomerEvent {}

final class AddBatchEvent extends CustomerEvent {
  final Batch batchData;

  AddBatchEvent({required this.batchData});
}

final class FetchBatchEvent extends CustomerEvent {}


