import 'package:crm/enums.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/providers/api_provider.dart';
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
        await apiProvider.addComplaint(complaintData);
        emit(ComplaintSubmitState(submissionStatus: SubmissionStatus.success));
      }

      void fetchComplaints(String customerId) async {
        emit(
            ComplaintFetchState(submissionStatus: SubmissionStatus.inProgress));
        List<Complaint> complaintList =
            await apiProvider.fetchComplaints(customerId);
        emit(ComplaintFetchState(
            submissionStatus: SubmissionStatus.success,
            complaintList: complaintList));
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

      void updateComplaintStatus(Complaint complaint) async {
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

      switch (event.runtimeType) {
        case ComplaintSubmitButtonPressed:
          event as ComplaintSubmitButtonPressed;
          return sendComplaintData(event.complaintData);
        case FetchComplaintsEvent:
          event as FetchComplaintsEvent;
          return fetchComplaints(event.customerId);
        case FetchBatchForCustomerEvent:
          event as FetchBatchForCustomerEvent;
          return fetchBatchForCustomer(event.customerId);
        case UpdateComplaintStatusEvent:
          event as UpdateComplaintStatusEvent;
          return updateComplaintStatus(event.complaint);
        default:
      }
    });
  }
}
