import 'package:crm/enums.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/models/vehicle_manufacturer_request.dart';
import 'package:crm/providers/api_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  final ApiProvider apiProvider;
  InfoBloc(this.apiProvider) : super(InfoInitial()) {
    on<InfoEvent>((event, emit) {
      void sendComplaintData(Complaint complaintData) async {
        emit(ComplaintSubmitState(
            submissionStatus: SubmissionStatus.inProgress));
        Complaint complaint = await apiProvider.addComplaint(complaintData);
        emit(ComplaintSubmitState(
            submissionStatus: SubmissionStatus.success, complaint: complaint));
      }

      void fetchAllComplaints() async {
        emit(
            ComplaintFetchState(submissionStatus: SubmissionStatus.inProgress));
        List<Complaint> complaintList = await apiProvider.fetchAllComplaints();
        emit(ComplaintFetchState(
            submissionStatus: SubmissionStatus.success,
            complaintList: complaintList));
      }

      
      void updateComplaintStatus(Map<String, String?> complaint) async {
        try {
          emit(UpdateComplaintStatusState(status: SubmissionStatus.inProgress));
          Complaint updatedComplaint =
              await apiProvider.updateComplaintStatus(complaint);
          emit(UpdateComplaintStatusState(
              status: SubmissionStatus.success, complaint: updatedComplaint));
        } catch (e) {
          emit(UpdateComplaintStatusState(status: SubmissionStatus.failure));
        }
      }

      void exportToExcel(
          List<Complaint> complaintList,
          List<Customer> customerList,
          List<VehicleManufacturer> vehicleManufacturerList,
          List<Batch> batchList,
          List<Bms> bmsList,
          List<Harness> harnessList,
          List<Make> makeList) async {
        await apiProvider.exportToExcel(complaintList, customerList,
            vehicleManufacturerList, batchList, bmsList, harnessList, makeList);
      }

      switch (event.runtimeType) {
        case ComplaintSubmitButtonPressed:
          event as ComplaintSubmitButtonPressed;
          return sendComplaintData(event.complaintData);
        case FetchAllComplaintsEvent:
          return fetchAllComplaints();
        
        case UpdateComplaintStatusEvent:
          event as UpdateComplaintStatusEvent;
          return updateComplaintStatus(event.complaint);
        case ExportToExcelEvent:
          event as ExportToExcelEvent;
          return exportToExcel(
              event.complaintList,
              event.customerList,
              event.vehicleManufacturerList,
              event.batchList,
              event.bmsList,
              event.harnessList,
              event.makeList);
        default:
      }
    });
  }
}
