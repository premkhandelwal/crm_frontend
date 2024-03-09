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
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class ApiProvider {
  final RestApiClient restApiClient;

  ApiProvider() : restApiClient = RestApiClient(DioBuilder.buildDioClient());
  Future<Customer> addCustomer(Customer customerData) async {
    return restApiClient.addCustomer(customerData);
  }

  Future<Customer> editCustomer(Customer customerData) async {
    return restApiClient.editCustomer(customerData);
  }

  Future<Customer> deleteCustomer(Customer customerData) async {
    return restApiClient.deleteCustomer(customerData);
  }

  Future<List<Customer>> fetchCustomers() async {
    List<Customer> customerList = await restApiClient.fetchCustomers();
    return customerList;
  }

  Future<Make> addMake(Make makeData) async {
    return restApiClient.addMake(makeData);
  }

  Future<Make> editMake(Make makeData) async {
    return restApiClient.editMake(makeData);
  }

  Future<Make> deleteMake(Make makeData) async {
    return restApiClient.deleteMake(makeData);
  }

  Future<List<Make>> fetchMake() async {
    List<Make> makeList = await restApiClient.fetchMake();
    return makeList;
  }

  Future<Harness> addHarness(Harness harnessData) async {
    return restApiClient.addHarness(harnessData);
  }

  Future<Harness> editHarness(Harness harnessData) async {
    return restApiClient.editHarness(harnessData);
  }

  Future<Harness> deleteHarness(Harness harnessData) async {
    return restApiClient.deleteHarness(harnessData);
  }

  Future<List<Harness>> fetchHarness() async {
    List<Harness> harnessList = await restApiClient.fetchHarness();
    return harnessList;
  }

  Future<Bms> addBms(Bms bmsData) async {
    return restApiClient.addBms(bmsData);
  }

  Future<Bms> editBms(Bms bmsData) async {
    return restApiClient.editBms(bmsData);
  }

  Future<Bms> deleteBms(Bms bmsData) async {
    return restApiClient.deleteBms(bmsData);
  }

  Future<List<Bms>> fetchBms() async {
    List<Bms> bmsList = await restApiClient.fetchBms();
    return bmsList;
  }

  Future<Batch> addBatch(Batch batchData) async {
    return restApiClient.addBatch(batchData);
  }

  Future<Batch> editBatch(Batch batchData) async {
    return restApiClient.editBatch(batchData);
  }

  Future<Batch> deleteBatch(Batch batchData) async {
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

  Future<VehicleManufacturer> addVehicleManufacturer(
      VehicleManufacturer vehicleManufacturerData) async {
    return restApiClient.addVehicleManufacturer(vehicleManufacturerData);
  }

  Future<VehicleManufacturer> editVehicleManufacturer(
      VehicleManufacturer vehicleManufacturerData) async {
    return restApiClient.editVehicleManufacturer(vehicleManufacturerData);
  }

  Future<VehicleManufacturer> deleteVehicleManufacturer(
      VehicleManufacturer vehicleManufacturerData) async {
    return restApiClient.deleteVehicleManufacturer(vehicleManufacturerData);
  }

  Future<Complaint> addComplaint(Complaint complaint) async {
    return restApiClient.addComplaint(complaint);
  }

  Future<Batch> addBmsSrNoInBatch(Batch batch) async {
    return restApiClient.addBmsSrNoInBatch(batch);
  }

  Future<List<Complaint>> fetchAllComplaints() async {
    List<Complaint> complaintList = await restApiClient.fetchAllComplaints();
    return complaintList;
  }

  Future<Complaint> updateComplaintStatus(
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
    List<Make> makeList,
  ) async {
    // Create an Excel workbook
    var excel = Excel.createExcel();

    // Iterate through each customer
    for (Customer customer in customerList) {
      // Filter complaints for the current customer
      List<Complaint> customerComplaints = complaintList
          .where((complaint) => complaint.customerId == customer.id)
          .toList();

      // Sort complaints based on lot number
      customerComplaints.sort((a, b) {
        int customerIndA =
            customerList.indexWhere((element) => element.id == a.customerId);
        int customerIndB =
            customerList.indexWhere((element) => element.id == b.customerId);
        int vehicleManufacturerIndA = vehicleManufacturerList
            .indexWhere((element) => element.id == a.vehicleManufacturerId);
        int vehicleManufacturerIndB = vehicleManufacturerList
            .indexWhere((element) => element.id == b.vehicleManufacturerId);
        int batchIndA =
            batchList.indexWhere((element) => element.id == a.batchId);
        int batchIndB =
            batchList.indexWhere((element) => element.id == b.batchId);

        String lotNoA =
            "${customerList[customerIndA].name} ${vehicleManufacturerList[vehicleManufacturerIndA].name} ${batchList[batchIndA].batchName}";
        String lotNoB =
            "${customerList[customerIndB].name} ${vehicleManufacturerList[vehicleManufacturerIndB].name} ${batchList[batchIndB].batchName}";

        return lotNoA.compareTo(lotNoB);
      });

      // Create a sheet for the current customer
      var sheet = excel[customer.name];

      // Write header to the sheet
      sheet.appendRow([
        const TextCellValue('Lot Number'),
        const TextCellValue('BMS No'),
        const TextCellValue('Return Date'),
        const TextCellValue('Complaint'),
        const TextCellValue('Missing Harness'),
        const TextCellValue('BMS Details'),
        const TextCellValue('Make'),
        const TextCellValue('Customer'),
        const TextCellValue('Behaviour'),
        const TextCellValue('Reason/Comment'),
        const TextCellValue('Solution'),
        const TextCellValue('Tester'),
        const TextCellValue('Status'),
      ]);

      // Write data to the sheet
      for (Complaint complaintData in customerComplaints) {
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
        int makeInd = makeList
            .indexWhere((element) => element.id == complaintData.makeId);

        if (customerInd != -1 &&
            vehicleManufacturerInd != -1 &&
            batchInd != -1 &&
            bmsInd != -1 &&
            harnessInd != -1 &&
            makeInd != -1) {
          String lotNo =
              "${customerList[customerInd].name} ${vehicleManufacturerList[vehicleManufacturerInd].name} ${batchList[batchInd].batchName}";

          sheet.appendRow([
            TextCellValue(lotNo),
            TextCellValue('${complaintData.bmsSerialNo}'),
            TextCellValue('${complaintData.returnDate}'),
            TextCellValue('${complaintData.complaint}'),
            TextCellValue((harnessList[harnessInd].name)),
            TextCellValue((bmsList[bmsInd].details)),
            TextCellValue((makeList[makeInd].name)),
            TextCellValue((customerList[customerInd].name)),
            TextCellValue('${complaintData.observation}'),
            TextCellValue('${complaintData.comment}'),
            TextCellValue('${complaintData.solution}'),
            TextCellValue('${complaintData.testingDoneBy}'),
            TextCellValue('${complaintData.status}'),
          ]);
        }
      }

      // Check if the user canceled the file picker
    }

    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'], // Add more extensions if needed
    );
    if (filePickerResult != null && filePickerResult.files.isNotEmpty) {
      PlatformFile pffile = filePickerResult.files.first;
      String? filePath = pffile.path;
      if (filePath == null) return;
      File file = File(filePath);
      // Write the Excel file to disk
      List<int>? encodedData = excel.save(fileName: pffile.name);
      if (encodedData != null) {
        file.writeAsBytesSync(encodedData);
      }
    }
  }
}
