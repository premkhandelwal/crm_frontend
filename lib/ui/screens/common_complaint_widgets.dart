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

Widget buildBatchListView(
    List<Batch> batchListForCustomer, List<Complaint> filteredComplaintList, bool isDashboard) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: batchListForCustomer.length,
    itemBuilder: (context, index) {
      Batch batch = batchListForCustomer[index];
      List<Complaint> filteredComplaintsBatch = filteredComplaintList
          .where((element) => element.batchId == batch.id)
          .toList();
      double percentage =
          calculatePercentageOfWorkCompleted(filteredComplaintsBatch);
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
                percentage.isNaN || !isDashboard
                    ? Container()
                    : WorkCompletionProgress(percentage: percentage)
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildBmsListView(List<MapEntry<Bms, List<String>>> bmsList,
    List<Complaint> filteredComplaintList, bool isDashboard) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: bmsList.length,
    itemBuilder: (context, index) {
      Bms bms = bmsList[index].key;
      List<Complaint> filteredComplaintsBMS = List.from(filteredComplaintList
          .where((element) => element.bmsId == bms.id));
      double percentage =
          calculatePercentageOfWorkCompleted(filteredComplaintsBMS);
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
                percentage.isNaN || !isDashboard
                    ? Container()
                    : WorkCompletionProgress(percentage: percentage)
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildBmsSerialNoListView(
    List<String> bmsSerialNoList, List<Complaint> complaintList, bool isDashboard) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: bmsSerialNoList.length,
    itemBuilder: (context, index) {
      int ind = complaintList.indexWhere(
          (element) => element.bmsSerialNo == bmsSerialNoList[index]);
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
                isDashboard ? StatusDisplayWidget(
                    complaintStatus:
                        ind != -1 ? complaintList[index].status : null,
                    isTappable: false): Container()
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
      required this.complaintStatus,
      required this.complaintId})
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
  final String? complaintId;

  @override
  Widget build(BuildContext context) {
    Complaint complaintData = Complaint(
      id: complaintId ?? "",
      status: "Not Resolved",
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isDashBoard
            ? StatusDisplayWidget(
                complaintStatus: complaintStatus,
                complaintId: complaintId,
                isTappable: true,
              )
            : Container(),
        buildTextFormFieldWithIcon(
            controller: returnDateController,
            labelText: 'Return Date',
            icon: Icons.calendar_today,
            readOnly: isDashBoard),
        buildTextFormFieldWithIcon(
            controller: complaintController,
            labelText: 'Complaint',
            icon: Icons.description,
            maxLines: 3,
            readOnly: isDashBoard),
        buildTextFormFieldWithIcon(
            controller: observationController,
            labelText: 'Observation',
            icon: Icons.description,
            maxLines: 3,
            readOnly: isDashBoard),
        buildTextFormFieldWithIcon(
            controller: commentController,
            labelText: 'Comment',
            icon: Icons.description,
            maxLines: 3,
            readOnly: isDashBoard),
        buildTextFormFieldWithIcon(
            controller: solutionController,
            labelText: 'Solution',
            icon: Icons.description,
            maxLines: 3,
            readOnly: isDashBoard),
        buildTextFormFieldWithIcon(
            controller: testingDoneByController,
            labelText: 'Testing Done By',
            icon: Icons.description,
            readOnly: isDashBoard),
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
                                id: complaintId ?? "",
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
                                status: "Not Resolved",
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

class StatusDisplayWidget extends StatelessWidget {
  const StatusDisplayWidget(
      {super.key,
      required this.complaintStatus,
      this.complaintId,
      required this.isTappable});

  final String? complaintStatus;
  final String? complaintId;
  final bool isTappable;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        buildStatusIcon(complaintStatus, context, complaintId, isTappable),
        const SizedBox(
          height: 20,
        )
      ],
    ));
  }
}

Widget buildStatusIcon(String? selectedStatus, BuildContext context,
    String? complaintId, bool isTappable) {
  Color? color;

  switch (selectedStatus) {
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
      color = null;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: color != null
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              )
            : null,
      ),
      const SizedBox(width: 8),
      InkWell(
          onTap: isTappable
              ? () async {
                  await showDialog(
                    context: context,
                    builder: (context) => StatusDialog(
                        onStatusSelected: (status) {
                          selectedStatus = status;
                        },
                        currentStatus: selectedStatus,
                        complaintId: complaintId!),
                  );
                }
              : null,
          child: selectedStatus != null ? Text(selectedStatus!) : Container()),
      const SizedBox(width: 8),
    ],
  );
}

class StatusDialog extends StatefulWidget {
  final Function(String?) onStatusSelected;
  final String? currentStatus;
  final String complaintId;

  const StatusDialog(
      {Key? key,
      required this.onStatusSelected,
      required this.currentStatus,
      required this.complaintId})
      : super(key: key);

  @override
  State<StatusDialog> createState() => _StatusDialogState();
}

class _StatusDialogState extends State<StatusDialog> {
  String? selectedStatus;

  // Define colors for each status
  Map<String, Color> statusColors = {
    'Not Resolved': Colors.red,
    'Not Tested': Colors.orange,
    'Completed': Colors.green,
    'Dispatched': Colors.blue,
    'Waste': Colors.grey,
  };

  @override
  void initState() {
    selectedStatus = widget.currentStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Status'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (var status in statusColors.keys) _buildStatusOption(status),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.read<InfoBloc>().add(UpdateComplaintStatusEvent(complaint: {
                  "id": widget.complaintId,
                  "status": selectedStatus
                }));
            Navigator.pop(context); // Close the dialog
            if (selectedStatus != null) {
              widget.onStatusSelected(selectedStatus);
            }
          },
          child: const Text('Update Status'),
        ),
      ],
    );
  }

  Widget _buildStatusOption(String status) {
    return RadioListTile<String>(
      controlAffinity: ListTileControlAffinity.trailing,
      title: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColors[status],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            status,
            style: TextStyle(color: statusColors[status]),
          ),
        ],
      ),
      value: status,
      groupValue: selectedStatus,
      onChanged: (value) {
        setState(() {
          selectedStatus = value;
        });
      },
    );
  }
}

double calculatePercentageOfWorkCompleted(List<Complaint> complaintList) {
  int totalComplaints = complaintList.length;
  double completedWeight = 0.66;
  double notTestedWeight = 0.33;
  double dispatchedWeight = 1;
  double notResolvedWeight = 0;
  double wasteWeight = 1;
  /* Not Resolved(0%), Not Tested(33%), Completed(66%), Dispatched(100%), Waste(Not to be considered in status)*/

  double totalWeight = 0;

  for (var complaint in complaintList) {
    switch (complaint.status) {
      case "Completed":
        totalWeight += completedWeight;
        break;
      case "Not Tested":
        totalWeight += notTestedWeight;
        break;
      case "Not Resolved":
        totalWeight += notResolvedWeight;
      case "Dispatched":
        totalWeight += dispatchedWeight;
      case "Waste":
        totalWeight += wasteWeight;
      default:
        totalWeight += 0;
      // Add more cases for other statuses if needed
    }
  }

  // Calculate percentage of work completed
  double percentageOfWorkCompleted = (totalWeight / totalComplaints) * 100;

  return percentageOfWorkCompleted;
}

class WorkCompletionProgress extends StatelessWidget {
  final double percentage;

  const WorkCompletionProgress({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$percentage%"),
        Flexible(
          child: SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
              backgroundColor: Colors.black,
              value: percentage / 100,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.green), // Change color as needed
            ),
          ),
        ),
      ],
    );
  }
}
