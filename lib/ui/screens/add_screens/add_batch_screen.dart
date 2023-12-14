import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/customer/customer_bloc.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/harness_request.dart';
import 'package:crm/models/make_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customerList = [];
List<Bms> bmsList = [];
List<Harness> harnessList = [];
List<Make> makeList = [];

Customer? selectedCustomer;
Bms? selectedBms;
List<Harness> selectedHarness = [];
Make? selectedMake;

class AddBatchScreen extends StatefulWidget {
  const AddBatchScreen({Key? key}) : super(key: key);

  @override
  State<AddBatchScreen> createState() => _AddBatchScreenState();
}

class _AddBatchScreenState extends State<AddBatchScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController batchNameController = TextEditingController();
  TextEditingController batchDescriptionController = TextEditingController();

  late CustomerBloc customerBloc;

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    customerBloc.add(FetchBmsEvent());
    customerBloc.add(FetchCustomerEvent());
    customerBloc.add(FetchHarnessEvent());
    customerBloc.add(FetchMakeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Batch"),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, customerState) {
          if (customerState is FetchCustomerState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            customerList = List.from(customerState.customerList);
          } else if (customerState is FetchBmsState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            bmsList = List.from(customerState.bmsList);
          } else if (customerState is FetchHarnessState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            harnessList = List.from(customerState.harnessList);
          } else if (customerState is FetchMakeState &&
              customerState.submissionStatus == SubmissionStatus.success) {
            makeList = List.from(customerState.makeList);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildTextFormFieldWithIcon(
                      controller: batchNameController,
                      labelText: 'Batch Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    buildDropdownFormFieldWithIcon<Bms?>(
                      items: bmsList,
                      value: selectedBms,
                      onChanged: (newValue) {
                        // Handle the value change
                        setState(() {
                          selectedBms = newValue;
                        });
                      },
                      labelText: 'Select the BMS',
                    ),
                    Row(children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Select Harness:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...harnessList.map((item) {
                        return Row(
                          children: [
                            Checkbox(
                              value: selectedHarness.contains(item),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null && value) {
                                    selectedHarness.add(item);
                                  } else {
                                    selectedHarness.remove(item);
                                  }
                                });
                              },
                            ),
                            Text(item.name),
                            const SizedBox(
                                width:
                                    16.0), // Adjust the spacing between checkboxes
                          ],
                        );
                      }).toList(),
                    ]),
                    buildDropdownFormFieldWithIcon<Make?>(
                      items: makeList,
                      value: selectedMake,
                      onChanged: (newValue) {
                        // Handle the value change
                        setState(() {
                          selectedMake = newValue;
                        });
                      },
                      labelText: 'Select the Make',
                    ),
                    buildDropdownFormFieldWithIcon<Customer?>(
                      items: customerList,
                      value: selectedCustomer,
                      onChanged: (newValue) {
                        // Handle the value change
                        setState(() {
                          selectedCustomer = newValue;
                        });
                      },
                      labelText: 'Select the Customer',
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<CustomerBloc, CustomerState>(
                      listener: (context, state) {
                        if (state is AddBatchState) {
                          if (state.submissionStatus ==
                              SubmissionStatus.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Batch added successfully")));
                          } else if (state.submissionStatus ==
                              SubmissionStatus.failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Failed to add batch")));
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is AddBatchState &&
                            state.submissionStatus ==
                                SubmissionStatus.inProgress) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Handle form submission
                              // Access the form field values using the controllers
                              Batch batchData = Batch(
                                batchName: batchNameController.text,
                                bmsId: selectedBms!.id,
                                customerId: selectedCustomer!.id,
                                harnessDetails: selectedHarness
                                    .map((harness) => harness.id)
                                    .toList(),
                                makeId: selectedMake!.id,
                              );
                              customerBloc
                                  .add(AddBatchEvent(batchData: batchData));
                            }
                          },
                          child: const Text('Submit'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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

  Widget buildDropdownFormFieldWithIcon<T>({
    required List<T> items,
    required T value,
    required void Function(T?) onChanged,
    required String labelText,
  }) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(10.0),
          ),
        ),
      ),
    );
  }
}
