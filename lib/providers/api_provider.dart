import 'dart:io';

import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/models/vehicle_manufacturer_request.dart';
import 'package:crm/networking/dio_builder.dart';
import 'package:crm/networking/rest_api_client.dart';
import 'package:file_picker/file_picker.dart';

class ApiProvider {
  final RestApiClient restApiClient;

  ApiProvider() : restApiClient = RestApiClient(DioBuilder.buildDioClient());
  Future addCustomer(Customer customerData) async {
    return restApiClient.addCustomer(customerData);
  }

  Future editCustomer(Customer customerData) async {
    return restApiClient.editCustomer(customerData);
  }

  Future deleteCustomer(Customer customerData) async {
    return restApiClient.deleteCustomer(customerData);
  }

  Future<List<Customer>> fetchCustomers() async {
    List<Customer> customerList = await restApiClient.fetchCustomers();
    return customerList;
  }

  Future addMake(Make makeData) async {
    return restApiClient.addMake(makeData);
  }

  Future editMake(Make makeData) async {
    return restApiClient.editMake(makeData);
  }

  Future deleteMake(Make makeData) async {
    return restApiClient.deleteMake(makeData);
  }

  Future<List<Make>> fetchMake() async {
    List<Make> makeList = await restApiClient.fetchMake();
    return makeList;
  }

  Future addHarness(Harness harnessData) async {
    return restApiClient.addHarness(harnessData);
  }

  Future editHarness(Harness harnessData) async {
    return restApiClient.editHarness(harnessData);
  }

  Future deleteHarness(Harness harnessData) async {
    return restApiClient.deleteHarness(harnessData);
  }

  Future<List<Harness>> fetchHarness() async {
    List<Harness> harnessList = await restApiClient.fetchHarness();
    return harnessList;
  }

  Future addBms(Bms bmsData) async {
    return restApiClient.addBms(bmsData);
  }

  Future editBms(Bms bmsData) async {
    return restApiClient.editBms(bmsData);
  }

  Future deleteBms(Bms bmsData) async {
    return restApiClient.deleteBms(bmsData);
  }

  Future<List<Bms>> fetchBms() async {
    List<Bms> bmsList = await restApiClient.fetchBms();
    return bmsList;
  }

  Future addBatch(Batch batchData) async {
    return restApiClient.addBatch(batchData);
  }

  Future editBatch(Batch batchData) async {
    return restApiClient.editBatch(batchData);
  }

  Future deleteBatch(Batch batchData) async {
    return restApiClient.deleteBatch(batchData);
  }

  Future<List<Batch>> fetchBatch() async {
    List<Batch> batchList = await restApiClient.fetchBatch();
    return batchList;
  }

  Future<List<Batch>> fetchBatchforCustomer(String customerId) async {
    List<Batch> batchList =
        await restApiClient.fetchBatchforCustomer(customerId);
    return batchList;
  }

  Future<List<Batch>> fetchBatchforVehicleManufacturer(
      String vehicleManufacturerId) async {
    List<Batch> batchList = await restApiClient
        .fetchBatchforVehicleManufacturer(vehicleManufacturerId);
    return batchList;
  }

  Future<List<VehicleManufacturer>> fetchVehicleManufacturerforCustomer(
      String customerId) async {
    List<VehicleManufacturer> vehicleManufacturerList =
        await restApiClient.fetchVehicleManufacturerforCustomer(customerId);
    return vehicleManufacturerList;
  }

  Future<List<VehicleManufacturer>> fetchAllVehicleManufacturer() async {
    List<VehicleManufacturer> vehicleManufacturerList =
        await restApiClient.fetchAllVehicleManufacturer();
    return vehicleManufacturerList;
  }

  Future addVehicleManufacturer(VehicleManufacturer vehicleManufacturerData) async {
    return restApiClient.addVehicleManufacturer(vehicleManufacturerData);
  }

  Future editVehicleManufacturer(VehicleManufacturer vehicleManufacturerData) async {
    return restApiClient.editVehicleManufacturer(vehicleManufacturerData);
  }

  Future deleteVehicleManufacturer(VehicleManufacturer vehicleManufacturerData) async {
    return restApiClient.deleteVehicleManufacturer(vehicleManufacturerData);
  }

  Future<Complaint> addComplaint(Complaint complaint) async {
    return restApiClient.addComplaint(complaint);
  }

  Future addBmsSrNoInBatch(Batch batch) async {
    return restApiClient.addBmsSrNoInBatch(batch);
  }

  Future<List<Complaint>> fetchAllComplaints() async {
    List<Complaint> complaintList = await restApiClient.fetchAllComplaints();
    return complaintList;
  }

  Future updateComplaintStatus(
    Map<String, String?> complaint,
  ) async {
    return restApiClient.updateComplaintStatus(complaint);
  }

  Future<void> exportToExcel(
      List<Complaint> complaintList,
      List<Customer> customerList,
      List<VehicleManufacturer> vehicleManufacturerList,
      List<Batch> batchList,
      List<Bms> bmsList,
      List<Harness> harnessList,
      List<Make> makeList) async {
    String? filePath = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['csv'], // Add more extensions if needed
    );

    // Check if the user canceled the file picker
    if (filePath == null) return;
    File file = File(filePath);
    IOSink sink = file.openWrite();

    // Write header if needed
    sink.writeln(
        'Lot Number,BMS No,Return Date, Complaint, Missing Harness, BMS Details, Make, Customer, Behaviour, Reason/Comment, Solution, Tester, Status'); // Replace with your headers

    // Write data to the file
    for (Complaint complaintData in complaintList) {
      int customerInd = customerList
          .indexWhere((element) => element.id == complaintData.customerId);
      int vehicleManufacturerInd = vehicleManufacturerList.indexWhere(
          (element) => element.id == complaintData.vehicleManufacturerId);
      int batchInd = batchList
          .indexWhere((element) => element.id == complaintData.batchId);
      int bmsInd =
          bmsList.indexWhere((element) => element.id == complaintData.bmsId);
      int harnessInd = harnessList
          .indexWhere((element) => element.id == complaintData.harnessId);
      int makeInd =
          makeList.indexWhere((element) => element.id == complaintData.makeId);
      if (customerInd != -1 &&
          vehicleManufacturerInd != -1 &&
          batchInd != -1 &&
          bmsInd != -1 &&
          harnessInd != -1 &&
          makeInd != -1) {
        sink.writeln(
          '${customerList[customerInd].name} ${vehicleManufacturerList[vehicleManufacturerInd].name} ${batchList[batchInd].batchName},${complaintData.bmsSerialNo}, ${complaintData.returnDate}, ${complaintData.complaint}, ${harnessList[harnessInd].name}, ${bmsList[bmsInd].details}, ${makeList[makeInd].name}, ${customerList[customerInd].name}, ${complaintData.observation}, ${complaintData.comment}, ${complaintData.solution}, ${complaintData.testingDoneBy}, ${complaintData.status}',
        ); // Replace with your data properties
      }
    }

    // Close the file
    sink.close();
    return;
  }

  void exportDataToFile(List<Complaint> dataList, String filePath) {
    try {
      // Open the file for writing
    } catch (e) {
      print('Error exporting data: $e');
    }
  }
}
