// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/info/info_bloc.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/complaint/complaint_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/ui/screens/common_complaint_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customers = [];
List<Bms> bmsList = [];

class CommonComplaintScreen extends StatefulWidget {
  final bool isDashBoard;
  const CommonComplaintScreen({
    Key? key,
    required this.isDashBoard,
  }) : super(key: key);

  @override
  State<CommonComplaintScreen> createState() => _CommonComplaintScreenState();
}

class _CommonComplaintScreenState extends State<CommonComplaintScreen> {
  late MasterBloc masterBloc;
  late InfoBloc infoBloc;
  late ComplaintCubit complaintCubit;

  final _formKey = GlobalKey<FormState>();

 

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
    infoBloc = BlocProvider.of<InfoBloc>(context);
    complaintCubit = BlocProvider.of<ComplaintCubit>(context);
    masterBloc.add(FetchCustomerEvent());
    masterBloc.add(FetchBmsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Customer? selectedCustomer;

    List<Batch> batchListForCustomer = [];
    Batch? selectedBatchForCustomer;
    Map<Bms, List<String>> bmsListForSelectedBatch = {};
    Bms? selectedBms;
    List<String> serialNoListforSelectedBms = [];
    String? selectedBmsSerialNo;

    TextEditingController returnDateController = TextEditingController();
    TextEditingController complaintController = TextEditingController();
    TextEditingController commentController = TextEditingController();
    TextEditingController observationController = TextEditingController();
    TextEditingController solutionController = TextEditingController();
    TextEditingController testingDoneByController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isDashBoard ? "Dashboard" : "Add Complaint"),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, customerState) {
          if (customerState is FetchCustomerState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            customers = List.from(customerState.customerList);
          }
        },
        builder: (context, customerState) {
          // Your existing UI code...
          if (customerState is FetchCustomerState &&
              customerState.submissionStatus == SubmissionStatus.inProgress) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Center(child: Text("Fetching customers"))
              ],
            );
          }
          return BlocConsumer<ComplaintCubit, ComplaintState>(
            listener: (context, complaintState) {
              if (complaintState is SelectedCustomerChangedState) {
                selectedCustomer = complaintState.customer;
                infoBloc.add(FetchBatchForCustomerEvent(
                    customerId: complaintState.customer.id));
              } else if (complaintState is SelectedBatchChangedState) {
                selectedBatchForCustomer = complaintState.batch;
                bmsListForSelectedBatch = {};
                bmsListForSelectedBatch =
                    complaintState.batch.bmsList.map((key, value) {
                  Bms bms = bmsList.firstWhere((element) => element.id == key);
                  return MapEntry(bms, value);
                });
              } else if (complaintState is SelectedBmsChangedState) {
                selectedBms = complaintState.bms;
                serialNoListforSelectedBms = complaintState.serialNoList;
              } else if (complaintState is SelectedSerialNoChangedState) {
                selectedBmsSerialNo = complaintState.serialNo;
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedCustomer != null)
                          Column(
                            children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (selectedBms != null) {
                                            selectedBms = null;
                                          } else if (selectedBatchForCustomer !=
                                              null) {
                                            selectedBatchForCustomer = null;
                                          } else {
                                            selectedCustomer = null;
                                          }
                                        });
                                      },
                                      child: const Text("Go back")),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        Center(
                          child: Text(
                            selectedCustomer == null
                                ? "Select the customer:"
                                : selectedBatchForCustomer == null
                                    ? "Select the batch:"
                                    : selectedBms == null
                                        ? "Select the bms:"
                                        : widget.isDashBoard
                                            ? 'Complaint Details:'
                                            : "Fill the details:",
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: selectedCustomer == null
                                ? BlocConsumer<MasterBloc, MasterState>(
                                    listener: (context, state) {
                                      if (state is FetchCustomerState &&
                                          state.submissionStatus ==
                                              SubmissionStatus.success) {
                                        customers =
                                            List.from(state.customerList);
                                      } else if (state is FetchBmsState &&
                                          state.submissionStatus ==
                                              SubmissionStatus.success) {
                                        bmsList = List.from(state.bmsList);
                                      }
                                    },
                                    builder: (context, state) {
                                      return buildCustomerWidget(
                                          customers, widget.isDashBoard);
                                    },
                                  )
                                : BlocConsumer<InfoBloc, InfoState>(
                                    listener: (context, state) {
                                      if (state is FetchBatchForCustomerState &&
                                          state.submissionStatus ==
                                              SubmissionStatus.success) {
                                        batchListForCustomer =
                                            List.from(state.batchList);
                                      }
                                    },
                                    builder: (context, state) {
                                      return selectedBatchForCustomer == null
                                          ? buildBatchListView(
                                              batchListForCustomer)
                                          : selectedBms == null
                                              ? buildBmsListView(
                                                  bmsListForSelectedBatch
                                                      .entries
                                                      .toList())
                                              : selectedBmsSerialNo == null
                                                  ? buildBmsSerialNoListView(
                                                      serialNoListforSelectedBms)
                                                  : Column(
                                                      children: [
                                                        buildComplaintTextFields(
                                                            commentController:
                                                                commentController,
                                                            complaintController:
                                                                complaintController,
                                                            observationController:
                                                                observationController,
                                                            returnDateController:
                                                                returnDateController,
                                                            solutionController:
                                                                solutionController,
                                                            testingDoneByController:
                                                                testingDoneByController),
                                                        BlocConsumer<InfoBloc,
                                                            InfoState>(
                                                          listener:
                                                              (context, state) {
                                                            if (state
                                                                is ComplaintSubmitState) {
                                                              if (state
                                                                      .submissionStatus ==
                                                                  SubmissionStatus
                                                                      .success) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text("Complaint added successfully")));
                                                              } else if (state
                                                                      .submissionStatus ==
                                                                  SubmissionStatus
                                                                      .failure) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text("Failed to lodge complaint")));
                                                              }
                                                            }
                                                          },
                                                          builder:
                                                              (context, state) {
                                                            if (state
                                                                    is ComplaintSubmitState &&
                                                                state.submissionStatus ==
                                                                    SubmissionStatus
                                                                        .inProgress) {
                                                              return const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              );
                                                            }
                                                            return widget
                                                                    .isDashBoard
                                                                ? Container()
                                                                : ElevatedButton(
                                                                    onPressed: selectedCustomer != null &&
                                                                            selectedBatchForCustomer !=
                                                                                null &&
                                                                            selectedBms !=
                                                                                null
                                                                        ? () {
                                                                            if (_formKey.currentState!.validate()) {
                                                                              // Handle form submission
                                                                              // Access the form field values using the controllers
                                                                              Complaint complaintData = Complaint(customerId: selectedCustomer!.id, batchId: selectedBatchForCustomer!.id, bmsId: selectedBms!.id, returnDate: DateTime.parse(returnDateController.text), complaint: complaintController.text, comment: commentController.text, observation: observationController.text, solution: solutionController.text, testingDoneBy: testingDoneByController.text, status: "NOT RESOLVED");
                                                                              infoBloc.add(ComplaintSubmitButtonPressed(complaintData: complaintData));
                                                                            }
                                                                          }
                                                                        : null,
                                                                    child: const Text(
                                                                        'Submit'),
                                                                  );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                    },
                                  ))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
