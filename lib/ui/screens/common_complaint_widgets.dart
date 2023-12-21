import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/info/info_bloc.dart';
import 'package:crm/logic/cubits/complaint/complaint_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildUserActionDescription(
    Customer? selectedCustomer,
    Batch? selectedBatchForCustomer,
    Bms? selectedBms,
    String? selectedBmsSerialNo,
    bool isDashBoard) {
  return Center(
    child: Text(
      selectedCustomer == null
          ? "Select the customer:"
          : selectedBatchForCustomer == null
              ? "Select the batch:"
              : selectedBms == null
                  ? "Select the bms:"
                  : selectedBmsSerialNo == null
                      ? "Select the BMS Serial No:"
                      : isDashBoard
                          ? 'Complaint Details:'
                          : "Fill the details:",
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

Widget buildCustomerWidget(List<Customer> customers, bool isDashboard) {
  return ListView.builder(
    shrinkWrap: true,
    // Your existing builder code...
    itemCount: customers.length,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        color: isDashboard ? null : Colors.white,
        child: InkWell(
          onTap: !isDashboard
              ? () {
                  context
                      .read<ComplaintCubit>()
                      .selectedCustomerChanged(customers[index]);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customers[index].name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                isDashboard
                    ? ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<ComplaintCubit>()
                              .selectedCustomerChanged(customers[index]);
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text("View Details"),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildOtherWidget(
    List<Batch> batchListForCustomer,
    List<Complaint> complaintsList,
    Batch? selectedBatchForCustomer,
    Bms? selectedBms,
    Map<Bms, List<String>> bmsListForSelectedBatch,
    String? selectedBmsSerialNo,
    List<String> serialNoListforSelectedBms,
    Complaint? filteredComplaint,
    TextEditingController returnDateController,
    TextEditingController complaintController,
    TextEditingController observationController,
    TextEditingController commentController,
    TextEditingController solutionController,
    TextEditingController testingDoneByController,
    Customer? selectedCustomer,
    bool isDashBoard,
    GlobalKey<FormState> formKey,
    int layerInd) {
  return layerInd == 1
      ? buildBatchListView(batchListForCustomer)
      : layerInd == 2
          ? buildBmsListView(bmsListForSelectedBatch.entries.toList())
          : layerInd == 3
              ? buildBmsSerialNoListView(serialNoListforSelectedBms)
              : (layerInd == 4) && (filteredComplaint != null || !(isDashBoard))
                  ? ComplaintForm(
                      returnDateController: returnDateController,
                      complaintController: complaintController,
                      observationController: observationController,
                      commentController: commentController,
                      solutionController: solutionController,
                      testingDoneByController: testingDoneByController,
                      selectedCustomer: selectedCustomer,
                      selectedBatchForCustomer: selectedBatchForCustomer,
                      selectedBms: selectedBms,
                      formKey: formKey,
                      selectedBmsSerialNo: selectedBmsSerialNo,
                      isDashBoard: isDashBoard,
                      complaintStatus: filteredComplaint?.status,
                    )
                  : const Center(
                      child: Text(
                        "No complaint found!!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
}

Widget buildBatchListView(List<Batch> batchListForCustomer) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: batchListForCustomer.length,
    itemBuilder: (context, index) {
      Batch batch = batchListForCustomer[index];
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            context.read<ComplaintCubit>().selectedBatchChanged(batch);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 10.0),
                      Text(
                        batch.batchName,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildBmsListView(List<MapEntry<Bms, List<String>>> bmsList) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: bmsList.length,
    itemBuilder: (context, index) {
      Bms bms = bmsList[index].key;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            context
                .read<ComplaintCubit>()
                .selectedBmsChanged(bms, bmsList[index].value);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 10.0),
                      Text(
                        bms.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildBmsSerialNoListView(List<String> bmsSerialNoList) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: bmsSerialNoList.length,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            context
                .read<ComplaintCubit>()
                .selectedSerialNoChanged(bmsSerialNoList[index]);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 10.0),
                      Text(
                        bmsSerialNoList[index],
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class ComplaintForm extends StatelessWidget {
  const ComplaintForm(
      {super.key,
      required this.returnDateController,
      required this.complaintController,
      required this.observationController,
      required this.commentController,
      required this.solutionController,
      required this.testingDoneByController,
      required this.selectedCustomer,
      required this.selectedBatchForCustomer,
      required this.selectedBms,
      required GlobalKey<FormState> formKey,
      required this.selectedBmsSerialNo,
      required this.isDashBoard,
      required this.complaintStatus})
      : _formKey = formKey;

  final TextEditingController returnDateController;
  final TextEditingController complaintController;
  final TextEditingController observationController;
  final TextEditingController commentController;
  final TextEditingController solutionController;
  final TextEditingController testingDoneByController;
  final Customer? selectedCustomer;
  final Batch? selectedBatchForCustomer;
  final Bms? selectedBms;
  final GlobalKey<FormState> _formKey;
  final String? selectedBmsSerialNo;
  final bool isDashBoard;
  final String? complaintStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isDashBoard
            ? Center(
                child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  buildStatusIcon(complaintStatus),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ))
            : Container(),
        buildTextFormFieldWithIcon(
          controller: returnDateController,
          labelText: 'Return Date',
          icon: Icons.calendar_today,
        ),
        buildTextFormFieldWithIcon(
          controller: complaintController,
          labelText: 'Complaint',
          icon: Icons.description,
          maxLines: 3,
        ),
        buildTextFormFieldWithIcon(
          controller: observationController,
          labelText: 'Observation',
          icon: Icons.description,
          maxLines: 3,
        ),
        buildTextFormFieldWithIcon(
          controller: commentController,
          labelText: 'Comment',
          icon: Icons.description,
          maxLines: 3,
        ),
        buildTextFormFieldWithIcon(
          controller: solutionController,
          labelText: 'Solution',
          icon: Icons.description,
          maxLines: 3,
        ),
        buildTextFormFieldWithIcon(
          controller: testingDoneByController,
          labelText: 'Testing Done By',
          icon: Icons.description,
        ),
        const SizedBox(height: 20),
        BlocConsumer<InfoBloc, InfoState>(
          listener: (context, state) {
            if (state is ComplaintSubmitState) {
              if (state.submissionStatus == SubmissionStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Complaint added successfully")));
              } else if (state.submissionStatus == SubmissionStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to lodge complaint")));
              }
            }
          },
          builder: (context, state) {
            if (state is ComplaintSubmitState &&
                state.submissionStatus == SubmissionStatus.inProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return isDashBoard
                ? Container()
                : ElevatedButton(
                    onPressed: selectedCustomer != null &&
                            selectedBatchForCustomer != null &&
                            selectedBms != null
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              // Handle form submission
                              // Access the form field values using the controllers
                              Complaint complaintData = Complaint(
                                customerId: selectedCustomer!.id,
                                batchId: selectedBatchForCustomer!.id,
                                bmsId: selectedBms!.id,
                                bmsSerialNo: selectedBmsSerialNo!,
                                returnDate:
                                    DateTime.parse(returnDateController.text),
                                complaint: complaintController.text,
                                comment: commentController.text,
                                observation: observationController.text,
                                solution: solutionController.text,
                                testingDoneBy: testingDoneByController.text,
                                status: "NOT RESOLVED",
                              );
                              context.read<InfoBloc>().add(
                                  ComplaintSubmitButtonPressed(
                                      complaintData: complaintData));
                            }
                          }
                        : null,
                    child: const Text('Submit'),
                  );
          },
        ),
      ],
    );
  }
}

Widget buildStatusIcon(String? status) {
  Color color;

  switch (status) {
    case "Not Resolved":
      color = Colors.red;
      break;
    case "Not Tested":
      color = Colors.orange;
      break;
    case "Completed":
      color = Colors.green;
      break;
    case "Dispatched":
      color = Colors.blue;
      break;
    case "Waste":
      color = Colors.grey;
      break;
    default:
      color = Colors.grey;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
      const SizedBox(width: 8),
      Text(status ?? "Unknown"),
    ],
  );
}
