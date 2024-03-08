// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/models/vehicle_manufacturer_request.dart';
import 'package:crm/providers/api_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'master_event.dart';
part 'master_state.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  final ApiProvider apiProvider;
  MasterBloc(
    this.apiProvider,
  ) : super(MasterInitial()) {
    on<MasterEvent>((event, emit) {
      void addCustomer(Customer customerData) async {
        try {
          emit(AddCustomerState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.addCustomer(customerData);
          emit(AddCustomerState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(AddCustomerState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void editCustomer(Customer customerData) async {
        try {
          emit(
              EditCustomerState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.editCustomer(customerData);
          emit(EditCustomerState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(EditCustomerState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void deleteCustomer(Customer customerData) async {
        try {
          emit(DeleteCustomerState(
              submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.deleteCustomer(customerData);
          emit(DeleteCustomerState(
              submissionStatus: SubmissionStatus.success,
              deletedCustomer: customerData));
        } catch (e) {
          emit(DeleteCustomerState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void fetchAllCustomers() async {
        try {
          emit(FetchCustomerState(
              submissionStatus: SubmissionStatus.inProgress));
          List<Customer> customerList = await apiProvider.fetchCustomers();
          emit(FetchCustomerState(
              submissionStatus: SubmissionStatus.success,
              customerList: customerList));
        } catch (e) {
          emit(FetchCustomerState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void addMake(Make makeData) async {
        try {
          emit(AddMakeState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.addMake(makeData);
          emit(AddMakeState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(AddMakeState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void editMake(Make makeData) async {
        try {
          emit(EditMakeState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.editMake(makeData);
          emit(EditMakeState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(EditMakeState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void deleteMake(Make makeData) async {
        try {
          emit(DeleteMakeState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.deleteMake(makeData);
          emit(DeleteMakeState(
              submissionStatus: SubmissionStatus.success,
              deletedMake: makeData));
        } catch (e) {
          emit(DeleteMakeState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void fetchAllMakes() async {
        try {
          emit(FetchMakeState(submissionStatus: SubmissionStatus.inProgress));
          List<Make> makeList = await apiProvider.fetchMake();
          emit(FetchMakeState(
              submissionStatus: SubmissionStatus.success, makeList: makeList));
        } catch (e) {
          emit(FetchMakeState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void addHarness(Harness harnessData) async {
        try {
          emit(AddHarnessState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.addHarness(harnessData);
          emit(AddHarnessState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(AddHarnessState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void editHarness(Harness harnessData) async {
        try {
          emit(EditHarnessState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.editHarness(harnessData);
          emit(EditHarnessState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(EditHarnessState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void deleteHarness(Harness harnessData) async {
        try {
          emit(DeleteHarnessState(
              submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.deleteHarness(harnessData);
          emit(DeleteHarnessState(
              submissionStatus: SubmissionStatus.success,
              deletedHarness: harnessData));
        } catch (e) {
          emit(DeleteHarnessState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void fetchAllHarness() async {
        try {
          emit(
              FetchHarnessState(submissionStatus: SubmissionStatus.inProgress));
          List<Harness> harnessList = await apiProvider.fetchHarness();
          emit(FetchHarnessState(
              submissionStatus: SubmissionStatus.success,
              harnessList: harnessList));
        } catch (e) {
          emit(FetchHarnessState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void addBms(Bms bmsData) async {
        try {
          emit(AddBmsState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.addBms(bmsData);
          emit(AddBmsState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(AddBmsState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void editBms(Bms bmsData) async {
        try {
          emit(EditBmsState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.editBms(bmsData);
          emit(EditBmsState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(EditBmsState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void deleteBms(Bms bmsData) async {
        try {
          emit(DeleteBmsState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.deleteBms(bmsData);
          emit(DeleteBmsState(
              submissionStatus: SubmissionStatus.success, deletedBms: bmsData));
        } catch (e) {
          emit(DeleteBmsState(submissionStatus: SubmissionStatus.inProgress));
        }
      }

      void fetchAllBms() async {
        try {
          emit(FetchBmsState(submissionStatus: SubmissionStatus.inProgress));
          List<Bms> bmsList = await apiProvider.fetchBms();
          emit(FetchBmsState(
              submissionStatus: SubmissionStatus.success, bmsList: bmsList));
        } catch (e) {
          emit(FetchBmsState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void addBatch(Batch batchData) async {
        try {
          emit(AddBatchState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.addBatch(batchData);
          emit(AddBatchState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(AddBatchState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void editBatch(Batch batchData) async {
        try {
          emit(EditBatchState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.editBatch(batchData);
          emit(EditBatchState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(EditBatchState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void deleteBatch(Batch batchData) async {
        try {
          emit(DeleteBatchState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.deleteBatch(batchData);
          emit(DeleteBatchState(
              submissionStatus: SubmissionStatus.success,
              deletedBatch: batchData));
        } catch (e) {
          emit(DeleteBatchState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void fetchAllBatch() async {
        try {
          emit(FetchBatchState(submissionStatus: SubmissionStatus.inProgress));
          List<Batch> batchList = await apiProvider.fetchBatch();
          emit(FetchBatchState(
              submissionStatus: SubmissionStatus.success,
              batchList: batchList));
        } catch (e) {
          emit(FetchBatchState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void fetchBatchForVehicleManufacturer(
          VehicleManufacturer vehicleManufacturer) async {
        try {
          emit(FetchBatchForVehicleManufacturerState(
              submissionStatus: SubmissionStatus.inProgress));
          List<Batch> batchList = await apiProvider
              .fetchBatchforVehicleManufacturer(vehicleManufacturer.id);
          emit(FetchBatchForVehicleManufacturerState(
              submissionStatus: SubmissionStatus.success,
              vehicleManufacturer: vehicleManufacturer,
              batchList: batchList));
        } catch (e) {
          emit(FetchBatchForVehicleManufacturerState(
              submissionStatus: SubmissionStatus.failure));
        }
      }

      void fetchBatchForCustomer(String customerId) async {
        try {
          emit(FetchBatchForCustomerState(
              submissionStatus: SubmissionStatus.inProgress));
          List<Batch> batchList =
              await apiProvider.fetchBatchforCustomer(customerId);
          emit(FetchBatchForCustomerState(
              submissionStatus: SubmissionStatus.success,
              batchList: batchList));
        } catch (e) {
          emit(FetchBatchForCustomerState(
              submissionStatus: SubmissionStatus.failure));
        }
      }

      void addBmsSrNoInBatch(Batch batch) async {
        try {
          emit(AddBmsSrNoInBatchState(
              submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.addBmsSrNoInBatch(batch);
          emit(AddBmsSrNoInBatchState(
              submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(AddBmsSrNoInBatchState(
              submissionStatus: SubmissionStatus.failure));
        }
      }

      void fetchAllVehicleManufacturer() async {
        try {
          emit(FetchAllVehicleManufacturerState(
              submissionStatus: SubmissionStatus.inProgress));
          List<VehicleManufacturer> vehicleManufacturerList =
              await apiProvider.fetchAllVehicleManufacturer();
          emit(FetchAllVehicleManufacturerState(
              submissionStatus: SubmissionStatus.success,
              vehicleManufacturerList: vehicleManufacturerList));
        } catch (e) {
          emit(FetchAllVehicleManufacturerState(
              submissionStatus: SubmissionStatus.failure));
        }
      }

      void fetchVehicleForCustomer(String customerId) async {
        try {
          emit(FetchVehicleForCustomerState(
              submissionStatus: SubmissionStatus.inProgress));
          List<VehicleManufacturer> vehicleManufacturerList =
              await apiProvider.fetchVehicleManufacturerforCustomer(customerId);
          emit(FetchVehicleForCustomerState(
              submissionStatus: SubmissionStatus.success,
              vehicleManufacturerList: vehicleManufacturerList));
        } catch (e) {
          emit(FetchVehicleForCustomerState(
              submissionStatus: SubmissionStatus.failure));
        }
      }

      void addVehicleManufacturer(VehicleManufacturer vehicleManufacturerData) async {
        try {
          emit(AddVehicleManufacturerState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.addVehicleManufacturer(vehicleManufacturerData);
          emit(AddVehicleManufacturerState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(AddVehicleManufacturerState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void editVehicleManufacturer(VehicleManufacturer vehicleManufacturerData) async {
        try {
          emit(EditVehicleManufacturerState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.editVehicleManufacturer(vehicleManufacturerData);
          emit(EditVehicleManufacturerState(submissionStatus: SubmissionStatus.success));
        } catch (e) {
          emit(EditVehicleManufacturerState(submissionStatus: SubmissionStatus.failure));
        }
      }

      void deleteVehicleManufacturer(VehicleManufacturer vehicleManufacturerData) async {
        try {
          emit(DeleteVehicleManufacturerState(submissionStatus: SubmissionStatus.inProgress));
          await apiProvider.deleteVehicleManufacturer(vehicleManufacturerData);
          emit(DeleteVehicleManufacturerState(
              submissionStatus: SubmissionStatus.success,
              deletedVehicleManufacturer: vehicleManufacturerData));
        } catch (e) {
          emit(DeleteVehicleManufacturerState(submissionStatus: SubmissionStatus.failure));
        }
      }



      switch (event.runtimeType) {
        case AddCustomerEvent:
          event as AddCustomerEvent;
          return addCustomer(event.customerData);
        case EditCustomerEvent:
          event as EditCustomerEvent;
          return editCustomer(event.customerData);
        case DeleteCustomerEvent:
          event as DeleteCustomerEvent;
          return deleteCustomer(event.customerData);
        case FetchCustomerEvent:
          return fetchAllCustomers();
        case AddMakeEvent:
          event as AddMakeEvent;
          return addMake(event.makeData);
        case EditMakeEvent:
          event as EditMakeEvent;
          return editMake(event.makeData);
        case DeleteMakeEvent:
          event as DeleteMakeEvent;
          return deleteMake(event.makeData);
        case FetchMakeEvent:
          return fetchAllMakes();
        case AddHarnessEvent:
          event as AddHarnessEvent;
          return addHarness(event.harnessData);
        case EditHarnessEvent:
          event as EditHarnessEvent;
          return editHarness(event.harnessData);
        case DeleteHarnessEvent:
          event as DeleteHarnessEvent;
          return deleteHarness(event.harnessData);
        case FetchHarnessEvent:
          return fetchAllHarness();
        case AddBmsEvent:
          event as AddBmsEvent;
          return addBms(event.bmsData);
        case EditBmsEvent:
          event as EditBmsEvent;
          return editBms(event.bmsData);
        case DeleteBmsEvent:
          event as DeleteBmsEvent;
          return deleteBms(event.bmsData);
        case FetchBmsEvent:
          return fetchAllBms();
        case AddBatchEvent:
          event as AddBatchEvent;
          return addBatch(event.batchData);
        case EditBatchEvent:
          event as EditBatchEvent;
          return editBatch(event.batchData);
        case DeleteBatchEvent:
          event as DeleteBatchEvent;
          return deleteBatch(event.batchData);
        case FetchBatchEvent:
          return fetchAllBatch();
        case FetchBatchForCustomerEvent:
          event as FetchBatchForCustomerEvent;
          return fetchBatchForCustomer(event.customerId);
        case FetchBatchForVehicleManufacturerEvent:
          event as FetchBatchForVehicleManufacturerEvent;
          return fetchBatchForVehicleManufacturer(event.vehicleManufacturerId);
        case AddBmsSrNoInBatchEvent:
          event as AddBmsSrNoInBatchEvent;
          return addBmsSrNoInBatch(event.batch);
        case FetchAllVehicleManufacturerEvent:
          return fetchAllVehicleManufacturer();
        case FetchVehicleForCustomerEvent:
          event as FetchVehicleForCustomerEvent;
          return fetchVehicleForCustomer(event.customerId);  
        case AddVehicleManufacturerEvent:
          event as AddVehicleManufacturerEvent;
          return addVehicleManufacturer(event.vehicleManufacturerData);
        case EditVehicleManufacturerEvent:
          event as EditVehicleManufacturerEvent;
          return editVehicleManufacturer(event.vehicleManufacturerData);
        case DeleteVehicleManufacturerEvent:
          event as DeleteVehicleManufacturerEvent;
          return deleteVehicleManufacturer(event.vehicleManufacturerData);  
        default:
      }
    });
  }
}
