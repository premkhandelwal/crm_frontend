import 'package:crm/models/complaint_request.dart';
import 'package:crm/networking/apis.dart';
import 'package:retrofit/retrofit.dart';

import 'package:dio/dio.dart';

part 'rest_api_client.g.dart';

@RestApi(baseUrl: Apis.activeBaseUrl)
abstract class RestApiClient {
  factory RestApiClient(Dio dio, {String baseUrl}) = _RestApiClient;

  @POST(Apis.addComplaint)
  Future<Complaint> addComplaint(@Body() Complaint complaintRequest);

  @GET(Apis.fetchComplaint)
  Future<List<Complaint>> fetchComplaint();
}
