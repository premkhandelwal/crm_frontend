import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/info/info_bloc.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customerList = [];
List<Bms> bmsList = [];

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({Key? key}) : super(key: key);

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController returnDateController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  TextEditingController solutionController = TextEditingController();
  TextEditingController testingDoneByController = TextEditingController();

  late InfoBloc infoBloc;
  late MasterBloc masterBloc;

  List<Batch> batchListForCustomer = [];
  Customer? selectedCustomer;
  Batch? selectedBatchForCustomer;
  List<Bms> bmsListForSelectedBatch = [];
  Bms? selectedBms;

  @override
  void initState() {
    infoBloc = BlocProvider.of<InfoBloc>(context);
    masterBloc = BlocProvider.of<MasterBloc>(context);
    masterBloc.add(FetchCustomerEvent());
    masterBloc.add(FetchBmsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Complaint"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                                  } else if (selectedBatchForCustomer != null) {
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
                                customerList = List.from(state.customerList);
                              } else if (state is FetchBmsState &&
                                  state.submissionStatus ==
                                      SubmissionStatus.success) {
                                bmsList = List.from(state.bmsList);
                              }
                            },
                            builder: (context, state) {
                              return _buildCustomerListView();
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
                                  ? _buildBatchListView()
                                  : selectedBms == null
                                      ? _buildBmsListView(
                                          bmsListForSelectedBatch)
                                      : _buildComplaintTextFields();
                            },
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: customerList.length,
      itemBuilder: (context, index) {
        Customer customer = customerList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              infoBloc.add(FetchBatchForCustomerEvent(customerId: customer.id));
              setState(() {
                selectedCustomer = customer;
              });
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
                          customer.name,
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

  Widget _buildBatchListView() {
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
              setState(() {
                selectedBatchForCustomer = batch;
                bmsListForSelectedBatch = [];
                for (var bmsId in batch.bmsList) {
                  bmsListForSelectedBatch.add(
                      bmsList.firstWhere((element) => element.id == bmsId));
                }
              });
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

  Widget _buildBmsListView(List<Bms> bmsList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: bmsList.length,
      itemBuilder: (context, index) {
        Bms bms = bmsList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              setState(() {
                selectedBms = bms;
              });
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

  Widget _buildComplaintTextFields() {
    return Column(
      children: [
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
            return ElevatedButton(
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
                            returnDate:
                                DateTime.parse(returnDateController.text),
                            complaint: complaintController.text,
                            comment: commentController.text,
                            observation: observationController.text,
                            solution: solutionController.text,
                            testingDoneBy: testingDoneByController.text,
                            status: "NOT RESOLVED");
                        infoBloc.add(ComplaintSubmitButtonPressed(
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

  Widget buildTextFormFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(10.0),
            prefixIcon: Icon(icon),
          ),
          maxLines: maxLines,
        ),
      ),
    );
  }
}


/* 

 */