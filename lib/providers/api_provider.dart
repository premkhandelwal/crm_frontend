import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/networking/dio_builder.dart';
import 'package:crm/networking/rest_api_client.dart';

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

  Future addComplaint(Complaint complaint) async {
    return restApiClient.addComplaint(complaint);
  }

  Future addBmsInBatch(Batch batch) async {
    return restApiClient.addBmsInBatch(batch);
  }

  Future<List<Complaint>> fetchComplaints(String customerId) async {
    List<Complaint> complaintList =
        await restApiClient.fetchComplaints(customerId);
    return complaintList;
  }

  Future updateComplaintStatus(Complaint complaint) async {
    return restApiClient.updateComplaintStatus(complaint);
  }
}
