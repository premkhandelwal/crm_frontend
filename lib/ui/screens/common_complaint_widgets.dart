import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/info/info_bloc.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/complaint/complaint_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:crm/models/vehicle_manufacturer_request.dart';
import 'package:crm/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

Widget buildUserActionDescription(
    Customer? selectedCustomer,
    VehicleManufacturer? selectedVehicleManufacturer,
    Batch? selectedBatchForCustomer,
    String? selectedBmsSerialNo) {
  return Center(
    child: Text(
      selectedCustomer == null
          ? "Select the customer:"
          : selectedVehicleManufacturer == null
              ? "Select the vehicle manufacturer"
              : selectedBatchForCustomer == null
                  ? "Select the batch:"
                  : selectedBmsSerialNo == null
                      ? "Select the BMS Serial No:"
                      : 'Complaint Details:',
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

Widget buildCustomerWidget(List<Customer> customers) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: customers.length,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            context
                .read<ComplaintCubit>()
                .selectedCustomerChanged(customers[index]);
          },
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
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildVehicleManufacturerListView(
    List<VehicleManufacturer> vehicleManufacturersList,
    List<Complaint> filteredComplaintList) {
  Map<String, double> weightMap = {
    "Completed": 0.66,
    "Not Tested": 0.33,
    "Dispatched": 1,
    "Not Resolved": 1,
    "Waste": 1,
  };
  return ListView.builder(
    shrinkWrap: true,
    itemCount: vehicleManufacturersList.length,
    itemBuilder: (context, index) {
      VehicleManufacturer vehicleManufacturer = vehicleManufacturersList[index];
      List<Complaint> filteredComplaintsBatch = filteredComplaintList
          .where((element) =>
              element.vehicleManufacturerId == vehicleManufacturer.id)
          .toList();

      Map<String, double> percentageMap =
          calculatePercentageOfWorkCompleted(filteredComplaintsBatch);
      double percentageVal = 0.0;
      for (var status in percentageMap.entries) {
        double val = status.value;
        if (val < 0) {
          val = -val;
        } else {
          percentageVal += val;
        }
        double tot = (val / (weightMap[status.key] ?? 1));
        print(tot);
        percentageMap[status.key] = val / (weightMap[status.key] ?? 1);
      }
      double percentage =
          (percentageVal / (filteredComplaintsBatch.length)) * 100;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            context.read<MasterBloc>().add(
                FetchBatchForVehicleManufacturerEvent(
                    vehicleManufacturerId: vehicleManufacturer));
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
                        vehicleManufacturer.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                percentage.isNaN
                    ? Container()
                    : WorkCompletionProgress(
                        percentage: percentage,
                        percentageMap: percentageMap,
                      )
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildBatchListView(
    List<Batch> batchListForCustomer, List<Complaint> filteredComplaintList) {
  Map<String, double> weightMap = {
    "Completed": 0.66,
    "Not Tested": 0.33,
    "Dispatched": 1,
    "Not Resolved": 1,
    "Waste": 1,
  };
  return ListView.builder(
    shrinkWrap: true,
    itemCount: batchListForCustomer.length,
    itemBuilder: (context, index) {
      Batch batch = batchListForCustomer[index];
      List<Complaint> filteredComplaintsBatch = filteredComplaintList
          .where((element) => element.batchId == batch.id)
          .toList();

      Map<String, double> percentageMap =
          calculatePercentageOfWorkCompleted(filteredComplaintsBatch);
      double percentageVal = 0.0;
      for (var status in percentageMap.entries) {
        double val = status.value;
        if (val < 0) {
          val = -val;
        } else {
          percentageVal += val;
        }
        percentageMap[status.key] = val / (weightMap[status.key] ?? 1);
      }
      double percentage =
          (percentageVal / (filteredComplaintsBatch.length)) * 100;

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
                percentage.isNaN
                    ? Container()
                    : WorkCompletionProgress(
                        percentage: percentage,
                        percentageMap: percentageMap,
                      )
              ],
            ),
          ),
        ),
      );
    },
  );
}

/*Widget buildBmsListView(List<MapEntry<Bms, List<String>>> bmsList,
    List<Complaint> filteredComplaintList, bool isDashboard) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: bmsList.length,
    itemBuilder: (context, index) {
      Bms bms = bmsList[index].key;
      List<Complaint> filteredComplaintsBMS = filteredComplaintList
          .where((element) => element.bmsId == bms.id)
          .toList();
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
}*/

Widget buildBmsSerialNoListView(
    List<String> bmsSerialNoList, List<Complaint> complaintList) {
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
                StatusDisplayWidget(
                    complaintStatus:
                        ind != -1 ? complaintList[index].status : null,
                    isTappable: false)
              ],
            ),
          ),
        ),
      );
    },
  );
}

class ComplaintForm extends StatefulWidget {
  const ComplaintForm(
      {super.key,
      required this.selectedCustomer,
      required this.selectedBatchForCustomer,
      required this.selectedBmsSerialNo,
      required this.selectedVehicleManufacturer,
      required this.filteredComplaint});

  final Customer? selectedCustomer;
  final Batch? selectedBatchForCustomer;
  final String? selectedBmsSerialNo;
  final VehicleManufacturer? selectedVehicleManufacturer;
  final Complaint? filteredComplaint;

  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  List<Make> makeList = [];
  List<Harness> harnessList = [];
  List<Bms> bmsList = [];
  late MasterBloc masterBloc;
  Harness? _selectedHarness;
  Make? _selectedMake;
  Bms? _selectedBms;
  Complaint? _filteredComplaint;

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
    masterBloc.add(FetchHarnessEvent());
    masterBloc.add(FetchMakeEvent());
    masterBloc.add(FetchBmsEvent());
    if (widget.filteredComplaint != null) {
      _filteredComplaint = widget.filteredComplaint;
      commentController.text = _filteredComplaint!.comment ?? "";
      complaintController.text = _filteredComplaint!.complaint ?? "";
      observationController.text = _filteredComplaint!.observation ?? "";
      if (_filteredComplaint!.returnDate != null) {
        returnDateController.text =
            DateFormat('dd-MM-yyyy').format(_filteredComplaint!.returnDate!);
      }
      solutionController.text = _filteredComplaint!.solution ?? "";
      testingDoneByController.text = _filteredComplaint!.testingDoneBy ?? "";
    }
    super.initState();
  }

  TextEditingController returnDateController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  TextEditingController solutionController = TextEditingController();
  TextEditingController testingDoneByController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocConsumer<InfoBloc, InfoState>(
      listener: (context, complaintState) {
        if (complaintState is ComplaintSubmitState) {
          if (complaintState.submissionStatus == SubmissionStatus.success) {
            _filteredComplaint = complaintState.complaint;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Complaint added successfully")));
          } else if (complaintState.submissionStatus ==
              SubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to lodge complaint")));
          }
        } else if (complaintState is UpdateComplaintStatusState &&
            complaintState.status == SubmissionStatus.success) {
          _filteredComplaint = complaintState.complaint;
        }
      },
      builder: (context, complaintState) {
        return BlocConsumer<MasterBloc, MasterState>(
          listener: (context, masterState) {
            if (masterState is FetchMakeState &&
                masterState.submissionStatus == SubmissionStatus.success) {
              makeList = List.from(masterState.makeList);
              int ind = makeList.indexWhere(
                  (element) => element.id == widget.filteredComplaint?.makeId);
              if (ind != -1) {
                _selectedMake = makeList[ind];
              }
            } else if (masterState is FetchHarnessState &&
                masterState.submissionStatus == SubmissionStatus.success) {
              harnessList = List.from(masterState.harnessList);
              int ind = harnessList.indexWhere((element) =>
                  element.id == widget.filteredComplaint?.harnessId);
              if (ind != -1) {
                _selectedHarness = harnessList[ind];
              }
            } else if (masterState is FetchBmsState &&
                masterState.submissionStatus == SubmissionStatus.success) {
              bmsList = List.from(masterState.bmsList);
              int ind = bmsList.indexWhere(
                  (element) => element.id == widget.filteredComplaint?.bmsId);
              if (ind != -1) {
                _selectedBms = bmsList[ind];
              }
            }
          },
          builder: (context, masterState) {
            if (masterState.submissionStatus == SubmissionStatus.inProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _filteredComplaint != null
                      ? StatusDisplayWidget(
                          complaintStatus: _filteredComplaint?.status,
                          complaintId: _filteredComplaint?.id,
                          isTappable: true,
                        )
                      : Container(),
                  buildDatePickerFormFieldWithIcon(
                      controller: returnDateController,
                      labelText: 'Return Date',
                      icon: Icons.calendar_today,
                      context: context),
                  buildTextFormFieldWithIcon(
                    controller: complaintController,
                    labelText: 'Complaint',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  buildDropdownFormFieldWithIcon<Harness?>(
                    items: harnessList,
                    value: _selectedHarness,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedHarness = newValue;
                      });
                    },
                    labelText: 'Select the Missing Harness',
                  ),
                  buildDropdownFormFieldWithIcon<Bms?>(
                    items: bmsList,
                    value: _selectedBms,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedBms = newValue;
                      });
                    },
                    labelText: 'Select the BMS Type',
                  ),
                  buildDropdownFormFieldWithIcon<Make?>(
                    items: makeList,
                    value: _selectedMake,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMake = newValue;
                      });
                    },
                    labelText: 'Select the Make',
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
                  complaintState is ComplaintSubmitState &&
                          complaintState.submissionStatus ==
                              SubmissionStatus.inProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: widget.selectedCustomer != null &&
                                  widget.selectedBatchForCustomer != null &&
                                  widget.selectedCustomer != null &&
                                  widget.selectedBatchForCustomer != null &&
                                  widget.selectedVehicleManufacturer != null &&
                                  _selectedBms != null &&
                                  _selectedHarness != null &&
                                  _selectedMake != null &&
                                  widget.selectedBmsSerialNo != null
                              ? () {
                                  if (formKey.currentState!.validate()) {
                                    Complaint complaintData = Complaint(
                                      id: widget.filteredComplaint?.id ?? "",
                                      customerId: widget.selectedCustomer!.id,
                                      batchId:
                                          widget.selectedBatchForCustomer!.id,
                                      harnessId: _selectedHarness!.id,
                                      makeId: _selectedMake!.id,
                                      vehicleManufacturerId: widget
                                          .selectedVehicleManufacturer!.id,
                                      bmsId: _selectedBms!.id,
                                      bmsSerialNo: widget.selectedBmsSerialNo!,
                                      returnDate: DateFormat('dd-MM-yyyy')
                                          .tryParse(returnDateController.text),
                                      complaint: complaintController.text,
                                      comment: commentController.text,
                                      observation: observationController.text,
                                      solution: solutionController.text,
                                      testingDoneBy:
                                          testingDoneByController.text,
                                      status: _filteredComplaint?.status ??
                                          "Not Resolved",
                                    );
                                    _filteredComplaint = complaintData;
                                    context.read<InfoBloc>().add(
                                        ComplaintSubmitButtonPressed(
                                            complaintData: complaintData));
                                  }
                                }
                              : null,
                          child: const Text('Submit'),
                        )
                ],
              ),
            );
          },
        );
      },
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
            Navigator.pop(context);
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

Map<String, double> calculatePercentageOfWorkCompleted(
    List<Complaint> complaintList) {
  Map<String, double> percentageMap = {};
  double completedWeight = 0.66;
  double notTestedWeight = 0.33;
  double dispatchedWeight = 1;
  double notResolvedWeight = -1;
  double wasteWeight = 1;
  /* Not Resolved(0%), Not Tested(33%), Completed(66%), Dispatched(100%), Waste(Not to be considered in status)*/

  double totalCompletedWeight = 0;
  double totalNotTestedWeight = 0;
  double totalNotResolvedWeight = 0;
  double totalNotDispatchedWeight = 0;
  double totalWasteWeight = 0;

  for (var complaint in complaintList) {
    switch (complaint.status) {
      case "Completed":
        totalCompletedWeight += completedWeight;
        break;
      case "Not Tested":
        totalNotTestedWeight += notTestedWeight;
        break;
      case "Not Resolved":
        totalNotResolvedWeight += notResolvedWeight;
        break;

      case "Dispatched":
        totalNotDispatchedWeight += dispatchedWeight;
        break;

      case "Waste":
        totalWasteWeight += wasteWeight;
        break;

      default:
    }
  }
  percentageMap = {
    "Not Tested": totalNotTestedWeight,
    "Not Resolved": totalNotResolvedWeight,
    "Completed": totalCompletedWeight,
    "Dispatched": totalNotDispatchedWeight,
    "Waste": totalWasteWeight,
  };

  return percentageMap;
}

class WorkCompletionProgress extends StatefulWidget {
  final double percentage;
  final Map<String, double> percentageMap;

  const WorkCompletionProgress(
      {super.key, required this.percentage, required this.percentageMap});

  @override
  State<WorkCompletionProgress> createState() => _WorkCompletionProgressState();
}

class _WorkCompletionProgressState extends State<WorkCompletionProgress> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Show progress",
      child: MouseRegion(
        onEnter: (_) => setState(() {
          isHovered = true;
        }),
        onExit: (_) => setState(() {
          isHovered = false;
        }),
        child: GestureDetector(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${widget.percentage.toStringAsFixed(2)}%"),
              Flexible(
                child: SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    backgroundColor: Colors.black,
                    value: widget.percentage / 100,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            _showPieChartDialog(
              context,
              widget.percentageMap,
            );
          },
        ),
      ),
    );
  }
}

void _showPieChartDialog(
    BuildContext context, Map<String, double> percentageMap) {
  Map<String, Color> colorMap = {
    "Not Resolved": Colors.red,
    "Not Tested": Colors.orange,
    "Completed": Colors.green,
    "Dispatched": Colors.blue,
    "Waste": Colors.grey
  };

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
            child: Text(
          "Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        content: SizedBox(
          width: 500,
          height: 500,
          child: PieChart(
            initialAngleInDegree: 0,
            dataMap: percentageMap,
            animationDuration: Duration.zero,
            colorList: colorMap.values.toList(),
            chartRadius: MediaQuery.of(context).size.width / 2,
            ringStrokeWidth: 24,
            chartValuesOptions: const ChartValuesOptions(
                chartValueStyle: TextStyle(fontSize: 20),
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValueBackground: false),
            legendOptions: const LegendOptions(
                showLegends: true,
                legendShape: BoxShape.rectangle,
                legendTextStyle: TextStyle(fontSize: 15),
                legendPosition: LegendPosition.bottom,
                showLegendsInRow: true),
          ),
          /*PieChart(
            PieChartData(
              sections: percentageMap.entries
                  .map((e) => PieChartSectionData(
                      value: (e.value / 5) * 100,
                      color: colorMap[e.key],
                      title: "${e.key} (${e.value.toInt()})",
                      radius: 100))
                  .toList(),
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 40,
              sectionsSpace: 0,
            ),
          ),*/
        ),
      );
    },
  );
}
