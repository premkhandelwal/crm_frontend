import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/models/vehicle_manufacturer_request.dart';
import 'package:crm/networking/apis.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_api_client.g.dart';

@RestApi(baseUrl: Apis.activeBaseUrl)
abstract class RestApiClient {
  factory RestApiClient(Dio dio, {String baseUrl}) = _RestApiClient;

  @POST(Apis.addCustomer)
  Future<Customer> addCustomer(@Body() Customer customerData);

  @PUT(Apis.editCustomer)
  Future<Customer> editCustomer(@Body() Customer customerData);

  @DELETE(Apis.deleteCustomer)
  Future<Customer> deleteCustomer(@Body() Customer customerId);

  @GET(Apis.fetchCustomers)
  Future<List<Customer>> fetchCustomers();

  @POST(Apis.addMake)
  Future<Make> addMake(@Body() Make makeData);

  @PUT(Apis.editMake)
  Future<Make> editMake(@Body() Make makeData);

  @DELETE(Apis.deleteMake)
  Future<Make> deleteMake(@Body() Make makeData);

  @GET(Apis.fetchMake)
  Future<List<Make>> fetchMake();

  @POST(Apis.addHarness)
  Future<Harness> addHarness(@Body() Harness harnessData);

  @PUT(Apis.editHarness)
  Future<Harness> editHarness(@Body() Harness harnessData);

  @DELETE(Apis.deleteHarness)
  Future<Harness> deleteHarness(@Body() Harness harnessData);

  @GET(Apis.fetchHarness)
  Future<List<Harness>> fetchHarness();

  @POST(Apis.addBms)
  Future<Bms> addBms(@Body() Bms bmsData);

  @PUT(Apis.editBms)
  Future<Bms> editBms(@Body() Bms bmsData);

  @DELETE(Apis.deleteBms)
  Future<Bms> deleteBms(@Body() Bms bmsData);

  @GET(Apis.fetchBms)
  Future<List<Bms>> fetchBms();

  @POST(Apis.addBatch)
  Future<Batch> addBatch(@Body() Batch batchData);

  @PUT(Apis.editBatch)
  Future<Batch> editBatch(@Body() Batch batchData);

  @DELETE(Apis.deleteBatch)
  Future<Batch> deleteBatch(@Body() Batch batchData);

  @GET(Apis.fetchBatch)
  Future<List<Batch>> fetchBatch();

  @GET(Apis.fetchBatchforCustomer)
  Future<List<Batch>> fetchBatchforCustomer(
      @Query("customerId") String customerId);

  @GET(Apis.fetchBatchforVehicleManufacturer)
  Future<List<Batch>> fetchBatchforVehicleManufacturer(
      @Query("vehicleManufacturerId") String vehicleManufacturerId);

  @POST(Apis.addBmsSrNoInBatch)
  Future<Batch> addBmsSrNoInBatch(@Body() Batch batchData);

  @POST(Apis.addComplaint)
  Future<Complaint> addComplaint(@Body() Complaint complaintRequest);

  @GET(Apis.fetchComplaintForCustomer)
  Future<List<Complaint>> fetchComplaintForCustomer();

  @GET(Apis.fetchAllComplaints)
  Future<List<Complaint>> fetchAllComplaints();

  @PUT(Apis.updateComplaintStatus)
  Future<Complaint> updateComplaintStatus(
      @Body() Map<String, String?> complaint);

  @GET(Apis.fetchAllVehicleManufacturer)
  Future<List<VehicleManufacturer>> fetchAllVehicleManufacturer();

  @GET(Apis.fetchVehicleManufacturer)
  Future<List<VehicleManufacturer>> fetchVehicleManufacturerforCustomer(
      @Query("customerId") String customerId);

  @POST(Apis.addVehicleManufacturer)
  Future<VehicleManufacturer> addVehicleManufacturer(@Body() VehicleManufacturer vehicleManufacturerData);

  @PUT(Apis.editVehicleManufacturer)
  Future<VehicleManufacturer> editVehicleManufacturer(@Body() VehicleManufacturer vehicleManufacturerData);

  @DELETE(Apis.deleteVehicleManufacturer)
  Future<VehicleManufacturer> deleteVehicleManufacturer(@Body() VehicleManufacturer vehicleManufacturerData);    
}
