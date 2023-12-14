import 'package:crm/enums.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/providers/api_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final ApiProvider apiProvider;
  ComplaintBloc(this.apiProvider) : super(ComplaintInitial()) {
    on<ComplaintEvent>((event, emit) {
      void sendComplaintData(Complaint complaintData) async {
        emit(ComplaintSubmitState(
            submissionStatus: SubmissionStatus.inProgress));
        await apiProvider.addComplaint(complaintData);
        emit(ComplaintSubmitState(submissionStatus: SubmissionStatus.success));
      }

      void fetchComplaints() async {
        emit(
            ComplaintFetchState(submissionStatus: SubmissionStatus.inProgress));
        List<Complaint> complaintList = await apiProvider.fetchComplaints();
        emit(ComplaintFetchState(
            submissionStatus: SubmissionStatus.success,
            complaintList: complaintList));
      }

      switch (event.runtimeType) {
        case ComplaintSubmitButtonPressed:
          event as ComplaintSubmitButtonPressed;
          return sendComplaintData(event.complaintData);
        case FetchComplaintsEvent:
          return fetchComplaints();
        default:
      }
    });
  }
}
