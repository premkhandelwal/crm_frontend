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
    await restApiClient.addCustomer(customerData);
  }

  Future<List<Customer>> fetchCustomers() async {
    List<Customer> customerList = await restApiClient.fetchCustomers();
    return customerList;
  }

  Future addMake(Make makeData) async {
    await restApiClient.addMake(makeData);
  }

  Future<List<Make>> fetchMake() async {
    List<Make> makeList = await restApiClient.fetchMake();
    return makeList;
  }

  Future addHarness(Harness harnessData) async {
    await restApiClient.addHarness(harnessData);
  }

  Future<List<Harness>> fetchHarness() async {
    List<Harness> harnessList = await restApiClient.fetchHarness();
    return harnessList;
  }

  Future addBms(Bms bmsData) async {
    await restApiClient.addBms(bmsData);
  }

  Future<List<Bms>> fetchBms() async {
    List<Bms> bmsList = await restApiClient.fetchBms();
    return bmsList;
  }

  Future addBatch(Batch batchData) async {
    await restApiClient.addBatch(batchData);
  }

  Future<List<Batch>> fetchBatch() async {
    List<Batch> batchList = await restApiClient.fetchBatch();
    return batchList;
  }


  Future addComplaint(Complaint complaint) async {
    await restApiClient.addComplaint(complaint);
  }

  Future<List<Complaint>> fetchComplaints() async {
    List<Complaint> complaintList = await restApiClient.fetchComplaints();
    return complaintList;
  }
}
