import 'package:crm/models/complaint_request.dart';
import 'package:crm/networking/dio_builder.dart';
import 'package:crm/networking/rest_api_client.dart';

class ApiProvider {
  final RestApiClient restApiClient;

  ApiProvider() : restApiClient = RestApiClient(DioBuilder.buildDioClient());
  Future addComplaint(Complaint complaint) async {
    await restApiClient.addComplaint(complaint);
  }

  Future<List<Complaint>> fetchComplaint() async {
    List<Complaint> complaintList = await restApiClient.fetchComplaint();
    return complaintList;
  }
}
