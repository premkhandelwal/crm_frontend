// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:crm/enums.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/providers/api_provider.dart';
import 'package:meta/meta.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final ApiProvider apiProvider;
  CustomerBloc(
    this.apiProvider,
  ) : super(CustomerInitial()) {
    on<CustomerEvent>((event, emit) {
      void addCustomer(Customer customerData) async {
        emit(AddCustomerState(submissionStatus: SubmissionStatus.inProgress));
        await apiProvider.addCustomer(customerData);
        emit(AddCustomerState(submissionStatus: SubmissionStatus.success));
      }

      void fetchAllCustomers() async {
        emit(FetchCustomerState(submissionStatus: SubmissionStatus.inProgress));
        List<Customer> customerList = await apiProvider.fetchCustomers();
        emit(FetchCustomerState(
            submissionStatus: SubmissionStatus.success,
            customerList: customerList));
      }

      void addMake(Make makeData) async {
        emit(AddMakeState(submissionStatus: SubmissionStatus.inProgress));
        await apiProvider.addMake(makeData);
        emit(AddMakeState(submissionStatus: SubmissionStatus.success));
      }

      void fetchAllMakes() async {
        emit(FetchMakeState(submissionStatus: SubmissionStatus.inProgress));
        List<Make> makeList = await apiProvider.fetchMake();
        emit(FetchMakeState(
            submissionStatus: SubmissionStatus.success, makeList: makeList));
      }

      void addHarness(Harness harnessData) async {
        emit(AddHarnessState(submissionStatus: SubmissionStatus.inProgress));
        await apiProvider.addHarness(harnessData);
        emit(AddHarnessState(submissionStatus: SubmissionStatus.success));
      }

      void fetchAllHarness() async {
        emit(FetchHarnessState(submissionStatus: SubmissionStatus.inProgress));
        List<Harness> harnessList = await apiProvider.fetchHarness();
        emit(FetchHarnessState(
            submissionStatus: SubmissionStatus.success,
            harnessList: harnessList));
      }

      void addBms(Bms bmsData) async {
        emit(AddBmsState(submissionStatus: SubmissionStatus.inProgress));
        await apiProvider.addBms(bmsData);
        emit(AddBmsState(submissionStatus: SubmissionStatus.success));
      }

      void fetchAllBms() async {
        emit(FetchBmsState(submissionStatus: SubmissionStatus.inProgress));
        List<Bms> bmsList = await apiProvider.fetchBms();
        emit(FetchBmsState(
            submissionStatus: SubmissionStatus.success, bmsList: bmsList));
      }

      void addBatch(Batch batchData) async {
        emit(AddBatchState(submissionStatus: SubmissionStatus.inProgress));
        await apiProvider.addBatch(batchData);
        emit(AddBatchState(submissionStatus: SubmissionStatus.success));
      }

      void fetchAllBatch() async {
        emit(FetchBatchState(submissionStatus: SubmissionStatus.inProgress));
        List<Batch> batchList = await apiProvider.fetchBatch();
        emit(FetchBatchState(
            submissionStatus: SubmissionStatus.success, batchList: batchList));
      }

      switch (event.runtimeType) {
        case AddCustomerEvent:
          event as AddCustomerEvent;
          return addCustomer(event.customerData);
        case FetchCustomerEvent:
          return fetchAllCustomers();
        case AddMakeEvent:
          event as AddMakeEvent;
          return addMake(event.makeData);
        case FetchMakeEvent:
          return fetchAllMakes();
        case AddHarnessEvent:
          event as AddHarnessEvent;
          return addHarness(event.harnessData);
        case FetchHarnessEvent:
          return fetchAllHarness();
        case AddBmsEvent:
          event as AddBmsEvent;
          return addBms(event.bmsData);
        case FetchBmsEvent:
          return fetchAllBms();
        case AddBatchEvent:
          event as AddBatchEvent;
          return addBatch(event.batchData);
        case FetchBatchEvent:
          return fetchAllBatch();
        default:
      }
    });
  }
}
